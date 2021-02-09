/**
 * Created by Henk Walgemoed<henk.walgemoed@appsolutely.nl>
 */
@IsTest
public with sharing class CalloutServiceTest {
    /**
     * Data inserts
     */
    @TestSetup static void setup() {
        Account acc = new Account();
        List<Order> orderList = new List<Order>();
        acc.Name = 'Test Account';
        insert acc;

        List<Product2> prodList = new List<Product2>();
        for (Integer i=0;i<10;i++) {
            Product2 product = new Product2();
            product.Name = 'Material Rock-'+i;
            prodList.add(product);
        }
        insert prodList;

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        for (Product2 prod : prodList) {
            PricebookEntry pbe = new PricebookEntry();
            pbe.Product2Id = prod.Id;
            pbe.Pricebook2Id = Test.getStandardPricebookId();
            pbe.UnitPrice = 5;
            pbe.UseStandardPrice = false;
            pbe.IsActive = true;
            pbeList.add(pbe);
        }
        insert pbeList;

        Order order = new Order();
        order.AccountId = acc.Id;
        order.EffectiveDate = Date.today().addDays(-10);
        order.Status = 'Draft';
        order.Pricebook2Id = Test.getStandardPricebookId();
        insert order;

        List<OrderItem> orderItemList = new List<OrderItem>();
        for (PricebookEntry pbe : pbeList) {
            OrderItem orderItem = new OrderItem();
            orderItem.OrderId = order.Id;
            orderItem.UnitPrice = pbe.UnitPrice;
            orderItem.PricebookEntryId = pbe.Id;
            orderItem.Quantity = 2;
            orderItemList.add(orderItem);
        }
        insert orderItemList;
    }

    @IsTest
    static void testSendOrder() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;

        Test.setMock(HttpCalloutMock.class, new CalloutMock());
        Test.startTest();
        try {
            CalloutService.sendOrder(orderId);
            System.assert(true, 'No Exception is thrown');
        } catch(CustomException e) {
            System.assert(false);
        }
        Test.stopTest();



    }
}