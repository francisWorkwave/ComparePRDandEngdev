@isTest
public with sharing class API_DispatcherTest {

    @isTest
    public static void testDispatch(){
        RestRequest req = new RestRequest();
        RestResponse resp = new RestResponse();

        Test.startTest();
        API_Dispatcher.dispatch('API_BaseHandler', 'GET', req, resp);
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }

    @isTest
    public static void testDispatch_debug(){
        RestRequest req = new RestRequest();
        req.headers.put('Debug', 'Debug');
        RestResponse resp = new RestResponse();

        Test.startTest();
        try{
            API_Dispatcher.dispatch('API_BaseHandler', 'GET', req, resp);
            System.assert(false);
        }catch(API_Dispatcher.APIException ex){
            System.assert(true);
        }
        Test.stopTest();
    }

    @isTest
    public static void testDispatch_InvalidHandler(){
        RestRequest req = new RestRequest();
        RestResponse resp = new RestResponse();

        Test.startTest();
        API_Dispatcher.dispatch('RandomClassName', 'GET', req, resp);
        Test.stopTest();

        System.assert(resp.statusCode > 200);
    }

    @IsTest
    public static void testHandleMethods(){
        RestRequest req = new RestRequest();
        RestResponse resp = new RestResponse();
        API_BaseHandler handler = new API_BaseHandler();

        Test.startTest();

        try{
            API_Dispatcher.handleMethod(handler, 'GET', req, resp);
            System.assert(false, 'Exception expected: GET called.');
        }catch(API_Dispatcher.APIException ex){
            System.assert(ex.getMessage().startsWith('GET'));
            System.assertEquals(501, ex.statusCode);
        }

        try{
            API_Dispatcher.handleMethod(handler, 'POST', req, resp);
            System.assert(false, 'Exception expected: POST called.');
        }catch(API_Dispatcher.APIException ex){
            System.assert(ex.getMessage().startsWith('POST'));
            System.assertEquals(501, ex.statusCode);
        }

        try{
            API_Dispatcher.handleMethod(handler, 'PATCH', req, resp);
            System.assert(false, 'Exception expected: PATCH called.');
        }catch(API_Dispatcher.APIException ex){
            System.assert(ex.getMessage().startsWith('PATCH'));
            System.assertEquals(501, ex.statusCode);
        }

        try{
            API_Dispatcher.handleMethod(handler, 'PUT', req, resp);
            System.assert(false, 'Exception expected: PUT called.');
        }catch(API_Dispatcher.APIException ex){
            System.assert(ex.getMessage().startsWith('PUT'));
            System.assertEquals(501, ex.statusCode);
        }

        try{
            API_Dispatcher.handleMethod(handler, 'DELETE', req, resp);
            System.assert(false, 'Exception expected: DELETE called.');
        }catch(API_Dispatcher.APIException ex){
            System.assert(ex.getMessage().startsWith('DELETE'));
            System.assertEquals(501, ex.statusCode);
        }

        try{
            API_Dispatcher.handleMethod(handler, 'HEAD', req, resp);
            System.assert(false, 'Exception expected: HEAD called.');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals('Method Not Allowed', ex.getMessage());
            System.assertEquals(405, ex.statusCode);
        }

        Test.stopTest();
    }

    @isTest
    public static void testHandleException_Debug(){
        RestRequest req = new RestRequest();
        RestResponse resp = new RestResponse();
        Exception ex = new API_Dispatcher.APIException();

        req.headers.put('Debug', 'Debug');

        Test.startTest();

        try{
            API_Dispatcher.handleException(req, resp, ex);
            System.assert(false, 'Exception expected: Debug header present');
        }catch(Exception exLocal){
            System.assertEquals(ex.getTypeName(), exLocal.getTypeName());
        }

        Test.stopTest();
    }

    @isTest
    public static void testHandleException_MaskedAPI(){
        RestRequest req = new RestRequest();
        RestResponse resp = new RestResponse();
        Exception ex = new API_Dispatcher.APIException(600, 'This is bad');

        Test.startTest();

        API_Dispatcher.Response respBody = API_Dispatcher.handleException(req, resp, ex);

        Test.stopTest();

        System.assertEquals(false, respBody.success);
        System.assertEquals('This is bad', respBody.message);
        System.assertEquals(600, API_Dispatcher.statusCode);
    }

    @isTest
    public static void testHandleException_MaskedNonAPI(){
        RestRequest req = new RestRequest();
        RestResponse resp = new RestResponse();
        Exception ex;

        try{
            Integer i = 1 / 0;
        }catch(Exception exTemp){
            ex = exTemp;
        }

        Test.startTest();

        API_Dispatcher.Response respBody = API_Dispatcher.handleException(req, resp, ex);

        Test.stopTest();

        System.assertEquals(false, respBody.success);
        System.assert(respBody.message.contains(Label.API_ExceptionDefault));
        System.assertEquals(500, API_Dispatcher.statusCode);
    }

    @isTest
    public static void testSetResponse(){
        RestResponse resp = new RestResponse();
        API_Dispatcher.Response respBody = new API_Dispatcher.Response();

        Test.startTest();

        API_Dispatcher.setResponse(resp, respBody, 201);

        Test.stopTest();

        System.assertEquals(201, resp.statusCode);
        System.assert(resp.responseBody.toString().contains('"success":true'));
    }
}