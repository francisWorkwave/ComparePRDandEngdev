public with sharing class Region_AssignmentTriggerHandler extends TriggerHandler{
    
    private Map<Id, Region_Assignment__c> newOppMap;
    private Region_Assignment sObjectDomain;
    
    public Region_AssignmentTriggerHandler() {
        this.newOppMap = (Map<Id, Region_Assignment__c>) Trigger.newMap;
        this.sObjectDomain = new Region_Assignment(records);
    }
    
    public override void beforeInsert() {
        sObjectDomain.onBeforeInsert();
    }
    
}