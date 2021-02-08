import {LightningElement, api, wire, track} from 'lwc';
import getAvailableProducts from '@salesforce/apex/OrderController.getAvailableProducts';



export default class AvailableProducts extends LightningElement {

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
        let payload = { detail : { pbeIds } }
        this.dispatchEvent(new CustomEvent('addbuttonclicked', payload));
    }
}