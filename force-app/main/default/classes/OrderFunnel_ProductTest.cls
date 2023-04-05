@isTest
public with sharing class OrderFunnel_ProductTest {
    @IsTest
    public static void testGET(){
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.Display_Name__c = 'Test Product';
        prod.ProductCode = 'TESTPROD';
        prod.IsActive = true;
        insert prod;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/product/' + prod.Id;
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Product.doGet();
        Test.stopTest();

        System.assertEquals(200, resp.statusCode);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resp.responseBody.toString());
        System.assertEquals(true, result.get('success'));
        System.assertEquals(1, result.get('recordCount'));
        List<OrderFunnel_Models.Product2Model> records = (List<OrderFunnel_Models.Product2Model>) JSON.deserialize(JSON.serialize(result.get('records')), List<OrderFunnel_Models.Product2Model>.class);
        System.assertEquals('Test Product', records[0].productName);
    }

    @IsTest
    public static void testPOST(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Product.doPost();
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
        OrderFunnel_Product.doPatch();
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
        OrderFunnel_Product.doPut();
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
        OrderFunnel_Product.doDelete();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }
}