public with sharing class OrderFunnel_AccountHandler extends API_BaseHandler{
    public override List<Object> handleGet(RestRequest req){

        //Parameter extraction
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(accountId) == false){
            throw new API_Dispatcher.APIException(400, 'Account identifier invalid');
        }

        //Execution Logic
        List<Account> accs = OrderFunnel_AccountUtility.getAccounts(accountId);

        if(accs.isEmpty()){
            throw new API_Dispatcher.APIException(404, 'Account not found');
        }

        List<OrderFunnel_Models.AccountModel> models = new List<OrderFunnel_Models.AccountModel>();
        for(Account a:accs){
            models.add(OrderFunnel_AccountUtility.buildModel(a));
        }

        setStatusCode(200);

        return models;
    }

    public override List<Object> handlePatch(RestRequest req){

        //Parameter extraction
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Blob accModelRaw = req.requestBody;
        OrderFunnel_Models.AccountModel accModel;

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(accountId) == false){
            throw new API_Dispatcher.APIException(400, 'Account identifier invalid');
        }
        if(accModelRaw == null){
            throw new API_Dispatcher.APIException(400, 'Missing request body');
        }

        try{
            accModel = (OrderFunnel_Models.AccountModel) JSON.deserialize(accModelRaw.toString(), OrderFunnel_Models.AccountModel.class);
        }catch(Exception ex){
            throw new API_Dispatcher.APIException(400, 'Invalid request body. ' + ex.getMessage());
        }

        //Execution Logic
        List<Account> accs = OrderFunnel_AccountUtility.getAccounts(accountId);

        if(accs.isEmpty()){
            throw new API_Dispatcher.APIException(404, 'Account not found');
        }

        // * Removed as the only current query parameter is recordId and will NEVER return a list.
        // if(accs.size() > 1){
        //     throw new API_Dispatcher.APIException(300, 'Multiple accounts identified');
        // }

        try{
            Account a = accs[0];
            OrderFunnel_AccountUtility.buildAccount(accModel, a);
            update a;

            setStatusCode(200);

            return new List<Object>{new OrderFunnel_Models.DMLResponse(a.Id)};
        }catch (Exception ex) {
            throw new API_Dispatcher.APIException(500, 'An error occurred while updating the account.' + ex.getMessage());
        }
    }
}