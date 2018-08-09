@isTest
public with sharing class EventHelperTest {
	@isTest
   private static void createEvent(){
    Test.startTest();
    List<EventHelper.BotAnswers> lstBot = new List<EventHelper.BotAnswers>();
    EventHelper.BotAnswers bAns = new EventHelper.BotAnswers();
    bAns.sessionKey = 'sessionTest';
    bAns.answer = 'Last_10_Contacts';
    lstBot.add(bAns);
    EventHelper.addPEvent(lstBot);
    Test.stopTest();
    System.assertEquals(lstBot[0].answer,'Last_10_Contacts',  'Event has been published');
   }
}