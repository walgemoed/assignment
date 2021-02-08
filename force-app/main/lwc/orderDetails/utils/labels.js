/**
 * Labels For Order Detail LWC
 * @author            : Henk Walgemoed
 * @lastModifiedDate  : 08-02-2021
 **/
import OrderItem_Product_Name from '@salesforce/label/c.OrderItem_Product_Name';
import OrderItem_Unit_Price from '@salesforce/label/c.OrderItem_Unit_Price';
import OrderItem_Quantity from '@salesforce/label/c.OrderItem_Quantity';
import OrderItem_Total_Price from '@salesforce/label/c.OrderItem_Total_Price';

async function getLabels() {
    return {
        OrderItem_Product_Name,
        OrderItem_Unit_Price,
        OrderItem_Quantity,
        OrderItem_Total_Price
    };
}

export { getLabels };