/*
* Copyright (c) 2018, salesforce.com, inc.
* All rights reserved.
* SPDX-License-Identifier: BSD-3-Clause
* For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
*/
({
	handleMessage : function(cmp,event) {
    	var payload = event.getParam("payload");
        $A.createComponent(
            "aura:html", { "tag" : "p", "body" : JSON.stringify(payload) + $A.get("$SObjectType.CurrentUser.Email"), 
            HTMLAttributes: { "class" : "slds-p-vertical_xx-small" }},
            function(newMessage, status, errorMessage){
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.unshift(newMessage);
                    cmp.set("v.body", body);
                }
            }
        );       		
	}
})