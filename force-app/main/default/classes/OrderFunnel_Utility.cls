public with sharing class OrderFunnel_Utility {
    public static Boolean isValidId(String value){
        return isValidId(value, false, null);
    }

    public static Boolean isValidId(String value, Boolean allowNulls){
        return isValidId(value, allowNulls, null);
    }

    public static Boolean isValidId(String value, Boolean allowNulls, SObjectType t){
        if(allowNulls && (value == null || value == '')){
            return true;
        }

        try{
            //Verify it can be cast to type id
            Id tempId = Id.valueOf(value);

            //Verify the object type
            if(t != null && tempId.getSobjectType() != t){
                return false;
            }

            return true;
        }catch(Exception ex){
            return false;
        }
    }

    public static List<OrderFunnel_Models.AdditionalFieldModel> buildAdditionalFieldModels(SObject obj, String key){
        List<OrderFunnel_Models.AdditionalFieldModel> additionalFields = new List<OrderFunnel_Models.AdditionalFieldModel>();

        for(Integer i = 1; i <= 20; i++){
            if(obj.get('Additional_Field_Label_' + i + '__c') != null){
                additionalFields.add(new OrderFunnel_Models.AdditionalFieldModel(key + i, (String) obj.get('Additional_Field_Label_' + i + '__c'), (String) obj.get('Additional_Field_Value_' + i + '__c')));
            }
        }

        return additionalFields;
    }

    public static void parseAdditionalFieldsModel(SObject obj, List<OrderFunnel_Models.AdditionalFieldModel> additionalFields, String key){
        if(additionalFields != null){
            //Note that nullifying additional fields requires a specific nil. The absence of a submission
            //will not cause the values to be erased.

            Map<String, SObjectField> objectFields = getObjectFields(obj);

            for (OrderFunnel_Models.AdditionalFieldModel af : additionalFields) {
                String index = af.id.substringAfter(key);

                if (objectFields.containsKey('Additional_Field_Label_' + index + '__c') == false) {
                    throw new API_Dispatcher.APIException(400, 'Additional Field Label not found: ' + af.id);
                }
                if (objectFields.containsKey('Additional_Field_Value_' + index + '__c') == false) {
                    throw new API_Dispatcher.APIException(400, 'Additional Field Value not found: ' + af.id);
                }

                obj.put(objectFields.get('Additional_Field_Label_' + index + '__c'), af.label);
                obj.put(objectFields.get('Additional_Field_Value_' + index + '__c'), af.value);
            }
        }
    }

    public static Map<String, SObjectField> getObjectFields(SObject obj){
        return obj.getSObjectType().getDescribe().fields.getMap();
    }

    public static OrderFunnel_Models.DMLResponse convertToDMLResponse(Object o){
        if(o == null){
            return null;
        }
        return (OrderFunnel_Models.DMLResponse) JSON.deserialize(JSON.serialize(o), OrderFunnel_Models.DMLResponse.class);
    }
}