public without sharing class FundsAdjustmentRequestSelector extends fflib_SObjectSelector{
    public static string RequestStatus_New = 'New';
    public static string RequestStatus_Pending = 'Pending';
    public static string RequestStatus_Processed = 'Processed';

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Funds_Adjustment_Request__c.Id,
            Funds_Adjustment_Request__c.Name,
            Funds_Adjustment_Request__c.Request_Status__c,
            Funds_Adjustment_Request__c.Job_Id__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Funds_Adjustment_Request__c.sObjectType;
    }
    
    public map<string, Funds_Adjustment_Request__c> selectByJobId(List<String> setId) {
        map<string, Funds_Adjustment_Request__c> mapByJobId = new map<string, Funds_Adjustment_Request__c>();

        for(Funds_Adjustment_Request__c item : (list<Funds_Adjustment_Request__c>) Database.query(newQueryFactory().setCondition('Job_Id__c IN: setId').toSOQL())){
            if (item.Request_Status__c == RequestStatus_New || item.Request_Status__c == RequestStatus_Pending || item.Request_Status__c == RequestStatus_Processed) {
                mapByJobId.put(item.Job_Id__c, item);        
            }
        }

        return mapByJobId;
    }

}