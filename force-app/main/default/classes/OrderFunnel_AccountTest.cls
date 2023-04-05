@isTest
public with sharing class OrderFunnel_AccountTest {
    @IsTest
    public static void testGET(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/account/' + a.Id;
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Account.doGet();
        Test.stopTest();

        System.assertEquals(200, resp.statusCode);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resp.responseBody.toString());
        System.assertEquals(true, result.get('success'));
        System.assertEquals(1, result.get('recordCount'));
        List<OrderFunnel_Models.AccountModel> records = (List<OrderFunnel_Models.AccountModel>) JSON.deserialize(JSON.serialize(result.get('records')), List<OrderFunnel_Models.AccountModel>.class);
        System.assertEquals('Test Account', records[0].name);
    }

    @isTest
    public static void testPOST(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Account.doPost();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }

    @IsTest
    public static void testPATCH(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        OrderFunnel_Models.AccountModel accModel = new OrderFunnel_Models.AccountModel();
        accModel.id = a.Id;
        accModel.name = 'Tested Account';
        accModel.additionalFields.add(new OrderFunnel_Models.AdditionalFieldModel('Customer1', 'label1', 'value1'));
        accModel.billingAddress = new OrderFunnel_Models.AddressModel();
        accModel.billingAddress.street = '2901 Ashton Blvd';
        accModel.billingAddress.city = 'Lehi';
        accModel.billingAddress.state = 'Utah';
        accModel.billingAddress.postalCode = '84043';
        accModel.phone = '8885551111';

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/account/' + a.Id;
        req.requestBody = Blob.valueOf(JSON.serialize(accModel));
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Account.doPatch();
        Test.stopTest();

        System.assertEquals(200, resp.statusCode);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resp.responseBody.toString());
        System.assertEquals(true, result.get('success'));
        System.assertEquals(1, result.get('recordCount'));
        List<OrderFunnel_Models.DMLResponse> records = (List<OrderFunnel_Models.DMLResponse>) JSON.deserialize(JSON.serialize(result.get('records')), List<OrderFunnel_Models.DMLResponse>.class);
        System.assertEquals(a.Id, records[0].id);

        Account a2 = [SELECT Id, Name, Phone, BillingAddress, Additional_Field_Label_1__c, Additional_Field_Value_1__c
                        FROM Account
                        WHERE Id = :a.Id];

        System.assertEquals('Tested Account', a2.Name);
        System.assertEquals('8885551111', a2.Phone);
        System.assertEquals('label1', a2.Additional_Field_Label_1__c);
        System.assertEquals('value1', a2.Additional_Field_Value_1__c);
        System.assertEquals('2901 Ashton Blvd', a2.BillingAddress.getStreet());
        System.assertEquals('Lehi', a2.BillingAddress.getCity());
        System.assertEquals('Utah', a2.BillingAddress.getState());
        System.assertEquals('84043', a2.BillingAddress.getPostalCode());
    }

    @IsTest
    public static void testPUT(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Account.doPut();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }

    @IsTest
    public static void testDELETE(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Account.doDelete();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }
}