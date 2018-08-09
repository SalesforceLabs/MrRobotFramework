/*
* Copyright (c) 2018, salesforce.com, inc.
* All rights reserved.
* SPDX-License-Identifier: BSD-3-Clause
* For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
*/
public with sharing class RobotCompController {
 /**
@Description: Method that retrieves the user session Id to be used in the component EventToLighting
*/
    @AuraEnabled
    public static String getMessage(String label) {
    	List<Robot_Topic__mdt> topics = [Select Value__c from Robot_Topic__mdt where Type__c ='Message' and DeveloperName=:label limit 1];
       	if(!topics.IsEmpty()){
       		return topics[0].Value__c;
       	}else{
       		return '';
       	}
    } 
 /**
  * @Description: Returns the object name that is mapped to an Action i.e. Account_Context = Account
*/
    @AuraEnabled
     public static String getObjectName(String objectName) {
     List<Robot_Topic__mdt > objConfigs = [Select Object_Name__c from Robot_Topic__mdt  where  DeveloperName=:objectName limit 1];
         if(!objConfigs.IsEmpty()){
             return objConfigs[0].Object_Name__c.replaceAll( '\\s+', '');
         }
         // if not found just return empty string
         return '';
     }
/**
*@Description: Method that retrieves a list of fields and labels
*/
    @AuraEnabled
    public static String getFieldInfo(String objectName) {
    	List<RobotTableParameter__mdt> params = [Select Fields__c from RobotTableParameter__mdt where  DeveloperName=:objectName limit 1];
       	JSONGenerator jgen = JSON.createGenerator(false);
       	
       	if(!params.IsEmpty()){
            String sParams = params[0].Fields__c.replaceAll( '\\s+', ''); // remove all whitespaces
       		List<Schema.DescribeSObjectResult> descResult = Schema.describeSObjects(new List<String>{objectName});
       		if(!descResult.IsEmpty() && descResult[0].isAccessible()){
       		   
       		   Map <String, Schema.SObjectField> fieldMap = descResult[0].fields.getMap();
       		   List<String> requestedFields = sParams.split(',');
               requestedFields = checkAccess(objectName, requestedFields);
       		   jgen.writeStartArray();
       		   for(String sfield : requestedFields){
       		   	if(fieldMap.containsKey(sfield)){
	       		   	Schema.DescribeFieldResult descField = fieldMap.get(sfield).getDescribe();
	       		   	/* Writting Column config i.e. { label: 'Contact Name', fieldName: 'Name', type: 'text'} */
					jgen.writeStartObject();
					jgen.writeStringField('label', descField.getLabel());
					jgen.writeStringField('fieldName',descField.getName());
					/* Mapping Type */
					jgen.writeStringField('type',
					descField.getType() == Schema.DisplayType.Date ? 'date-local':
					descField.getType() == Schema.DisplayType.DateTime ? 'date':
					descField.getType() == Schema.DisplayType.Boolean ? 'boolean':
					descField.getType() == Schema.DisplayType.Currency ? 'currency':
					descField.getType() == Schema.DisplayType.Double ? 'number':
					descField.getType() == Schema.DisplayType.Integer ? 'number':
					descField.getType() == Schema.DisplayType.Percent ? 'percent':
					descField.getType() == Schema.DisplayType.Phone ? 'phone':
					descField.getType() == Schema.DisplayType.URL ? 'url':
					descField.getType() == Schema.DisplayType.Email ? 'email': 'text'
					);
					/* End Mapping Type */
					jgen.writeEndObject();
       		   	}
       		   }
       		   	jgen.writeEndArray();
       		}
       		
       	}
		jgen.close();
		return jgen.getAsString();
    } 

/**
@Description: Method that retrieves a list of sObject records
*/
    @AuraEnabled
    public static List<sObject> getRecords(String objectName, String searchKey) {
    	List<RobotTableParameter__mdt> params = [Select Fields__c from RobotTableParameter__mdt where  DeveloperName=:objectName limit 1];
        String sFields = '';
        if(!params.IsEmpty()){
            String sParams = params[0].Fields__c.replaceAll( '\\s+', ''); // remove all whitespaces
       		List<Schema.DescribeSObjectResult> descResult = Schema.describeSObjects(new List<String>{objectName});
       		if(!descResult.IsEmpty() && descResult[0].isAccessible()){
       		   Map <String, Schema.SObjectField> fieldMap = descResult[0].fields.getMap();
       		   List<String> requestedFields = sParams.split(',');
               requestedFields = checkAccess(objectName, requestedFields);
                /* Use valid fields only on the query construction*/
                for(Integer i = 0; i < requestedFields.size(); i++){// String sfield : requestedFields){
                   if(fieldMap.containsKey(requestedFields.get(i))){
                       sFields+= i == requestedFields.size()-1 ? requestedFields.get(i) : requestedFields.get(i) +',';
                   }
               }
                if (String.IsBlank(sFields)){
                    sFields = 'id';
                }
                /* If a searching criteria was provided */
                if(String.isNotBlank(searchKey)){
                    
                 	/* Using SOSL to find a record that matches a dynamic key*/
                    String searchquery= 'FIND {' + String.escapeSingleQuotes(searchKey).trim() + '*}'+
                      				  ' IN ALL FIELDS RETURNING ' + objectName + ' (' + sFields + ' ORDER BY LastModifiedDate) Limit 10';
                 	List<List<SObject>> searchList = search.query(searchquery);
                    If(!searchList.isEmpty()){
                        //If not empty we should only get one sObject type back
                        return searchList[0];
                    }
                /* If not searching criteria just execute SOQL*/                                 
                }else{
                    return Database.query('Select ' +sFields+' from ' + objectName + ' order by LastModifiedDate desc limit 10'); 
                }
        	}
            
    	}
        // If invalid object or fields just return null
		return null;
	}
     /**
    @Description: Returns the configured Amount field name
    */
    @AuraEnabled
    public static String getAmountFieldName(String objectName) {
    	List<RobotTableParameter__mdt> params = [Select ChartAmountCol__c from RobotTableParameter__mdt where
                                                 DeveloperName=:objectName and RefreshChart__c = true limit 1]; 
        if(!params.IsEmpty()){
            return params[0].ChartAmountCol__c;
        }
        return null;
    }
/**
@Description: Method that retrieves information for render the chart
*/
    @AuraEnabled
    public static List<sObject> getChartRecords(String objectName, String searchKey) {
    	List<RobotTableParameter__mdt> params = [Select ChartAmountCol__c from RobotTableParameter__mdt where
                                                 DeveloperName=:objectName and RefreshChart__c = true limit 1];
        String sFields = '';
        if(!params.IsEmpty()){
            String sParams = params[0].ChartAmountCol__c.replaceAll( '\\s+', ''); // remove all whitespaces
       		List<Schema.DescribeSObjectResult> descResult = Schema.describeSObjects(new List<String>{objectName});
       		if(!descResult.IsEmpty() && descResult[0].isAccessible()){
       		   Map <String, Schema.SObjectField> fieldMap = descResult[0].fields.getMap();
       		   List<String> requestedFields = sParams.split(',');
               requestedFields = checkAccess(objectName, requestedFields);
                /* Use valid fields only on the query construction*/
               if(fieldMap.containsKey(requestedFields.get(0))){
                   sFields = 'Name, ' + requestedFields.get(0);
                   /* If a searching criteria was provided */
                   if(String.isNotBlank(searchKey)){
                       
                       /* Using SOSL to find a record that matches a dynamic key*/
                       String searchquery= 'FIND {' + String.escapeSingleQuotes(searchKey).trim() + '*}'+
                           ' IN ALL FIELDS RETURNING ' + objectName + ' (' + sFields + ' ORDER BY LastModifiedDate) Limit 10';
                       List<List<SObject>> searchList = search.query(searchquery);
                       If(!searchList.isEmpty()){
                           //If not empty we should only get one sObject type back
                           return searchList[0];
                       }
                       /* If not searching criteria just execute SOQL*/                                 
                   }else{
                       return Database.query('Select ' +sFields+' from ' + objectName + ' order by LastModifiedDate desc limit 10'); 
                   }          
               }

        	}
            
    	}
        // If invalid object or fields just return null
		return null;
	}
    
    // function to check for CRUD access  
    // ***** WIP ***********
    public static List<String> checkAccess(String objectName, List<String> requestedFields) {
      //String selectedObject = 'Opportunity';
      //List<String> requestedFields = new list<String>{'Name', 'ExpectedRevenue' , 'Probability', 'StageName'};
      Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
	  Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap();
	  List<String> validFields = new List<String>();

	  for(Schema.SObjectField sfield : fieldMap.Values()) {
    	Schema.describefieldresult dfield = sfield.getDescribe();

    	if(requestedFields.contains(dfield.getname())){

       		for(String requestedField : requestedFields) {
          		if(requestedField == dfield.getname() && dfield.isAccessible()) {
            		validFields.add(dfield.getname());
          		}
      		}
    	}
      }
       return validFields;
    }
    
}