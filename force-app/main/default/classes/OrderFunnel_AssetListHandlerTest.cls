@isTest
public with sharing class OrderFunnel_AssetListHandlerTest {

    @isTest
    public static void testHandleGet_Success(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Asset ast = new Asset();
        ast.Name = '2901 Ashton Blvd';
        ast.AccountId = a.Id;
        insert ast;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/list';
        req.params.put('id', ast.Id);

        OrderFunnel_AssetListHandler handler = new OrderFunnel_AssetListHandler();

        Test.startTest();

        List<OrderFunnel_Models.AssetModel> models = (List<OrderFunnel_Models.AssetModel>) handler.handleGet(req);

        Test.stopTest();

        System.assertEquals(1, models.size());
    }

    @isTest
    public static void testHandleGet_InvalidAssetId(){

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/list';
        req.params.put('id', 'X001000000000000');

        OrderFunnel_AssetListHandler handler = new OrderFunnel_AssetListHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
            System.assert(false, 'Exception expected: Invalid asset id');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Invalid asset id value.'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testHandleGet_InvalidAccountId(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/list';
        req.params.put('accountId', 'X003000000000000');

        OrderFunnel_AssetListHandler handler = new OrderFunnel_AssetListHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
            System.assert(false, 'Exception expected: Invalid account id');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Invalid account id value.'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void testHandleGet_NoParams(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/list';

        OrderFunnel_AssetListHandler handler = new OrderFunnel_AssetListHandler();

        Test.startTest();

        try{
            handler.handleGet(req);
            System.assert(false, 'Exception expected: No params presented');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Please specify at least one filter criteria.'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }
}