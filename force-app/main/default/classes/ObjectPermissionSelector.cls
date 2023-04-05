public without sharing class ObjectPermissionSelector extends fflib_SObjectSelector{

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            ObjectPermission__mdt.Id,
            ObjectPermission__mdt.Label,
            ObjectPermission__mdt.Developername,
            ObjectPermission__mdt.DoNotDelete__c,
            ObjectPermission__mdt.Object__c,
            ObjectPermission__mdt.Profile__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return ObjectPermission__mdt.sObjectType;
    }
    
    public ObjectPermission__mdt selectByProfileAndObject(String objectApiName) {
        String profileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
        fflib_QueryFactory newQuery = newQueryFactory();
        newQuery.setCondition('Profile__r.Label =: profileName AND Object__r.ObjectAPI__c =: objectApiName').toSOQL();

        list<ObjectPermission__mdt> resul = Database.query(newQuery.toSOQL());
        if (!resul.isEmpty()) {
            return resul[0];
        }

        return new ObjectPermission__mdt();
    }
}