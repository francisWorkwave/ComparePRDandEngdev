public with sharing class OrderFunnel_AssetUtility {

    private static Map<String, String> assetMetrics;
    public static Map<String, String> getAssetMetrics(){
        if(assetMetrics == null){
            Map<String, SObjectField> assetFields = getAssetFields();
            assetMetrics = new Map<String, String>();

            for(Property_Metric_Map__mdt metric : [ SELECT  MasterLabel, Asset_Field_API_Name__c
                                                    FROM    Property_Metric_Map__mdt ]){
                if (assetFields.containsKey(metric.Asset_Field_API_Name__c)) {
                    assetMetrics.put(metric.Asset_Field_API_Name__c, metric.MasterLabel);
                    assetMetrics.put(metric.MasterLabel, metric.Asset_Field_API_Name__c);
                }
            }
        }

        return assetMetrics;
    }

    @testVisible
    private static Map<String, SObjectField> getAssetFields(){
        return Asset.sObjectType.getDescribe().fields.getMap();
    }

    public static List<Asset> getAssets(String accountId, String propertyId, String assetId, Boolean allowList){
        String query = buildQuery(accountId, propertyId, assetId);

        List<Asset> assets = (List<Asset>) Database.query(query);

        if(assets.isEmpty()){
            throw new API_Dispatcher.APIException(404, 'Asset not found');
        }

        if(allowList == false && assets.size() > 1){
            throw new API_Dispatcher.APIException(300, 'Multiple assets identified');
        }

        return assets;
    }

    @testVisible
    private static String buildQuery(String accountId, String propertyId, String assetId){
        String query = 'SELECT Id, Name, AccountId, Account.Price_Book__c, TE_Property_Id__c, CU_Property_Id__c, Current_Tracing_ID__c, ';
        query += 'Street_Address__c, City__c, State__c, Postal_Code__c, Property_Location__Latitude__s, Property_Location__Longitude__s, ';
        query += 'Access_Code__c, Access_Note__c, Region__c, Region__r.Name, Region__r.TE_Region__c, Region__r.Price_Book__c, ';
        query += getAssetMetricFieldsString('');
        query += 'Additional_Field_Label_1__c, Additional_Field_Value_1__c, Additional_Field_Label_2__c, Additional_Field_Value_2__c, ';
        query += 'Additional_Field_Label_3__c, Additional_Field_Value_3__c, Additional_Field_Label_4__c, Additional_Field_Value_4__c, ';
        query += 'Additional_Field_Label_5__c, Additional_Field_Value_5__c, Additional_Field_Label_6__c, Additional_Field_Value_6__c, ';
        query += 'Additional_Field_Label_7__c, Additional_Field_Value_7__c, Additional_Field_Label_8__c, Additional_Field_Value_8__c, ';
        query += 'Additional_Field_Label_9__c, Additional_Field_Value_9__c, Additional_Field_Label_10__c, Additional_Field_Value_10__c, ';
        query += 'Additional_Field_Label_11__c, Additional_Field_Value_11__c, Additional_Field_Label_12__c, Additional_Field_Value_12__c, ';
        query += 'Additional_Field_Label_13__c, Additional_Field_Value_13__c, Additional_Field_Label_14__c, Additional_Field_Value_14__c, ';
        query += 'Additional_Field_Label_15__c, Additional_Field_Value_15__c, Additional_Field_Label_16__c, Additional_Field_Value_16__c, ';
        query += 'Additional_Field_Label_17__c, Additional_Field_Value_17__c, Additional_Field_Label_18__c, Additional_Field_Value_18__c, ';
        query += 'Additional_Field_Label_19__c, Additional_Field_Value_19__c, Additional_Field_Label_20__c, Additional_Field_Value_20__c ';

        query += 'FROM Asset ';

        query += 'WHERE ';
        if(accountId != null && accountId != ''){
            query += 'AccountId = :accountId AND ';
        }
        if(propertyId != null && propertyId != ''){
            query += 'TE_Property_Id__c = :propertyId AND ';
        }
        if(assetId != null && assetId != ''){
            query += 'Id = :assetId';
        }

        query = query.removeEnd(' AND ');

        return query;
    }

    public static String getAssetMetricFieldsString(String prefix){
        if(prefix == null){
            prefix = '';
        }

        String fieldsString = '';
        for(String metric : getAssetMetrics().keySet()){
            if(metric.endsWith('__c')){
                fieldsString += prefix + metric + ', ';
            }
        }
        return fieldsString;
    }

    public static OrderFunnel_Models.AssetModel buildModel(Asset a){
        OrderFunnel_Models.AssetModel model = new OrderFunnel_Models.AssetModel();
        model.Name = a.Name;
        model.AccountId = a.AccountId;
        model.SFID = a.Id;
        model.TEID = a.TE_Property_Id__c;
        model.CUID = a.CU_Property_Id__c;
        model.CurrentTracingId = a.Current_Tracing_ID__c;
        model.Address = new OrderFunnel_Models.AddressModel();
        model.Address.Street = a.Street_Address__c;
        model.Address.City = a.City__c;
        model.Address.State = a.State__c;
        model.Address.PostalCode = a.Postal_Code__c;
        model.Address.latitude = a.Property_Location__Latitude__s;
        model.Address.longitude = a.Property_Location__Longitude__s;
        model.teRegionId = a.Region__c;
        model.teRegionName = a.Region__r.Name;
        model.pricebookId = a.Region__r.Price_book__c;
        model.accessCode = a.Access_Code__c;
        model.accessNote = a.Access_Note__c;

        model.additionalFields = OrderFunnel_Utility.buildAdditionalFieldModels(a, 'Asset');

        for (String metricFieldName : getAssetMetrics().keySet()) {
            if(metricFieldName.endsWith('__c') && a.get(metricFieldName) != null) {
                OrderFunnel_Models.MetricModel metric = new OrderFunnel_Models.MetricModel();
                metric.Type = getAssetMetrics().get(metricFieldName);
                metric.Value = ((Decimal) a.get(metricFieldName)).toPlainString();
                model.Metrics.add(metric);
            }
        }
        return model;
    }

    public static Asset buildAsset(OrderFunnel_Models.AssetModel model, Asset a){
        if(a == null){
            a = new Asset();
            a.Id = model.sfId;
        }
        a.Name = model.Name;
        a.AccountId = model.AccountId;
        a.TE_Property_Id__c = model.TEID;
        a.CU_Property_Id__c = model.CUID;
        a.Current_Tracing_ID__c = model.CurrentTracingId;
        a.Status = model.status;

        if (model.Address != null) {
            a.Street_Address__c = model.Address.Street;
            a.City__c = model.Address.City;
            a.State__c = model.Address.State;
            a.Postal_Code__c = model.Address.PostalCode;
            a.Property_Location__Latitude__s = model.Address.latitude;
            a.Property_Location__Longitude__s = model.Address.longitude;
        }

        a.Access_Code__c = model.accessCode;
        a.Access_Note__c = model.accessNote;


        OrderFunnel_Utility.parseAdditionalFieldsModel(a, model.additionalFields, 'Asset');

        if(model.Metrics != null){
            //Note that nullifying metric fields requires a specific nil. The absence of a submission
            //will not cause the values to be erased.

            for (OrderFunnel_Models.MetricModel m : model.Metrics) {
                if (getAssetMetrics().containsKey(m.Type) == false) {
                    throw new API_Dispatcher.APIException(400, 'Metric field not mapped for: ' + m.Type);
                }

                a.put(getAssetMetrics().get(m.Type), Decimal.valueOf(m.Value));
            }
        }
        return a;
    }

    public static Property_Tracing__c requestRetrace(String assetId, List<OrderFunnel_Models.MetricModel> metrics) {
        Property_Tracing__c pt = new Property_Tracing__c();
        pt.Asset__c = assetId;
        String metricsChoices = '';
        for (OrderFunnel_Models.MetricModel m : metrics) {
            metricsChoices += m.Type + ';';
        }
        metricsChoices = metricsChoices.removeEnd(';');
        pt.Metrics__c = metricsChoices;

        return pt;

    }
}