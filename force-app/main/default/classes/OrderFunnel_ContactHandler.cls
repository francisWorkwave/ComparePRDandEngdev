public with sharing class OrderFunnel_ContactHandler extends API_BaseHandler{
    /*public override List<Object> handleGet(RestRequest req){

        //Parameter extraction
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(contactId, false, Contact.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Contact identifier invalid');
        }

        //Execution Logic
        List<Contact> contacts = OrderFunnel_ContactUtility.getContacts(contactId, false);

        List<OrderFunnel_Models.ContactModel> models = new List<OrderFunnel_Models.ContactModel>();
        for(Contact c:contacts){
            models.add(OrderFunnel_ContactUtility.buildModel(c));
        }

        setStatusCode(200);

        return models;
    }*/

    public override List<Object> handleGet(RestRequest req){

        //Parameter extraction
        String accountId = req.params.get('accountId');
        String externalId = req.params.get('externalId');
        String includeChildren = req.params.get('includeChildren');

        if (includeChildren == null || includeChildren == '') {
            includeChildren = 'False';    
        
        }else if (includeChildren != 'False' && includeChildren != 'True') {
            throw new API_Dispatcher.APIException(400, 'includeChildren invalid value');    
        
        }else if (accountId == null && externalId == null) {
            throw new API_Dispatcher.APIException(400, 'No Account identifier');    
        }

        if (accountId == null && externalId != null) {
            accountId = externalId;        
        }

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(accountId) == false){
            throw new API_Dispatcher.APIException(400, 'Account identifier invalid');

        }/* if(OrderFunnel_Utility.isValidId(externalId) == false){
            throw new API_Dispatcher.APIException(400, 'Account identifier invalid');
        } */

        //Execution Logic
        List<Contact> contacts = OrderFunnel_ContactUtility.getChildrenContacts(accountId, boolean.ValueOf(includeChildren));

        //return JSON.serialize(contacts);
        return contacts;
    }

    public override List<Object> handlePost(RestRequest req){

        //Parameter extraction
        Blob conModelRaw = req.requestBody;
        OrderFunnel_Models.ContactModel conModel;

        //Parameter validation
        if(conModelRaw == null){
            throw new API_Dispatcher.APIException(400, 'Missing request body');
        }

        try{
            conModel = (OrderFunnel_Models.ContactModel) JSON.deserialize(conModelRaw.toString(), OrderFunnel_Models.ContactModel.class);
        }catch(Exception ex){
            throw new API_Dispatcher.APIException(400, 'Invalid request body. ' + ex.getMessage());
        }

        if(conModel.account == null){
            throw new API_Dispatcher.APIException(400, 'Please supply account information for new contacts.');
        }

        //Execution Logic
        try{
            OrderFunnel_ContactUtility.verifyAccount(conModel);

            Contact c = OrderFunnel_ContactUtility.buildContact(conModel, null);
            insert c;

            setStatusCode(201);

            return new List<OrderFunnel_Models.DMLResponse>{new OrderFunnel_Models.DMLResponse(c.Id)};
        }catch(Exception ex){

            throw new API_Dispatcher.APIException(500, 'An error occurred while creating the contact. ' + ex.getMessage());
        }
    }

    public override List<Object> handlePatch(RestRequest req){

        //Parameter extraction
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Blob contactModelRaw = req.requestBody;
        OrderFunnel_Models.ContactModel conModel;

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(contactId, false, Contact.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Contact identifier invalid');
        }
        if(contactModelRaw == null){
            throw new API_Dispatcher.APIException(400, 'Missing request body');
        }

        try{
            conModel = (OrderFunnel_Models.ContactModel) JSON.deserialize(contactModelRaw.toString(), OrderFunnel_Models.ContactModel.class);
        }catch(Exception ex){
            throw new API_Dispatcher.APIException(400, 'Invalid request body. ' + ex.getMessage());
        }

        //Execution Logic
        OrderFunnel_ContactUtility.verifyAccount(conModel);

        List<Contact> contacts = OrderFunnel_ContactUtility.getContacts(contactId, false);

        try{
            Contact c = contacts[0];
            OrderFunnel_ContactUtility.buildContact(conModel, c);
            update c;

            setStatusCode(200);

            return new List<OrderFunnel_Models.DMLResponse>{new OrderFunnel_Models.DMLResponse(c.Id)};
        }catch (Exception ex) {
            throw new API_Dispatcher.APIException(500, 'An error occurred while updating the contact.' + ex.getMessage());
        }
    }
}