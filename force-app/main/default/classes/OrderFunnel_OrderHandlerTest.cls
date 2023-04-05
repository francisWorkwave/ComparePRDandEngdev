@isTest
public with sharing class OrderFunnel_OrderHandlerTest {
    @isTest
    public static void handleGet_Success(){
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
        o.Pricebook2Id=Test.getStandardPricebookId(); 
        insert o;
        
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.Display_Name__c = 'Test Product';
        prod.ProductCode = 'TESTPROD';
        prod.IsActive = true;
        prod.Merchandising_Tags__c = 'Most Popular;Best Value';
        insert prod;
        
		PricebookEntry pbe=new PricebookEntry(unitprice=5,Product2Id=prod.Id, Pricebook2Id=Test.getStandardPricebookId(), IsActive= true); 
     	insert pbe;       
        
        OrderItem  oi = new OrderItem ();
        oi.Orderid = o.Id;
        oi.PricebookEntryId = pbe.id;
        oi.UnitPrice = 5;
        oi.Quantity = 1;
        insert oi;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/order/' + o.Id;

        OrderFunnel_OrderHandler handler = new OrderFunnel_OrderHandler();

        Test.startTest();

        List<OrderFunnel_Models.OrderModel> models = (List<OrderFunnel_Models.OrderModel>) handler.handleGet(req);

        Test.stopTest();

        System.assertEquals(1, models.size());
    }

    @isTest
    public static void handleGet_InvalidOrderId(){

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/order/001000000000000';

        OrderFunnel_OrderHandler handler = new OrderFunnel_OrderHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
            System.assert(false, 'Exception expected: Invalid order id');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Order identifier invalid'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handlePost_Success(){
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

        OrderFunnel_OrderHandler handler = new OrderFunnel_OrderHandler();

        Test.startTest();

        List<OrderFunnel_Models.DMLResponse> models = (List<OrderFunnel_Models.DMLResponse>) handler.handlePost(req);

        Test.stopTest();

        System.assertEquals(1, models.size());
    }

    @isTest
    public static void handlePost_InvalidQuoteId(){

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/order/';
        req.params.put('quoteId', '001000000000000');

        OrderFunnel_OrderHandler handler = new OrderFunnel_OrderHandler();

        Test.startTest();

        try{
            handler.handlePost(req);
            System.assert(false, 'Exception expected: Invalid quote id');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Quote identifier invalid'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }
}