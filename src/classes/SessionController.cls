/*
* Copyright (c) 2018, salesforce.com, inc.
* All rights reserved.
* SPDX-License-Identifier: BSD-3-Clause
* For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
*/
public with sharing class SessionController {
	
/**
@Author: Alan
@Description: Method that retrieves the user session Id to be used in the component EventToLighting
*/
    @AuraEnabled
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }
/**
@Description: This method creates a unique key that will be used to pair the chatbot with the current UI
*/    
    @AuraEnabled 
    public static String createSession(){
        // Creating a SHA to hide the email information
        String emailSHA = EncodingUtil.base64Encode(Crypto.generateDigest('SHA1',Blob.valueOf(UserInfo.getUserEmail())));
        // Email SHA + the current time in miliseconds
        String sessionKey =  emailSHA + DateTime.now().getTime();
        Schema.DescribeSObjectResult describeResult = Robot_Session__c.sObjectType.getDescribe();
        Boolean isCreateable = describeResult.isCreateable();
    	if(isCreateable){
            // Inserts new Robot session record
            insert new Robot_Session__c(Email__c = UserInfo.getUserEmail(),Session_Key__c = sessionKey);
            //Return Key to the UI
            return sessionKey;
        }
        return '';
    }
}