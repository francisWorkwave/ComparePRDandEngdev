@isTest
public with sharing class OrderFunnel_AssetRetraceTest {
    @IsTest
    public static void testGET(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_AssetRetrace.doGet();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }

    @IsTest
    public static void testPOST(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Asset ast = new Asset();
        ast.Name = '2901 Ashton Blvd';
        ast.AccountId = a.Id;
        insert ast;

        List<OrderFunnel_Models.MetricModel> models = new List<OrderFunnel_Models.MetricModel>();
        models.add(new OrderFunnel_Models.MetricModel('Lawn', '1500'));

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/' + ast.Id + '/retrace';
        req.requestBody = Blob.valueOf(JSON.serialize(models));
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_AssetRetrace.doPost();
        Test.stopTest();

        System.assertEquals(201, resp.statusCode);
    }

    @IsTest
    public static void testPATCH(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_AssetRetrace.doPatch();
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
        OrderFunnel_AssetRetrace.doPut();
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
        OrderFunnel_AssetRetrace.doDelete();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }
}