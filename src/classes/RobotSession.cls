/*
* Copyright (c) 2018, salesforce.com, inc.
* All rights reserved.
* SPDX-License-Identifier: BSD-3-Clause
* For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
*/
global with sharing class RobotSession {
	
    @InvocableMethod(label='Get SessionKey' description='Returns the latest generated session key of the provided email')
	global static List<String> getSessionKey(List<String> emails) {
		List<Robot_Session__c> rSessions = [select Session_Key__c from Robot_Session__c 
							  	where Email__c = : emails[0] and isPaired__c = false order by name desc limit 1 ];
		
		if(!rSessions.IsEmpty()){
			Robot_Session__c s = rSessions[0];
			s.isPaired__c = true;
			update s;
			return new List<String>{s.Session_Key__c};
		}
		
		return null;
	}
	
}