@isTest
public with sharing class OrderFunnel_ProductSearchTest {
    @IsTest
    public static void testGET() {
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.Display_Name__c = 'Test Product';
        prod.ProductCode = 'TESTPROD';
        prod.IsActive = true;
        insert prod;

        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = prod.Id;
        pbe.UnitPrice = 1;
        insert pbe;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/product/search';
        req.params.put('includeInternal', 'true');
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_ProductSearch.doGet();
        Test.stopTest();

        System.assertEquals(200, resp.statusCode);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resp.responseBody.toString());
        System.assertEquals(true, result.get('success'));
        System.assertEquals(1, result.get('recordCount'));
        List<OrderFunnel_Models.ProductSearchResultModel> records = (List<OrderFunnel_Models.ProductSearchResultModel>) JSON.deserialize(JSON.serialize(result.get('records')), List<OrderFunnel_Models.ProductSearchResultModel>.class);
        System.assertEquals('Test Product', records[0].productName);
    }

    @IsTest
    public static void testPOST() {
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_ProductSearch.doPost();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }

    @IsTest
    public static void testPATCH() {
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_ProductSearch.doPatch();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }

    @IsTest
    public static void testPUT() {
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_ProductSearch.doPut();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }

    @IsTest
    public static void testDELETE() {
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_ProductSearch.doDelete();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }
}