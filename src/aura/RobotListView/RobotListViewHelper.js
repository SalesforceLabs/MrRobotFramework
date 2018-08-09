/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
({
	setColumns : function(cmp) {
		var action = cmp.get("c.getFieldInfo");
		action.setParams({"objectName":cmp.get("v.objectName")});
		action.setCallback(this, function(response) {
			cmp.set('v.columns',JSON.parse(response.getReturnValue()));
		});
       	$A.enqueueAction(action);
	},
    
    setDataTable:function(cmp,searchKey){
        var action = cmp.get("c.getRecords");
		action.setParams({objectName:cmp.get('v.objectName'),searchKey:searchKey});
		action.setCallback(this, function(response) {
			cmp.set('v.data',response.getReturnValue());
		});
       	$A.enqueueAction(action);
        
    },
    
    getData: function(cmp, messageData, searchKey){
    	var action = cmp.get("c.getObjectName");
        action.setParams({objectName:messageData});
		action.setCallback(this, function(response) {
			cmp.set('v.objectName',response.getReturnValue());
            if(response.getReturnValue()){
                this.setColumns(cmp);
                this.setDataTable(cmp,searchKey);
            }
        cmp.set("v.contentCss","FadeInEffect");
		});
       	$A.enqueueAction(action);
	}
    
})