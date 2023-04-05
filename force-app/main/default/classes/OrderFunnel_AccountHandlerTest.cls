@isTest
public with sharing class OrderFunnel_AccountHandlerTest {

    @isTest
    public static void testHandleGet_Success(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/account/' + a.Id;

        OrderFunnel_AccountHandler handler = new OrderFunnel_AccountHandler();

        Test.startTest();
        List<Object> results = handler.handleGet(req);
        Test.stopTest();

        System.assertEquals(200, API_Dispatcher.statusCode);

        System.assertEquals(1, results.size());
    }

    @isTest
    public static void testHandleGet_InvalidId(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/account/' + '123ABC';

        OrderFunnel_AccountHandler handler = new OrderFunnel_AccountHandler();

        Test.startTest();
        try{
            List<Object> results = handler.handleGet(req);
            System.assert(false, 'Exception expected: Valid id presented');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains(('Account identifier invalid')));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }
        Test.stopTest();
    }

    @isTest
    public static void testHandleGet_MissingRecord(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/account/' + '001000000000000';

        OrderFunnel_AccountHandler handler = new OrderFunnel_AccountHandler();

        Test.startTest();
        try{
            List<Object> results = handler.handleGet(req);
            System.assert(false, 'Exception expected: Record matched');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(404, ex.statusCode);
            System.assert(ex.getMessage().contains(('Account not found')));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }
        Test.stopTest();
    }

    @isTest
    public static void testHandlePatch_Success(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        OrderFunnel_Models.AccountModel accModel = new OrderFunnel_Models.AccountModel();
        accModel.id = a.Id;
        accModel.name = 'Tested Account';
        accModel.additionalFields.add(new OrderFunnel_Models.AdditionalFieldModel('Customer1', 'label1', 'value1'));
        accModel.billingAddress = new OrderFunnel_Models.AddressModel();
        accModel.billingAddress.street = '2901 Ashton Blvd';
        accModel.billingAddress.city = 'Lehi';
        accModel.billingAddress.state = 'Utah';
        accModel.billingAddress.postalCode = '84043';
        accModel.phone = '8885551111';

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/account/' + a.Id;
        req.requestBody = Blob.valueOf(JSON.serialize(accModel));

        OrderFunnel_AccountHandler handler = new OrderFunnel_AccountHandler();

        Test.startTest();
        List<Object> results = handler.handlePatch(req);
        Test.stopTest();

        System.assertEquals(200, API_Dispatcher.statusCode);

        System.assertEquals(1, results.size());

        Account a2 = [SELECT Id, Name, Phone, BillingAddress, Additional_Field_Label_1__c, Additional_Field_Value_1__c
                        FROM Account
                        WHERE Id = :a.Id];

        System.assertEquals('Tested Account', a2.Name);
    }

    @isTest
    public static void testHandlePatch_InvalidDML(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        OrderFunnel_Models.AccountModel accModel = new OrderFunnel_Models.AccountModel();
        accModel.id = a.Id;
        accModel.name = null;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/account/' + a.Id;
        req.requestBody = Blob.valueOf(JSON.serialize(accModel));

        OrderFunnel_AccountHandler handler = new OrderFunnel_AccountHandler();

        Test.startTest();

        try{
            List<Object> results = handler.handlePatch(req);
            System.assert(false, 'Exception expected: Account name nilled');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(500, ex.statusCode);
            System.assert(ex.getMessage().contains(('while updating the account')));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testHandlePatch_InvalidId(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/account/' + 'ABC123';
        req.requestBody = Blob.valueOf('{}');

        OrderFunnel_AccountHandler handler = new OrderFunnel_AccountHandler();

        Test.startTest();

        try{
            List<Object> results = handler.handlePatch(req);
            System.assert(false, 'Exception expected: Account identifier valid');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains(('Account identifier invalid')));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testHandlePatch_InvalidBody(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/account/' + a.Id;
        req.requestBody = Blob.valueOf('{]');

        OrderFunnel_AccountHandler handler = new OrderFunnel_AccountHandler();

        Test.startTest();

        try{
            List<Object> results = handler.handlePatch(req);
            System.assert(false, 'Exception expected: Request body valid');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains(('Invalid request body')));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testHandlePatch_MissingBody(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/account/' + '001000000000000';

        OrderFunnel_AccountHandler handler = new OrderFunnel_AccountHandler();

        Test.startTest();

        try{
            List<Object> results = handler.handlePatch(req);
            System.assert(false, 'Exception expected: Request body present');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains(('Missing request body')));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testHandlePatch_MissingRecord(){
        OrderFunnel_Models.AccountModel accModel = new OrderFunnel_Models.AccountModel();

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/account/' + '001000000000000';
        req.requestBody = Blob.valueOf(JSON.serialize(accModel));

        OrderFunnel_AccountHandler handler = new OrderFunnel_AccountHandler();

        Test.startTest();

        try{
            List<Object> results = handler.handlePatch(req);
            System.assert(false, 'Exception expected: record matched erroneously');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(404, ex.statusCode);
            System.assert(ex.getMessage().contains(('Account not found')));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }
}