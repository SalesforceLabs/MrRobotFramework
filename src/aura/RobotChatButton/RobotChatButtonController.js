/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
({
	handleMaximize: function(cmp, evt, hlp) {
    cmp.find("minimizedAPI").maximize();
	},
    onInit: function(cmp, evt, hlp) {
       cmp.find("minimizedAPI").registerEventHandler(hlp.minimizedEventHandler.bind(hlp, cmp));
       console.log("Chat Started");
       var messageEvent = $A.get("e.c:ChatbotEvent");
        messageEvent.setParam("payload", JSON.parse('{"chatStarted":"Chat-Started"}'));
	    messageEvent.fire(); 
    }
    
})