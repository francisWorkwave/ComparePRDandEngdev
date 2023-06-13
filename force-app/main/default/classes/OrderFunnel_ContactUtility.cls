public with sharing class OrderFunnel_ContactUtility {
    public static List<Contact> getContacts(String id, Boolean allowList){
        List<Contact> cons = [  SELECT  Id, FirstName, LastName, Phone, Email,
                                        MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, AccountId,
                                        (
                                            SELECT  Account.Id, Account.Name, Account.BillingStreet, Account.BillingCity, Account.BillingState,
                                                    Account.BillingPostalCode, Account.BillingCountry, Account.Phone,
                                                    Account.Additional_Field_Label_1__c, Account.Additional_Field_Value_1__c, Account.Additional_Field_Label_2__c, Account.Additional_Field_Value_2__c,
                                                    Account.Additional_Field_Label_3__c, Account.Additional_Field_Value_3__c, Account.Additional_Field_Label_4__c, Account.Additional_Field_Value_4__c,
                                                    Account.Additional_Field_Label_5__c, Account.Additional_Field_Value_5__c, Account.Additional_Field_Label_6__c, Account.Additional_Field_Value_6__c,
                                                    Account.Additional_Field_Label_7__c, Account.Additional_Field_Value_7__c, Account.Additional_Field_Label_8__c, Account.Additional_Field_Value_8__c,
                                                    Account.Additional_Field_Label_9__c, Account.Additional_Field_Value_9__c, Account.Additional_Field_Label_10__c, Account.Additional_Field_Value_10__c,
                                                    Account.Additional_Field_Label_11__c, Account.Additional_Field_Value_11__c, Account.Additional_Field_Label_12__c, Account.Additional_Field_Value_12__c,
                                                    Account.Additional_Field_Label_13__c, Account.Additional_Field_Value_13__c, Account.Additional_Field_Label_14__c, Account.Additional_Field_Value_14__c,
                                                    Account.Additional_Field_Label_15__c, Account.Additional_Field_Value_15__c, Account.Additional_Field_Label_16__c, Account.Additional_Field_Value_16__c,
                                                    Account.Additional_Field_Label_17__c, Account.Additional_Field_Value_17__c, Account.Additional_Field_Label_18__c, Account.Additional_Field_Value_18__c,
                                                    Account.Additional_Field_Label_19__c, Account.Additional_Field_Value_19__c, Account.Additional_Field_Label_20__c, Account.Additional_Field_Value_20__c
                                            FROM    AccountContactRelations)
        FROM Contact WHERE Id =: id];

        if(cons.isEmpty()){
            throw new API_Dispatcher.APIException(404, 'Contact not found');
        }

        if(allowList == false && cons.size() > 1){
            throw new API_Dispatcher.APIException(300, 'Multiple contacts identified');
        }

        return cons;
    }


    public static List<Contact> getChildrenContacts(String filter, String accountId, Boolean includeChildren){

        Schema.FieldSet fieldSet = Schema.getGlobalDescribe().get('Contact').getDescribe().fieldSets.getMap().get('AccountContactChildren');
        if(fieldSet == null) {
            throw new API_Dispatcher.APIException(300, 'fieldSet not found');
        }
        string contactQuery = 'Select ';
        string fields = ',Id';

        for(Schema.FieldSetMember fieldSetMem:fieldSet.getFields()){
            fields += ', ' + fieldSetMem.getFieldPath();
        }
        fields = fields.replaceFirst(',', '');

        contactQuery += fields + ' From Contact Where';

        if (filter == 'accountExternalId') {
            contactQuery += ' Account.External_ID__c = \'' + accountId + '\'';    
            if (includeChildren) {
                contactQuery += ' OR Account.Parent.External_ID__c = \'' + accountId + '\'';
                contactQuery += ' OR Account.Parent.Parent.External_ID__c = \'' + accountId + '\'';
                contactQuery += ' OR Account.Parent.Parent.Parent.External_ID__c = \'' + accountId + '\'';
                contactQuery += ' OR Account.Parent.Parent.Parent.External_ID__c = \'' + accountId + '\''; 
                contactQuery += ' OR Account.Parent.Parent.Parent.Parent.External_ID__c = \'' + accountId + '\''; 
            }
        }else {
            contactQuery += ' AccountId = \'' + accountId + '\'';
            if (includeChildren) {
                contactQuery += ' OR Account.ParentId = \'' + accountId + '\'';
                contactQuery += ' OR Account.Parent.ParentId = \'' + accountId + '\'';
                contactQuery += ' OR Account.Parent.Parent.ParentId = \'' + accountId + '\'';
                contactQuery += ' OR Account.Parent.Parent.ParentId = \'' + accountId + '\''; 
                contactQuery += ' OR Account.Parent.Parent.Parent.ParentId = \'' + accountId + '\''; 
            }
        }
        System.debug('contactQuery ' + contactQuery);

        List<Contact> cons = Database.query(contactQuery);

        if(cons.isEmpty()){
            throw new API_Dispatcher.APIException(404, 'Contact not found');
        }

        return cons;
    }

    public static OrderFunnel_Models.ContactModel buildModel(Contact c){
        OrderFunnel_Models.ContactModel model = new OrderFunnel_Models.ContactModel();
        model.id = c.Id;
        model.firstName = c.FirstName;
        model.lastName = c.LastName;
        model.phone = c.Phone;
        model.email = c.Email;
        model.accountId = c.AccountId;

        model.mailingAddress = new OrderFunnel_Models.AddressModel();
        model.mailingAddress.street = c.MailingStreet;
        model.mailingAddress.city = c.MailingCity;
        model.mailingAddress.state = c.MailingState;
        model.mailingAddress.postalCode = c.MailingPostalCode;
        model.mailingAddress.country = c.MailingCountry;

        for (AccountContactRelation acr: c.AccountContactRelations) {
            OrderFunnel_Models.AccountModel accountModel = OrderFunnel_AccountUtility.buildModel(acr.Account);

            model.Accounts.add(accountModel);

            if (accountModel.Id == model.AccountId) {
                model.Account = accountModel;
            }
        }

        return model;
    }

    public static Contact buildContact(OrderFunnel_Models.ContactModel model, Contact c){
        if(c == null){
            c = new Contact();
            c.Id = model.Id;
        }
        c.FirstName = model.FirstName;
        c.LastName = model.LastName;
        c.Phone = model.Phone;
        c.Email = model.Email;
        if (model.MailingAddress != null) {
            c.MailingStreet = model.MailingAddress.Street;
            c.MailingCity = model.MailingAddress.City;
            c.MailingState = model.MailingAddress.State;
            c.MailingPostalCode = model.MailingAddress.PostalCode;
            c.MailingCountry = model.MailingAddress.Country;
        }

        if(model.account != null){
            c.AccountId = model.account.id;
        }
        return c;
    }

    public static void verifyAccount(OrderFunnel_Models.ContactModel conModel){
        if(conModel.account == null){
            return;
        }

        if(conModel.account.id == null){
            Account a = OrderFunnel_ContactUtility.buildAccount(conModel);
            insert a;

            conModel.account.id = a.Id;
        }
        else{
            //This verifies that an account exists with the given id, erroring otherwise.
            List<Account> accs = OrderFunnel_AccountUtility.getAccounts(conModel.account.id);

            if(accs.isEmpty()){
                throw new API_Dispatcher.APIException(404, 'Account not found');
            }
        }
    }

    public static Account buildAccount(OrderFunnel_Models.ContactModel conModel){
        OrderFunnel_Models.AccountModel accModel = conModel.account;

        if(accModel.billingAddress == null || accModel.billingAddress.street == null){
            accModel.billingAddress = conModel.mailingAddress;
        }
        if(accModel.phone == null){
            accModel.phone = conModel.phone;
        }
        return OrderFunnel_AccountUtility.buildAccount(accModel, null);
    }
}