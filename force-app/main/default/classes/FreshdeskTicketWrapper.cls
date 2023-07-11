/************************************************************************************************
* Name      : FreshdeskTicketWrapper
* Purpose   : Wrapper class to FreshdeskTicketService
* TestClass : FreshdeskTicketServiceTest
* Author    : Bruna Girão
* Date      : 11-07-2023
--------------------------------------------------------------------------------------------------
Date                Modified By             Description
--------------------------------------------------------------------------------------------------
11-07-2023         Bruna Girão             create class 
***************************************************************************************************/

public class FreshdeskTicketWrapper {

    
    public class TicketWrapper {

        public Integer priority;
        public Integer source;	
        public Integer status;	

        public String subject;	
        public String type;	
        public String textDescription;	
        public String htmlDescription;
        
        public Boolean urgent;
        public List<Blob> attachments;
        public List<String> ccEmails;

        public RequesterWrapper requester;

        public TicketWrapper() {}
    }
	
    //Requester Info
    public class RequesterWrapper {
        public Integer id;	
        public String name;
        public String email;
        public String phone;

        public RequesterWrapper() {}
    }

	public static FreshdeskTicketWrapper parse(String json){
		return (FreshdeskTicketWrapper) System.JSON.deserialize(json, FreshdeskTicketWrapper.class);
	}

    public static String generateJSONFormat(FreshdeskTicketWrapper.TicketWrapper wrapper) {
        JSONGenerator jsGen = JSON.createGenerator(true);
        jsGen.writeStartObject();   


        //jsGen.writeNumberField('requester_id',      wrapper.requester.id);
        //jsGen.writeStringField('name',              wrapper.requester.name);
        jsGen.writeStringField('email',             wrapper.requester.email);
        // jsGen.writeStringField('phone',             wrapper.requester.phone);
        jsGen.writeNumberField('source',            wrapper.source);
        jsGen.writeNumberField('status',            wrapper.status);
        jsGen.writeNumberField('priority',            wrapper.priority);
        jsGen.writeStringField('subject',           wrapper.subject);
        //jsGen.writeStringField('type',              wrapper.type);
        jsGen.writeStringField('description',       wrapper.textDescription);
        //jsGen.writeStringField('description_html',  wrapper.htmlDescription);

        jsGen.writeEndObject();
        String jsonData = jsGen.getAsString();
         
        System.debug('json format Data==> ' + jsonData);

        return jsonData;
    }

}