public with sharing class CaseController {
    @AuraEnabled(cacheable=true)
    public static List<Case> getAssignedCases() {
        String currentUserId = UserInfo.getUserId();
        
        return [SELECT CaseNumber,Case_Owner_Name__c, Subject, Status, Priority
                FROM Case
                WHERE OwnerId = :currentUserId];
    }
}