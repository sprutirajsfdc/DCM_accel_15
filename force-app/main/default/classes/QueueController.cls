public class QueueController {
    @AuraEnabled
    public static List<Group> getQueues() {
        List<Group> queues = [SELECT Id, Name, Owner.Name, Owner.Email FROM Group WHERE Type = 'Queue'];
        return queues;
    }
    
    @AuraEnabled
    public static List<User> getQueueUsers(String queueId) {
        List<GroupMember> groupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :queueId];
        
        Set<Id> userIds = new Set<Id>();
        for (GroupMember gm : groupMembers) {
            if (gm.UserOrGroupId.getSObjectType() == User.SObjectType) {
                userIds.add(gm.UserOrGroupId);
            }
        }
        
        List<User> users = [SELECT Id, Name, Email FROM User WHERE Id IN :userIds];
        return users;
    }
    
    
}