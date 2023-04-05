@isTest
public class OrderFunnel_PricebookTest {
    
    @IsTest
    public static void testGET(){

        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.Display_Name__c = 'Test Product';
        prod.ProductCode = 'TESTPROD';
        prod.IsActive = true;
        insert prod;

        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = prod.Id;
        pbe.UnitPrice = 1;
        pbe.IsActive = true;
        insert pbe;

        Pricebook2 customPricebook = new Pricebook2();
        customPricebook.Name = 'Custom';
        customPricebook.IsActive = true;
        insert customPricebook;

        PricebookEntry pbc = new PricebookEntry();
        pbc.Pricebook2Id = customPricebook.Id;
        pbc.Product2Id = prod.Id;
        pbc.UnitPrice = 1;
        pbc.IsActive = true;
        insert pbc;

        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
    
        Contracted_Discount__c contractedDiscount = new Contracted_Discount__c();
        contractedDiscount.Account__c = acc.id;
        contractedDiscount.Price_Book__c = customPricebook.Id;
        contractedDiscount.Product__c = prod.id;
        insert contractedDiscount;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/pricebook/' + customPricebook.Id;
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
            OrderFunnel_Pricebook.doGet();
        Test.stopTest();

        System.assertEquals(200, resp.statusCode);
    }

    @IsTest
    public static void doPost(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
            OrderFunnel_Pricebook.doPost();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }

    @IsTest
    public static void testPATCH(){
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/pricebook/' + Test.getStandardPricebookId();
        //req.requestBody = Blob.valueOf(JSON.serialize(accModel));
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
            OrderFunnel_Pricebook.doPatch();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }

    @IsTest
    public static void testPUT(){
        RestRequest req = new RestRequest();
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
            OrderFunnel_Pricebook.doPut();
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
            OrderFunnel_Pricebook.doDelete();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }
}