@isTest
public with sharing class OrderFunnel_AssetRetraceHandlerTest {
    @isTest
    public static void handlePost_Success(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Asset ast = new Asset();
        ast.Name = '2901 Ashton Blvd';
        ast.AccountId = a.Id;
        insert ast;

        List<OrderFunnel_Models.MetricModel> models = new List<OrderFunnel_Models.MetricModel>();
        models.add(new OrderFunnel_Models.MetricModel('Lawn', '1500'));

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/' + ast.Id + '/retrace';
        req.requestBody = Blob.valueOf(JSON.serialize(models));

        OrderFunnel_AssetRetraceHandler handler = new OrderFunnel_AssetRetraceHandler();

        Test.startTest();

        List<Property_Tracing__c> results = (List<Property_Tracing__c>) handler.handlePost(req);

        Test.stopTest();

        System.assertEquals(1, results.size());
    }

    @isTest
    public static void handlePost_InvalidAssetId(){

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/001000000000000/retrace';

        OrderFunnel_AssetRetraceHandler handler = new OrderFunnel_AssetRetraceHandler();

        Test.startTest();

        try{
            handler.handlePost(req);
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
    public static void handlePost_InvalidMetrics(){

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/02i000000000000/retrace';
        req.requestBody = Blob.valueOf('[{]');

        OrderFunnel_AssetRetraceHandler handler = new OrderFunnel_AssetRetraceHandler();

        Test.startTest();

        try{
            handler.handlePost(req);
            System.assert(false, 'Exception expected: Invalid metrics');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
            System.assert(ex.getMessage().contains('Invalid metrics submitted'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @isTest
    public static void handlePost_InvalidUpdate(){

        List<OrderFunnel_Models.MetricModel> models = new List<OrderFunnel_Models.MetricModel>();
        models.add(new OrderFunnel_Models.MetricModel('Lawn','Lawn_Sq_Ft__c'));
        models.add(new OrderFunnel_Models.MetricModel('Weeding','Garden_Sq_Ft__c'));

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/asset/02i000000000000/retrace';
        req.requestBody = Blob.valueOf(JSON.serialize(models));

        OrderFunnel_AssetRetraceHandler handler = new OrderFunnel_AssetRetraceHandler();

        Test.startTest();

        try{
            handler.handlePost(req);
            System.assert(false, 'Exception expected: General Failure');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(500, ex.statusCode);
            System.assert(ex.getMessage().contains('An error occurred while requesting a retrace.'));
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }
}