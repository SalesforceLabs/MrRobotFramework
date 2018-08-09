global without sharing class EventHelper {
	
    @InvocableMethod(label='Publish a platform event' description='This method willpublis a sfdc PE')
	global static void addPEvent (List<BotAnswers> lstAnswers) {
		List<bot_message__e> pEvents = new List<bot_message__e>();
		BotAnswers ba = lstAnswers[0];
			bot_message__e ev = new bot_message__e ();
			ev.data__c=  ba.answer;
			ev.SessionKey__c = ba.sessionKey;
			ev.Additional_Data__c = String.IsBlank(ba.additionalInfo) ? '' : ba.additionalInfo;
			pEvents.add(ev);

		EventBus.publish(pEvents);

	}
	global class BotAnswers{
		
	@InvocableVariable(required=true)
	global String sessionKey;
	
	@InvocableVariable(required=true)
	global String answer;
	
	@InvocableVariable(required=false)
	global String additionalInfo;
	
	}
}