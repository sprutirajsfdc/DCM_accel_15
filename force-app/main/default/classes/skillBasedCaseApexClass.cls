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
public class skillBasedCaseApexClass {
    public static void assignCases(List<Case> caseList) {
        Map<String, Id> caseCreatedWithSkill = new Map<String, Id>();
        for (Case caseCreatedWithSkills : caseList) {
            system.debug('Skill__c      ' + caseCreatedWithSkills.Skill_Name__c);
            if (caseCreatedWithSkills.Skill_Name__c != null) {
                caseCreatedWithSkill.put(caseCreatedWithSkills.Skill_Name__c, caseCreatedWithSkills.Id);
                system.debug('caseCreatedWithSkill' + caseCreatedWithSkill.KeySet());
            }
        }
        if (!caseCreatedWithSkill.isEmpty()) {
            //  List<Skill__c> availableUsersSelectedSkill = [SELECT Id, Name, (SELECT User__c FROM User_Skills__r) FROM Skill__c WHERE Name IN :caseCreatedWithSkill.keySet()];
            List<User_Skill__c > availableUsersSelectedSkill1 = [SELECT User__c, Skill_Name__c FROM User_Skill__c where Skill_Name__c IN :caseCreatedWithSkill.keySet() ];
            //system.debug('availableUsersSelectedSkill' + availableUsersSelectedSkill);
            system.debug('availableUsersSelectedSkill' + availableUsersSelectedSkill1);
            
            
            
            Map<String, List<String>> matchingSkillInSelectedCaseAvailableUsers = new Map<String, List<String>>();
            List<String> userList = new List<String>(); // Move the declaration inside the loop
            
            
            
            for (User_Skill__c skillUsers : availableUsersSelectedSkill1) {
                system.debug('skillUsers.Skill_Name__c' + skillUsers.Skill_Name__c);
                if (caseCreatedWithSkill.containsKey(skillUsers.Skill_Name__c)) {
                    userList.Add(skillUsers.User__c);
                    matchingSkillInSelectedCaseAvailableUsers.put(skillUsers.User__c, userList);
                }
            }
            
            System.debug('matchingSkillInSelectedCaseAvailableUsers: ' + matchingSkillInSelectedCaseAvailableUsers.Values());
            
            Set<String> userIds = new Set<String>();
            for (List<String> userList1 : matchingSkillInSelectedCaseAvailableUsers.values()) {
                userIds.addAll(userList1);
            }
            System.debug('separated ids ' + userIds);
            
            Case lastAssignedSkillCase;
            try {
                lastAssignedSkillCase = [SELECT Id, OwnerId, Skill_Name__c FROM Case WHERE OwnerId != null AND Skill_Name__c != null ORDER BY CreatedDate DESC LIMIT 1];
            } catch (Exception ex) {
                lastAssignedSkillCase = null;
            }
            
            Integer userIndex = 0;
            system.debug('userIds.size()/....'+ userIds.size());
            if (userIds.size() > 1) {
                if (lastAssignedSkillCase != null && lastAssignedSkillCase.OwnerId != null) {
                    Integer j = 0;
                    for (String userId : userIds) {
                        if (userId == lastAssignedSkillCase.OwnerId) {
                            if (j == userIds.size() - 1) {
                                userIndex = 0;
                            } else {
                                userIndex = Math.mod(j + 1, userIds.size());
                            }
                        }
                        j++;
                    }
                }
                for (Case newCase : caseList) {
                    System.debug('newCase.....' + newCase.Skill_Name__c);
                    if (newCase.Skill_Name__c != null && (newCase.Priority == 'Low' || newCase.Priority == 'Medium' || newCase.Priority == 'High') && newCase.Product__c == null) {
                        if (caseCreatedWithSkill.containsKey(newCase.Skill_Name__c)) {
                            List<String> userIdList = new List<String>(userIds);
                            if (!userIdList.isEmpty()) { // Check if the list is empty before accessing elements
                                newCase.OwnerId = userIdList[userIndex];
                                userIndex = Math.mod(userIndex + 1, userIds.size());
                            }
                        }
                    }
                }
            } else if (userIds.size() <= 1) {
                for (Case css : caseList) {
                    if (css.Skill_Name__c != null && (css.Priority == 'Low' || css.Priority == 'Medium' || css.Priority == 'High') && css.Product__c == null) {
                        List<String> userIdList = new List<String>(userIds);
                        if (!userIdList.isEmpty()) { // Check if the list is empty before accessing elements
                            css.OwnerId = userIdList[userIndex];
                        }
                    }
                }
            }
        }
    }
}