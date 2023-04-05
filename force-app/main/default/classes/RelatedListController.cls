public class RelatedListController {  
  
    @AuraEnabled( cacheable=true )  
    public static List < sObject > fetchRecords( String listValues )  {  
      
        system.debug( 'values are ' + listValues );  
        List < String > strList = listValues.split( ',' );  
        system.debug( 'values are ' + strList );  
          
        if ( strList.size() == 9 ) {  
          
            String recordId = strList.get( 0 );  
            String objectName = strList.get( 1 );
            String editMode = strList.get( 2 );
            String parentFieldAPIName = strList.get( 3 );
            String parentField2APIName = strList.get( 4 );
            String fieldName = strList.get( 5 );  
            String fieldValue = strList.get( 6 );  
            String filterType = strList.get( 7 );  
            String operator = strList.get( 8 );
              
            String strSOQL = 'SELECT Id FROM ' + objectName + ' WHERE (' + parentFieldAPIName + ' = \'' + recordId + '\'' + ' OR ' + parentField2APIName + ' = \'' + recordId + '\') AND ';
            if ( filterType == 'String' )      
                strSOQL += fieldName + ' = \'' + fieldValue + '\'';  
            else if ( filterType == 'Boolean' )      
                strSOQL += fieldName + ' = ' + fieldValue;  
            else  
                strSOQL += fieldName + ' ' + operator + ' ' + fieldValue;  
            strSOQL += ' LIMIT 10';      
            return Database.query( strSOQL );  
              
        } else   
            return null;  
          
    }  
          
}