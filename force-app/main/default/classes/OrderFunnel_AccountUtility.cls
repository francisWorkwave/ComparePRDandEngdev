public with sharing class OrderFunnel_AccountUtility {
    public static List<Account> getAccounts(String id){
        List<Account> accs = [  SELECT  Id, Name, Phone, BillingStreet, BillingCity, External_ID__c,
                                        BillingState, BillingPostalCode, BillingCountry, PaymentMethod__c, PaymentTerms__c,

                                        Additional_Field_Label_1__c, Additional_Field_Value_1__c, Additional_Field_Label_2__c, Additional_Field_Value_2__c,
                                        Additional_Field_Label_3__c, Additional_Field_Value_3__c, Additional_Field_Label_4__c, Additional_Field_Value_4__c,
                                        Additional_Field_Label_5__c, Additional_Field_Value_5__c, Additional_Field_Label_6__c, Additional_Field_Value_6__c,
                                        Additional_Field_Label_7__c, Additional_Field_Value_7__c, Additional_Field_Label_8__c, Additional_Field_Value_8__c,
                                        Additional_Field_Label_9__c, Additional_Field_Value_9__c, Additional_Field_Label_10__c, Additional_Field_Value_10__c,
                                        Additional_Field_Label_11__c, Additional_Field_Value_11__c, Additional_Field_Label_12__c, Additional_Field_Value_12__c,
                                        Additional_Field_Label_13__c, Additional_Field_Value_13__c, Additional_Field_Label_14__c, Additional_Field_Value_14__c,
                                        Additional_Field_Label_15__c, Additional_Field_Value_15__c, Additional_Field_Label_16__c, Additional_Field_Value_16__c,
                                        Additional_Field_Label_17__c, Additional_Field_Value_17__c, Additional_Field_Label_18__c, Additional_Field_Value_18__c,
                                        Additional_Field_Label_19__c, Additional_Field_Value_19__c, Additional_Field_Label_20__c, Additional_Field_Value_20__c

                                FROM    Account
                                WHERE   Id =: id];

        return accs;
    }

    public static OrderFunnel_Models.AccountModel buildModel(Account a){
        OrderFunnel_Models.AccountModel model = new OrderFunnel_Models.AccountModel();
        model.Id = a.Id;
        model.Name = a.Name;
        model.Phone = a.Phone;
        model.BillingAddress = new OrderFunnel_Models.AddressModel();
        model.BillingAddress.Street = a.BillingStreet;
        model.BillingAddress.City = a.BillingCity;
        model.BillingAddress.State = a.BillingState;
        model.BillingAddress.PostalCode = a.BillingPostalCode;
        model.BillingAddress.Country = a.BillingCountry;
        model.PaymentMethod = a.PaymentMethod__c;
        model.PaymentTerms = a.PaymentTerms__c;
        model.externalId = a.External_ID__c; // Added by Fran 05-19-2023
        model.additionalFields = OrderFunnel_Utility.buildAdditionalFieldModels(a, 'Customer');

        return model;
    }

    public static Account buildAccount(OrderFunnel_Models.AccountModel model, Account a){
        if(a == null){
            a = new Account();
            a.Id = model.Id;
        }
        a.Name = model.Name;
        a.Phone = model.Phone;
        a.BillingStreet = model.BillingAddress.Street;
        a.BillingCity = model.BillingAddress.City;
        a.BillingState = model.BillingAddress.State;
        a.BillingPostalCode = model.BillingAddress.PostalCode;
        a.BillingCountry = model.BillingAddress.Country;

        OrderFunnel_Utility.parseAdditionalFieldsModel(a, model.additionalFields, 'Customer');

        return a;
    }
}