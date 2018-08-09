/*
* Copyright (c) 2018, salesforce.com, inc.
* All rights reserved.
* SPDX-License-Identifier: BSD-3-Clause
* For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
*/
({
	doInit : function(cmp, event, helper) {
        helper.setChartData(cmp,null);
	},
    handleMessage: function(cmp,event,helper){
        cmp.set("v.contentCss","");
		var message = event.getParam("payload");
		if(!message["chatStarted"]){
        helper.updateChart(cmp,message["data__c"],message["Additional_Data__c"]);
        }
 
    }
})