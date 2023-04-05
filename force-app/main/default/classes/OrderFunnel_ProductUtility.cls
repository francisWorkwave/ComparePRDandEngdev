public with sharing class OrderFunnel_ProductUtility {

    public static List<OrderFunnel_Models.ProductSearchResultModel> searchProducts(String accountId, String assetId, Boolean includeInternal, List<String> tags){

        String region = null;

        if(assetId != null && assetId != ''){
            List<Asset> assets = OrderFunnel_AssetUtility.getAssets(null, null, assetId, false);
            accountId = assets[0].AccountId;
            region = assets[0]?.Region__r?.TE_Region__c;
        }

        String query = buildSearchQuery(accountId, region, includeInternal, tags);
        List<Product2> products = Database.query(query);

        List<OrderFunnel_Models.ProductSearchResultModel> models = new List<OrderFunnel_Models.ProductSearchResultModel>();

        for(Product2 prod:products){
            models.add(buildSearchModel(prod));
        }

        return models;
    }

    private static String buildSearchQuery(String accountId, String region, Boolean includeInternal, List<String> tags){
        String query = 'SELECT Id, ProductCode, Name, Display_Name__c, RecordType.Name, ';
        query += 'Description, Merchandising_Tags__c, Family, Client__c, External_ID__c, Product_Photo_URL__c,';

        query += '(SELECT Id, Service_Type__c, Service_Type__r.Name, Service_Type__r.Contractor_Description__c, Service_Type__r.Customer_Description__c ';
        query += 'FROM Component_Services__r) ';

        query += 'FROM Product2 ';
        query += 'WHERE ';

        query += '(Client__c = null OR ';
        if(accountId != null && accountId != ''){
            query += 'Client__c = :accountId';
        }
        query = query.removeEnd(' OR ');
        query += ') AND ';

        if(includeInternal == false){
            query += 'Is_Customer_Accessible__c = true AND ';
        }

        if(tags.isEmpty() == false){
            query += 'Merchandising_Tags__c INCLUDES (\'' + String.join(tags,'\',\'') + '\') AND ';
        }

        // query += '(Regional_Availability__c = \'All\' OR ';
        // if(region != null){
        //     query += '(Regional_Availability__c = \'Exclude\' AND TE_Regions__c EXCLUDES (\'' + region + '\')) OR ';
        //     query += '(Regional_Availability__c = \'Include\' AND TE_Regions__c INCLUDES (\'' + region + '\')) OR ';
        // }
        // query = query.removeEnd(' OR ');
        // query += ') AND ';

        query = query.removeEnd(' AND ');

        return query;
    }

    public static List<Product2> getProducts(Set<Id> productIds, Boolean allowList){
        //TODO Add flag to include all internal properties of products/service types/photo sets
        //TODO for use in internal mapping (non-customer facing or cached)
        List<Product2> products = [ SELECT  Id
                                    FROM Product2
                                    WHERE Id IN :productIds];

        if(products.isEmpty()){
            throw new API_Dispatcher.APIException(404, 'Products not found');
        }

        if(allowList == false && products.size() > 1){
            throw new API_Dispatcher.APIException(300, 'Multiple products found');
        }

        return products;
    }

    public static void initProductModelMap(Set<Id> productIds, String accountId){
        OrderFunnel_ProductUtilityHelper.buildProductModelMap(productIds, accountId);
    }

    public static OrderFunnel_Models.Product2Model buildModel(String productId, String accountId){
        OrderFunnel_ProductUtilityHelper.buildProductModelMap(new Set<Id>{productId}, accountId);
        return OrderFunnel_ProductUtilityHelper.getProductModel(productId, accountId);
    }

    public static OrderFunnel_Models.ProductSearchResultModel buildSearchModel(Product2 product){
        OrderFunnel_Models.ProductSearchResultModel model = new OrderFunnel_Models.ProductSearchResultModel();
        model.Id = product.Id;
        model.externalId = product.External_ID__c;
        model.ProductName = product.Name;
        model.ProductCode = product.ProductCode;
        model.DisplayName = product.Display_Name__c;
        model.productPhotoURL = product.Product_Photo_URL__c;
        model.Type = product.RecordType.Name;
        model.Description = product.Description;
        model.Family = product.Family;
        model.MerchandisingTags = product.Merchandising_Tags__c;
        if(product.Client__c != null){
            model.clientProduct = true;
        }

        for(Component_Service__c componentService : product.Component_Services__r){
            model.ServiceTypes.add(buildServiceTypeModel(componentService));
        }
        return model;
    }

    public static OrderFunnel_Models.ServiceTypeModel buildServiceTypeModel(Component_Service__c componentService){
        OrderFunnel_Models.ServiceTypeModel model = new OrderFunnel_Models.ServiceTypeModel();
        model.Name = componentService.Service_Type__r.Name;
        model.description.customer = componentService.Service_Type__r.Customer_Description__c;
        model.description.contractor = componentService.Service_Type__r.Contractor_Description__c;
        return model;
    }

    public static CPQ_Models.ProductModel buildCPQModel(String productId, String pricebookId){
        try{
            ProductReaderContext ctx = new ProductReaderContext(pricebookId, null);
            String productJSON = SBQQ.ServiceRouter.load('SBQQ.ProductAPI.ProductLoader', productId, JSON.serialize(ctx));
            return (CPQ_Models.ProductModel) JSON.deserialize(productJSON, CPQ_Models.ProductModel.class);
        }catch(Exception ex){
            throw new API_Dispatcher.APIException(404, 'Unable to read product. ' + ex.getMessage());
        }
    }

    public class ProductReaderContext {
        public Id pricebookId;
        public String currencyCode;

        public ProductReaderContext(Id pricebookId, String currencyCode) {
            this.pricebookId = pricebookId;
            this.currencyCode = currencyCode;
        }
    }
}