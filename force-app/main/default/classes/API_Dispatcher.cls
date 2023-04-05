public with sharing class API_Dispatcher {

    public static Integer statusCode;

    public static void dispatch(String handlerName, String method, RestRequest req, RestResponse resp){
        Response apiResp = new Response();

        try{
            API_BaseHandler handler = getHandler(handlerName);
            apiResp.records = handleMethod(handler, method, req, resp);
        }catch(Exception ex){
            apiResp = handleException(req, resp, ex);
        }

        setResponse(resp, apiResp, statusCode);
    }

    @testVisible
    private static API_BaseHandler getHandler(String handlerName){
        try{
            System.Type t = Type.forName(handlerName);
            API_BaseHandler handler = (API_BaseHandler) t.newInstance();
            return handler;
        }catch(Exception ex){
            System.debug('Internal Error');
            System.debug(ex.getMessage());

            throw new APIException(500, 'Unable to locate handler \'' + handlerName + '\'. Please contact the system administrator.');
        }
    }

    @testVisible
    private static List<Object> handleMethod(API_BaseHandler handler, String method, RestRequest req, RestResponse resp){
        if(method == 'GET'){
            return handler.handleGet(req);
        }else if(method == 'POST'){
            return handler.handlePost(req);
        }else if(method == 'PATCH'){
            return handler.handlePatch(req);
        }else if(method == 'PUT'){
            return handler.handlePut(req);
        }else if(method == 'DELETE'){
            return handler.handleDelete(req);
        }else{
            throw new APIException(405, 'Method Not Allowed');
        }
    }

    @testVisible
    private static Response handleException(RestRequest req, RestResponse resp, Exception ex){
        if(req.headers.containsKey('Debug')){
            throw ex;
        }

        Response apiResp = new Response();
        apiResp.success = false;

        if(ex.getTypeName() == 'API_Dispatcher.APIException'){
            statusCode = ((APIException) ex).statusCode;
            apiResp.message = ex.getMessage();
        }else{
            statusCode = 500;
            apiResp.message = ex.getTypeName() + ':' + Label.API_ExceptionDefault;
        }

        return apiResp;
    }

    @testVisible
    private static void setResponse(RestResponse resp, Response apiResp, Integer statusCode){
        resp.statusCode = statusCode;
        resp.addHeader('Content-Type', 'application/json');
        resp.responseBody = Blob.valueOf(apiResp.toString());
    }

    public class Response{
        public Boolean success {get;set;}
        public String message {get;set;}
        public List<Object> records;
        public Integer recordCount{
            get{
                if(records == null){
                    return null;
                }
                return records.size();
            }
        }

        public Response(){
            this.success = true;
        }

        public override String toString(){
            return JSON.serialize(this, false);
        }
    }

    public class APIException extends Exception{
        public Integer statusCode {get;set;}

        public APIException(Integer statusCode, String message){
            this.statusCode = statusCode;
            this.setMessage(message);
        }
    }
}