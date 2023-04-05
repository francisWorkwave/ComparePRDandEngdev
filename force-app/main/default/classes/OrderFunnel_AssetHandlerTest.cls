@isTest
public with sharing class OrderFunnel_AssetHandlerTest {

    @isTest
    public static void testHandleGet_Success(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Asset ast = new Asset();
        ast.Name = '2901 Ashton Blvd';
        ast.AccountId = a.Id;
        insert ast;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/' + ast.Id;

        OrderFunnel_AssetHandler handler = new OrderFunnel_AssetHandler();

        Test.startTest();

        List<OrderFunnel_Models.AssetModel> models = (List<OrderFunnel_Models.AssetModel>) handler.handleGet(req);

        Test.stopTest();

        System.assertEquals(1, models.size());
        System.assertEquals('2901 Ashton Blvd', models[0].name);
    }

    @isTest
    public static void testHandleGet_InvalidId(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/1234';

        OrderFunnel_AssetHandler handler = new OrderFunnel_AssetHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
            System.assert(false, 'Exception expected: Valid id presented');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Asset identifier invalid'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testHandleGet_MissingId(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/';

        OrderFunnel_AssetHandler handler = new OrderFunnel_AssetHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
            System.assert(false, 'Exception expected: Valid id presented');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Asset identifier invalid'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testHandleGet_UnknownId(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/001000000000000';

        OrderFunnel_AssetHandler handler = new OrderFunnel_AssetHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
            System.assert(false, 'Exception expected: Non-asset id presented');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(404, ex.statusCode);
            System.assert(ex.getMessage().contains('Asset not found'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testPostAsset_Success(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        OrderFunnel_Models.AssetModel assetModel = new OrderFunnel_Models.AssetModel();
        assetModel.name = 'Eide Bailly LLP';
        assetModel.accountId = a.Id;
        assetModel.teId = 'PropertyId';
        assetModel.cuId = 'CustomerPropertyId';
        assetModel.currentTracingId = '12345';
        assetModel.address = new OrderFunnel_Models.AddressModel();
        assetModel.address.street = '2901 Ashton Blvd';
        assetModel.address.city = 'Lehi';
        assetModel.address.state = 'UT';
        assetModel.address.postalCode = '84043';
        assetModel.address.country = 'US';
        assetModel.accessCode = '9999';
        assetModel.accessNote = 'Enter through the side gate.';
        assetModel.additionalFields.add(new OrderFunnel_Models.AdditionalFieldModel('Asset1','label1','value1'));
        assetModel.metrics.add(new OrderFunnel_Models.MetricModel('Lawn', '1500'));

        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestURI = '/orderfunnel/asset/';
        req.requestBody = Blob.valueOf(JSON.serialize(assetModel));
        RestContext.request = req;

        OrderFunnel_AssetHandler handler = new OrderFunnel_AssetHandler();

        Test.startTest();

        List<Object> results = handler.handlePost(req);

        Test.stopTest();

        System.assertEquals(201, API_Dispatcher.statusCode);
        System.assertEquals(1, results.size());
        OrderFunnel_Models.DMLResponse dmlResult = OrderFunnel_Utility.convertToDMLResponse(results[0]);

        System.assertEquals(assetModel.name, dmlResult.name);
    }

    @isTest
    public static void testPostAsset_NoBody(){
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestURI = '/orderfunnel/asset/';
        RestContext.request = req;

        OrderFunnel_AssetHandler handler = new OrderFunnel_AssetHandler();

        Test.startTest();

        try{
            handler.handlePost(req);
            System.assert(false, 'Exception expected: Valid body presented');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Missing request body'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testPostAsset_InvalidBody(){
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestURI = '/orderfunnel/asset/';
        req.requestBody = Blob.valueOf('{]}');
        RestContext.request = req;

        OrderFunnel_AssetHandler handler = new OrderFunnel_AssetHandler();

        Test.startTest();

        try{
            handler.handlePost(req);
            System.assert(false, 'Exception expected: Valid body presented');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Invalid request body'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testPostAsset_CreationError(){
        OrderFunnel_Models.AssetModel assetModel = new OrderFunnel_Models.AssetModel();
        assetModel.name = 'Eide Bailly LLP';
        assetModel.teId = 'PropertyId';
        assetModel.cuId = 'CustomerPropertyId';
        assetModel.currentTracingId = '12345';
        assetModel.address = new OrderFunnel_Models.AddressModel();
        assetModel.address.street = '2901 Ashton Blvd';
        assetModel.address.city = 'Lehi';
        assetModel.address.state = 'UT';
        assetModel.address.postalCode = '84043';
        assetModel.address.country = 'US';
        assetModel.accessCode = '9999';
        assetModel.accessNote = 'Enter through the side gate.';
        assetModel.additionalFields.add(new OrderFunnel_Models.AdditionalFieldModel('Asset1','label1','value1'));
        assetModel.metrics.add(new OrderFunnel_Models.MetricModel('Lawn', '1500'));

        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestURI = '/orderfunnel/asset/';
        req.requestBody = Blob.valueOf(JSON.serialize(assetModel));
        RestContext.request = req;

        OrderFunnel_AssetHandler handler = new OrderFunnel_AssetHandler();

        Test.startTest();

        try{
            handler.handlePost(req);
            System.assert(false, 'Exception expected: Valid body presented');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(500, ex.statusCode);
            System.assert(ex.getMessage().contains('error occurred while updating the asset'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testPatchAsset_Success(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Asset a = new Asset();
        a.Name = 'Test Asset';
        a.AccountId = acc.Id;
        insert a;

        OrderFunnel_Models.AssetModel assetModel = new OrderFunnel_Models.AssetModel();
        assetModel.name = 'Eide Bailly LLP';
        assetModel.accountId = acc.Id;
        assetModel.teId = 'PropertyId';
        assetModel.cuId = 'CustomerPropertyId';
        assetModel.currentTracingId = '12345';
        assetModel.address = new OrderFunnel_Models.AddressModel();
        assetModel.address.street = '2901 Ashton Blvd';
        assetModel.address.city = 'Lehi';
        assetModel.address.state = 'UT';
        assetModel.address.postalCode = '84043';
        assetModel.address.country = 'US';
        assetModel.accessCode = '9999';
        assetModel.accessNote = 'Enter through the side gate.';
        assetModel.additionalFields.add(new OrderFunnel_Models.AdditionalFieldModel('Asset1','label1','value1'));
        assetModel.metrics.add(new OrderFunnel_Models.MetricModel('Lawn', '1500'));

        RestRequest req = new RestRequest();
        req.httpMethod = 'PATCH';
        req.requestURI = '/orderfunnel/asset/' + a.Id;
        req.requestBody = Blob.valueOf(JSON.serialize(assetModel));
        RestContext.request = req;

        OrderFunnel_AssetHandler handler = new OrderFunnel_AssetHandler();

        Test.startTest();

        List<Object> results = handler.handlePatch(req);

        Test.stopTest();

        System.assertEquals(200, API_Dispatcher.statusCode);
        System.assertEquals(1, results.size());
        OrderFunnel_Models.DMLResponse dmlResult = OrderFunnel_Utility.convertToDMLResponse(results[0]);

        System.assertEquals(assetModel.name, dmlResult.name);

        Asset a2 = [SELECT Id, Name FROM Asset WHERE Id = :a.Id];

        System.assertEquals('Eide Bailly LLP', a2.Name);
    }

    @isTest
    public static void testHandlePatch_InvalidId(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/1234';

        OrderFunnel_AssetHandler handler = new OrderFunnel_AssetHandler();

        Test.startTest();

        try{
            handler.handlePatch(req);
            System.assert(false, 'Exception expected: Valid id presented');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Invalid asset id value.'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testPatchAsset_NoBody(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Asset a = new Asset();
        a.Name = 'Test Asset';
        a.AccountId = acc.Id;
        insert a;

        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestURI = '/orderfunnel/asset/' + a.Id;
        RestContext.request = req;

        OrderFunnel_AssetHandler handler = new OrderFunnel_AssetHandler();

        Test.startTest();

        try{
            handler.handlePatch(req);
            System.assert(false, 'Exception expected: Valid body presented');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Missing request body'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testPatchAsset_InvalidBody(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Asset a = new Asset();
        a.Name = 'Test Asset';
        a.AccountId = acc.Id;
        insert a;

        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestURI = '/orderfunnel/asset/' + a.Id;
        req.requestBody = Blob.valueOf('{]}');
        RestContext.request = req;

        OrderFunnel_AssetHandler handler = new OrderFunnel_AssetHandler();

        Test.startTest();

        try{
            handler.handlePatch(req);
            System.assert(false, 'Exception expected: Valid body presented');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Invalid request body'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testPatchAsset_UpdateError(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Asset a = new Asset();
        a.Name = 'Test Asset';
        a.AccountId = acc.Id;
        insert a;

        OrderFunnel_Models.AssetModel assetModel = new OrderFunnel_Models.AssetModel();
        assetModel.name = 'Eide Bailly LLP';
        assetModel.accountId = null;
        assetModel.teId = 'PropertyId';
        assetModel.cuId = 'CustomerPropertyId';
        assetModel.currentTracingId = '12345';
        assetModel.address = new OrderFunnel_Models.AddressModel();
        assetModel.address.street = '2901 Ashton Blvd';
        assetModel.address.city = 'Lehi';
        assetModel.address.state = 'UT';
        assetModel.address.postalCode = '84043';
        assetModel.address.country = 'US';
        assetModel.accessCode = '9999';
        assetModel.accessNote = 'Enter through the side gate.';
        assetModel.additionalFields.add(new OrderFunnel_Models.AdditionalFieldModel('Asset1','label1','value1'));
        assetModel.metrics.add(new OrderFunnel_Models.MetricModel('Lawn', '1500'));

        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestURI = '/orderfunnel/asset/' + a.Id;
        req.requestBody = Blob.valueOf(JSON.serialize(assetModel));
        RestContext.request = req;

        OrderFunnel_AssetHandler handler = new OrderFunnel_AssetHandler();

        Test.startTest();

        try{
            handler.handlePatch(req);
            System.assert(false, 'Exception expected: Asset update successful');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(500, ex.statusCode);
            System.assert(ex.getMessage().contains('error occurred while updating the asset'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }
}