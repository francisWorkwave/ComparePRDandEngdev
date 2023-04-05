public with sharing class OrderFunnel_ContractedPriceHelper {
    public String pricebookId;
    public String accountId;

    Map<Id, SBQQ__ContractedPrice__c> contractedPricesByProductId = new Map<Id, SBQQ__ContractedPrice__c>();
    Map<Id, SBQQ__DiscountSchedule__c> discountSchedules = new Map<Id, SBQQ__DiscountSchedule__c>();
    Map<Id, Product2> products = new Map<Id, Product2>();

    public OrderFunnel_ContractedPriceHelper(String pricebookId, String accountId) {
        this.pricebookId = pricebookId;
        this.accountId = accountId;

        loadContractedPrices();
        loadProducts();
        loadDiscountSchedules();
    }

    private void loadContractedPrices(){
        List<SBQQ__ContractedPrice__c> contractedPrices = getContractedPrices();

        for (SBQQ__ContractedPrice__c cPrice : contractedPrices) {
            contractedPricesByProductId.put(cPrice.SBQQ__Product__c, cPrice);
            if (cPrice.SBQQ__DiscountSchedule__c != null) {
                discountSchedules.put(cPrice.SBQQ__DiscountSchedule__c, null);
            }
            products.put(cPrice.SBQQ__Product__c, null);
        }
    }

    private List<SBQQ__ContractedPrice__c> getContractedPrices() {
        String query = 'SELECT Id, SBQQ__Product__c, SBQQ__Account__c, SBQQ__Price__c, SBQQ__Discount__c, SBQQ__DiscountSchedule__c, ';
        query += 'SBQQ__DiscountSchedule__r.SBQQ__Pricebook__c, SBQQ__DiscountSchedule__r.SBQQ__ExcludedPricebookIds__c ';
        query += 'FROM SBQQ__ContractedPrice__c ';
        query += 'WHERE ';
        query += '(SBQQ__EffectiveDate__c < TODAY OR SBQQ__EffectiveDate__c = null) AND ';
        query += '(SBQQ__ExpirationDate__c > TODAY OR SBQQ__ExpirationDate__c = null) ';

        if (accountId != null && accountId != '') {
            query += ' AND SBQQ__Account__c = \'' + String.escapeSingleQuotes(accountId) + '\' ';
        }

        if (pricebookId != null) {
            List<String> orClauses = new List<String>();

            orClauses.add('SBQQ__DiscountSchedule__c = null');
            orClauses.add('SBQQ__DiscountSchedule__r.SBQQ__Pricebook__c = :pricebookId');

            String complexOr = '(';
            complexOr += 'SBQQ__DiscountSchedule__r.SBQQ__Pricebook__c = null';
            complexOr += ' AND ';
            complexOr += '(NOT SBQQ__DiscountSchedule__r.SBQQ__ExcludedPricebookIds__c LIKE \'%' + pricebookId + '%\')';
            complexOr += ')';

            orClauses.add(complexOr);

            query += 'AND (' + String.join(orClauses, ' OR ') + ')';
        }

        return Database.query(query);
    }

    private void loadProducts() {
        List<Product2> productList = [
            SELECT Id, SBQQ__PricingMethod__c, Property_Metric__c, (
                SELECT Id, UnitPrice
                FROM PricebookEntries
                WHERE Pricebook2Id = :pricebookId
            ), (
                SELECT Id, SBQQ__LowerBound__c, SBQQ__UpperBound__c, SBQQ__Price__c
                FROM SBQQ__BlockPrices__r
                WHERE SBQQ__Pricebook2__c = :pricebookId
                ORDER BY SBQQ__LowerBound__c
            )
            FROM Product2
            WHERE Id IN :products.keySet()];
        products.putAll(productList);
    }

    private void loadDiscountSchedules() {
        List<SBQQ__DiscountSchedule__c> discounts = [
            SELECT Id, SBQQ__DiscountUnit__c, SBQQ__Type__c, (
                SELECT Id, SBQQ__LowerBound__c, SBQQ__UpperBound__c, SBQQ__Price__c,
                SBQQ__Discount__c, SBQQ__DiscountAmount__c
                FROM SBQQ__DiscountTiers__r
                ORDER BY SBQQ__Number__c)
            FROM SBQQ__DiscountSchedule__c
            WHERE Id IN :discountSchedules.keySet()
        ];
        discountSchedules.putAll(discounts);
    }

    public List<OrderFunnel_Models.PricebookEntry> getAllEntries(){
        List<OrderFunnel_Models.PricebookEntry> entries = new List<OrderFunnel_Models.PricebookEntry>();

        for(String productId:contractedPricesByProductId.keySet()){
            entries.add(getEntry(productId));
        }

        return entries;
    }

    public OrderFunnel_Models.PricebookEntry getEntry(String productId){
        Product2 prod = products.get(productId);
        SBQQ__ContractedPrice__c cPrice = contractedPricesByProductId.get(productId);

        OrderFunnel_Models.PricebookEntry entry = new OrderFunnel_Models.PricebookEntry();

        entry.productId = prod.Id;
        entry.pricebookId = pricebookId;
        entry.type = prod.SBQQ__PricingMethod__c;
        entry.propertyMetric = prod.Property_Metric__c;
        entry.unitPrice = prod.PricebookEntries[0].UnitPrice;

        if(cPrice.SBQQ__Price__c != null){
            entry.unitPrice = cPrice.SBQQ__Price__c;
        }else if(cPrice.SBQQ__Discount__c != null){
            handleDiscountPercent(entry, prod, cPrice);
        }else if(cPrice.SBQQ__DiscountSchedule__c != null){
            handleDiscountSchedule(entry, prod, cPrice);
        }

        return entry;
    }

    private void handleDiscountPercent(OrderFunnel_Models.PricebookEntry entry, Product2 prod, SBQQ__ContractedPrice__c cPrice){
        // if(prod.SBQQ__PricingMethod__c == 'List'){
            entry.unitPrice = entry.unitPrice * ((100 - cPrice.SBQQ__Discount__c)/100);
        // }else if(prod.SBQQ__PricingMethod__c == 'Block'){
        //     entry.blocks = calculateBlocks(prod.SBQQ__BlockPrices__r, cPrice.SBQQ__Discount__c, 'Percent');
        // }
    }

    private void handleDiscountSchedule(OrderFunnel_Models.PricebookEntry entry, Product2 prod, SBQQ__ContractedPrice__c cPrice){
        SBQQ__DiscountSchedule__c discount = discountSchedules.get(cPrice.SBQQ__DiscountSchedule__c);

        //If a discount schedule is used, it will ALWAYS look like block pricing
        //Slab is here for completeness, they can pre-calculate it on client
        if(discount.SBQQ__Type__c == 'Range'){
            entry.type = 'Block';
        }
        if(discount.SBQQ__Type__c == 'Slab'){
            entry.type = 'Slab';
        }

        // if(prod.SBQQ__PricingMethod__c == 'List'){
            entry.blocks = calculateBlocks(prod.PricebookEntries[0].UnitPrice, discount.SBQQ__DiscountTiers__r, discount.SBQQ__DiscountUnit__c);
        // }else if(prod.SBQQ__PricingMethod__c == 'Block'){
        //     entry.blocks = calculateBlocks(prod.SBQQ__BlockPrices__r, discount.SBQQ__DiscountTiers__r, discount.SBQQ__DiscountUnit__c);
        // }
    }

    private List<OrderFunnel_Models.PriceBlock> calculateBlocks(Decimal unitPrice, List<SBQQ__DiscountTier__c> tiers, String type){

        //Set up a list priced product to look like block pricing because
        //discount schedules always show as block pricing.
        List<SBQQ__BlockPrice__c> blocks = new List<SBQQ__BlockPrice__c>();
        SBQQ__BlockPrice__c block = new SBQQ__BlockPrice__c();
        block.SBQQ__LowerBound__c = 0;
        block.SBQQ__UpperBound__c = 999999;
        block.SBQQ__Price__c = unitPrice;
        blocks.add(block);

        return calculateBlocks(blocks, tiers, type);
    }

    private List<OrderFunnel_Models.PriceBlock> calculateBlocks(List<SBQQ__BlockPrice__c> blocks, Decimal discountPercent, String type){

        //Set up contracted prices with fixed percent discount across to board
        //to mimic a discount schedule behavior
        List<SBQQ__DiscountTier__c> tiers = new List<SBQQ__DiscountTier__c>();
        SBQQ__DiscountTier__c tier = new SBQQ__DiscountTier__c();
        tier.SBQQ__LowerBound__c = 0;
        tier.SBQQ__UpperBound__c = 999999;
        tier.SBQQ__Discount__c = discountPercent;
        tiers.add(tier);

        return calculateBlocks(blocks, tiers, type);
    }

    private List<OrderFunnel_Models.PriceBlock> calculateBlocks(List<SBQQ__BlockPrice__c> blocks, List<SBQQ__DiscountTier__c> tiers, String type){
        List<OrderFunnel_Models.PriceBlock> priceBlocks = new List<OrderFunnel_Models.PriceBlock>();

        Integer i = 0;
        Integer j = 0;

        while(i < blocks.size() && j <= tiers.size()){
            OrderFunnel_Models.PriceBlock blockModel = new OrderFunnel_Models.PriceBlock();

            //If I run out of discount tiers, I still need to represent the rest of the blocks
            if(j == tiers.size()){
                blockModel.metricMin = Math.max(blocks[i].SBQQ__LowerBound__c, tiers[j-1].SBQQ__UpperBound__c);
                blockModel.metricMax = blocks[i].SBQQ__UpperBound__c;
                blockModel.unitPrice = blocks[i].SBQQ__Price__c;
                priceBlocks.add(blockModel);

                i++;
                continue;
            }

            //Walk each combined segment of both lists (blocks and discounts)
            blockModel.metricMin = Math.max(blocks[i].SBQQ__LowerBound__c, tiers[j].SBQQ__LowerBound__c);
            blockModel.metricMax = Math.min(blocks[i].SBQQ__UpperBound__c, tiers[j].SBQQ__UpperBound__c);

            if(type == 'Price'){
                blockModel.unitPrice = tiers[j].SBQQ__Price__c;
            }else if(type == 'Amount'){
                blockModel.unitPrice = blocks[i].SBQQ__Price__c - tiers[j].SBQQ__DiscountAmount__c;
            }else if(type == 'Percent'){
                blockModel.unitPrice = blocks[i].SBQQ__Price__c * ((100 - tiers[j].SBQQ__Discount__c)/100);
            }

            priceBlocks.add(blockModel);

            //Walk to the next segment (move blocks, discounts, or both)
            if(blocks[i].SBQQ__UpperBound__c <= tiers[j].SBQQ__UpperBound__c){
                i++;
            }
            if(blocks[i].SBQQ__UpperBound__c >= tiers[j].SBQQ__UpperBound__c){
                j++;
            }
        }
		
        /*commented by Fran 06-08-22
         * error: OrderFunnel_Models System.ListException: One or more of the items in this list is not Comparable.
         * Interface "Comparable" has to be implemented
        */
        //priceBlocks.sort();  

        return priceBlocks;
    }


}