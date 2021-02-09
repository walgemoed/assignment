import {LightningElement, api, wire, track} from 'lwc';
import getAvailableProducts from '@salesforce/apex/OrderController.getAvailableProducts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import Product_Title from '@salesforce/label/c.Products_Title';
import Add_Products_Title from '@salesforce/label/c.Add_Products_Title';

export default class AvailableProducts extends LightningElement {

    label = {
        Product_Title,
        Add_Products_Title
    }

    @track columns = [
        {label: 'Name', fieldName: 'Name'},
        {label: 'unit Price', fieldName: 'UnitPrice', type: 'currency'}
    ];

    @track isLoading = true;
    @api recordId;
    productData = [];
    @api isDisabled = false;

    connectedCallback() {
        this.loadProducts();
    }

    loadProducts() {
        this.isLoading = true;
        getAvailableProducts({ orderId : this.recordId})
            .then((result) => {
                this.productData = result;
            })
            .catch((error)=>{
                console.log(error);
            })
            .finally(()=>{
                this.isLoading = false;
            })
    }

    addProducts() {
        const productList = this.template.querySelector("[data-identifier='prodId']");
        let selectedRows = productList.getSelectedRows();

        let pbeIds = selectedRows.map((element) =>{ return element['Id'] });
        if (pbeIds.length === 0) {
            this.showNotification('error', 'Error', 'No products selected');
        } else {
            let payload = {detail: {pbeIds}}
            this.dispatchEvent(new CustomEvent('addbuttonclicked', payload));
        }
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