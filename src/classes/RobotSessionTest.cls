/*
* Copyright (c) 2018, salesforce.com, inc.
* All rights reserved.
* SPDX-License-Identifier: BSD-3-Clause
* For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
*/
@isTest
public with sharing class RobotSessionTest {
	@isTest
	private static void testGetSessionKey(){
		
		insert new Robot_Session__c(Email__c = 'Test@salesforce.com',Session_Key__c='testSessionKey');
		
		Test.StartTest();
		String sessionKey = RobotSession.getSessionKey(new List<String>{'Test@salesforce.com'})[0];
		Test.StopTest();
		System.assertEquals(sessionKey,'testSessionKey', 'Session key found');
	
	}
	@isTest
	private static void testGetNoSessionKey(){
		insert new Robot_Session__c(Email__c = 'Test@salesforce.com',Session_Key__c='testSessionKey');
		
		Test.StartTest();
		List<String> sessionKey = RobotSession.getSessionKey(new List<String>{'WrongTest@salesforce.com'});
		Test.StopTest();
		System.assertEquals(sessionKey,null, 'Session key not found');
			
	}
    
}