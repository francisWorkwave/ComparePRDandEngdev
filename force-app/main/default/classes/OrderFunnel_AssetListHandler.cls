public with sharing class OrderFunnel_AssetListHandler extends API_BaseHandler{

    public override List<Object> handleGet(RestRequest req){

        //Parameter extraction
        String assetid = req.params.get('id');
        String accountId = req.params.get('accountId');
        String propertyId = req.params.get('propertyId'); //The TE property identifier

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(assetId, true) == false){ throw new API_Dispatcher.APIException(400, 'Invalid asset id value.'); }
        if(OrderFunnel_Utility.isValidId(accountId, true) == false){ throw new API_Dispatcher.APIException(400, 'Invalid account id value.'); }

        if(
            OrderFunnel_Utility.isValidId(assetId) == false &&
            OrderFunnel_Utility.isValidId(accountId) == false &&
            (propertyId == null || propertyId == '')
        ){
            throw new API_Dispatcher.APIException(400, 'Please specify at least one filter criteria.');
        }

        //Execution Logic
        List<Asset> assets = OrderFunnel_AssetUtility.getAssets(accountId, propertyId, assetId, true);

        List<OrderFunnel_Models.AssetModel> models = new List<OrderFunnel_Models.AssetModel>();
        for(Asset a:assets){
            models.add(OrderFunnel_AssetUtility.buildModel(a));
        }

        setStatusCode(200);

        return models;
    }
}