global without sharing class PrepareMySandbox implements SandboxPostCopy {
    
    global void runApexClass(SandboxContext context) {
        System.debug('Org ID: ' + context.organizationId());
        System.debug('Sandbox ID: ' + context.sandboxId());
        System.debug('Sandbox Name: ' + context.sandboxName());
        
        // Delete Orders
        List<Order> listOrders = [Select id From Order];
        if (!listOrders.isEmpty()) {
            delete listOrders;    
        }

        
        // Delete Quotes
        List<SBQQ__Quote__c> listQuotes = [Select id From SBQQ__Quote__c];
        if (!listQuotes.isEmpty()) {
            delete listQuotes;    
        }

        // Delete Assets
        List<Asset> listAssets = [Select id From Asset];
        if (!listAssets.isEmpty()) {
            delete listAssets;    
        }

        List<User> userEmailList = [select Email from User where profile.name = 'System Administrator' and IsActive = TRUE]; 

        List<User> usersToUpdate = new List<User>();
        for(User uc : userEmailList) { 
            String addedPhrase = '.invalid'; 
            uc.Email = uc.Email.remove(addedPhrase); 
            usersToUpdate.add(uc); 
        } 

        if(usersToUpdate.size() > 0) { 
             Update usersToUpdate; 
        }

    }
}