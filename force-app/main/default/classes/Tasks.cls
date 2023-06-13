public class Tasks extends fflib_SObjectDomain{

    public Tasks(List<Task> sObjectList) {
        super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Tasks(sObjectList);
        }
    }

    public override void onBeforeDelete() {
        ObjectPermission__mdt ObjectPermission = new ObjectPermissionSelector().selectByProfileAndObject('Task');

        for (Task item : (List<Task>) Records) {
            if (ObjectPermission.DoNotDelete__c) {
                item.addError(Label.TaskDeletion);
            }
        }
    }
}