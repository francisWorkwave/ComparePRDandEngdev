@isTest
public with sharing class OrderFunnel_QuoteTest {
    @IsTest
    public static void testGET(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Asset a = new Asset();
        a.Name = 'Test Asset';
        a.AccountId = acc.Id;
        insert a;

        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Account__c = acc.Id;
        q.Asset__c = a.Id;
        q.SBQQ__PricebookId__c = Test.getStandardPricebookId();
        insert q;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/quote/' + q.Id;
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Quote.doGet();
        Test.stopTest();

        System.assertEquals(200, resp.statusCode);
    }

    @IsTest
    public static void testPOST(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Price_Book__c = Test.getStandardPricebookId();
        insert acc;

        Asset a = new Asset();
        a.Name = 'Test Asset';
        a.AccountId = acc.Id;
        insert a;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/quote/';
        req.params.put('assetId', a.Id);
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Quote.doPost();
        Test.stopTest();

        System.assertEquals(201, resp.statusCode);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resp.responseBody.toString());
        System.assertEquals(true, result.get('success'));
        System.assertEquals(1, result.get('recordCount'));
        List<CPQ_Models.QuoteModel> records = (List<CPQ_Models.QuoteModel>) JSON.deserialize(JSON.serialize(result.get('records')), List<CPQ_Models.QuoteModel>.class);
        System.assertNotEquals(null, records[0].record.id);
    }

    @IsTest
    public static void testPATCH(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Quote.doPatch();
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
        OrderFunnel_Quote.doPut();
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
        OrderFunnel_Quote.doDelete();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }
}