@isTest
public with sharing class OrderFunnel_ProductSearchHandlerTest {
    @isTest
    public static void handleGet_Success(){
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.Display_Name__c = 'Test Product';
        prod.ProductCode = 'TESTPROD';
        prod.IsActive = true;
        prod.Merchandising_Tags__c = 'Most Popular;Best Value';
        insert prod;

        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = prod.Id;
        pbe.UnitPrice = 1;
        insert pbe;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/product/search';
        req.params.put('includeInternal', 'true');
        req.params.put('tags', 'Most Popular');

        OrderFunnel_ProductSearchHandler handler = new OrderFunnel_ProductSearchHandler();

        Test.startTest();

        List<OrderFunnel_Models.ProductSearchResultModel> models = (List<OrderFunnel_Models.ProductSearchResultModel>) handler.handleGet(req);

        Test.stopTest();

        System.assertEquals(1, models.size());
    }

    @isTest
    public static void handleGet_InvalidAccount(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/product/search';
        req.params.put('accountId', '003000000000000');

        OrderFunnel_ProductSearchHandler handler = new OrderFunnel_ProductSearchHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
            System.assert(false, 'Exception expected: Invalid account id');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Account identifier invalid'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handleGet_InvalidAsset(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/product/search';
        req.params.put('assetId', '003000000000000');

        OrderFunnel_ProductSearchHandler handler = new OrderFunnel_ProductSearchHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
            System.assert(false, 'Exception expected: Invalid asset id');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Asset identifier invalid'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

}