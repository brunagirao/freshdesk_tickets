import { LightningElement, wire }   from 'lwc';

//UI OBJECTS INFO
import { getPicklistValues }        from 'lightning/uiObjectInfoApi';
import { getObjectInfo }            from 'lightning/uiObjectInfoApi';

//OBJECTS
import TICKET_OBJECT                from '@salesforce/schema/fr_Ticket__c'

//FIELDS
import PRIORITY_FIELD               from '@salesforce/schema/fr_Ticket__c.Priority__c'
import STATUS_FIELD                 from '@salesforce/schema/fr_Ticket__c.Status__c'


export default class CreateTicket extends LightningElement {

    //WIRES SECTION
    @wire(getObjectInfo, 
        {
            objectApiName: TICKET_OBJECT
        }
    )
    ticketInfo;

    @wire(getPicklistValues, 
        {
            recordTypeId: '$ticketInfo.data.defaultRecordTypeId',
            fieldApiName: PRIORITY_FIELD
        }
    )
    priorityPicklist;

    @wire(getPicklistValues,
        {
            recordTypeId: '$ticketInfo.data.defaultRecordTypeId',
            fieldApiName: STATUS_FIELD
        }

    )
    statusPicklist;

}