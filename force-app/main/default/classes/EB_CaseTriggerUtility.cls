public with sharing class EB_CaseTriggerUtility {
    public static void beforeCaseInsert(List<Case> newList){

        Map<String, Case> caseDomainMap = new Map<String, Case>();

        Map<Case, String> caseEmailMap = new Map<Case, String>();

        for(Case c : newList){
            String domain;
            if(c.suppliedEmail != null){
                domain = c.SuppliedEmail.split('@').get(1);
                caseEmailMap.put(c, c.SuppliedEmail);
            }

            if(!String.isBlank(domain)){
                c.Domain__c = domain;
                caseDomainMap.put(domain, c);
            }
        }

        String contactSearchTerms = '';

        for(String email : caseEmailMap.values()){
            contactSearchTerms += '(' + email + ') OR ';
        }

        contactSearchTerms = contactSearchTerms.removeEnd(' OR ');
        System.debug(contactSearchTerms);

        List<List<SObject>> searchList1 = New List<List<SObject>>();
        List<Contact> conSearchList = new List<Contact>();

        if(contactSearchTerms.length() !=0){
            searchList1 = [FIND :contactSearchTerms IN ALL FIELDS RETURNING Contact (Email, AccountId)];
            conSearchList = searchList1[0];
        }

        System.debug(conSearchList);

        Map<String, Id> ContactEmailAccountIdMap = new Map<String, Id>();

        for(Contact con : conSearchList){
            ContactEmailAccountIdMap.put(con.email, con.AccountId);
        }
        System.debug(ContactEmailAccountIdMap);

        Map<String, Account> accountDomainIdMap = new Map<String, Account>([SELECT Domain__c, Id FROM Account WHERE Id IN :ContactEmailAccountIdMap.values() AND ParentId = null]);
        System.debug(accountDomainIdMap);

        for(String accId : accountDomainIdMap.keySet()){
            String accDomain = accountDomainIdMap.get(accId).Domain__c;

            for(String domain : caseDomainMap.keySet()){
                if(domain == accDomain){
                    case c = caseDomainMap.get(domain);
                    c.AccountId = accId;
                    caseDomainMap.remove(domain);
                }
            }
        }

        String searchTerms = '';

        for(String domain : caseDomainMap.keyset()){
            searchTerms += '(' + domain + ') OR ';
        }

        searchTerms = searchTerms.removeEnd(' OR ');

        List<List<SObject>> searchList2 = New List<List<SObject>>();
        List<Account> accSearchList = new List<Account>();

        if(searchTerms.length() !=0){
            searchList2 = [FIND :searchTerms IN ALL FIELDS RETURNING Account (Domain__c, ParentId)];
            accSearchList = searchList2[0];
        }

        for(String domain: caseDomainMap.keyset()){
            Case c = caseDomainMap.get(domain);
            for(Account acc : accSearchList){
                if(acc.Domain__c == Domain && acc.ParentId == null){
                    c.AccountId = acc.Id;
                }
            }
        // System.debug(c);
        }
    }
}