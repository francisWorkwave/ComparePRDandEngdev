@isTest
public with sharing class OrderFunnel_QuoteHandlerTest {
    @isTest
    public static void handleGet_Success(){
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

        OrderFunnel_QuoteHandler handler = new OrderFunnel_QuoteHandler();

        Test.startTest();

        List<CPQ_Models.QuoteModel> models = (List<CPQ_Models.QuoteModel>) handler.handleGet(req);

        Test.stopTest();

        System.assertEquals(1, models.size());
    }

    @isTest
    public static void handleGet_InvalidId(){

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/quote/001000000000000';

        OrderFunnel_QuoteHandler handler = new OrderFunnel_QuoteHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
            System.assert(false, 'Exception expected: Invalid quote id');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Quote identifier invalid'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handlePost_Success(){
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

        OrderFunnel_QuoteHandler handler = new OrderFunnel_QuoteHandler();

        Test.startTest();

        List<CPQ_Models.QuoteModel> models = (List<CPQ_Models.QuoteModel>) handler.handlePost(req);

        Test.stopTest();

        System.assertEquals(1, models.size());
    }

    @isTest
    public static void handleGet_InvalidAssetId(){

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/quote/';
        req.params.put('assetId', '');

        OrderFunnel_QuoteHandler handler = new OrderFunnel_QuoteHandler();

        Test.startTest();

        try{
            handler.handlePost(req);
            System.assert(false, 'Exception expected: Invalid asset id');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Asset identifier invalid'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handleGet_InvalidPricebookId(){

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/quote/';
        req.params.put('assetId', '02i000000000000');
        req.params.put('pricebookId', '02i000000000000');

        OrderFunnel_QuoteHandler handler = new OrderFunnel_QuoteHandler();

        Test.startTest();

        try{
            handler.handlePost(req);
            System.assert(false, 'Exception expected: Invalid pricebook id');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Pricebook identifier invalid'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }
}