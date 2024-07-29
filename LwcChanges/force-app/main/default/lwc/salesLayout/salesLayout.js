import { refreshApex } from '@salesforce/apex';
import getServiceAppointment from '@salesforce/apex/UrlController.getServiceAppointment';
import updateServiceAppointment from '@salesforce/apex/UrlController.updateServiceAppointment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { LightningElement, api, track, wire } from 'lwc';

export default class SalesLayout extends LightningElement {
    @api recordId;
    @track url = '';
    @track errorMessage = '';
    wiredServiceAppointmentResult;

    @wire(getServiceAppointment, { id: '$recordId' })
    wiredServiceAppointment(result) {
        this.wiredServiceAppointmentResult = result;
        const { error, data } = result;
        if (data) {
            if (data.SalesLayout_Url__c !== null && data.SalesLayout_Url__c !== undefined) {
                this.url = data.SalesLayout_Url__c;
            } else {
                this.url = ''; // Ensure the URL field is empty
                this.errorMessage = 'The URL field is empty.'; // Log but don't display
                console.warn(this.errorMessage);
            }
        } else if (error) {
            this.errorMessage = 'An error occurred while retrieving the Service Appointment'; // Log but don't display
            console.error(this.errorMessage, error);
        }
    }

    connectedCallback() {
        refreshApex(this.wiredServiceAppointmentResult);
    }

    handleUrlChange(event) {
        this.url = event.target.value;
    }

    handleSave() {
        updateServiceAppointment({ id: this.recordId, url: this.url })
            .then(() => {
                console.log('Service Appointment updated successfully');
                // Refresh the data to ensure the latest value is displayed
                return refreshApex(this.wiredServiceAppointmentResult);
            })
            .then(() => {
                // Show a success toast message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Service Appointment updated successfully',
                        variant: 'success',
                    })
                );
                // Dispatch a custom event to notify the parent component to close the modal
                this.dispatchEvent(new CustomEvent('closemodal'));
            })
            .catch(error => {
                this.errorMessage = 'An error occurred while updating the Service Appointment'; // Log but don't display
                console.error(this.errorMessage, error);
                // Show an error toast message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: this.errorMessage,
                        variant: 'error',
                    })
                );
            });
    }
}
