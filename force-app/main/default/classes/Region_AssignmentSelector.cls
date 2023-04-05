public with sharing class Region_AssignmentSelector extends fflib_SObjectSelector{
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Region_Assignment__c.Id,
            Region_Assignment__c.Account__c,
            Region_Assignment__c.Region__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Region_Assignment__c.sObjectType;
    }
    
    public List<Region_Assignment__c> selectBySetAccountId(Set<Id> setAccountId) {
        return (List<Region_Assignment__c>) Database.query(
            newQueryFactory().
            selectField('Region__r.Name').
            setCondition('Account__c =: setAccountId').
            toSOQL()
        );
    }
}