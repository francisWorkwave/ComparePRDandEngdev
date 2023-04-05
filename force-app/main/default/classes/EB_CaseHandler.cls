global class EB_CaseHandler extends EDHU.SObjectHandler{

    global override void beforeInsert(List<SObject> newList){
        List<Case> CaseNewList = (List<Case>)newList;
        EB_CaseTriggerUtility.beforeCaseInsert(CaseNewList);
    }

    global override void beforeUpdate(List<SObject> newList, Map<Id, SObject> oldMap){
    }

    global override void beforeDelete(Map<Id, SObject> oldMap){
    }

    global override void afterInsert(List<SObject> newList){
        List<Case> CaseNewList = (List<Case>)newList;
        Map<Id, Case> CaseNewMap = new Map<Id, Case>(CaseNewList);


    }

    global override void afterUpdate(List<SObject> newList, Map<Id, SObject> oldMap){
        List<Case> CaseNewList = (List<Case>)newList;
        Map<Id, Case> CaseOldMap = (Map<Id, Case>)oldMap;
        Map<Id, Case> CaseNewMap = new Map<Id, Case>(CaseNewList);


    }

    global override void afterDelete(Map<Id, SObject> oldMap){
        Map<Id, Case> CaseOldMap = (Map<Id, Case>)oldMap;

       
    }


}