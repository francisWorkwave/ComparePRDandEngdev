@RestResource(urlMapping='/orderfunnel/pricebook/*/entries')
global with sharing class OrderFunnel_PricebookEntries {
    global static final String HANDLERNAME = 'OrderFunnel_PricebookEntriesHandler';

    @HttpGet
    global static void doGet(){
        API_Dispatcher.dispatch(HANDLERNAME, 'GET', RestContext.request, RestContext.response);
    }

    @HttpPost
    global static void doPost(){
        API_Dispatcher.dispatch(HANDLERNAME, 'POST', RestContext.request, RestContext.response);
    }

    @HttpPatch
    global static void doPatch(){
        API_Dispatcher.dispatch(HANDLERNAME, 'PATCH', RestContext.request, RestContext.response);
    }

    @HttpPut
    global static void doPut(){
        API_Dispatcher.dispatch(HANDLERNAME, 'PUT', RestContext.request, RestContext.response);
    }

    @HttpDelete
    global static void doDelete(){
        API_Dispatcher.dispatch(HANDLERNAME, 'DELETE', RestContext.request, RestContext.response);
    }
}