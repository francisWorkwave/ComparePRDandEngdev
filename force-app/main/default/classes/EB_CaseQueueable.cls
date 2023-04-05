public with sharing class EB_CaseQueueable implements Queueable{

  public List<Id> caseIdRerun;

  public void execute(QueueableContext context) {
    Case caseRerun = findCase(caseIdRerun[0]);
    AssignmentRule assignRule = findActiveAssignRule();
    updateCaseAssignment(caseRerun.Id, assignRule.Id);
  }

  public static Case findCase(Id caseId){
    List<Case> caseRerun = [SELECT Id FROM Case WHERE Id =: caseID LIMIT 1];
    return caseRerun[0];
  }

  public static AssignmentRule findActiveAssignRule(){
    List<AssignmentRule> ars = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Case' and Active = true limit 1];
    return ars[0];
  }

  public static void updateCaseAssignment(Id caseId, Id assignRuleId){
    Case caseUpdate = new Case();

    Database.DMLOptions dmlOpts = new Database.DMLOptions();
    dmlOpts.assignmentRuleHeader.assignmentRuleId= assignRuleId;
    caseUpdate.setOptions(dmlOpts);
    caseUpdate.id = caseId;
    update caseUpdate;
  }

}