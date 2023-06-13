public with sharing class OrderFunnel_PricebookUtility {
    public static List<OrderFunnel_Models.Pricebook> getPricebooks(String pricebookId, Boolean includeInactive) {
        List<Pricebook2> pbs = queryPricebooks(pricebookId, includeInactive);

        List<OrderFunnel_Models.Pricebook> pricebookModels = new List<OrderFunnel_Models.Pricebook>();

        for (Pricebook2 pb : pbs) {
            pricebookModels.add(buildPricebook(pb));
        }

        return pricebookModels;
    }

    private static List<Pricebook2> queryPricebooks(String pricebookId, Boolean includeInactive) {
        String whereClause = buildWhereClause(pricebookId, includeInactive);

        String query = 'SELECT Id, Name, LastModifiedDate, IsActive, ';
        query += '(';
        query += 'SELECT Id, Product__c, Account__c ';
        query += 'FROM Contracted_Discounts__r';
        query += ')';
        query += 'FROM Pricebook2';
        query += whereClause;

        return (List<Pricebook2>) Database.query(query);
    }

    private static String buildWhereClause(String pricebookId, Boolean includeInactive) {
        List<String> whereClauses = new List<String>();
        if (pricebookId != null) {
            whereClauses.add('Id = \'' + String.escapeSingleQuotes(pricebookId) + '\'');
        }
        if (includeInactive == false) {
            whereClauses.add('IsActive = true');
        }

        if (whereClauses.isEmpty() == false) {
            return ' WHERE ' + String.join(whereClauses, ' AND ');
        }
        return '';
    }

    private static OrderFunnel_Models.Pricebook buildPricebook(Pricebook2 pb) {
        OrderFunnel_Models.Pricebook pbModel = new OrderFunnel_Models.Pricebook();

        pbModel.pricebookId = pb.Id;
        pbModel.name = pb.Name;
        pbModel.isActive = pb.IsActive;
        pbModel.modstamp = String.valueOf(pb.LastModifiedDate.getTime());
        for(Contracted_Discount__c cd:pb.Contracted_Discounts__r){
            pbModel.overrides.add(cd.Account__c);
        }

        return pbModel;
    }

    public static List<OrderFunnel_Models.PricebookEntry> getPricebookEntries(
        String pricebookId,
        String accountId,
        String productId,
        Boolean showAll
    ) {
        Map<Id, OrderFunnel_Models.PricebookEntry> pbeModels = new Map<Id, OrderFunnel_Models.PricebookEntry>();
        if ((accountId == '' || accountId == null) || showAll) {
            List<Product2> products;
            if(productId == null || productId == ''){
                products = [
                    SELECT
                        Id, SBQQ__PricingMethod__c, RecordType.Name,
                        Property_Metric__c,
                        (SELECT Id, UnitPrice FROM PricebookEntries WHERE Pricebook2Id = :pricebookId),
                        (SELECT Id, SBQQ__LowerBound__c, SBQQ__UpperBound__c, SBQQ__Price__c FROM SBQQ__BlockPrices__r WHERE SBQQ__PriceBook2__c = :pricebookId ORDER BY SBQQ__LowerBound__c)
                    FROM Product2
                    WHERE Id IN (SELECT Product2ID FROM PricebookEntry WHERE Pricebook2Id = :pricebookId)
                ];
            }else{
                products = [
                    SELECT
                        Id, SBQQ__PricingMethod__c, RecordType.Name,
                        Property_Metric__c,
                        (SELECT Id, UnitPrice FROM PricebookEntries WHERE Pricebook2Id = :pricebookId),
                        (SELECT Id, SBQQ__LowerBound__c, SBQQ__UpperBound__c, SBQQ__Price__c FROM SBQQ__BlockPrices__r WHERE SBQQ__PriceBook2__c = :pricebookId ORDER BY SBQQ__LowerBound__c)
                    FROM Product2
                    WHERE Id = :productId
                ];

                if(products.isEmpty() || products[0].PricebookEntries.isEmpty()){
                    throw new API_Dispatcher.APIException(404, 'No product found in pricebook with given parameters.');
                }
            }

            for (Product2 prod : products) {
                OrderFunnel_Models.PricebookEntry entry = new OrderFunnel_Models.PricebookEntry();

                entry.productId = prod.Id;
                entry.productType = prod.RecordType.Name;
                entry.pricebookId = pricebookId;
                entry.type = prod.SBQQ__PricingMethod__c;
                entry.propertyMetric = prod.Property_Metric__c;
                entry.unitPrice = prod.PricebookEntries[0].UnitPrice;

                if (prod.SBQQ__PricingMethod__c == 'Block') {
                    for (SBQQ__BlockPrice__c block : prod.SBQQ__BlockPrices__r) {
                        OrderFunnel_Models.PriceBlock blockModel = new OrderFunnel_Models.PriceBlock();
                        blockModel.metricMin = block.SBQQ__LowerBound__c;
                        blockModel.metricMax = block.SBQQ__UpperBound__c;
                        blockModel.unitPrice = block.SBQQ__Price__c;
                        entry.blocks.add(blockModel);
                    }
                }

                pbeModels.put(entry.productId, entry);
            }
        }

        if (accountId != null) {
            OrderFunnel_ContractedDiscountHelper helper = new OrderFunnel_ContractedDiscountHelper(pricebookId, accountId);

            if(productId == null || productId == ''){
                for (OrderFunnel_Models.PricebookEntry entry : helper.getAllEntries()) {
                    pbeModels.put(entry.productId, entry);
                }
            }else{
                OrderFunnel_Models.PricebookEntry entry = helper.getEntry(productId);
                pbeModels.put(productId, entry);
            }
        }

        return pbeModels.values();
    }
}