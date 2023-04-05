@isTest
public with sharing class OrderFunnel_AssetUtilityTest {
    @IsTest
    static void getAssetFields(){

        Test.startTest();

        Map<String, SObjectField> fields = OrderFunnel_AssetUtility.getAssetFields();

        Test.stopTest();

        System.assertNotEquals(0, fields.size());
        System.assert(fields.containsKey('Lawn_Sq_Ft__c'));
    }

    @IsTest
    static void getAssetMetrics(){

        Test.startTest();

        Map<String, String> metrics = OrderFunnel_AssetUtility.getAssetMetrics();

        Test.stopTest();

        System.assertNotEquals(0, metrics.size());
        System.assert(metrics.containsKey('Lawn'));
    }

    @IsTest
    static void getAssetMetricFieldsString(){

        Test.startTest();

        String fieldsString = OrderFunnel_AssetUtility.getAssetMetricFieldsString(null);

        Test.stopTest();

        System.assert(fieldsString.contains('Lawn_Sq_Ft__c'));
    }

    @IsTest
    static void buildQuery_NoParams(){
        Test.startTest();

        String query = OrderFunnel_AssetUtility.buildQuery(null, null, null);

        Test.stopTest();

        System.assert(query.endsWith('WHERE '));
    }

    @IsTest
    static void buildQuery_TwoParams(){

        Test.startTest();

        String query = OrderFunnel_AssetUtility.buildQuery('001000000000000', '9876543210', null);

        Test.stopTest();

        System.assert(query.contains('WHERE AccountId = :accountId AND TE_Property_Id__c = :propertyId'));
        System.assert(query.endsWith( 'AND ') == false);
    }

    @IsTest
    static void buildQuery_AllParams(){

        Test.startTest();

        String query = OrderFunnel_AssetUtility.buildQuery('001000000000000', '9876543210', '02i000000000000');

        Test.stopTest();

        System.assertEquals(2, query.countMatches(' AND '));
        System.assert(query.endsWith(' AND ') == false);
    }

    @IsTest
    static void getAssets(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Asset ast = new Asset();
        ast.Name = '2901 Ashton Blvd';
        ast.AccountId = a.Id;
        ast.TE_Property_Id__c = '123';
        insert ast;

        Asset ast2 = new Asset();
        ast2.Name = '2910 Ashton Ave';
        ast2.AccountId = a.Id;
        ast2.TE_Property_Id__c = '456';
        insert ast2;


        Test.startTest();

        //Success Single
        List<Asset> records = OrderFunnel_AssetUtility.getAssets(null, null, ast.Id, false);
        System.assertEquals(1, records.size());

        //Success Multiple
        records = OrderFunnel_AssetUtility.getAssets(a.Id, null, null, true);
        System.assertEquals(2, records.size());

        //No Results Failure
        try{
            OrderFunnel_AssetUtility.getAssets(null, null, '02i000000000000', false);
            System.assert(false, 'No found error expected.');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(404, ex.statusCode);
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }
        //Multiple Results Failure
        try{
            OrderFunnel_AssetUtility.getAssets(a.Id, null, null, false);
            System.assert(false, 'Expected Multiple Records error');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(300, ex.statusCode);
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @IsTest
    static void buildModel(){
        Asset ast = new Asset();
        ast.Name = '2901 Ashton Blvd';
        ast.AccountId = '001000000000000';
        ast.Additional_Field_Label_1__c = 'label1';
        ast.Additional_Field_Value_1__c = 'value1';
        ast.Lawn_Sq_Ft__c = 1500;

        Test.startTest();

        OrderFunnel_Models.AssetModel model = OrderFunnel_AssetUtility.buildModel(ast);

        Test.stopTest();

        System.assertEquals(1, model.additionalFields.size());
        System.assertEquals('label1', model.additionalFields[0].label);
        System.assertEquals('value1', model.additionalFields[0].value);
        System.assertEquals(1, model.metrics.size());
        System.assertEquals('Lawn', model.metrics[0].type);
        System.assertEquals('1500', model.metrics[0].value);
    }

    @IsTest
    static void buildAsset(){
        OrderFunnel_Models.AssetModel assetModel = new OrderFunnel_Models.AssetModel();
        assetModel.name = 'Eide Bailly LLP';
        assetModel.accountId = '001000000000000';
        assetModel.teId = 'PropertyId';
        assetModel.cuId = 'CustomerPropertyId';
        assetModel.currentTracingId = '12345';
        assetModel.address = new OrderFunnel_Models.AddressModel();
        assetModel.address.street = '2901 Ashton Blvd';
        assetModel.address.city = 'Lehi';
        assetModel.address.state = 'UT';
        assetModel.address.postalCode = '84043';
        assetModel.address.country = 'US';
        assetModel.accessCode = '9999';
        assetModel.accessNote = 'Enter through the side gate.';
        assetModel.additionalFields.add(new OrderFunnel_Models.AdditionalFieldModel('Asset1','label1','value1'));
        assetModel.metrics.add(new OrderFunnel_Models.MetricModel('Lawn', '1500'));

        Test.startTest();

        Asset a = OrderFunnel_AssetUtility.buildAsset(assetModel, null);

        Test.stopTest();

        System.assertEquals('label1', a.Additional_Field_Label_1__c);
        System.assertEquals('value1', a.Additional_Field_Value_1__c);
        System.assertEquals(1500, a.Lawn_Sq_Ft__c);

    }

    @IsTest
    static void buildAsset_InvalidMetric(){
        OrderFunnel_Models.AssetModel assetModel = new OrderFunnel_Models.AssetModel();
        assetModel.name = 'Eide Bailly LLP';
        assetModel.accountId = '001000000000000';
        assetModel.teId = 'PropertyId';
        assetModel.cuId = 'CustomerPropertyId';
        assetModel.currentTracingId = '12345';
        assetModel.address = new OrderFunnel_Models.AddressModel();
        assetModel.address.street = '2901 Ashton Blvd';
        assetModel.address.city = 'Lehi';
        assetModel.address.state = 'UT';
        assetModel.address.postalCode = '84043';
        assetModel.address.country = 'US';
        assetModel.accessCode = '9999';
        assetModel.accessNote = 'Enter through the side gate.';
        assetModel.additionalFields.add(new OrderFunnel_Models.AdditionalFieldModel('Asset1','label1','value1'));
        assetModel.metrics.add(new OrderFunnel_Models.MetricModel('FakeMetric', '1500'));

        Test.startTest();

        try{
            Asset a = OrderFunnel_AssetUtility.buildAsset(assetModel, null);
            System.assert(false, 'Expected Invalid Metric error');
        }catch(API_Dispatcher.APIException ex){
            System.assertEquals(400, ex.statusCode);
        }catch(Exception ex){
            System.assert(false, 'APIException expected: ' + ex.getTypeName() + ' presented');
        }

        Test.stopTest();
    }

    @IsTest
    static void requestRetrace(){

        List<OrderFunnel_Models.MetricModel> models = new List<OrderFunnel_Models.MetricModel>();
        models.add(new OrderFunnel_Models.MetricModel('Lawn','Lawn_Sq_Ft__c'));
        models.add(new OrderFunnel_Models.MetricModel('Weeding','Garden_Sq_Ft__c'));

        Test.startTest();

        Property_Tracing__c tracing = OrderFunnel_AssetUtility.requestRetrace('02i000000000000', models);

        Test.stopTest();

        System.assertEquals('02i000000000000', tracing.Asset__c);
        System.assertEquals('Lawn;Weeding',tracing.Metrics__c);
    }
}