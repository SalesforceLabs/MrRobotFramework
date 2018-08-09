/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
({
    minimizedEventHandler: function(cmp, eventName, eventData) {
        switch(eventName) {
            case "prechatState":
                cmp.set("v.message", "Chat wit an Expert Bot");
                Break;
            // Handle other events here!
            default:
                cmp.set("v.message", eventData.label);
        }
    }
})