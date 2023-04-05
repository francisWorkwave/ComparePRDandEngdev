public with sharing class OrderFunnel_PricebookEntriesHandler extends API_BaseHandler{
    public override List<Object> handleGet(RestRequest req){

        //Parameter extraction
        String pricebookId = req.requestURI.substringBetween('pricebook/', '/entries');
        String accountId = req.params.get('accountId');
        String productId = req.params.get('productId');
        Boolean showAll = req.params.get('showAll') != null;

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(pricebookId, true, Pricebook2.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Pricebook identifier invalid');
        }
        if(OrderFunnel_Utility.isValidId(accountId, true, Account.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Account identifier invalid');
        }
        if(OrderFunnel_Utility.isValidId(productId, true, Product2.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Product2 identifier invalid');
        }

        //Execution logic
        List<OrderFunnel_Models.PricebookEntry> pbeModels = OrderFunnel_PricebookUtility.getPricebookEntries(pricebookId, accountId, productId, showAll);

        setStatusCode(200);

        return pbeModels;
    }
}