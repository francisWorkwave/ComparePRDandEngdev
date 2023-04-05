@isTest
public with sharing class OrderFunnel_AccountUtilityTest {
    @isTest
    public static void testGetAccounts(){
        OrderFunnel_AccountUtility.getAccounts(null);
    }

    @isTest
    public static void testBuildModel(){
        Account a = new Account();
        a.Name = 'Tested Account';
        a.Phone = '8885551111';
        a.BillingStreet = '2901 Ashton Blvd';
        a.BillingCity = 'Lehi';
        a.BillingState = 'Utah';
        a.BillingPostalCode = '84043';
        a.Additional_Field_Label_1__c = 'label1';
        a.Additional_Field_Value_1__c = 'value1';
        a.Additional_Field_Label_2__c = 'label2';
        a.Additional_Field_Value_3__c = 'value3';

        Test.startTest();

        OrderFunnel_Models.AccountModel accModel = OrderFunnel_AccountUtility.buildModel(a);

        Test.stopTest();

        System.assertEquals('Tested Account', accModel.Name);
        System.assertEquals('8885551111', accModel.Phone);
        System.assertEquals('2901 Ashton Blvd', accModel.billingAddress.street);
        System.assertEquals('Lehi', accModel.billingAddress.city);
        System.assertEquals('Utah', accModel.billingAddress.state);
        System.assertEquals('84043', accModel.billingAddress.postalCode);
        System.assertEquals(2, accModel.additionalFields.size());
    }

    @isTest
    public static void testBuildAccount(){
        OrderFunnel_Models.AccountModel accModel = new OrderFunnel_Models.AccountModel();
        accModel.id = '001000000000000';
        accModel.name = 'Tested Account';
        accModel.additionalFields.add(new OrderFunnel_Models.AdditionalFieldModel('Customer1', 'label1', 'value1'));
        accModel.billingAddress = new OrderFunnel_Models.AddressModel();
        accModel.billingAddress.street = '2901 Ashton Blvd';
        accModel.billingAddress.city = 'Lehi';
        accModel.billingAddress.state = 'Utah';
        accModel.billingAddress.postalCode = '84043';
        accModel.phone = '8885551111';

        Test.startTest();

        Account a = OrderFunnel_AccountUtility.buildAccount(accModel, null);

        Test.stopTest();

        System.assertEquals('Tested Account', a.Name);
        System.assertEquals('8885551111', a.Phone);
        System.assertEquals('label1', a.Additional_Field_Label_1__c);
        System.assertEquals('value1', a.Additional_Field_Value_1__c);
        System.assertEquals('2901 Ashton Blvd', a.BillingStreet);
        System.assertEquals('Lehi', a.BillingCity);
        System.assertEquals('Utah', a.BillingState);
        System.assertEquals('84043', a.BillingPOstalCode);
    }
}