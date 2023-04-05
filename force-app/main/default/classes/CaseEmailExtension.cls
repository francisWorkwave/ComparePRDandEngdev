public with sharing class CaseEmailExtension {

public ID csId {get; set;}  // comes from assignTo on component 

public CaseEmailExtension() { }
    
private final Case currentCase;

public CaseEmailExtension(ApexPages.StandardController currentcase) {
    this.currentCase = (Case)currentcase.getRecord();
  }

  public List<EmailMessage> getSortEmails(){
  String contactEmail = [SELECT Id, ContactEmail FROM Case where Id=:csId].get(0).ContactEmail;
  contactEmail = '%'+contactEmail+'%';
    return this.csId == null
        ? new List<EmailMessage>()  // handles UI preview use case
        : [SELECT Id, FromAddress, ToAddress, BCCAddress, CcAddress, MessageDate, Subject, Incoming, TextBody, HtmlBody, CreatedBy.Name   
            from EmailMessage where ParentId =: this.csId AND(FromAddress LIKE :contactEmail OR ToAddress LIKE :contactEmail OR BCCAddress LIKE :contactEmail OR CcAddress LIKE :contactEmail)
            order by MessageDate DESC ];
  }
}