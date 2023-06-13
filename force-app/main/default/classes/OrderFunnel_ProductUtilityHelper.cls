public with sharing class OrderFunnel_ProductUtilityHelper {
    private static Map<Id, OrderFunnel_Models.Product2Model> productModelMap = new Map<Id, OrderFunnel_Models.Product2Model>();
    private static String accountId;

    public static void buildProductModelMap(Set<Id> productIds, String accountId){
        if(accountId != accountId){
            accountId = accountId;
            productModelMap = new Map<Id, OrderFunnel_Models.Product2Model>();
        }else{
            productIds.removeAll(productModelMap.keySet());
        }

        if(productIds.isEmpty()){
            return;
        }

        List<Product2> products = [ SELECT  Id, Name, ProductCode, Display_Name__c, RecordType.Name, Description,
                                            Family, Merchandising_Tags__c, Netsuite_Item__c, SBQQ__TaxCode__c,
                                            External_Id__c, Product_Photo_URL__c
                                    FROM    Product2
                                    WHERE   Id IN :productIds];
        for(Product2 product: products){
            OrderFunnel_Models.Product2Model productModel = buildProductModel(product);
            productModelMap.put(product.Id, productModel);
        }

        buildServiceTypes(productIds, accountId);
    }

    private static void buildServiceTypes(Set<Id> productIds, String accountId){
        List<Service_Type__c> serviceTypes = [  SELECT  Id, Name, Contractor_Description__c, Customer_Description__c,

                                                        (   SELECT  Id, Product__c, Product__r.Id, Product__r.Name, Product__r.ProductCode, Product__r.Display_Name__c,
                                                                    Product__r.RecordType.Name, Product__r.Description, Product__r.Family, Product__r.Merchandising_Tags__c,
                                                                    Product__r.Netsuite_Item__c, Product__r.SBQQ__TaxCode__c, Product__r.External_ID__c, Product__r.Product_Photo_URL__c
                                                            FROM    Component_Services__r
                                                            WHERE   Product__c IN :productIds),

                                                        (   SELECT  Id, Photo__c, Photo__r.Name, Photo__r.Sample_Photo__c, Photo__r.Instructional_Photo__c,
                                                                    Photo__r.Before_Service__c, Photo__r.Service_in_Action__c, Photo__r.After_Service__c
                                                            FROM    Photo_Set_Items__r
                                                            WHERE   Customer__c = null OR Customer__c = :accountId)
                                                FROM    Service_Type__c
                                                WHERE   Id IN
                                                        (   SELECT Service_Type__c
                                                            FROM Component_Service__c
                                                            WHERE Product__c IN :productIds)
                                                ];
        for(Service_Type__c sType : serviceTypes){
            OrderFunnel_Models.ServiceTypeModel model = buildServiceTypeModel(sType);


            for(Component_Service__c component:sType.Component_Services__r){
                OrderFunnel_Models.Product2Model productModel = productModelMap.get(component.Product__c);
                if(productModel == null){
                    productModel = buildProductModel(component.Product__r);
                    productModelMap.put(component.Product__c, productModel);
                }
                productModel.ServiceTypes.add(model);
            }
        }
    }

    private static OrderFunnel_Models.Product2Model buildProductModel(Product2 product){
        OrderFunnel_Models.Product2Model model = new OrderFunnel_Models.Product2Model();
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
        model.NetsuiteItem = product.Netsuite_Item__c;
        model.TaxCode = product.SBQQ__TaxCode__c;
        return model;
    }

    private static OrderFunnel_Models.ServiceTypeModel buildServiceTypeModel(Service_Type__c sType){
        OrderFunnel_Models.ServiceTypeModel model = new OrderFunnel_Models.ServiceTypeModel();
        model.Id = sType.Id;
        model.Name = sType.Name;
        model.ServiceCode = sType.Id;
        model.description.customer = sType.Customer_Description__c;
        model.description.contractor = sType.Contractor_Description__c;

        for(Photo_Set_Item__c photoSetItem : sType.Photo_Set_Items__r){
            model.PhotoSets.addAll(buildPhotoSetModels(photoSetItem.Photo__r));
        }

        return model;
    }

    private static List<OrderFunnel_Models.PhotoSetModel> buildPhotoSetModels(Photo__c photoSet){
        List<OrderFunnel_Models.PhotoSetModel> models = new List<OrderFunnel_Models.PhotoSetModel>();

        if(photoSet.Before_Service__c){
            models.add(buildPhotoSetModel(photoSet, 'BEFORE'));
        }
        if(photoSet.After_Service__c){
            models.add(buildPhotoSetModel(photoSet, 'AFTER'));
        }
        if(photoSet.Service_in_Action__c){
            models.add(buildPhotoSetModel(photoSet, 'SINGLE'));
        }

        return models;
    }

    private static OrderFunnel_Models.PhotoSetModel buildPhotoSetModel(Photo__c photoSet, String timing){
        OrderFunnel_Models.PhotoSetModel model = new OrderFunnel_Models.PhotoSetModel();
        model.PhotoId = photoSet.Id + '_' + timing;
        model.PhotoName = photoSet.Name;
        model.PhotoDefinitionId = photoSet.Id;
        model.PhotoDescription = photoSet.Name;
        model.PhotoExample = photoSet.Sample_Photo__c;
        model.PhotoInstruction = photoSet.Instructional_Photo__c;
        model.Timing = timing;
        return model;
    }


    public static OrderFunnel_Models.Product2Model getProductModel(String productId, String accountId){
        if(productModelMap == null){
            throw new API_Dispatcher.APIException(500, 'Product model map not initialized.');
        }

        //TODO Reinstate this
        // if(accountId != OrderFunnel_ProductUtilityHelper.accountId){
        //     throw new API_Dispatcher.APIException(500, 'Cross-customer product model access detected.');
        // }

        if(productModelMap.containsKey(productId) == false){
            throw new API_Dispatcher.APIException(404, 'Product model not found or initialized.');
        }

        return productModelMap.get(productId);
    }
}