@isTest
public with sharing class OrderFunnel_OrderTest {
    @IsTest
    public static void testGET(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Asset a = new Asset();
        a.Name = 'Test Asset';
        a.AccountId = acc.Id;
        insert a;

        Order o = new Order();
        o.AccountId = acc.Id;
        o.Asset__c = a.Id;
        o.EffectiveDate = Date.today();
        o.Status = 'Draft';
        insert o;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/order/' + o.Id;
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Order.doGet();
        Test.stopTest();

        System.assertEquals(200, resp.statusCode);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resp.responseBody.toString());
        System.assertEquals(true, result.get('success'));
        System.assertEquals(1, result.get('recordCount'));
        List<OrderFunnel_Models.OrderModel> records = (List<OrderFunnel_Models.OrderModel>) JSON.deserialize(JSON.serialize(result.get('records')), List<OrderFunnel_Models.OrderModel>.class);
        System.assertEquals(o.Id, records[0].orderId);
        System.assertEquals(a.Id, records[0].asset.sfId);
    }

    @IsTest
    public static void testPOST(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Asset a = new Asset();
        a.Name = 'Test Asset';
        a.AccountId = acc.Id;
        insert a;

        Opportunity o = new Opportunity();
        o.Name = 'Test Opp';
        o.AccountId = acc.Id;
        o.StageName = 'Prospecting';
        o.CloseDate = Date.today();
        o.Pricebook2Id = Test.getStandardPricebookId();
        o.Opportunity_Origination__c = 'Facebook';
        insert o;

        SBQQ__Quote__c q = new SBQQ__Quote__c();
        q.SBQQ__Account__c = acc.Id;
        q.Asset__c = a.Id;
        q.SBQQ__PricebookId__c = Test.getStandardPricebookId();
        q.SBQQ__Primary__c = true;
        q.SBQQ__Opportunity2__c = o.Id;
        insert q;

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
        pbe.IsActive = true;
        insert pbe;

        SBQQ__QuoteLine__c qli = new SBQQ__QuoteLine__c();
        qli.SBQQ__Quote__c = q.Id;
        qli.SBQQ__PricebookEntryId__c = pbe.Id;
        qli.SBQQ__Product__c = prod.Id;
        qli.SBQQ__Quantity__c = 1;
        qli.SBQQ__ListPrice__c = 1;
        qli.SBQQ__NetPrice__c = 1;
        insert qli;

        o.SBQQ__PrimaryQuote__c = q.Id;
        update o;

        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Product2Id = prod.Id;
        oli.OpportunityId = o.Id;
        oli.PricebookEntryId = pbe.Id;
        oli.TotalPrice = 1;
        oli.Quantity = 1;
        oli.SBQQ__QuoteLine__c = qli.Id;
        insert oli;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/order/';
        req.params.put('quoteId', q.Id);
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Order.doPost();
        Test.stopTest();

        System.assertEquals(201, resp.statusCode);

        SBQQ__Quote__c q2 = [SELECT Id, SBQQ__Status__c FROM SBQQ__Quote__c WHERE Id = :q.Id];
        System.assertEquals('Accepted', q2.SBQQ__Status__c);
    }

    @IsTest
    public static void testPATCH(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Order.doPatch();
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
        OrderFunnel_Order.doPut();
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
        OrderFunnel_Order.doDelete();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }
}