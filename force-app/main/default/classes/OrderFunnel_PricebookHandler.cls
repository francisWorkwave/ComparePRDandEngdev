public with sharing class OrderFunnel_PricebookHandler extends API_BaseHandler{

    public override List<Object> handleGet(RestRequest req){
        //Parameter extraction
        String pricebookId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        String accountId = req.params.get('accountId');

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(pricebookId, true, Pricebook2.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Pricebook identifier invalid');
        }
        if(pricebookId == ''){
            pricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true].Id;
        }

        //Execution logic
        List<OrderFunnel_Models.Pricebook> pbs = OrderFunnel_PricebookUtility.getPricebooks(pricebookId, false);

        setStatusCode(200);

        return pbs;
    }
}