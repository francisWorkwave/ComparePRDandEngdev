public without sharing class Region_Assignment extends fflib_SObjectDomain{
    
    public Region_Assignment(List<Region_Assignment__c> sObjectList) {
        super(sObjectList);
    }
    
    public override void onBeforeInsert() {
        set<Id> listAccountId = new set<Id>();

        for(Region_Assignment__c item : (List<Region_Assignment__c>) Records){
            listAccountId.add(item.Account__c);   
        }

        map<String, String> mapExistingRegions = new map<String, String>();
        for(Region_Assignment__c item : new Region_AssignmentSelector().selectBySetAccountId(listAccountId)){
            mapExistingRegions.put(item.Account__c + '-' + item.Region__c, item.Region__r.Name);
        }

        for(Region_Assignment__c item : (List<Region_Assignment__c>) Records){
            if (mapExistingRegions.containsKey(item.Account__c + '-' + item.Region__c)) {
                item.addError(Label.DuplicateRegionAssignment.replace('{RegionName}', mapExistingRegions.get(item.Account__c + '-' + item.Region__c)));    
            }
        }
    }
    
}