public with sharing class OrderFunnel_AssetHandler extends API_BaseHandler{

    public override List<Object> handleGet(RestRequest req){

        //Parameter extraction
        String assetId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(assetId) == false){
            throw new API_Dispatcher.APIException(400, 'Asset identifier invalid');
        }

        //Execution Logic
        List<Asset> assets = OrderFunnel_AssetUtility.getAssets(null, null, assetId, false);

        List<OrderFunnel_Models.AssetModel> models = new List<OrderFunnel_Models.AssetModel>();
        for(Asset a:assets){
            models.add(OrderFunnel_AssetUtility.buildModel(a));
        }

        setStatusCode(200);

        return models;
    }

    public override List<Object> handlePost(RestRequest req){

        //Parameter extraction
        Blob assetModelRaw = req.requestBody;
        OrderFunnel_Models.AssetModel assetModel;

        // Parameter validation
        if(assetModelRaw == null){
            throw new API_Dispatcher.APIException(400, 'Missing request body');
        }

        try{
            assetModel = (OrderFunnel_Models.AssetModel) JSON.deserialize(assetModelRaw.toString(), OrderFunnel_Models.AssetModel.class);
        }catch(Exception ex){
            throw new API_Dispatcher.APIException(400, 'Invalid request body. ' + ex.getMessage());
        }

        //Execution Logic
        try{

            Asset a = OrderFunnel_AssetUtility.buildAsset(assetModel, null);
            insert a;

            setStatusCode(201);
            return new List<Object>{new OrderFunnel_Models.DMLResponse(a.Id, a.AccountId, a.Name)};
        }catch(Exception ex){
            throw new API_Dispatcher.APIException(500, 'An error occurred while updating the asset. ' + ex.getMessage());
        }
    }

    public override List<Object> handlePatch(RestRequest req){

        //Parameter extraction
        String assetId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Blob assetModelRAW = req.requestBody;
        OrderFunnel_Models.AssetModel assetModel;

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(assetId) == false){
            throw new API_Dispatcher.APIException(400, 'Invalid asset id value.');
        }
        if(assetModelRAW == null){
            throw new API_Dispatcher.APIException(400, 'Missing request body');
        }
        try{
            assetModel = (OrderFunnel_Models.AssetModel) JSON.deserialize(assetModelRAW.toString(), OrderFunnel_Models.AssetModel.class);
        }catch(Exception ex){
            throw new API_Dispatcher.APIException(400, 'Invalid request body. ' + ex.getMessage());
        }

        List<Asset> assets = OrderFunnel_AssetUtility.getAssets(null, null, assetId, false);

        try{
            Asset a = assets[0];
            OrderFunnel_AssetUtility.buildAsset(assetModel, a);
            update a;

            setStatusCode(200);

            return new List<Object>{new OrderFunnel_Models.DMLResponse(a.Id, a.accountId, a.Name)};
        }catch (Exception ex) {
            throw new API_Dispatcher.APIException(500, 'An error occurred while updating the asset.' + ex.getMessage());
        }
    }
}