import BasePrechat from 'lightningsnapin/basePrechat';
import { api, track } from 'lwc';
import botPreChatFormCSS from "@salesforce/resourceUrl/botPreChatFormCSS";
import { loadStyle } from "lightning/platformResourceLoader";

export default class PrechatCustom extends BasePrechat {
    @api prechatFields;
    @api backgroundImgURL;
    @api disableButton;
    @track fields;
    @track namelist;
 
    //Set the button label and prepare the prechat fields to be shown in the form.
    connectedCallback() {
        this.disableButton = true;

        if (this.prechatFields) {
            this.fields = this.prechatFields.map(field => {
                field = JSON.parse(JSON.stringify(field));
                field.type = field.type.replace('input', '');
                if(field.type == 'Select'){
                    field.combo = true;
                    field.options = field.picklistOptions;
                }else{
                    field.combo = false;
                }
                const { label, name, value, required, maxLength, type, combo, options } = field;
                return { label, name, value, required, maxLength, type, combo, options };
            });
            this.namelist = this.fields.map(field => field.name);
        }
    }
 
    //Focus on the first input after this component renders.
    renderedCallback() {
        Promise.all([
            loadStyle(this, botPreChatFormCSS),
        ]).then(() => { });
        /* if(!this.inputFocused) {
            let lightningInputElement = this.template.querySelector("lightning-combobox");
            if (lightningInputElement) {
                lightningInputElement.focus();
                this.inputFocused = true;
            };
        } */
        this.template.querySelector("lightning-combobox").focus();
    }
    
    get hasFields() {
        return this.fields && this.fields.length > 0;
    }
    
    termConditions(event) {
        this.disableButton = true;

        if (event.target.checked) {
            this.disableButton = false;    
        }
    }

    handleStartChat() {
        this.template.querySelectorAll("lightning-input").forEach(input => {
            this.fields[this.namelist.indexOf(input.name)].value = input.value;
        });
        this.template.querySelectorAll("lightning-combobox").forEach(input => {
            this.fields[this.namelist.indexOf(input.name)].value = input.value;
        });
        if (this.validateFields(this.fields).valid) {
            this.startChat(this.fields);
        } else {
            // Error handling if fields do not pass validation.
        }
    }
 
    checkInputValidity(inputElements) {
        const allValid = [...inputElements].reduce(
            (validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        return allValid;
    }
}