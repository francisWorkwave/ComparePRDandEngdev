//This trigger utilizes an Event-Dispatch-Handler-Utility framework to simplify the code base and extend the admin controls over triggers in production.
//for more information see the following link: https://bitbucket.org/eidebailly/edhu/src/dev 
trigger EB_CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    //Initialize the handler
    EDHU.SObjectHandler handler = EDHU.SObjectDispatcher.init('EB_Case');

    //Execute the appropriate dispatch method.
    if(handler != null){ handler.execute(Trigger.operationType, Trigger.new, Trigger.oldMap); }
}