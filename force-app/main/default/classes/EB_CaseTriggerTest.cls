@isTest 
public class EB_CaseTriggerTest {
    
    @isTest
    private static void caseWithRelatedAccountDomain() {
        Account acc = new Account();
        acc.Domain__c = 'test.com';
        acc.Is_this_a_registered_company__c = 'Yes';
        acc.Name = 'KelseyTest';
        insert acc;

        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = acc.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        
        Case c = new Case();
        c.SuppliedEmail = 'test@test.com';

        Test.startTest();
        insert c;
        Test.stopTest();

        Case TriggerResult = [SELECT AccountId, Domain__c FROM Case WHERE Id =: c.Id];

        System.assertEquals(acc.Id, TriggerResult.AccountId);
        System.assertEquals(acc.Domain__c, TriggerResult.Domain__c);

        
    }

    @isTest
    private static void caseWithNoRelatedAccountDomain() {
        Account acc = new Account();
        acc.Is_this_a_registered_company__c = 'Yes';
        acc.Name = 'KelseyTest';
        insert acc;

        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = null;
        Test.setFixedSearchResults(fixedSearchResults);
        
        Case c = new Case();
        c.SuppliedEmail = 'test@test.com';

        Test.startTest();
        insert c;
        Test.stopTest();

        Case TriggerResult = [SELECT AccountId, Domain__c FROM Case WHERE Id =: c.Id];
        
        System.assertEquals(null, TriggerResult.AccountId);
        System.assertEquals('test.com', TriggerResult.Domain__c);

    }

    @isTest
    private static void caseWithNoSuppliedEmailDomain() {
        Account acc = new Account();
        acc.Domain__c = 'test.com';
        acc.Is_this_a_registered_company__c = 'Yes';
        acc.Name = 'KelseyTest';
        insert acc;

        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = null;
        Test.setFixedSearchResults(fixedSearchResults);
        
        Case c = new Case();

        Test.startTest();
        insert c;
        Test.stopTest();

        Case TriggerResult = [SELECT AccountId, Domain__c FROM Case WHERE Id =: c.Id];
        
        System.assertEquals(null, TriggerResult.AccountId);
        System.assertEquals(null, TriggerResult.Domain__c);
    }

    
}