/**
 * @author Henk Walgemoed<henk.walgemoed@appsolutely.nl>
 */
public with sharing class OrderSelector {

    /**
     * @description Retrieve the order including the order items
     * @param orderId ID of the current Order
     *
     * @return Order
     */
    public static Order getOrderItems(String orderId) {
        List<Order> orderList = [SELECT Id,
                                    AccountId,
                                    Account.AccountNumber,
                                    OrderNumber,
                                    Type,
                                    Pricebook2Id,
                                    Status,
                                    (SELECT Id,
                                    Product2Id,
                                    Product2.Name,
                                    Product2.ProductCode,
                                    Quantity,
                                    UnitPrice,
                                    TotalPrice,
                                    PricebookEntryId
                                    FROM OrderItems
                                    ORDER BY CreatedDate
                                    )
                                    FROM Order
                                    WHERE Id =: orderId
                                    ORDER BY CreatedDate];
        if (orderList.size() == 1) {
            return orderList[0];
        } else {
            throw new CustomException('Error, invalid id');
        }
    }

    /**
     * @description Return the Id of the PriceBookId of the order
     * @param orderId Id of the current Order
     *
     * @return Id of the PriceBook used on the order
     */
    public static Id getPriceBookIdFromOrder(Id orderId) {
        return [SELECT Id, Pricebook2Id FROM Order WHERE Id = :orderId].Pricebook2Id;
    }
}