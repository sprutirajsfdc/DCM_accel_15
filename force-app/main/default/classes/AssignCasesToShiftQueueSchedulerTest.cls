@isTest(seeAllData=True)
public class AssignCasesToShiftQueueSchedulerTest {
    @isTest(seeAllData=True)
    static void testAssigningToMorningShift() {
        Test.startTest();
        Case c = [select id, Priority, Origin, OwnerId, CreatedDate, My_Skill__c, Initial_Shift_Name__c, Product__c from Case where Initial_Shift_Name__c = 'Morning Shift' limit 1];
        system.debug('c' + c.OwnerId);
        AssignCasesToShiftQueueScheduler scheduler = new AssignCasesToShiftQueueScheduler();
        scheduler.execute(null);
        Group morningShiftQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Morning Shift'];
        system.debug('morningShiftQueue' + morningShiftQueue.Id);
        Test.stopTest();
    }
    @isTest(seeAllData=True)
static void testAssigningToAfternoonShift() {
Case c = [select id, Priority, Origin, OwnerId, CreatedDate,My_Skill__c, Initial_Shift_Name__c, Product__c from Case where Initial_Shift_Name__c = 'Afternoon Shift' limit 1];
system.debug('c' + c.OwnerId);
AssignCasesToShiftQueueScheduler scheduler = new AssignCasesToShiftQueueScheduler();
scheduler.execute(null);
Group afternonnShiftQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Afternoon Shift'];
system.debug('afternonnShiftQueue' + afternonnShiftQueue.Id);
} 
    @isTest(seeAllData=True)
    static void testAssigningToNightShift() {
        Test.startTest();
        Case c = [select id, Priority, Origin, OwnerId, CreatedDate, My_Skill__c, Initial_Shift_Name__c, Product__c from Case where Initial_Shift_Name__c = 'Night Shift' limit 1];
        system.debug('c' + c.OwnerId);
        AssignCasesToShiftQueueScheduler scheduler = new AssignCasesToShiftQueueScheduler();
        scheduler.execute(null);
        Group nightShiftQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Night Shift'];
        system.debug('nightShiftQueue' + nightShiftQueue.Id);
        Test.stopTest();
    }
}