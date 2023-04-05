trigger FundsAdjustmentRequest on Funds_Adjustment_Request__c (before insert) {
    new FundsAdjustmentRequestTriggerHandler().run();
}