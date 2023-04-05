public with sharing class OrderFunnel_AssetRetraceHandler extends API_BaseHandler {

    public override List<Object> handlePost(RestRequest req){

        //Parameter extraction
        String assetId = req.requestURI.substringBetween('asset/', '/retrace');

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(assetId, false, Asset.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Invalid asset id value.');
        }

        List<OrderFunnel_Models.MetricModel> metrics;
        try{
            metrics = (List<OrderFunnel_Models.MetricModel>) JSON.deserialize(req.requestBody.toString(), List<OrderFunnel_Models.MetricModel>.class);
        }catch(Exception ex){
            throw new API_Dispatcher.APIException(400, 'Invalid metrics submitted');
        }

        try{
            Property_Tracing__c tracing = OrderFunnel_AssetUtility.requestRetrace(assetId, metrics);
            insert tracing;

            setStatusCode(201);

            return new List<Property_Tracing__c>{tracing};
        }catch(Exception ex){
            throw new API_Dispatcher.APIException(500, 'An error occurred while requesting a retrace. ' + ex.getMessage());
        }

    }
}