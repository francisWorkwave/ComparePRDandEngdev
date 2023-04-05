public with sharing class OrderFunnel_QuoteUtility {
    public static List<SBQQ__Quote__c> getQuotes(String id, Boolean allowList){
        List<SBQQ__Quote__c> quotes = [ SELECT Id
                                        FROM SBQQ__Quote__c
                                        WHERE Id =: id];

        if(quotes.isEmpty()){
            throw new API_Dispatcher.APIException(404, 'Quote not found');
        }

        if(allowList == false && quotes.size() > 1){
            throw new API_Dispatcher.APIException(300, 'Multiple quotes identified');
        }

        return quotes;
    }

    public static CPQ_Models.QuoteModel buildModel(String id){
        try{
            String quoteJSON = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', id);
            return (CPQ_Models.QuoteModel) JSON.deserialize(quoteJSON, CPQ_Models.QuoteModel.class);
        }catch(Exception ex){
            throw new API_Dispatcher.APIException(404, 'Unable to read quote. ' + ex.getMessage());
        }
    }

    public static SBQQ__Quote__c createQuote(String assetId, String pricebookId){
        List<Asset> assets = OrderFunnel_AssetUtility.getAssets(null, null, assetId, false);
        Asset a = assets[0];

        if(pricebookId == null){
            pricebookId = a.Account.Price_Book__c;
        }


        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.Asset__c = a.Id;
        quote.SBQQ__Account__c = a.AccountId;
        quote.SBQQ__PricebookId__c = pricebookId;
        return quote;
    }
}