/*
* Copyright (c) 2018, salesforce.com, inc.
* All rights reserved.
* SPDX-License-Identifier: BSD-3-Clause
* For full license text, see LICENSE.txt file in the repo root or https://opensource.org/licenses/BSD-3-Clause
*/
({
    buildChart: function(cmp,searchKey){
        var action = cmp.get("c.getAmountFieldName");
		action.setParams({"objectName":cmp.get("v.objectName")});
		action.setCallback(this, function(response) {
			cmp.set('v.amountField',response.getReturnValue());
            this.setChartData(cmp,searchKey);
		});
       	$A.enqueueAction(action);
    
	},  
    setChartData:function(cmp,searchKey){
        var action = cmp.get("c.getChartRecords");
		action.setParams({objectName:cmp.get('v.objectName'),searchKey:searchKey});
		action.setCallback(this, function(response) {
            if(response.getReturnValue()){
                var chartData = response.getReturnValue().map(function(record) {
                               return record[cmp.get("v.amountField")];
                               });
                var chartLabels =  response.getReturnValue().map(function(record) {
                               return record["Name"];
                               });
                var ctx = cmp.find("chart").getElement();
                cmp.set("v.contentCss","FadeInEffect");
                var theChart = new Chart(ctx, {
                    type: 'horizontalBar',
                    data: {
                        labels: chartLabels,
                        datasets: [
                            {
                                label: cmp.get("v.amountField"),
                                data: chartData,
                                backgroundColor: [
                                    "#4bca81",
                                    "#0070d2",
                                    "#1589ee",
                                    "#d8edff",
                                    "#FFB74D",
                                    "#E67E22",
                                    "#F8C471",
                                    "#ffdde1",
                                    "#00BCD4",
                                    "#ffb75d ",
                                ]
                            }
                        ]
                    },
                       options: {
                           scales: {
                               yAxes: [{
                                   ticks: {
                                       beginAtZero:false
                                   }
                               }]
                           }
                       }
                });
               cmp.set("v.genChart",theChart);
            }
		});
       	$A.enqueueAction(action);
        
    },
    
    updateChart: function(cmp, messageData, searchKey){
  		var theChart = cmp.get("v.genChart");
        theChart.destroy();
    	var action = cmp.get("c.getObjectName");
        action.setParams({objectName:messageData});
		action.setCallback(this, function(response) {
			cmp.set('v.objectName',response.getReturnValue());
            if(response.getReturnValue()){
                this.buildChart(cmp,searchKey);
            }
		});
       	$A.enqueueAction(action);
	}
    
})