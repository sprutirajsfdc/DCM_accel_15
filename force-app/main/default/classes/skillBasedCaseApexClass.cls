/**
@Description :Cases are assigned based on the skills of the individuals involved. 
             In cases where multiple users possess the same skill, 
             a fair distribution is ensured through the implementation of the Round Robin method for assigning the cases.
@Author :     Subba Reddy
@Last Modified By : Subba Reddy
@Last Modified On: 21/04/2023
@Modification Log:
Ver    Date            Author           LastModification
1.0   26/04/2023     Subba Reddy        Initial Version
**/
public class skillBasedCaseApexClass 
{
    // Assign cases based on matching skills
    public static void assignCases(List<Case> caseList){
        // Map to store cases created with specific skills
        Map<String, Id> caseCreatedWithSkill = new Map<String, Id>();
        // Iterate through the case list to find cases with assigned skills
        for(Case caseCreatedWithSkills : caseList){
            if(caseCreatedWithSkills.My_Skill__c != null){
                caseCreatedWithSkill.put(caseCreatedWithSkills.My_Skill__c, caseCreatedWithSkills.Id);
            }
        }
        // Retrieve available users who have selected skills matching the cases
        List<Skill__c> availableUsersSelectedSkill = [SELECT Id, Name, (SELECT User__c FROM User_Skills__r) FROM Skill__c where Name =: caseCreatedWithSkill.KeySet()];
        // Map to store matching skills with available users
        Map<String, List<String>> matchingSkillInSelectedCaseAvailableUsers = new Map<String, List<String>>();
        List<String> userList = new List<String>();
        // Iterate through available skills to find matching users
        for(Skill__c skillUsers : availableUsersSelectedSkill){
            if(caseCreatedWithSkill.containsKey(skillUsers.Name)){
                for(User_Skill__c userSkill : skillUsers.User_Skills__r){
                    userList.add(userSkill.User__c);
                }
                matchingSkillInSelectedCaseAvailableUsers.put(skillUsers.Name, userList);
            }
        }
        
        system.debug('matchingSkillInSelectedCaseAvailableUsers: ' + matchingSkillInSelectedCaseAvailableUsers);
        // Set to store the user Ids
        Set<String> userIds = new Set<String>();
        for(List<String> userList1 : matchingSkillInSelectedCaseAvailableUsers.values()){
            userIds.addAll(userList1);
        }
        system.debug('separated ids ' + userIds);
        
        Case lastAssignedSkillCase;
        try {
            // Retrieve the last assigned case with an owner and a skill
            lastAssignedSkillCase = [SELECT Id, OwnerId, My_Skill__c FROM Case WHERE OwnerId != null AND My_Skill__c != null ORDER BY CreatedDate DESC LIMIT 1];
        } catch (Exception ex) {
            lastAssignedSkillCase = null;
        }
        
        // Initialize the user index to 0
        Integer userIndex = 0;
        // Check if there are more than one matchingAvailableSkillUsers users
         // Check if there are more than one matching available skill users
        if(userIds.size() > 1){
            // Check if the last assigned case exists and has an owner
            if (lastAssignedSkillCase != null && lastAssignedSkillCase.OwnerId != null) {
                // Loop through the matchingAvailableSkillUsers to find the index of the last assigned Skill case user
                Integer j = 0;
                for(String userId : userIds){
                    if (userId == lastAssignedSkillCase.OwnerId) {
                        if(j == userIds.size()-1){
                            userIndex = 0;
                        }
                        else {
                            userIndex = Math.mod(j + 1, userIds.size()); 
                        }
                    }
                    j++;
                }
            }
            for(Case newCase : caseList){
                system.debug('newCase.....'+newCase.Product__c);
                if(newCase.My_Skill__c != null && (newCase.Priority == 'Low' || newCase.Priority == 'Medium' || newCase.Priority == 'High') && ( newCase.Product__c == null)){
                    if(caseCreatedWithSkill.containsKey(newCase.My_Skill__c)){
                        if (lastAssignedSkillCase != null) {
                            List<String> userIdList = new List<String>(userIds);
                            newCase.OwnerId = userIdList[userIndex];
                            userIndex = Math.mod(userIndex + 1, userIds.size());
                        } else {
                            List<String> userIdList = new List<String>(userIds);
                            newCase.OwnerId = userIdList[userIndex];
                            userIndex = Math.mod(userIndex + 1, userIds.size());
                        }
                    }
                }
            }
        }
        // Check if there is only one matching available skill user
        Else if(userIds.size() <= 1){
            for(Case css : caseList){
                if(css.My_Skill__c != null && (css.Priority == 'Low' || css.Priority == 'Medium' || css.Priority == 'High') && (css.Product__c == null)){
                    List<String> userIdList = new List<String>(userIds);
                    css.OwnerId = userIdList[userIndex];
                }
            }
        }
    }
}