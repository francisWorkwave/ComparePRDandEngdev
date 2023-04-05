@isTest
public with sharing class OrderFunnel_ContactTest {
    @IsTest
    public static void testGET(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Contact c = new Contact();
        c.FirstName = 'Jane';
        c.LastName = 'Deaux';
        c.AccountId = a.Id;
        insert c;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/' + c.Id;
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Contact.doGet();
        Test.stopTest();

        System.assertEquals(200, resp.statusCode);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resp.responseBody.toString());
        System.assertEquals(true, result.get('success'));
        System.assertEquals(1, result.get('recordCount'));
        List<OrderFunnel_Models.ContactModel> records = (List<OrderFunnel_Models.ContactModel>) JSON.deserialize(JSON.serialize(result.get('records')), List<OrderFunnel_Models.ContactModel>.class);
        System.assertEquals('Deaux', records[0].lastName);
    }

    @IsTest
    public static void testPOST(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        OrderFunnel_Models.ContactModel conModel = new OrderFunnel_Models.ContactModel();
        conModel.accountId = a.Id;
        conModel.account = new OrderFunnel_Models.AccountModel();
        conModel.account.id = a.Id;
        conModel.firstName = 'John';
        conModel.lastName = 'Doe';
        conModel.email = 'jdoe@test.com';
        conModel.phone = '5555555555';
        conModel.mailingAddress = new OrderFunnel_Models.AddressModel();
        conModel.mailingAddress.street = '2901 Ashton Blvd';
        conModel.mailingAddress.city = 'Lehi';
        conModel.mailingAddress.state = 'Utah';
        conModel.mailingAddress.postalCode = '84043';

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/';
        req.requestBody = Blob.valueOf(JSON.serialize(conModel));
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Contact.doPost();
        Test.stopTest();

        System.assertEquals(201, resp.statusCode);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resp.responseBody.toString());
        System.assertEquals(true, result.get('success'));
        System.assertEquals(1, result.get('recordCount'));
        List<OrderFunnel_Models.DMLResponse> records = (List<OrderFunnel_Models.DMLResponse>) JSON.deserialize(JSON.serialize(result.get('records')), List<OrderFunnel_Models.DMLResponse>.class);
        System.assertNotEquals(null, records[0].id);
    }

    @IsTest
    public static void testPATCH(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        Contact c = new Contact();
        c.FirstName = 'Jane';
        c.LastName = 'Deaux';
        c.AccountId = a.Id;
        insert c;

        OrderFunnel_Models.ContactModel conModel = new OrderFunnel_Models.ContactModel();
        conModel.id = c.Id;
        conModel.accountId = a.Id;
        conModel.account = new OrderFunnel_Models.AccountModel();
        conModel.account.id = a.Id;
        conModel.firstName = 'Jane';
        conModel.lastName = 'Smith';
        conModel.email = 'jdoe@test.com';
        conModel.phone = '5555555555';
        conModel.mailingAddress = new OrderFunnel_Models.AddressModel();
        conModel.mailingAddress.street = '2901 Ashton Blvd';
        conModel.mailingAddress.city = 'Lehi';
        conModel.mailingAddress.state = 'Utah';
        conModel.mailingAddress.postalCode = '84043';

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/contact/' + c.Id;
        req.requestBody = Blob.valueOf(JSON.serialize(conModel));
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Contact.doPatch();
        Test.stopTest();

        System.assertEquals(200, resp.statusCode);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(resp.responseBody.toString());
        System.assertEquals(true, result.get('success'));
        System.assertEquals(1, result.get('recordCount'));
        List<OrderFunnel_Models.DMLResponse> records = (List<OrderFunnel_Models.DMLResponse>) JSON.deserialize(JSON.serialize(result.get('records')), List<OrderFunnel_Models.DMLResponse>.class);
        System.assertEquals(c.Id, records[0].id);

        Contact c2 = [SELECT Id, LastName FROM Contact WHERE Id = :c.Id];

        System.assertEquals('Smith', c2.LastName);
    }

    @IsTest
    public static void testPUT(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
        OrderFunnel_Contact.doPut();
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
        OrderFunnel_Contact.doDelete();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }
}