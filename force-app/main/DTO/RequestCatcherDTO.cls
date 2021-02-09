/**
 * Created by Henk Walgemoed<henk.walgemoed@appsolutely.nl>
 */
public with sharing class RequestCatcherDTO {
    public String accountNumber;

    public String orderNumber;
    public String type;
    public String status;
    public List<OrderProductClass> orderProducts;

    public class OrderProductClass {
        public String name;
        public String code;
        public Decimal unitPrice;
        public Decimal quantity;
    }
}