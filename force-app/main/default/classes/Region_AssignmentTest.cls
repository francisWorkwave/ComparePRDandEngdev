@isTest
public with sharing class Region_AssignmentTest {
   
    @TestSetup
    static void makeData(){
        Account newAccount = new Account(Name = 'Test');
        insert newAccount;

        Region__c region = new Region__c(Name = 'Test', Code__c = '123');
        insert region;
    } 

    @IsTest
    static void methodName(){
        Account newAccount = [Select id From Account WHERE Name = 'Test' Limit 1];
        Region__c region = [Select id From Region__c WHERE Code__c = '123' Limit 1];

        Test.startTest();
            Region_Assignment__c regionAssignment = new Region_Assignment__c();
            regionAssignment.Account__c = newAccount.id;
            regionAssignment.Region__c = region.id;
            insert regionAssignment;

            System.assert(regionAssignment.id != null, 'Pass');
            
        Test.stopTest();
        
    } 
}