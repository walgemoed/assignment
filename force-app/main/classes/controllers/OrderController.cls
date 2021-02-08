/**
 * @author Henk Walgemoed<henk.walgemoed@appsolutely.nl>
 * @date 08-02-2021
 */
public inherited sharing class OrderController {

    /**
     * @description Used in the OrderDetails LWC to retrieve all the products available on the order
     * @param orderId Id of the current Order on the record page
     *
     * @return List<OrderItem>
     */
    @AuraEnabled
    public static OrderDTO getOrderItems(String orderId) {
        try {
            Order order = OrderSelector.getOrderItems(orderId);
            return new OrderDTO(order);
        }
        catch(Exception e){
            throw e;
        }
    }

    /**
     * @description Get all products with the same PriceBook ID as this order
     * @param orderId If of the current Order
     *
     * @return List<PriceBookEntry>
     */
    @AuraEnabled(Cacheable=true)
    public static List<PricebookEntry> getAvailableProducts(Id orderId){
        try {
            return ProductSelector.getAvailableProducts(orderId);
        }
        catch(Exception e){
            throw e;
        }
    }

    /**
     * @description This will add the products as order items to the order. If they are already present, the quantity
     *              will be upped by 1
     * @param priceBookIdList List of Id's of PriceBookEntries that will be added to the order
     * @param orderId Id of the current Order
     */
    @AuraEnabled
    public static void addProducts(List<String> priceBookIdList, String orderId) {
        try {
            OrderService.addProductToOrder(priceBookIdList, orderId);
        } catch(Exception e) {
            throw e;
        }
    }
}