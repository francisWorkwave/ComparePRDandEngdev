public with sharing class OrderFunnel_ProductSearchHandler extends API_BaseHandler{
    public override List<Object> handleGet(RestRequest req){

        //Parameter extraction
        String accountId = req.params.get('accountId');
        String assetId = req.params.get('assetId');
        String tagsString = req.params.get('tags');
        Boolean includeInternal = req.params.containsKey('includeInternal');

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(accountId, true, Account.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Account identifier invalid');
        }
        if(OrderFunnel_Utility.isValidId(assetId, true, Asset.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Asset identifier invalid');
        }
        List<String> tags = new List<String>();
        if(tagsString != null){
            tags = EncodingUtil.urlDecode(tagsString, 'UTF-8').split(';');
        }

        List<OrderFunnel_Models.ProductSearchResultModel> results = OrderFunnel_ProductUtility.searchProducts(accountId, assetId, includeInternal, tags);

        setStatusCode(200);

        return results;
    }
}