import {api, LightningElement} from 'lwc';

export default class OrderView extends LightningElement {

    /**
     * The order record id
     */
    @api recordId;

    handleAddProductEvent(event){
        let pbeIds = event.detail['pbeIds'];
        this.template.querySelector("c-order-details").handleAddProduct(pbeIds);
    }

}