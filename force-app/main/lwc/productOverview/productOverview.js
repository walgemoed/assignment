/**
 * Created by Henk Walgemoed<henk.walgemoed@appsolutely.nl>
 */

import {LightningElement, track} from 'lwc';
import { ToastEventController } from 'c/toastEventController';
import { getLabels } from './utils/labels';

export default class ProductOverview extends LightningElement {

    /**
     * Track state of the component to display spinner when needed
     */
    @track isLoading = true;

    /**
     * Component Labels
     */
    @track labels = {};

    async connectedCallback() {
        this.isLoading = true;
        try {
            this.labels = await getLabels();

        } catch (e) {
            new ToastEventController(this).showErrorToastMessage(this.labels.ErrorLabel, reduceErrors(e).join(', '));
        } finally {
            this.isLoading = false;
        }
    }
}