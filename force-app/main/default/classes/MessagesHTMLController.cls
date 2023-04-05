public with sharing class MessagesHTMLController {
    
    @AuraEnabled
    public static string getHTML(String recordId, String emailTemplateName){
        try {

            Messaging.reserveSingleEmailCapacity(1);            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{'invalid@emailaddr.com'};
            mail.setToAddresses(toAddresses);
            mail.setUseSignature(false);
            mail.setSaveAsActivity(false);
            mail.setSenderDisplayName('MMPT');
            mail.setTargetObjectId(UserInfo.getUserId());    
            
            EmailTemplate eTemplate = [select Id, htmlValue from EmailTemplate where Name =:emailTemplateName  LIMIT 1];
            Account thisContact = [Select PersonContactId From Account Where id = '0016u00000QMp1BAAT'];
            mail.setTemplateId(eTemplate.Id);
            //Set the context for the framework to merge the fields
            mail.setTargetObjectId(thisContact.PersonContactId);    
            //set additional reference context (related opportunity to the contact)
            mail.setWhatId(recordId);                           
            Savepoint sp = Database.setSavepoint();            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});            
            //Rollback so that teh framework merges the fields but doesnt send the email out
            Database.rollback(sp);              
            //Extract the merged results and display in the UI
            return mail.getHTMLBody();

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}