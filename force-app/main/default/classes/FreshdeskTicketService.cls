/************************************************************************************************
* Name      : FreshdeskTicketService
* Purpose   : Helper class to Account Trigger
* TestClass : FreshdeskTicketServiceTest
* Author    : Bruna Girão
* Date      : 11-07-2023
--------------------------------------------------------------------------------------------------
Date                Modified By             Description
--------------------------------------------------------------------------------------------------
11-07-2023         Bruna Girão             create class 
11-07-2023         Bruna Girão             add createTicket() method
13-07-2023         Bruna Girão             deserialize response of the API and improve logic code
13-07-2023         Bruna Girão             add getTicketsByRequesterEmail() method
***************************************************************************************************/
public with sharing class FreshdeskTicketService {
    
    //Freshdesk Custom Settings
    public static FreshdeskSettings__c freshDeskSettings = FreshdeskSettings__c.getInstance('Default'); 
    
    //HTTP Request/Response Variables
    public static Http http;
    public static HttpRequest request;
    public static HttpResponse response;


    public static void createTicket(FreshdeskTicketWrapper.TicketWrapper ticketWrapper) {

        if(ticketWrapper == null) {
            return;
        }

        try {
            System.debug('SETTINGS => ' + freshDeskSettings);
            System.debug('ticketWrapper => ' + ticketWrapper);
        
            http      = new Http();
            request   = new HttpRequest();
            response  = new HttpResponse();

            request.setEndpoint('callout:FreshdeskCredential' + freshDeskSettings.TicketEndpoint__c);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(freshDeskSettings.ApiKey__c)));
            
            request.setBody(FreshdeskTicketWrapper.generateJSONFormat(ticketWrapper));
            System.debug('REQUEST ==> ' + request);
            response = http.send(request);

            if(response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                FreshdeskTicketWrapper.TicketWrapper ticket = (FreshdeskTicketWrapper.TicketWrapper) JSON.deserialize(response.getBody(), FreshdeskTicketWrapper.TicketWrapper.class);
                System.debug('Response Server Success => ' + ticket); 
            } else {
                System.debug('Response Server Error => ' + response.getBody()); 
            }
            
        } catch (Exception e) {
            System.debug('ERROR => ' + e.getMessage());
        }
    }

    public static void getTicketsByRequesterEmail(String requesterEmail) {

        if(String.isBlank(requesterEmail)) {
            return;
        }

        try {
            System.debug('SETTINGS => ' + freshDeskSettings);
            System.debug('ticketWrapper => ' + requesterEmail);
        
            http      = new Http();
            request   = new HttpRequest();
            response  = new HttpResponse();

            request.setEndpoint('callout:FreshdeskCredential' + freshDeskSettings.GetTicketsByRequesterEmailEndpoint__c + requesterEmail);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(freshDeskSettings.ApiKey__c)));
            
            System.debug('REQUEST ==> ' + request);
            response = http.send(request);

            if(response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                System.debug('response => ' + response.getBody());
                List<FreshdeskTicketWrapper.TicketWrapper> ticketsByRequester = (List<FreshdeskTicketWrapper.TicketWrapper>) JSON.deserialize(response.getBody(), List<FreshdeskTicketWrapper.TicketWrapper>.class);
                System.debug('ticketsByRequester => ' + ticketsByRequester);
                for(FreshdeskTicketWrapper.TicketWrapper ticket : ticketsByRequester) {
                    System.debug('ticket => ' + ticket);
                }
            } else {
                System.debug('Response Server Error => ' + response.getBody()); 
            }
            
        } catch (Exception e) {
            System.debug('ERROR => ' + e.getMessage());
        }
    }
}