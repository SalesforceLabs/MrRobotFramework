/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
({
	doInit : function(component){
		component.set("v.size","font-size:" + component.get("v.size") + ";color:#061c3f;");
        var greeting = component.get("v.defaultMessage");
        component.set("v.messageFromEvent",greeting)
	},
	handleMessage : function(component, event, helper) {
        component.set("v.contentCss","cRobotMessage");
		var message = event.getParam("payload");
		var action = component.get("c.getMessage");
		action.setParams({"label":message["data__c"]});
		action.setCallback(this, function(response) { 
        component.set("v.contentCss","cRobotMessage FadeInEffect");
        component.set("v.messageFromEvent",response.getReturnValue())
   
		});
		if(!message["chatStarted"]){
			$A.enqueueAction(action);
		 }
	}
})