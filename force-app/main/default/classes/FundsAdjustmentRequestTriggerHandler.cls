public without sharing class FundsAdjustmentRequestTriggerHandler extends TriggerHandler{

    private Map<Id, Funds_Adjustment_Request__c> newOppMap;
    private FundsAdjustmentRequest sObjectDomain;
    
    public FundsAdjustmentRequestTriggerHandler() {
        this.newOppMap = (Map<Id, Funds_Adjustment_Request__c>) Trigger.newMap;
        this.sObjectDomain = new FundsAdjustmentRequest(records);
    }

    public override void beforeInsert(){
        sObjectDomain.onBeforeInsert();
    }
}