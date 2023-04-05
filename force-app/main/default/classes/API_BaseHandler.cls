public virtual class API_BaseHandler {
    /**
     * Common status codes:
     * * 200 OK
     * * 201 Created
     * * 202 Accepted
     * * 204 No Content
     * * 400 Bad Request
     * * 401 Unauthorized
     * * 403 Forbidden
     * * 404 Not Found
     * * 500 Internal Server Error (Served when apex error thrown)
     */
    public void setStatusCode(Integer statusCode){
        API_Dispatcher.statusCode = statusCode;
    }

    public virtual List<Object> handleGet(RestRequest req){
        throw new API_Dispatcher.APIException(501, 'GET method not implemented.');
    }

    public virtual List<Object> handlePost(RestRequest req){
        throw new API_Dispatcher.APIException(501, 'POST method not implemented.');
    }

    public virtual List<Object> handlePatch(RestRequest req){
        throw new API_Dispatcher.APIException(501, 'PATCH method not implemented.');
    }

    public virtual List<Object> handlePut(RestRequest req){
        throw new API_Dispatcher.APIException(501, 'PUT method not implemented.');
    }

    public virtual List<Object> handleDelete(RestRequest req){
        throw new API_Dispatcher.APIException(501, 'DELETE method not implemented.');
    }

}