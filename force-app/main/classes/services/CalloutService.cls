/**
 * Created by Henk Walgemoed<henk.walgemoed@appsolutely.nl>
 */
public with sharing class CalloutService {

    public static final String REQUEST_CATCHER_HOST = 'https://457.requestcatcher.com/';

        public static OrderDTO sendOrder(Id orderId) {
            Order order = OrderSelector.getOrderItems(orderId);

            RequestCatcherDTO newOrderDTO = new RequestCatcherDTO();
            newOrderDTO.accountNumber = String.isEmpty(order.Account.AccountNumber) ? '' : order.Account.AccountNumber;
            newOrderDTO.orderNumber = String.isEmpty(order.OrderNumber) ? '' : order.OrderNumber;
            newOrderDTO.type = String.isEmpty(order.Type) ? '' : order.Type;
            newOrderDTO.status = String.isEmpty(order.Status) ? '' : order.Status;

            List<RequestCatcherDTO.OrderProductClass> reqClassList = new List<RequestCatcherDTO.OrderProductClass>();
            for (OrderItem oi : order.OrderItems) {
                RequestCatcherDTO.OrderProductClass newOp = new RequestCatcherDTO.OrderProductClass();
                newOp.name = String.isEmpty(oi.Product2.Name) ? '' : oi.Product2.Name;
                newOp.code = String.isEmpty(oi.Product2.ProductCode) ? '' : oi.Product2.ProductCode;
                newOp.unitPrice = oi.UnitPrice;
                newOp.quantity = oi.Quantity;
                reqClassList.add(newOp);
            }
            newOrderDTO.orderProducts = reqClassList;


            // Serialize into json
            String body = JSON.serialize(newOrderDTO, false);
            HttpRequest req = new HttpRequest();
            req.setEndpoint(REQUEST_CATCHER_HOST);
            req.setMethod('POST');
            req.setBody(body);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json-patch+json');
            // Excecute Request

            Http http = new Http();
            HTTPResponse res = http.send(req);
            //
            // Parse Response
            if (res.getStatusCode() == 200) {

            } else {
                throw new CustomException('Something went wrong');
            }
            return OrderController.getOrderItems(orderId);
        }
}