@isTest
public with sharing class OrderFunnel_AssetListTest {
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
        req.requestURI = '/orderfunnel/asset/list';
        req.params.put('id',ast.Id);
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_AssetList.doGet();
        Test.stopTest();

        System.assertEquals(200, resp.statusCode);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resp.responseBody.toString());
        System.assertEquals(true, result.get('success'));
        System.assertEquals(1, result.get('recordCount'));
        List<OrderFunnel_Models.AssetModel> records = (List<OrderFunnel_Models.AssetModel>) JSON.deserialize(JSON.serialize(result.get('records')), List<OrderFunnel_Models.AssetModel>.class);
        System.assertEquals('2901 Ashton Blvd', records[0].name);
    }

    @IsTest
    public static void testPOST(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_AssetList.doPost();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }

    @IsTest
    public static void testPATCH(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_AssetList.doPatch();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }

    @IsTest
    public static void testPUT(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_AssetList.doPut();
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
        OrderFunnel_AssetList.doDelete();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }
}