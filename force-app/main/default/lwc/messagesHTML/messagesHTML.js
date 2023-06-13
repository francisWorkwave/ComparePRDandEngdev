import { LightningElement, api, wire } from 'lwc';
import getHTML from '@salesforce/apex/MessagesHTMLController.getHTML';

export default class MessagesHTML extends LightningElement {
    @api recordId;
    @api emailTemplateName;
    htmlValue;

    connectedCallback() {
        getHTML({ recordId: this.recordId, emailTemplateName: this.emailTemplateName})
        .then(result => {
            this.htmlValue = result;
            this.attachmentPoint = this.template.querySelector('div[ishtmlcontainer=true]');
            this.attachmentPoint.innerHTML = this.htmlValue;
        })
        .catch(error => {
            console.log(error);
        });
    }
}