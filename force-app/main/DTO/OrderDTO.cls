public with sharing class OrderDTO {

    @AuraEnabled
    public Id orderId  {get; set;}

    @AuraEnabled
    public Id accountId  {get; set;}

    @AuraEnabled
    public Id Pricebook2Id  {get; set;}

    @AuraEnabled
    public List<OrderItemDTO> orderItems {get;set;}

    public OrderDTO(Order order) {
        this.orderId = order.Id;
        this.accountId = order.AccountId;
        this.Pricebook2Id = order.Pricebook2Id;

        List<OrderItemDTO> oiDTOList = new List<OrderItemDTO>();
        for (OrderItem oi : order.OrderItems) {
            OrderItemDTO oiDTO = new OrderItemDTO(oi);
            oiDTOList.add(oiDTO);
        }
        this.orderItems = oiDTOList;
    }
}