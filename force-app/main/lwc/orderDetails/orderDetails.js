
/**
 * Created by Henk Walgemoed<henk.walgemoed@appsolutely.nl>
 */

import {LightningElement, track, wire, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getOrderItems from '@salesforce/apex/OrderController.getOrderItems';
import addProducts from '@salesforce/apex/OrderController.addProducts';
import sendoutOrder from '@salesforce/apex/OrderController.activateOrder';

import Order_Products_Title from '@salesforce/label/c.Order_Products_Title';
import Sendout_Title from '@salesforce/label/c.Sendout_Title';


export default class OrderDetails extends LightningElement {

    label = {
        Order_Products_Title,
        Sendout_Title
    }
    /**
     * Current Record ID
     */
    @api recordId;

    @track isLoading = true;
    @track isDisabled = false;

    /**
     * Array of Order Items
     */
    orderItems;

    @track columns = [
        { label: 'Name', fieldName: 'productName' },
        { label: 'Unit Price', fieldName: 'unitPrice', type: 'currency', cellAttributes : {alignment: 'left'}},
        { label: 'Quantity', fieldName: 'quantity', type: 'number' },
        { label: 'Total Price', fieldName: 'totalPrice', type: 'currency', cellAttributes : {alignment: 'left'} },
    ];



    connectedCallback() {
        this.loadOrderItems();
    }

    @api
    handleAddProduct(pbeIds){
        this.addProducts(pbeIds);
    }

    addProducts(pbeIds) {
        if (this.isDisabled) {
            this.showNotification('error', 'Error', 'Order is activated, no more products can be added');
        } else {
            this.isLoading = true;
            addProducts({priceBookIdList: pbeIds, orderId: this.recordId})
                .then((result) => {

                })
                .catch((error) => {
                    console.log(error);
                })
                .finally(() => {
                    this.loadOrderItems();
                    this.showNotification('success', 'Success', 'Products are added to the order');
                    this.isLoading = false;
                })
        }
    }


    loadOrderItems() {
        this.isLoading = true;
        this.orderItems = [];
        getOrderItems({ orderId : this.recordId})
            .then((result) => {
                if (result.status === 'Activated') this.isDisabled = true;
                this.orderItems = result.orderItems;
            })
            .catch((error)=>{
                console.log(error);
            })
            .finally(()=>{
                this.isLoading = false;
            })
    }

    sendoutOrder() {
        this.isLoading = true;
        sendoutOrder({ orderId : this.recordId})
            .then((result) => {
                if (result.status === 'Activated') this.isDisabled = true;
                this.orderItems = result.orderItems;
            })
            .catch((error)=>{
                console.log(error);
            })
            .finally(()=>{
                this.showNotification('success', 'Success', 'Order has been sent to external system');
                this.isLoading = false;
            })
    }

    showNotification(variant, title, message) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}