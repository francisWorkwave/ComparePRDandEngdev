@isTest
public with sharing class OrderFunnel_ProductCPQHandlerTest {
    @isTest
    public static void handleGet_Success(){
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.Display_Name__c = 'Test Product';
        insert prod;

        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = prod.Id;
        pbe.UnitPrice = 1;
        insert pbe;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/product/' + prod.Id + '/cpq';
        req.params.put('pricebookId', Test.getStandardPricebookId());

        OrderFunnel_ProductCPQHandler handler = new OrderFunnel_ProductCPQHandler();

        Test.startTest();

        List<CPQ_Models.ProductModel> models = (List<CPQ_Models.ProductModel>) handler.handleGet(req);

        Test.stopTest();

        System.assertEquals(1, models.size());
    }

    @isTest
    public static void handleGet_InvalidProduct(){

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/product/001000000000000/cpq';

        OrderFunnel_ProductCPQHandler handler = new OrderFunnel_ProductCPQHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
            System.assert(false, 'Exception expected: Invalid product id');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Product identifier invalid:'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handleGet_InvalidPricebook(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/product/01t000000000000/cpq';

        OrderFunnel_ProductCPQHandler handler = new OrderFunnel_ProductCPQHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
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