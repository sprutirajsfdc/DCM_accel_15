@isTest
public class caseEscalationTest {
 @isTest(seeAllData = true)
    static void testExecute() {
         Case testCases = [SELECT Id, Status, OwnerId, createdDate FROM Case WHERE status !='Escalated' limit 1];
        
        Test.startTest();
        caseEscalation scheduledJob = new caseEscalation(testCases, testCases.Id);
        String sch = '0 0 0 3 9 ?';
        system.schedule('testBasicScheduledApex', sch, scheduledJob);
    }
        @isTest(seeAllData = true)
    static void testExecute3() {
        
        list<Case> listCases = new list<Case>();
         Case testCases = [SELECT Id, Status, OwnerId, createdDate FROM Case WHERE status !='Escalated' ORDER BY CreatedDate DESC limit 1];
        listCases.add(testCases);
        Test.startTest();
        EscalationTriggerHandler.scheduleEscalation(listCases);
       
        Test.stopTest();
    }
     @isTest(seeAllData = true)
    static void testExecute1() {
        list<Case> listCases = new list<Case>();
         Case testCases = [SELECT Id, Status, OwnerId, createdDate FROM Case WHERE status !='Escalated' ORDER BY CreatedDate DESC limit 1];
        listCases.add(testCases);
        Test.startTest();
        EscalationTriggerHandler.scheduleEscalation(listCases);
       
        Test.stopTest();
    }
}