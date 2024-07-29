import { LightningElement, api, track } from 'lwc';

export default class UpdateUrl extends LightningElement {
    @track isModalOpen = true; // Set to true to open the modal automatically
    @api recordId;

    connectedCallback() {
        console.log('updateUrl component loaded with recordId:', this.recordId);
        // No need to explicitly call openModal() here since isModalOpen is already set to true
    }

    // Method to close the modal
    closeModal() {
        this.isModalOpen = false;
    }

    // Handle the custom event from salesLayout component
    handleClose() {
        this.closeModal();
    }
}
