@IsTest
public class OrderFunnel_PricebookEntriesTest {
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

        SBQQ__DiscountSchedule__c discount = new SBQQ__DiscountSchedule__c();
        discount.Name = 'Test';
        discount.SBQQ__Account__c = acc.id;
        discount.SBQQ__Type__c = 'Range';
        discount.SBQQ__Pricebook__c = customPricebook.Id;
        discount.SBQQ__DiscountUnit__c = 'Percent';
        insert discount;

        SBQQ__DiscountTier__c tier = new SBQQ__DiscountTier__c();
        tier.SBQQ__Schedule__c = discount.id;
        tier.SBQQ__DiscountAmount__c = 1;
        tier.SBQQ__Discount__c = 1;
        tier.SBQQ__LowerBound__c = 1;
        tier.SBQQ__Number__c = 1;
        tier.SBQQ__Price__c = 1;
        tier.SBQQ__UpperBound__c = 2;
        insert tier;

        Contracted_Discount__c contractedDiscount = new Contracted_Discount__c();
        contractedDiscount.Account__c = acc.id;
        contractedDiscount.Discount_Schedule__c = discount.Id;
        contractedDiscount.Price_Book__c = customPricebook.Id;
        contractedDiscount.Product__c = prod.id;
        insert contractedDiscount;

        RestRequest req = new RestRequest();
        req.requestURI = '/orderfunnel/pricebook/' + customPricebook.Id + '/entries';
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
            OrderFunnel_PricebookEntries.doGet();

            req.params.put('accountId', acc.Id);
            req.params.put('productId', prod.Id);
            OrderFunnel_PricebookEntries.doGet();
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
            OrderFunnel_PricebookEntries.doPost();
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
        req.requestURI = '/orderfunnel/pricebook/' + Test.getStandardPricebookId() + '/entries';
        //req.requestBody = Blob.valueOf(JSON.serialize(accModel));
        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        Test.startTest();
            OrderFunnel_PricebookEntries.doPatch();
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
            OrderFunnel_PricebookEntries.doPut();
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
            OrderFunnel_PricebookEntries.doDelete();
        Test.stopTest();

        System.assertEquals(501, resp.statusCode);
    }    
}