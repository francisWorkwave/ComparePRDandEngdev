@isTest
public with sharing class OrderFunnel_UtilityTest {

    @isTest
    public static void isValidId_Required(){
        System.assertEquals(true, OrderFunnel_Utility.isValidId('001000000000000'));
        System.assertEquals(true, OrderFunnel_Utility.isValidId('001000000000000', false));
        System.assertEquals(true, OrderFunnel_Utility.isValidId('001000000000000', false, Account.getSObjectType()));
        System.assertEquals(false, OrderFunnel_Utility.isValidId('001000000000000', false, Asset.getSObjectType()));
        System.assertEquals(false, OrderFunnel_Utility.isValidId('0'));
        System.assertEquals(false, OrderFunnel_Utility.isValidId('0', false));
        System.assertEquals(false, OrderFunnel_Utility.isValidId(''));
        System.assertEquals(false, OrderFunnel_Utility.isValidId('', false));
        System.assertEquals(false, OrderFunnel_Utility.isValidId(null));
        System.assertEquals(false, OrderFunnel_Utility.isValidId(null, false));
    }

    @isTest
    public static void isValidId_Optional(){
        System.assertEquals(true, OrderFunnel_Utility.isValidId('001000000000000', true));
        System.assertEquals(true, OrderFunnel_Utility.isValidId('001000000000000', true, Account.getSObjectType()));
        System.assertEquals(false, OrderFunnel_Utility.isValidId('001000000000000', true, Asset.getSObjectType()));
        System.assertEquals(false, OrderFunnel_Utility.isValidId('0', true));
        System.assertEquals(true, OrderFunnel_Utility.isValidId('', true));
        System.assertEquals(true, OrderFunnel_Utility.isValidId(null, true));
    }

    @isTest
    public static void testBuildAdditionalFieldModels(){
        Account a = new Account();
        a.Additional_Field_Label_1__c = 'label1';
        a.Additional_Field_Value_1__c = 'value1';
        a.Additional_Field_Value_2__c = 'value2';
        a.Additional_Field_Label_3__c = 'label3';

        List<OrderFunnel_Models.AdditionalFieldModel> addFields;

        Test.startTest();

        addFields = OrderFunnel_Utility.buildAdditionalFieldModels(a, 'account');

        Test.stopTest();

        System.assertEquals(2, addFields.size());

        System.assertEquals('account1', addFields[0].id);
        System.assertEquals('label1', addFields[0].label);
        System.assertEquals('value1', addFields[0].value);

        System.assertEquals('account3', addFields[1].id);
        System.assertEquals('label3', addFields[1].label);
        System.assertEquals(null, addFields[1].value);
    }

    @isTest
    public static void testParseAdditionalFieldModel(){
        List<OrderFunnel_Models.AdditionalFieldModel> addFields = new List<OrderFunnel_Models.AdditionalFieldModel>();
        addFields.add(new OrderFunnel_Models.AdditionalFieldModel('account1', 'label1', 'value1'));
        addFields.add(new OrderFunnel_Models.AdditionalFieldModel('account3', 'label3', null));
        addFields.add(new OrderFunnel_Models.AdditionalFieldModel('account5', null, 'value5'));

        Account a = new Account();

        Test.startTest();

        OrderFunnel_Utility.parseAdditionalFieldsModel(a, addFields, 'account');

        Test.stopTest();

        System.assertEquals(a.Additional_Field_Label_1__c, 'label1');
        System.assertEquals(a.Additional_Field_Value_1__c, 'value1');
        System.assertEquals(a.Additional_Field_Label_3__c, 'label3');
        System.assertEquals(a.Additional_Field_Value_3__c, null);
        System.assertEquals(a.Additional_Field_Label_5__c, null);
        System.assertEquals(a.Additional_Field_Value_5__c, 'value5');
    }

    @isTest
    public static void testParseAdditionalFieldModel_Exceptions(){
        List<OrderFunnel_Models.AdditionalFieldModel> addFields = new List<OrderFunnel_Models.AdditionalFieldModel>();
        addFields.add(new OrderFunnel_Models.AdditionalFieldModel('account1', 'label1', 'value1'));

        Test.startTest();

        try{
            OrderFunnel_Utility.parseAdditionalFieldsModel(new Contact(), addFields, 'account');
            System.assert(false, 'Exception expected');
        }catch(Exception ex){
            System.assert(true, 'SUCESS');
        }

        Test.stopTest();
    }

    @isTest
    public static void testConvertToDMLResponse(){
        System.assertEquals(null, OrderFunnel_Utility.convertToDMLResponse(null));
        OrderFunnel_Models.DMLResponse resp = new OrderFunnel_Models.DMLResponse('id','accid','name');
        OrderFunnel_Models.DMLResponse resp2 = OrderFunnel_Utility.convertToDMLResponse(resp);
        System.assertEquals(resp.id, resp2.id);

    }
}