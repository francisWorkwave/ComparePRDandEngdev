public with sharing class OrderFunnel_PricebookListHandler extends API_BaseHandler{
    public override List<Object> handleGet(RestRequest req){
        //Parameter extraction
        Boolean includeInactive = req.params.get('showInactive') != null;

        //Parameter validation

        //Execution logic
        List<OrderFunnel_Models.Pricebook> pbs = OrderFunnel_PricebookUtility.getPricebooks(null, includeInactive);

        setStatusCode(200);

        return pbs;
    }
}