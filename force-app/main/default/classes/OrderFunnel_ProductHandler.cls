public with sharing class OrderFunnel_ProductHandler extends API_BaseHandler{
    public override List<Object> handleGet(RestRequest req){

        //Parameter extraction
        String productId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        String accountId = req.params.get('accountId');

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(productId, false, Product2.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Product identifier invalid');
        }
        if(OrderFunnel_Utility.isValidId(accountId, true, Account.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Account identifier invalid');
        }

        //Execution logic
        List<Product2> products = OrderFunnel_ProductUtility.getProducts(new Set<Id>{productId}, false);

        List<OrderFunnel_Models.Product2Model> models = new List<OrderFunnel_Models.Product2Model>();
        for(Product2 prod:products){
            models.add(OrderFunnel_ProductUtility.buildModel(productId, accountId));
        }

        setStatusCode(200);

        return models;
    }
}