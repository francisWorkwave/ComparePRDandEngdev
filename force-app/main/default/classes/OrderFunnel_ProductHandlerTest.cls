@isTest
public with sharing class OrderFunnel_ProductHandlerTest {
    @isTest
    public static void handleGet_Success(){
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.Display_Name__c = 'Test Product';
        prod.ProductCode = 'TESTPROD';
        prod.IsActive = true;
        prod.Merchandising_Tags__c = 'Most Popular;Best Value';
        insert prod;

        Service_Type__c service = new Service_Type__c(Contractor_Description__c = 'Description', Name = 'Name', External_ID__c = prod.id);
        insert service;
        
        Component_Service__c component = new Component_Service__c(Product__c = prod.Id, Service_Type__c = service.id, Service_Type_Description__c = 'Des');
		insert component;
        
        Photo__c photo = new Photo__c(Before_Service__c = true, Name = 'Name');
        insert photo;
        
        Photo_Set_Item__c photoSet = new Photo_Set_Item__c(Service_Type__c = service.id, Photo__c = photo.id);
        insert photoSet;
        
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/product/' + prod.Id;

        OrderFunnel_ProductHandler handler = new OrderFunnel_ProductHandler();

        Test.startTest();

        List<OrderFunnel_Models.Product2Model> models = (List<OrderFunnel_Models.Product2Model>) handler.handleGet(req);

        Test.stopTest();

        System.assertEquals(1, models.size());
    }

    @isTest
    public static void handleGet_InvalidAccount(){

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/product/01t000000000000';
        req.params.put('accountId', '003000000000000');

        OrderFunnel_ProductHandler handler = new OrderFunnel_ProductHandler();

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
    public static void handleGet_InvalidProduct(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/product/001000000000000';

        OrderFunnel_ProductHandler handler = new OrderFunnel_ProductHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
            System.assert(false, 'Exception expected: Invalid product id');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Product identifier invalid'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }
}