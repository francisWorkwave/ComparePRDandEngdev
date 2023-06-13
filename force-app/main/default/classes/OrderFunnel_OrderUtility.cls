public with sharing class OrderFunnel_OrderUtility {
    public static List<Order> getOrders(String orderId, String quoteId, Boolean allowList){
        String query = buildQuery(orderId, quoteId);

        List<Order> orders = (List<Order>) Database.query(query);

        if(orders.isEmpty()){
            throw new API_Dispatcher.APIException(404, 'Order not found');
        }

        if(allowList == false && orders.size() > 1){
            throw new API_Dispatcher.APIException(300, 'Multiple orders identified');
        }

        return orders;
    }

    public static String buildQuery(String orderId, String quoteId){
        if(quoteId != null){
            return 'SELECT Id, AccountId, OrderNumber, Name FROM Order WHERE SBQQ__Quote__c =: quoteId';
        }

        String query = 'SELECT Id, OrderNumber, Work_Order_Reference__c, Status, Plan_Type__c, Billing_Type__c, Payment_Schedule__c, ';
        query += 'CreatedDate, Earliest_Start_Date__c, Latest_End_Date__c, EffectiveDate, EndDate, ';
        query += 'Additional_Field_Label_1__c, Additional_Field_Value_1__c, Additional_Field_Label_2__c, Additional_Field_Value_2__c, ';
        query += 'Additional_Field_Label_3__c, Additional_Field_Value_3__c, Additional_Field_Label_4__c, Additional_Field_Value_4__c, ';
        query += 'Additional_Field_Label_5__c, Additional_Field_Value_5__c, Additional_Field_Label_6__c, Additional_Field_Value_6__c, ';
        query += 'Additional_Field_Label_7__c, Additional_Field_Value_7__c, Additional_Field_Label_8__c, Additional_Field_Value_8__c, ';
        query += 'Additional_Field_Label_9__c, Additional_Field_Value_9__c, Additional_Field_Label_10__c, Additional_Field_Value_10__c, ';
        query += 'Additional_Field_Label_11__c, Additional_Field_Value_11__c, Additional_Field_Label_12__c, Additional_Field_Value_12__c,';
        query += 'Additional_Field_Label_13__c, Additional_Field_Value_13__c, Additional_Field_Label_14__c, Additional_Field_Value_14__c, ';
        query += 'Additional_Field_Label_15__c, Additional_Field_Value_15__c, Additional_Field_Label_16__c, Additional_Field_Value_16__c, ';
        query += 'Additional_Field_Label_17__c, Additional_Field_Value_17__c, Additional_Field_Label_18__c, Additional_Field_Value_18__c, ';
        query += 'Additional_Field_Label_19__c, Additional_Field_Value_19__c, Additional_Field_Label_20__c, Additional_Field_Value_20__c, ';

        query += 'SBQQ__Quote__r.SBQQ__PrimaryContact__r.FirstName, SBQQ__Quote__r.SBQQ__PrimaryContact__r.LastName, ';

        query += 'Contractor__c, Contractor__r.Name, ';

        query += 'AccountId, Account.Name, Account.Phone, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry,';
        query += 'Account.Additional_Field_Label_1__c, Account.Additional_Field_Value_1__c, Account.Additional_Field_Label_2__c, Account.Additional_Field_Value_2__c, ';
        query += 'Account.Additional_Field_Label_3__c, Account.Additional_Field_Value_3__c, Account.Additional_Field_Label_4__c, Account.Additional_Field_Value_4__c, ';
        query += 'Account.Additional_Field_Label_5__c, Account.Additional_Field_Value_5__c, Account.Additional_Field_Label_6__c, Account.Additional_Field_Value_6__c, ';
        query += 'Account.Additional_Field_Label_7__c, Account.Additional_Field_Value_7__c, Account.Additional_Field_Label_8__c, Account.Additional_Field_Value_8__c, ';
        query += 'Account.Additional_Field_Label_9__c, Account.Additional_Field_Value_9__c, Account.Additional_Field_Label_10__c, Account.Additional_Field_Value_10__c, ';
        query += 'Account.Additional_Field_Label_11__c, Account.Additional_Field_Value_11__c, Account.Additional_Field_Label_12__c, Account.Additional_Field_Value_12__c,';
        query += 'Account.Additional_Field_Label_13__c, Account.Additional_Field_Value_13__c, Account.Additional_Field_Label_14__c, Account.Additional_Field_Value_14__c, ';
        query += 'Account.Additional_Field_Label_15__c, Account.Additional_Field_Value_15__c, Account.Additional_Field_Label_16__c, Account.Additional_Field_Value_16__c, ';
        query += 'Account.Additional_Field_Label_17__c, Account.Additional_Field_Value_17__c, Account.Additional_Field_Label_18__c, Account.Additional_Field_Value_18__c, ';
        query += 'Account.Additional_Field_Label_19__c, Account.Additional_Field_Value_19__c, Account.Additional_Field_Label_20__c, Account.Additional_Field_Value_20__c, ';

        query += 'Asset__c, Asset__r.Name, Asset__r.TE_Property_Id__c, Asset__r.CU_Property_Id__c, Asset__r.Current_Tracing_ID__c, Asset__r.AccountId, ';
        query += 'Asset__r.Street_Address__c, Asset__r.City__c, Asset__r.State__c, Asset__r.Postal_Code__c, Asset__r.Property_Location__Latitude__s, Asset__r.Property_Location__Longitude__s, ';
        query += 'Asset__r.Access_Code__c, Asset__r.Access_Note__c, ';
        query += OrderFunnel_AssetUtility.getAssetMetricFieldsString('Asset__r.');
        query += 'Asset__r.Additional_Field_Label_1__c, Asset__r.Additional_Field_Value_1__c, Asset__r.Additional_Field_Label_2__c, Asset__r.Additional_Field_Value_2__c, ';
        query += 'Asset__r.Additional_Field_Label_3__c, Asset__r.Additional_Field_Value_3__c, Asset__r.Additional_Field_Label_4__c, Asset__r.Additional_Field_Value_4__c, ';
        query += 'Asset__r.Additional_Field_Label_5__c, Asset__r.Additional_Field_Value_5__c, Asset__r.Additional_Field_Label_6__c, Asset__r.Additional_Field_Value_6__c, ';
        query += 'Asset__r.Additional_Field_Label_7__c, Asset__r.Additional_Field_Value_7__c, Asset__r.Additional_Field_Label_8__c, Asset__r.Additional_Field_Value_8__c, ';
        query += 'Asset__r.Additional_Field_Label_9__c, Asset__r.Additional_Field_Value_9__c, Asset__r.Additional_Field_Label_10__c, Asset__r.Additional_Field_Value_10__c, ';
        query += 'Asset__r.Additional_Field_Label_11__c, Asset__r.Additional_Field_Value_11__c, Asset__r.Additional_Field_Label_12__c, Asset__r.Additional_Field_Value_12__c,';
        query += 'Asset__r.Additional_Field_Label_13__c, Asset__r.Additional_Field_Value_13__c, Asset__r.Additional_Field_Label_14__c, Asset__r.Additional_Field_Value_14__c, ';
        query += 'Asset__r.Additional_Field_Label_15__c, Asset__r.Additional_Field_Value_15__c, Asset__r.Additional_Field_Label_16__c, Asset__r.Additional_Field_Value_16__c, ';
        query += 'Asset__r.Additional_Field_Label_17__c, Asset__r.Additional_Field_Value_17__c, Asset__r.Additional_Field_Label_18__c, Asset__r.Additional_Field_Value_18__c, ';
        query += 'Asset__r.Additional_Field_Label_19__c, Asset__r.Additional_Field_Value_19__c, Asset__r.Additional_Field_Label_20__c, Asset__r.Additional_Field_Value_20__c, ';
        query += 'Asset__r.Region__c, Asset__r.Region__r.Name, Asset__r.Region__r.TE_Region__c, Asset__r.Region__r.Price_Book__c, ';

        query += '(SELECT Id, OrderItemNumber, SBQQ__RequiredBy__c, Optional_Product__c, Service_Template__c, Service_Template_Id__c, ';
        query += 'Description, SBQQ__TaxCode__c, UnitPrice, Quantity, SBQQ__TaxAmount__c, OA_Insurance_Cost__c, NTE_Amount__c, ASP_Total__c, ';
        query += 'GL_Insurance_Cost__c, Contractor_Earnings__c, Estimated_Effort__c, Additional_Instructions__c, ';
        query += 'Product2.Name, Product2.Display_Name__c, Product2Id, Recurrence_Type__c, Product2.Netsuite_Item__c, Product2.ProductCode, Product2.RecordType.Name, ';
        query += 'Additional_Field_Label_1__c, Additional_Field_Value_1__c, Additional_Field_Label_2__c, Additional_Field_Value_2__c, ';
        query += 'Additional_Field_Label_3__c, Additional_Field_Value_3__c, Additional_Field_Label_4__c, Additional_Field_Value_4__c, ';
        query += 'Additional_Field_Label_5__c, Additional_Field_Value_5__c, Additional_Field_Label_6__c, Additional_Field_Value_6__c, ';
        query += 'Additional_Field_Label_7__c, Additional_Field_Value_7__c, Additional_Field_Label_8__c, Additional_Field_Value_8__c, ';
        query += 'Additional_Field_Label_9__c, Additional_Field_Value_9__c, Additional_Field_Label_10__c, Additional_Field_Value_10__c, ';
        query += 'Additional_Field_Label_11__c, Additional_Field_Value_11__c, Additional_Field_Label_12__c, Additional_Field_Value_12__c,';
        query += 'Additional_Field_Label_13__c, Additional_Field_Value_13__c, Additional_Field_Label_14__c, Additional_Field_Value_14__c, ';
        query += 'Additional_Field_Label_15__c, Additional_Field_Value_15__c, Additional_Field_Label_16__c, Additional_Field_Value_16__c, ';
        query += 'Additional_Field_Label_17__c, Additional_Field_Value_17__c, Additional_Field_Label_18__c, Additional_Field_Value_18__c, ';
        query += 'Additional_Field_Label_19__c, Additional_Field_Value_19__c, Additional_Field_Label_20__c, Additional_Field_Value_20__c ';
        query += 'FROM OrderItems) ';

        query += 'FROM Order WHERE Id =: orderId';

        return query;
    }

    public static OrderFunnel_Models.OrderModel buildModel(Order o){

        if(o == null){
            return null;
        }

        OrderFunnel_Models.OrderModel model = new OrderFunnel_Models.OrderModel();

        model.OrderId = o.Id;
        model.OrderNumber = o.OrderNumber;
        model.OrderDate = dateTimeToString(o.CreatedDate);
        model.OrderStatus = o.Status;
        model.PlanType = o.Plan_Type__c;
        model.BillingType = o.Billing_Type__c;
        model.PaymentFrequency = o.Payment_Schedule__c;
        model.OrderStartDate = dateToString(o.EffectiveDate);
        model.OrderEndDate = dateToString(o.EndDate);
        model.EarliestAvailableStartDate = dateToString(o.Earliest_Start_Date__c);
        model.LatestAvailableEndDate = dateToString(o.Latest_End_Date__c);
        model.WorkOrderReference = o.Work_Order_Reference__c;
        model.ServiceId = null;
        model.StripeTransactionId = null;

        model.Contractor = o.Contractor__c;
        model.WorkCrewId = null;

        model.additionalFields = OrderFunnel_Utility.buildAdditionalFieldModels(o, 'Order');

        model.Customer = OrderFunnel_AccountUtility.buildModel(o.Account);
        model.Asset = OrderFunnel_AssetUtility.buildModel(o.Asset__r);
        model.Bundles = buildBundleModels(o.OrderItems, o.AccountId);

        return model;
    }



    public static List<OrderFunnel_Models.BundleModel> buildBundleModels(List<OrderItem> orderItems, String accountId){
        Set<Id> productIds = getProductIds(orderItems);
        OrderFunnel_ProductUtility.initProductModelMap(productIds, accountId);

        Map<Id, OrderFunnel_Models.OrderItemModel> orderItemMap = buildOrderItemMap(orderItems, accountId);

        List<OrderFunnel_Models.BundleModel> bundles = new List<OrderFunnel_Models.BundleModel>();
        for(OrderFunnel_Models.OrderItemModel itemModel : orderItemMap.values()){
            switch on itemModel.type {
                when 'Bundle' {
                    bundles.add((OrderFunnel_Models.BundleModel) itemModel);
                }
                when 'Package' {
                    OrderFunnel_Models.BundleModel parentBundle;
                    //TODO Clean this up
                    String parentId = itemModel.parentId;
                    if(parentId != null && orderItemMap.containsKey(parentId) && orderItemMap.get(parentId).type == 'Package'){
                        parentId = orderItemMap.get(parentId).parentId;
                    }
                    if(parentId != null){
                        parentBundle = (OrderFunnel_Models.BundleModel) orderItemMap.get(parentId);
                    }else{
                        parentBundle = buildDefaultBundleModel(itemModel);
                        bundles.add(parentBundle);
                    }
                    parentBundle.packages.add((OrderFunnel_Models.PackageModel) itemModel);
                }
                when 'Option' {
                    if(itemModel.parentId == null || itemModel.parentId == ''){
                        throw new API_Dispatcher.APIException(500, 'Invalid model: Optional item not included in bundle.');
                    }
                    OrderFunnel_Models.BundleModel parentBundle = (OrderFunnel_Models.BundleModel) orderItemMap.get(itemModel.parentId);
                    parentBundle.optionalServices.add((OrderFunnel_Models.OptionalPackageModel) itemModel);
                }
            }
        }

        return bundles;
    }

    public static Set<Id> getProductIds(List<OrderItem> orderItems){
        Set<Id> ids = new Set<Id>();
        for(OrderItem oi:orderItems){
            ids.add(oi.Product2Id);
        }
        return ids;
    }

    public static Map<Id, OrderFunnel_Models.OrderItemModel> buildOrderItemMap(List<OrderItem> orderItems, String accountId){
        Map<Id, OrderFunnel_Models.OrderItemModel> orderItemMap = new Map<Id, OrderFunnel_Models.OrderItemModel>();

        for(OrderItem item:orderItems){
            if(item.Product2.RecordType.Name == 'Bundle Set'){
                continue;
            }
            orderItemMap.put(item.Id, buildOrderItemModel(item, accountId));
        }

        return orderItemMap;
    }

    public static OrderFunnel_Models.OrderItemModel buildOrderItemModel(OrderItem item, String accountId){
        switch on item.Product2.RecordType.Name {
            when 'Bundle' {
                return buildBundleModel(item, accountId);
            }
            when 'Package' {
                return buildPackageModel(item, accountId);
            }
            when 'Option' {
                return buildOptionModel(item, accountId);
            }
        }

        throw new API_Dispatcher.APIException(500, 'Unable to convert order item to model. Unknown type: ' + item.Product2.RecordType.Name);
    }

    public static OrderFunnel_Models.BundleModel buildBundleModel(OrderItem item, String accountId){
        OrderFunnel_Models.BundleModel model = new OrderFunnel_Models.BundleModel();
        model.Id = item.Id;
        model.parentId = item.SBQQ__RequiredBy__c;
        model.product = OrderFunnel_ProductUtilityHelper.getProductModel(item.Product2Id, accountId);

        model.recurrenceType = item.Recurrence_Type__c;
        model.nteAmount = item.NTE_Amount__c;
        return model;
    }

    public static OrderFunnel_Models.BundleModel buildDefaultBundleModel(OrderFunnel_Models.OrderItemModel packageModel){
        OrderFunnel_Models.BundleModel model = new OrderFunnel_Models.BundleModel();
        model.Id = packageModel.Id;
        model.parentId = null;
        model.product = null;

        model.recurrenceType = 'One-Time'; // ? Verify that this is correct
        model.nteAmount = 0;
        return model;
    }

    public static OrderFunnel_Models.PackageModel buildPackageModel(OrderItem item, String accountId){
        OrderFunnel_Models.PackageModel model = new OrderFunnel_Models.PackageModel();
        model.Id = item.Id;
        model.parentId = item.SBQQ__RequiredBy__c;
        model.product = OrderFunnel_ProductUtilityHelper.getProductModel(item.Product2Id, accountId);

        model.additionalInstructions = item.Additional_Instructions__c;
        model.scheduleTemplate = item.Service_Template__c;
        // model.billingSchedule = item.Billing_Schedule__c;
        model.customerPrice = item.UnitPrice;
        model.contractorPayout = item.Contractor_Earnings__c;
        model.glInsuranceCost = item.GL_Insurance_Cost__c;
        model.oaInsuranceCost = item.OA_Insurance_Cost__c;
        model.estimatedEffort = item.Estimated_Effort__c;
        model.estimatedTax = item.SBQQ__TaxAmount__c;
        model.aspTotal = item.ASP_Total__c;

        model.additionalFields = OrderFunnel_Utility.buildAdditionalFieldModels(item, 'Package');

        return model;
    }

    public static OrderFunnel_Models.OptionalPackageModel buildOptionModel(OrderItem item, String accountId){
        OrderFunnel_Models.OptionalPackageModel model = new OrderFunnel_Models.OptionalPackageModel();
        model.id = item.Id;
        model.parentId = item.SBQQ__RequiredBy__c;
        model.product = OrderFunnel_ProductUtilityHelper.getProductModel(item.Product2Id, accountId);
        return model;
    }

    public static String dateToString(Date d) {
        if (d == null) {
            return null;
        }
        DateTime dt = DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0);
        return dt.format('yyyy-MM-dd');
    }

    public static String dateTimeToString(DateTime dt) {
        if (dt == null) {
            return null;
        }
        return dt.format('yyyy-MM-dd');
    }
}