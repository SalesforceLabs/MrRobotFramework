/*
* Copyright (c) 2018, salesforce.com, inc.
* All rights reserved.
* SPDX-License-Identifier: BSD-3-Clause
* For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
*/
@isTest
public with sharing class RobotCompControllerTest {
	
	private static String accName = 'RobotAccount';
	
	@testSetUp
	private static void createTestData(){
		List<Account> accounts = new List<Account>();
		
		for(integer i = 0; i<10 ; i++){
			accounts.add(new account(Name=accName + i,
				AnnualRevenue = 100 + i
			));
		}
		insert accounts;
		System.assertEquals(accounts.size(),10,'10 accounts have been inserted');
	}
	
	@isTest
	private static void testGetMessage(){
		Test.StartTest();
		String sMessage = RobotCompController.getMessage('Account_Context');
		Test.StopTest();
		System.assert(String.isNotBlank(sMessage),'The message should be the one defined in the metadata type');
	}
	
  	@isTest
	private static void testGetNoMessage(){
		Test.StartTest();
		String sMessage = RobotCompController.getMessage('Account_Context_Wrong' + DateTime.Now());
		Test.StopTest();
		System.assert(String.isBlank(sMessage),'No Message has beed defined for this action');
	}  
	
	@isTest
	private static void testGetObjName(){
		Test.StartTest();
		String objName = RobotCompController.getObjectName('Account_Context');
		Test.StopTest();
		System.assertEquals(objName,'Account','Object defined in metadataType is Account');
	}
	@isTest
	private static void testGetNoObjName(){
		Test.StartTest();
		String objName = RobotCompController.getObjectName('Account_Context_Wrong' + DateTime.Now());
		Test.StopTest();
		System.assert(String.isBlank(objName),'No object configured in metadata');
	}
	
	@isTest
	private static void testGetLabels(){
		Test.StartTest();
		String jsonLabels = RobotCompController.getFieldInfo('Account');
		Test.StopTest();
		System.assert(jsonLabels.contains('"fieldName":"Name"') ,'The Name label should be returned');
	}	
	
	
	@isTest
	private static void testGetRecordsNoFilter(){
		Test.StartTest();
		List<Account> accs = (List<Account>)RobotCompController.getRecords('Account','');
		Test.StopTest();
		System.assertEquals(accs.size(), 10 ,'10 Test accounts should be returned');
	}	
	
	@isTest
	private static void testGetRecordsWFilter(){
		Test.StartTest();
		Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = [select id from account where name =:accName+9].id;
		Test.setFixedSearchResults(fixedSearchResults);		
		List<Account> accs = (List<Account>)RobotCompController.getRecords('Account',accName+9);
		Test.StopTest();
		System.assertEquals(accs.size(), 1 ,'1 Account with name RobotAccount9 will be returned');
	}	
	
	@isTest
	private static void testGetNoRecords(){
		Test.StartTest();
		List<sObject> records = RobotCompController.getRecords('AccountFalseOb','');
		Test.StopTest();
		System.assertEquals(records, null ,'10 Test accounts should be returned');
	}
	
	@isTest
	private static void testGetAmoutField(){
		Test.StartTest();
		String amountF = RobotCompController.getAmountFieldName('Account');
		Test.StopTest();
		System.assertEquals(amountF, 'AnnualRevenue' ,'Annual Revenue is the default field');
	}	
	
	@isTest
	private static void testGetNoAmoutField(){
		Test.StartTest();
		String amountF = RobotCompController.getAmountFieldName('AccountFalseObj');
		Test.StopTest();
		System.assertEquals(amountF, null ,'amount field doesnt exist');
	}	
	
	@isTest
	private static void testGetChartData(){
		Test.StartTest();
		List<Account> accounts = (List<Account>)RobotCompController.getChartRecords('Account','');
		Test.StopTest();
		for(Account acc : accounts){
			System.assert(acc.AnnualRevenue >= 100 ,'Annual Revenue is higher than 100');		
		}
	}	
	
	@isTest
	private static void testGetNoChartData(){
		Test.StartTest();
		List<Account> accounts = (List<Account>)RobotCompController.getChartRecords('Account','NoAccountsFound');
		Test.StopTest();
		System.assert(accounts.IsEmpty() ,'No Accounts found');		
	}
	@isTest
	private static void testGetNoObjChartData(){
		Test.StartTest();
		List<Account> accounts = (List<Account>)RobotCompController.getChartRecords('AccountNotFound','NoAccountsFound');
		Test.StopTest();
		System.assertEquals(accounts,null ,'No Accounts found');		
	}				
}