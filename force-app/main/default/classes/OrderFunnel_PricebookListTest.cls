@IsTest
public class OrderFunnel_PricebookListTest {
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

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/pricebook/list' + Test.getStandardPricebookId() ;
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
            OrderFunnel_PricebookList.doGet();
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
            OrderFunnel_PricebookList.doPost();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }

    @IsTest
    public static void testPATCH(){
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
        
        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/pricebook/list' + Test.getStandardPricebookId();
        //req.requestBody = Blob.valueOf(JSON.serialize(accModel));
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
            OrderFunnel_PricebookList.doPatch();
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
            OrderFunnel_PricebookList.doPut();
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
            OrderFunnel_PricebookList.doDelete();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }
}