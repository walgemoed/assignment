import {api, LightningElement} from 'lwc';

export default class OrderView extends LightningElement {

    /**
     * The order record id
     */
    @api recordId;

    handleAddProductButton(event){
        let pbeIds = event.detail['pbeIds'];
        console.log('##pbeIds: ', pbeIds);
        this.template.querySelector("c-order-details").handleAddProduct(pbeIds);
    }

}