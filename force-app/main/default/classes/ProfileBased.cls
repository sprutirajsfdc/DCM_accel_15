public class ProfileBased  {
  @AuraEnabled(cacheable = true)
    public static string getProfile(){
        Id profileId = UserInfo.getProfileId();
    String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
    system.debug('Profile Name'+profileName);
        return profileName;
    }
}

//  @AuraEnabled
//     public static List<Group> getQueues() {
//         List<Group> queues = [SELECT Id, Name, Owner.Name, Owner.Email FROM Group WHERE Type = 'Queue'];
//         return queues;
//     }