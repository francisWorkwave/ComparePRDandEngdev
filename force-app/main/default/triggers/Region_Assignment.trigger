trigger Region_Assignment on Region_Assignment__c (before insert, before update, after insert, after update) {
    new Region_AssignmentTriggerHandler().run();
}