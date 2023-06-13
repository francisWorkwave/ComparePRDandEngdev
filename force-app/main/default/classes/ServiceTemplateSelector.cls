/*
    Created by: Fran Oseguer
    Description: Selector for Service_Template__c object
*/
public without sharing class ServiceTemplateSelector extends fflib_SObjectSelector{
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Service_Template__c.Id,
            Service_Template__c.AFM_Zone__c,
            Service_Template__c.Frequency_Factor__c,
            Service_Template__c.Service_Schedule__c,
            Service_Template__c.Service_Template_External_ID__c,
            Service_Template__c.Name,
            Service_Template__c.Service_Template_Type__c,
            Service_Template__c.Total_Services__c
        };
    }
    
    public Schema.SObjectType getSObjectType() {
        return Service_Template__c.sObjectType;
    }
    
    public Map<String, List<Service_Template__c>> selectByType(set<String> setTemplateType) {
        Map<String, List<Service_Template__c>> mapTemplatesByType = new Map<String, List<Service_Template__c>>();

        for(Service_Template__c item : Database.query(newQueryFactory().setCondition('Service_Template_Type__c IN: setTemplateType').toSOQL()))
        {
            List<Service_Template__c> listTemplate = new List<Service_Template__c>();
            if (mapTemplatesByType.containsKey(item.Service_Template_Type__c)) {
                listTemplate = mapTemplatesByType.get(item.Service_Template_Type__c);    
            }
            listTemplate.add(item);
            mapTemplatesByType.put(item.Service_Template_Type__c, listTemplate);
        }
        
        return mapTemplatesByType;
    }
}