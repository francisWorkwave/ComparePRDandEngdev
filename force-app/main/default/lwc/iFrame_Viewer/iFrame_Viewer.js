import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

export default class IFrame_Viewer extends LightningElement {
    @api baseURL;
    @api recordId;
    @api param;
    @api fieldApiName;
    @api width;
    @api height;

    @track fieldArray = [];

    connectedCallback(){
        this.fieldArray = [this.fieldApiName]
    }

    @wire(getRecord, {recordId: '$recordId', optionalFields: '$fieldArray'}) record;

    get fullURL(){
        if(this.record.data){
            return this.baseURL + this.param + getFieldValue(this.record.data, this.fieldApiName);
        }else{
            return '';
        }
    }
}