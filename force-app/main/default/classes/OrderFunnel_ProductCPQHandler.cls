public with sharing class OrderFunnel_ProductCPQHandler extends API_BaseHandler{
    public override List<Object> handleGet(RestRequest req){

        //Parameter extraction
        String productId = req.requestURI.substringBetween('product/', '/cpq');
        String pricebookId = req.params.get('pricebookId');

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(productId, false, Product2.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Product identifier invalid: ' + productId);
        }
        if(OrderFunnel_Utility.isValidId(pricebookId, false, Pricebook2.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Pricebook identifier invalid');
        }

        //Execution logic
        CPQ_Models.ProductModel model = OrderFunnel_ProductUtility.buildCPQModel(productId, pricebookId);

        setStatusCode(200);

        return new List<CPQ_Models.ProductModel>{model};
    }
}