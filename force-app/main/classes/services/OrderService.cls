/**
 * Created by Henk Walgemoed<henk.walgemoed@appsolutely.nl>
 */
public with sharing class OrderService {

    public static void addProductToOrder(List<Id> priceBookEntryIds, Id orderId) {
        Order order = OrderSelector.getOrderItems(orderId);
        List<PricebookEntry> pbeList = ProductSelector.getPricebookEntries(priceBookEntryIds);
        Map<Id, OrderItem> oiMap = new Map<Id, OrderItem>();
        Map<Id, PricebookEntry> pbeMap = new Map<Id, PricebookEntry>();
        List<OrderItem> orderItemUpdate = new List<OrderItem>();
        for(PricebookEntry pbe : pbeList) {
            pbeMap.put(pbe.Id, pbe);
        }
        for(OrderItem oi : order.OrderItems) {
            oiMap.put(oi.PricebookEntryId, oi);
        }
        for (Id pbeId : priceBookEntryIds) {
            if (oiMap.containsKey(pbeId)) {
                OrderItem oi = oiMap.get(pbeId);
                oi.Quantity += 1;
                orderItemUpdate.add(oi);
            } else {
                PricebookEntry pbe = pbeMap.get(pbeId);
                OrderItem newOi = new OrderItem();
                newOi.PricebookEntryId = pbeId;
                newOi.Quantity = 1;

                newOi.OrderId = orderId;
                newOi.UnitPrice = pbe.UnitPrice;
                newOi.Quantity = 1;
                orderItemUpdate.add(newOi);
            }
        }
        if (orderItemUpdate.size() > 0) {
            try {
                if (order.Pricebook2Id == null) { // If for some reason no PriceBook Id is set on the order, set the default
                    order.Pricebook2Id = pbeList[0].Pricebook2Id;
                    update order;
                }
                upsert orderItemUpdate;
            } catch(Exception e) {
                throw e;
            }
        }
    }

    /**
     * @param orderId
     *
     * @return
     */
    public static OrderDTO updateOrderStatus(Id orderId) {
        Order order = OrderSelector.getOrderItems(orderId);
        order.Status = 'Activated';
        update order;

        return OrderController.getOrderItems(orderId);
    }
}