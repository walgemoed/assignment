public with sharing class OrderItemDTO {

    @AuraEnabled
    public Id Id  {get; set;}

    @AuraEnabled
    public String productName {get; set;}

    @AuraEnabled
    public Decimal unitPrice {get; set;}

    @AuraEnabled
    public Decimal quantity {get; set;}

    @AuraEnabled
    public Decimal totalPrice {get; set;}

    public OrderItemDTO(OrderItem oi) {
        this.Id = oi.Id;
        this.productName = oi.Product2.Name;
        this.unitPrice = oi.UnitPrice;
        this.quantity = oi.Quantity;
        this.totalPrice = oi.TotalPrice;
    }
}