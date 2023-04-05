@isTEst
public with sharing class API_BaseHandlerTest {
    @isTest
    public static void testHandleGet(){
        API_BaseHandler dispatch = new API_BaseHandler();

        RestRequest req = new RestRequest();

        try{
            dispatch.handleGET(req);
            System.assert(false, 'An exception should have been thrown.');
        }catch(API_Dispatcher.APIException ex){
            System.assert(true);
            System.assertEquals(501, ex.statusCode);
        }
    }

    @isTest
    public static void testHandlePOST(){
        API_BaseHandler dispatch = new API_BaseHandler();

        RestRequest req = new RestRequest();

        try{
            dispatch.handlePost(req);
            System.assert(false, 'An exception should have been thrown.');
        }catch(API_Dispatcher.APIException ex){
            System.assert(true);
            System.assertEquals(501, ex.statusCode);
        }
    }

    @isTest
    public static void testHandlePut(){
        API_BaseHandler dispatch = new API_BaseHandler();

        RestRequest req = new RestRequest();

        try{
            dispatch.handlePut(req);
            System.assert(false, 'An exception should have been thrown.');
        }catch(API_Dispatcher.APIException ex){
            System.assert(true);
            System.assertEquals(501, ex.statusCode);
        }
    }

    @isTest
    public static void testHandlePATCH(){
        API_BaseHandler dispatch = new API_BaseHandler();

        RestRequest req = new RestRequest();

        try{
            dispatch.handlePatch(req);
            System.assert(false, 'An exception should have been thrown.');
        }catch(API_Dispatcher.APIException ex){
            System.assert(true);
            System.assertEquals(501, ex.statusCode);
        }
    }

    @isTest
    public static void testHandleDELETE(){
        API_BaseHandler dispatch = new API_BaseHandler();

        RestRequest req = new RestRequest();

        try{
            dispatch.handleDelete(req);
            System.assert(false, 'An exception should have been thrown.');
        }catch(API_Dispatcher.APIException ex){
            System.assert(true);
            System.assertEquals(501, ex.statusCode);
        }
    }

    @isTest
    public static void testSetStatusCode(){
        System.assertEquals(null, API_Dispatcher.statusCode);

        API_BaseHandler dispatch = new API_BaseHandler();

        dispatch.setStatusCode(500);

        System.assertEquals(500, API_Dispatcher.statusCode);

    }
}