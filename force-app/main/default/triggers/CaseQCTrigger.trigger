trigger CaseQCTrigger on Case (before update) {

    for (case record : trigger.new)
    {
    if (record.QC_Rejection_Reason__c != null)
    {
        record.QC_Rejection_Reasons_Formatted__c = record.QC_Rejection_Reason__c.replace(';', ', ');
    }
}
}