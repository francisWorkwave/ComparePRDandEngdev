import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ConditionallyToastAlert extends LightningElement {
    @api toastTitle;
    @api toastMessage;
    @api toastVariant;
    @api toastMode;

    connectedCallback() {
        const toastEvent = new ShowToastEvent({
            title:  this.toastTitle,
            message: this.toastMessage,
            variant: this.toastVariant,
            mode: this.toastMode
        });
        this.dispatchEvent(toastEvent);
    }

}