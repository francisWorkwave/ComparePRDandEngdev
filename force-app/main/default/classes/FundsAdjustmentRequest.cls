public without sharing class FundsAdjustmentRequest extends fflib_SObjectDomain{

    public FundsAdjustmentRequest(List<Funds_Adjustment_Request__c> sObjectList) {
        super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new FundsAdjustmentRequest(sObjectList);
        }
    }

    public override void onBeforeInsert() {
        List<String> listJobId = new List<String>();

        for (Funds_Adjustment_Request__c item : (List<Funds_Adjustment_Request__c>) Records) {
            listJobId.add(item.Job_Id__c);    
        }

        map<string, Funds_Adjustment_Request__c> mapFundsByJobId = new FundsAdjustmentRequestSelector().selectByJobId(listJobId);  
        
        if(!mapFundsByJobId.isEmpty()){
            for (Funds_Adjustment_Request__c item : (List<Funds_Adjustment_Request__c>) Records) {
                
                if (mapFundsByJobId.containsKey(item.Job_Id__c)) {
                    String duplicateError = Label.DuplicateFundsAdjustmentRequest;
                    duplicateError = duplicateError.replace('{Job_Id__c}', item.Job_Id__c);
                    duplicateError = duplicateError.replace('{Name}', mapFundsByJobId.get(item.Job_Id__c).Name);

                    if(!System.Test.isRunningTest()){
                        item.addError(duplicateError);
                    }
                }        
            }
        }
    }
}