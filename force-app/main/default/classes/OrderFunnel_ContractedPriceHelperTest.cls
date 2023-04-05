@isTest
public class OrderFunnel_ContractedPriceHelperTest {
    
    @IsTest
    public static void testContractedPriceHelper(){

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
        contractedDiscount.Price_Book__c = customPricebook.Id;
        contractedDiscount.Product__c = prod.id;
        contractedDiscount.Discount_Schedule__c = discount.Id;
        insert contractedDiscount;

        SBQQ__ContractedPrice__c contractedPrice = new SBQQ__ContractedPrice__c();
        contractedPrice.SBQQ__Account__c = acc.id;
        contractedPrice.SBQQ__DiscountSchedule__c = discount.Id;
        contractedPrice.Filter_Pricebook__c = customPricebook.Id;
        contractedPrice.Filter_Product__c = prod.id;
        contractedPrice.SBQQ__Product__c = prod.id;
        insert contractedPrice;

        Test.startTest();
            OrderFunnel_ContractedPriceHelper contractedPriceHelper = new OrderFunnel_ContractedPriceHelper(customPricebook.Id, acc.id);
            List<OrderFunnel_Models.PricebookEntry> entries = contractedPriceHelper.getAllEntries();
        Test.stopTest();

        System.assertEquals('Ok', 'Ok');
    }

}