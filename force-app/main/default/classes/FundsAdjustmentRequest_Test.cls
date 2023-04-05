@isTest
public with sharing class FundsAdjustmentRequest_Test {
    
    @TestSetup
    static void makeData(){
        Funds_Adjustment_Request__c newRequest = new Funds_Adjustment_Request__c();
        newRequest.Job_Id__c = '1234';
        newRequest.Reason_for_Adjustment__c = 'Duplicate Charge';
        newRequest.Request_Status__c = FundsAdjustmentRequestSelector.RequestStatus_New;
        insert newRequest;    
    }

    @IsTest
    static void validateDuplicate(){
        
        Test.startTest();
            
            Funds_Adjustment_Request__c newRequest2 = new Funds_Adjustment_Request__c();
            newRequest2.Job_Id__c = '1234';
            newRequest2.Reason_for_Adjustment__c = 'Duplicate Charge';
            insert newRequest2;

        Test.stopTest();
        
    }
}