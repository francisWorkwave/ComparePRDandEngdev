@isTest
public with sharing class OrderFunnel_ContactHandlerTest {
    @isTest
    public static void handleGet_Success(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Contact c = new Contact();
        c.FirstName = 'Jane';
        c.LastName = 'Deaux';
        c.AccountId = a.Id;
        insert c;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/' + c.Id;

        OrderFunnel_ContactHandler handler = new OrderFunnel_ContactHandler();

        Test.startTest();

        List<OrderFunnel_Models.ContactModel> models = (List<OrderFunnel_Models.ContactModel>) handler.handleGet(req);

        Test.stopTest();

        System.assertEquals(1, models.size());
    }

    @isTest
    public static void testHandleGet_InvalidContact(){

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/001000000000000';

        OrderFunnel_ContactHandler handler = new OrderFunnel_ContactHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
            System.assert(false, 'Exception expected: Invalid contact id');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Contact identifier invalid'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handlePost_Success(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        OrderFunnel_Models.ContactModel conModel = new OrderFunnel_Models.ContactModel();
        conModel.accountId = a.Id;
        conModel.account = new OrderFunnel_Models.AccountModel();
        conModel.account.id = a.Id;
        conModel.firstName = 'John';
        conModel.lastName = 'Doe';
        conModel.email = 'jdoe@test.com';
        conModel.phone = '5555555555';
        conModel.mailingAddress = new OrderFunnel_Models.AddressModel();
        conModel.mailingAddress.street = '2901 Ashton Blvd';
        conModel.mailingAddress.city = 'Lehi';
        conModel.mailingAddress.state = 'Utah';
        conModel.mailingAddress.postalCode = '84043';

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/';
        req.requestBody = Blob.valueOf(JSON.serialize(conModel));

        OrderFunnel_ContactHandler handler = new OrderFunnel_ContactHandler();

        Test.startTest();

        List<OrderFunnel_Models.DMLResponse> models = (List<OrderFunnel_Models.DMLResponse>) handler.handlePost(req);

        Test.stopTest();

        System.assertEquals(1, models.size());
    }

    @isTest
    public static void handlePost_MissingBody(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/';

        OrderFunnel_ContactHandler handler = new OrderFunnel_ContactHandler();

        Test.startTest();

        try{
            handler.handlePost(req);
            System.assert(false, 'Exception expected: Missing body');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Missing request body'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handlePost_InvalidBody(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/';
        req.requestBody = Blob.valueOf('[{]');

        OrderFunnel_ContactHandler handler = new OrderFunnel_ContactHandler();

        Test.startTest();

        try{
            handler.handlePost(req);
            System.assert(false, 'Exception expected: Invalid body');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Invalid request body.'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handlePost_MissingAccountDetails(){
        OrderFunnel_Models.ContactModel conModel = new OrderFunnel_Models.ContactModel();
        conModel.firstName = 'John';
        conModel.lastName = 'Doe';
        conModel.email = 'jdoe@test.com';
        conModel.phone = '5555555555';
        conModel.mailingAddress = new OrderFunnel_Models.AddressModel();
        conModel.mailingAddress.street = '2901 Ashton Blvd';
        conModel.mailingAddress.city = 'Lehi';
        conModel.mailingAddress.state = 'Utah';
        conModel.mailingAddress.postalCode = '84043';

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/';
        req.requestBody = Blob.valueOf(JSON.serialize(conModel));

        OrderFunnel_ContactHandler handler = new OrderFunnel_ContactHandler();

        Test.startTest();

        try{
            handler.handlePost(req);
            System.assert(false, 'Exception expected: Missing account details');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Please supply account information for new contacts.'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handlePost_GeneralFailure(){
        OrderFunnel_Models.ContactModel conModel = new OrderFunnel_Models.ContactModel();
        conModel.accountId = '001000000000000';
        conModel.account = new OrderFunnel_Models.AccountModel();
        conModel.account.id = '001000000000000';
        conModel.firstName = 'John';
        conModel.lastName = 'Doe';
        conModel.email = 'jdoe@test.com';
        conModel.phone = '5555555555';
        conModel.mailingAddress = new OrderFunnel_Models.AddressModel();
        conModel.mailingAddress.street = '2901 Ashton Blvd';
        conModel.mailingAddress.city = 'Lehi';
        conModel.mailingAddress.state = 'Utah';
        conModel.mailingAddress.postalCode = '84043';

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/';
        req.requestBody = Blob.valueOf(JSON.serialize(conModel));

        OrderFunnel_ContactHandler handler = new OrderFunnel_ContactHandler();

        Test.startTest();

        try{
            handler.handlePost(req);
            System.assert(false, 'Exception expected: General Failure');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(500, ex.statusCode);
            System.assert(ex.getMessage().contains('An error occurred while creating the contact.'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handlePatch_Success(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Contact c = new Contact();
        c.FirstName = 'Jane';
        c.LastName = 'Deaux';
        c.AccountId = a.Id;
        insert c;

        OrderFunnel_Models.ContactModel conModel = new OrderFunnel_Models.ContactModel();
        conModel.id = c.Id;
        conModel.accountId = a.Id;
        conModel.account = new OrderFunnel_Models.AccountModel();
        conModel.account.id = a.Id;
        conModel.firstName = 'Jane';
        conModel.lastName = 'Smith';
        conModel.email = 'jdoe@test.com';
        conModel.phone = '5555555555';
        conModel.mailingAddress = new OrderFunnel_Models.AddressModel();
        conModel.mailingAddress.street = '2901 Ashton Blvd';
        conModel.mailingAddress.city = 'Lehi';
        conModel.mailingAddress.state = 'Utah';
        conModel.mailingAddress.postalCode = '84043';

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/' + c.Id;
        req.requestBody = Blob.valueOf(JSON.serialize(conModel));

        OrderFunnel_ContactHandler handler = new OrderFunnel_ContactHandler();

        Test.startTest();

        List<OrderFunnel_Models.DMLResponse> models = (List<OrderFunnel_Models.DMLResponse>) handler.handlePatch(req);

        Test.stopTest();

        System.assertEquals(1, models.size());
    }

    @isTest
    public static void handlePatcht_InvalidContact(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/001000000000000';

        OrderFunnel_ContactHandler handler = new OrderFunnel_ContactHandler();

        Test.startTest();

        try{
            handler.handlePatch(req);
            System.assert(false, 'Exception expected: Invalid contact id');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Contact identifier invalid'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handlePatcht_MissingBody(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/003000000000000';

        OrderFunnel_ContactHandler handler = new OrderFunnel_ContactHandler();

        Test.startTest();

        try{
            handler.handlePatch(req);
            System.assert(false, 'Exception expected: Missing body');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Missing request body'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handlePatch_InvalidBody(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/003000000000000';
        req.requestBody = Blob.valueOf('[{]');

        OrderFunnel_ContactHandler handler = new OrderFunnel_ContactHandler();

        Test.startTest();

        try{
            handler.handlePatch(req);
            System.assert(false, 'Exception expected: Invalid body');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Invalid request body.'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handlePatch_GeneralFailure(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Contact c = new Contact();
        c.FirstName = 'Jane';
        c.LastName = 'Deaux';
        c.AccountId = a.Id;
        insert c;

        OrderFunnel_Models.ContactModel conModel = new OrderFunnel_Models.ContactModel();
        conModel.id = c.Id;
        conModel.accountId = a.Id;
        conModel.account = new OrderFunnel_Models.AccountModel();
        conModel.account.id = a.Id;
        conModel.firstName = 'Jane';
        conModel.lastName = null;
        conModel.email = 'jdoe@test.com';
        conModel.phone = '5555555555';
        conModel.mailingAddress = new OrderFunnel_Models.AddressModel();
        conModel.mailingAddress.street = '2901 Ashton Blvd';
        conModel.mailingAddress.city = 'Lehi';
        conModel.mailingAddress.state = 'Utah';
        conModel.mailingAddress.postalCode = '84043';

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/' + c.Id;
        req.requestBody = Blob.valueOf(JSON.serialize(conModel));

        OrderFunnel_ContactHandler handler = new OrderFunnel_ContactHandler();

        Test.startTest();

        try{
            handler.handlePatch(req);
            System.assert(false, 'Exception expected: General Failure');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(500, ex.statusCode);
            System.assert(ex.getMessage().contains('An error occurred while updating the contact.'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }
}