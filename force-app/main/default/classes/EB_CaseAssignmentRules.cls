public with sharing class EB_CaseAssignmentRules {

  @InvocableMethod
  public static void caseHandler(List<Id> caseId){
    system.debug('handler accepted');
    EB_CaseQueueable queue = new EB_CaseQueueable();
    queue.caseIdRerun = caseId;
    System.enqueueJob(queue);

  }
}