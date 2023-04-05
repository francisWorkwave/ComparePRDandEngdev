public with sharing class OrderFunnel_QuoteHandler extends API_BaseHandler{
    public override List<Object> handleGet(RestRequest req){

        //Parameter extraction
        String quoteId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(quoteId, false, SBQQ__Quote__c.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Quote identifier invalid');
        }

        //Execution Logic

        CPQ_Models.QuoteModel quote = OrderFunnel_QuoteUtility.buildModel(quoteId);

        setStatusCode(200);
        return new List<CPQ_Models.QuoteModel>{quote};
    }

    public override List<Object> handlePost(RestRequest req){

        //Parameter extraction
        String assetId = req.params.get('assetId');
        String pricebookId = req.params.get('pricebookId');

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(assetId, false, Asset.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Asset identifier invalid');
        }
        if(OrderFunnel_Utility.isValidId(pricebookId, true, Pricebook2.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Pricebook identifier invalid');
        }

        //Execution Logic
        SBQQ__Quote__c quote = OrderFunnel_QuoteUtility.createQuote(assetId, pricebookId);
        insert quote;

        CPQ_Models.QuoteModel model = OrderFunnel_QuoteUtility.buildModel(quote.Id);

        setStatusCode(201);
        return new List<CPQ_Models.QuoteModel>{model};
    }
}