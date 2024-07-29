/* Author : Richa
Description : Service Appointment PDF Generation
Initial Draft : Richa 
                12th Jan 2023
*/
public with sharing class ServiceAppointmentPhotoPDFClass
{
    public string ServAppntId {get;set;}
    public List<Service_Appointment_Checklist_Item__c> AppntChecklist {get;set;}
    public ServiceAppointment servAppt {get;set;}
    public List<AssignedResource> assResList {get;set;}
    public MAP<String , List<Service_Appointment_Checklist_Item__c>> lableSummaryMap {get;set;}
    public Set<String> keyValues {get;set;}
    public List<String> projectNames {get;set;}
    
    public ServiceAppointmentPhotoPDFClass() 
    {
        AppntChecklist = new List<Service_Appointment_Checklist_Item__c> ();
        assResList = new List<AssignedResource>();
        lableSummaryMap = new MAP<String , List<Service_Appointment_Checklist_Item__c>>();
        keyValues = new Set<String>();
        projectNames = new List<String>();
        
        if(ServAppntId == null)
        {
            ServAppntId = ApexPages.currentPage().getParameters().get('id');
        }
        if(ServAppntId != null)
        {
            servAppt = [SELECT Id, Opportunity_Type__c,AccountId, Description, Subject, Opportunity__c, Opportunity__r.Name FROM ServiceAppointment Where Id = : ServAppntId];
            
            AppntChecklist = [Select id,Export_to_PDF__c,PDF_Section_Label__c,Section_Label__c,Service_Appointment__c,Notes__c,Summary__c from Service_Appointment_Checklist_Item__c Where Service_Appointment__c =: ServAppntId order by Sort_Order__c asc];
            
            List<Service_Appointment_Checklist_Item__c> temp;
            
            for(Service_Appointment_Checklist_Item__c sac : AppntChecklist)
            {
                if(sac.Notes__c != '' && sac.Notes__c != null)
                {
                    if(lableSummaryMap.containsKey(sac.Section_Label__c))
                        temp = lableSummaryMap.get(sac.Section_Label__c);
                    else
                        temp = new List<Service_Appointment_Checklist_Item__c>();
                    temp.add(sac);
                    lableSummaryMap.put(sac.Section_Label__c, temp); 
                }
            }
            system.debug('lableSummaryMap::::::'+lableSummaryMap);
            keyValues = lableSummaryMap.keySet();
            system.debug('keyValues :::'+keyValues );
            
            assResList = [Select Id, ServiceAppointmentId, ServiceResourceId,ServiceResource.Name FROM AssignedResource where ServiceAppointmentId = : ServAppntId];
            
            for(Project__c p : [Select Id, Name, Record_Type_Hidden__c from Project__c where Opportunity__c = :servAppt.Opportunity__c])
                projectNames.add(p.Record_Type_Hidden__c+': '+p.Name);
        }
        
    }
}