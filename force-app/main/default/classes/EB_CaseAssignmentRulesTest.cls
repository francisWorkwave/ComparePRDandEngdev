@isTest
private class EB_CaseAssignmentRulesTest {
  static testMethod void runPositiveTestCases() {
    Case testCase = new Case();
    List<Id> caseIds = new List<Id>();

    insert testCase;

    caseIds.add(testCase.Id);

    Test.startTest();
    EB_CaseAssignmentRules.caseHandler(caseIds);
    Test.stopTest();
  }
}