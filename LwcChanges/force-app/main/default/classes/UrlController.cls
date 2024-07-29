public with sharing class UrlController {
    @AuraEnabled(cacheable=true)
    public static ServiceAppointment getServiceAppointment(Id id) {
        return [SELECT Id, SalesLayout_Url__c FROM ServiceAppointment WHERE Id = :id LIMIT 1];
    }

    @AuraEnabled
    public static void updateServiceAppointment(Id id, String url) {
        ServiceAppointment sa = [SELECT Id, SalesLayout_Url__c FROM ServiceAppointment WHERE Id = :id LIMIT 1];
        sa.SalesLayout_Url__c = url;
        update sa;
    }
}