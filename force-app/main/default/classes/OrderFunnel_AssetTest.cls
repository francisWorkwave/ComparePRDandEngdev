@isTest
public with sharing class OrderFunnel_AssetTest {
    @IsTest
    public static void testGET(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Asset ast = new Asset();
        ast.Name = '2901 Ashton Blvd';
        ast.AccountId = a.Id;
        insert ast;


        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/' + ast.Id;
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Asset.doGet();
        Test.stopTest();

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resp.responseBody.toString());
        System.assertEquals(true, result.get('success'));
        System.assertEquals(1, result.get('recordCount'));
        List<OrderFunnel_Models.AssetModel> records = (List<OrderFunnel_Models.AssetModel>) JSON.deserialize(JSON.serialize(result.get('records')), List<OrderFunnel_Models.AssetModel>.class);
        System.assertEquals('2901 Ashton Blvd', records[0].name);
    }

    @IsTest
    public static void testPOST(){
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

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Asset.doPost();
        Test.stopTest();

        System.assertEquals(201, resp.statusCode);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resp.responseBody.toString());
        System.assertEquals(true, result.get('success'));
        System.assertEquals(1, result.get('recordCount'));
        List<OrderFunnel_Models.DMLResponse> records = (List<OrderFunnel_Models.DMLResponse>) JSON.deserialize(JSON.serialize(result.get('records')), List<OrderFunnel_Models.DMLResponse>.class);
        System.assertNotEquals(null, records[0].id);
    }

    @IsTest
    public static void testPATCH(){
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
        assetModel.sfId = a.Id;
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

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Asset.doPatch();
        Test.stopTest();

        System.assertEquals(200, resp.statusCode);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resp.responseBody.toString());
        System.assertEquals(true, result.get('success'));
        System.assertEquals(1, result.get('recordCount'));
        List<OrderFunnel_Models.DMLResponse> records = (List<OrderFunnel_Models.DMLResponse>) JSON.deserialize(JSON.serialize(result.get('records')), List<OrderFunnel_Models.DMLResponse>.class);
        System.assertEquals(a.Id, records[0].id);

        Asset a2 = [SELECT Id, Name, Lawn_Sq_Ft__c FROM Asset WHERE Id = :a.Id];
        System.assertEquals('Eide Bailly LLP', a2.Name);
        System.assertEquals(1500, a2.Lawn_Sq_Ft__c);
    }

    @IsTest
    public static void testPUT(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Asset.doPut();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }

    @IsTest
    public static void testDELETE(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Asset.doDelete();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }
}