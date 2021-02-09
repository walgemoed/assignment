/**
 * @author Henk Walgemoed<henk.walgemoed@appsolutely.nl>
 */
@IsTest
public with sharing class OrderControllerTest {

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
    static void testGetOrderItemsWithValidIdNoOrderItems() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;

        Test.startTest();
        OrderDTO order = OrderController.getOrderItems(orderId);
        Test.stopTest();

        System.assertEquals(order.orderItems.size(), 10, '10 OrderItems on the order');
    }

    @IsTest
    static void testGetOrderItemsWithInValidId() {
        Test.startTest();
        try {
            OrderDTO order = OrderController.getOrderItems(null);
        } catch(Exception e) {
            System.assertEquals(true, e.getMessage().contains('invalid id'), 'Invalid ID Exception');
        }
        Test.stopTest();
    }

    @IsTest
    static void testGetAvailableProducts() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;

        Test.startTest();
        List<PricebookEntry> pbeList = OrderController.getAvailableProducts(orderId);
        Test.stopTest();

        System.assertEquals(pbeList.size(), 10, '10 PriceBookEntries found');
    }

    @IsTest
    static void testGetAvailableProductsNoValidId() {
        Test.startTest();
        try {
            List<PricebookEntry> pbeList = OrderController.getAvailableProducts(null);
            System.assert(false);
        } catch(Exception e) {
            System.assert(true, 'No OrderId Found');
        }
        Test.stopTest();
    }

    @IsTest
    static void testAddProducts() {
        Order oldOrder = [SELECT Id, AccountId, Pricebook2Id FROM Order LIMIT 1];
        Order order = new Order();
        order.AccountId = oldOrder.AccountId;
        order.EffectiveDate = Date.today().addDays(-10);
        order.Status = 'Draft';
        order.Pricebook2Id = oldOrder.Pricebook2Id;
        insert order;

        OrderDTO odto = OrderController.getOrderItems(order.Id);
        List<PricebookEntry> pbeList = [SELECT Id FROM PricebookEntry WHERE IsActive = TRUE AND Pricebook2Id =: oldOrder.Pricebook2Id];
        List<Id> pbeIdList = new List<Id>();
        for (PricebookEntry pbe : pbeList) {
            pbeIdList.add(pbe.Id);
        }

        Test.startTest();
        System.assertEquals(odto.orderItems.size(), 0, 'No OrderItems');
        OrderController.addProducts(pbeIdList, order.Id);
        odto = OrderController.getOrderItems(order.Id);
        System.assertEquals(odto.orderItems.size(), 10, '10 OrderItems');
        OrderController.addProducts(pbeIdList, order.Id);
        System.assertEquals(odto.orderItems.size(), 10, '10 OrderItems');
        Test.stopTest();


    }

    @IsTest
    static void testAddProductsException() {
        Test.startTest();
        try {
            OrderController.addProducts(null, null);
            System.assert(false);
        } catch(Exception e) {
            System.assert(true);
        }

        Test.stopTest();
    }

    @IsTest
    static void testActivateOrder() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;

        Test.setMock(HttpCalloutMock.class, new CalloutMock());
        Test.startTest();
        try {
            OrderController.activateOrder(orderId);

            Order order = OrderSelector.getOrderItems(orderId);
            System.assertEquals('Activated', order.Status, 'Status is set to Activated');
        } catch(CustomException e) {
            System.assert(false);
        }
        Test.stopTest();
    }
}