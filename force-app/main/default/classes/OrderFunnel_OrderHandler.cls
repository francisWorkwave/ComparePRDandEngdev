public with sharing class OrderFunnel_OrderHandler extends API_BaseHandler{
    public override List<Object> handleGet(RestRequest req){

        //Parameter extraction
        String orderId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(orderId, false, Order.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Order identifier invalid');
        }

        //Execution Logic
        List<Order> orders = OrderFunnel_OrderUtility.getOrders(orderId, null, false);

        List<OrderFunnel_Models.OrderModel> models = new List<OrderFunnel_Models.OrderModel>();
        for(Order o:orders){
            models.add(OrderFunnel_OrderUtility.buildModel(o));
        }

        setStatusCode(200);
        return models;
    }

    public override List<Object> handlePost(RestRequest req){

        //Parameter extraction
        String quoteId = req.params.get('quoteId');

        //Parameter validation
        if(OrderFunnel_Utility.isValidId(quoteId, false, SBQQ__Quote__c.getSObjectType()) == false){
            throw new API_Dispatcher.APIException(400, 'Quote identifier invalid');
        }

        //Execution Logic
        List<SBQQ__Quote__c> quotes = OrderFunnel_QuoteUtility.getQuotes(quoteId, false);
        SBQQ__Quote__c quote = quotes[0];
        quote.SBQQ__Status__c = 'Accepted';
        quote.SBQQ__Ordered__c = true;
        update quote;

        List<Order> orders = OrderFunnel_OrderUtility.getOrders(null, quoteId, true);

        List<OrderFunnel_Models.DMLResponse> responses = new List<OrderFunnel_Models.DMLResponse>();

        for (Order o : orders) {
            responses.add(new OrderFunnel_Models.DMLResponse(o.Id, o.AccountId, o.OrderNumber));
        }

        setStatusCode(201);
        return responses;
    }
}