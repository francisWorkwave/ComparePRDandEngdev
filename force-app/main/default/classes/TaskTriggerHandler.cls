public  class TaskTriggerHandler extends TriggerHandler{

    private Map<Id, Task> newMap;
    private Tasks sObjectDomain;
    
    public TaskTriggerHandler() {
        this.newMap = (Map<Id, Task>) Trigger.newMap;
        this.sObjectDomain = new Tasks(records);
    }

    public override void beforeDelete(){
        sObjectDomain.onBeforeDelete();
    }
   
}