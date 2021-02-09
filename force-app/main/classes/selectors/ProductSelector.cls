/**
 * @author Henk Walgemoed<henk.walgemoed@appsolutely.nl>
 */
public with sharing class ProductSelector {

    /**
     * @description Check the pricebookId of the current order, then retrieve all pricebookentries with the same id
     * @param orderId order Id of the current Order
     *
     * @return List<PricebookEntry>
     */
    public static List<PricebookEntry> getAvailableProducts(Id orderId) {
        if (String.isEmpty(orderId)) {
            throw new CustomException('No orderId');
        }
        Id pricebookId = OrderSelector.getPriceBookIdFromOrder(orderId);
        if (pricebookId == null) {
            pricebookId = [SELECT Id FROM Pricebook2 WHERE IsActive = TRUE AND IsStandard = TRUE].Id;
        }
        List<PricebookEntry> pricebookEntries = [
                SELECT Id,
                        Name,
                        UnitPrice,
                        Product2Id,
                        Pricebook2Id
                FROM PricebookEntry
                WHERE IsActive = TRUE
                    AND
                    Pricebook2Id = :pricebookId
        ];
        return pricebookEntries;
    }

    /**
     * @description Get details of the Pricebookentries
     * @param pbeIdList List with Id of pricebook entries
     *
     * @return List<PricebookEntry>
     */
    public static List<PricebookEntry> getPricebookEntries(List<Id> pbeIdList) {
        List<PricebookEntry> pricebookEntries = [
                SELECT Id,
                        Name,
                        UnitPrice,
                        Product2Id,
                        Pricebook2Id
                FROM PricebookEntry
                WHERE IsActive = TRUE
                AND
                Id IN :pbeIdList
        ];
        return pricebookEntries;
    }
}