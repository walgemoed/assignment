
/**
 * Created by Henk Walgemoed<henk.walgemoed@appsolutely.nl>
 */

import {LightningElement, track, wire, api} from 'lwc';

import getOrderItems from '@salesforce/apex/OrderController.getOrderItems';
import addProducts from '@salesforce/apex/OrderController.addProducts';

export default class OrderDetails extends LightningElement {

    /**
     * Current Record ID
     */
    @api recordId;

    @track isLoading = true;

    @track columns = [
        { label: 'Name', fieldName: 'productName' },
        { label: 'Unit Price', fieldName: 'unitPrice', type: 'currency', cellAttributes : {alignment: 'left'}},
        { label: 'Quantity', fieldName: 'quantity', type: 'number' },
        { label: 'Total Price', fieldName: 'totalPrice', type: 'currency', cellAttributes : {alignment: 'left'} },
    ];

    /**
     * Array of Order Items
     */
    orderItems;

    connectedCallback() {
        this.loadOrderItems();
    }

    @api
    handleAddProduct(pbeIds){
        this.addProducts(pbeIds);
    }

    addProducts(pbeIds) {
        this.isLoading = true;

        addProducts({ priceBookIdList : pbeIds, orderId : this.recordId})
            .then((result) => {

            })
            .catch((error)=>{
                console.log(error);
            })
            .finally(()=>{
                this.loadOrderItems();
                this.isLoading = false;
            })
    }


    loadOrderItems() {
        this.isLoading = true;
        this.orderItems = [];
        getOrderItems({ orderId : this.recordId})
            .then((result) => {
                this.orderItems = result.orderItems;
            })
            .catch((error)=>{
                console.log(error);
            })
            .finally(()=>{
                this.isLoading = false;
            })
    }

}