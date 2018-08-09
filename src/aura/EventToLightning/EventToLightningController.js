/*
* Copyright (c) 2018, salesforce.com, inc.
* All rights reserved.
* SPDX-License-Identifier: BSD-3-Clause
* For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
*/
({
    doInit: function(component, event, helper) {

    },
    handleDestroy : function (component, event, helper) {
        // Ensure this component unsubscribes and disconnects from the server
		var cometd = component.get("v.cometd");
		var subscription = component.get("v.subscription");
		cometd.unsubscribe(subscription, {}, function(unsubscribeReply) {
		    if(unsubscribeReply.successful) {
                cometd.disconnect(function(disconnectReply) 
                    { 
                        console.log('streaming component: Success unsubscribe')
                        if(disconnectReply.successful) {
                            console.log('streaming component: Success disconnect')
                        } else {
                            console.error('streaming component: Failed disconnect')                    
                        }
                    });
		    } else {
		        console.error('streaming component: Failed unsubscribe')                    		    
		    }
		});
    },
    	handleMessage : function(component, event, helper) {
		var message = event.getParam("payload");
		if(message["chatStarted"] == "Chat-Started"){
    	var actionK = component.get("c.createSession");
    	actionK.setCallback(this,function(response){
    		component.set("v.sessionKey" , response.getReturnValue());
    		/*Platform Event connection*/
    		var action = component.get("c.getSessionId");
    		action.setCallback(this, function(response) {
        
            // Configure CometD for this component window.location.hostname
            var sessionId = response.getReturnValue();
            var cometd = new window.org.cometd.CometD();
            cometd.configure({
                url: window.location.protocol + '//' + window.location.hostname + '/cometd/41.0/',
                requestHeaders: { Authorization: 'OAuth ' + sessionId},
                appendMessageTypeToURL : false
            });
            cometd.websocketEnabled = false;
            component.set('v.cometd', cometd);

            // Connect to 
            cometd.handshake($A.getCallback(function(status) {
                if (status.successful) {
                    var eventName = '/event/bot_message__e?Session_Key__c=' + component.get('v.sessionKey');//component.get('/event/bot_message__e');
                    var subscription = 
                        cometd.subscribe(eventName, $A.getCallback(function(message) {
                            var messageEvent = $A.get("e.c:ChatbotEvent"); //component.getEvent("onMessage");
	                        if(messageEvent!=null) {
	                        	if(message.data.payload.SessionKey__c == component.get('v.sessionKey')){
		                        	messageEvent.setParam("payload", message.data.payload);
	                                messageEvent.fire(); 
	                        	}
        
	                        }
                        }
                    ));
                    component.set('v.subscription', subscription);
                } else {
                    // TODO: Throw an event / set error property here?
                    console.error('streaming component: ' + status);
                }
            }));

        });
        $A.enqueueAction(action);
        
    	});
    	
    	$A.enqueueAction(actionK);

   
		}
	}
})