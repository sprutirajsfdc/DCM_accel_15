@IsTest(seeAllData = true)
public class skillBasedCaseApexClassTest {
 @isTest
     static void testAssignCasesWithMatchingSkills() {
        // Create test cases with matching skills
        Case testCase1 = new Case(My_Skill__c='English', Priority='High');
        Case testCase2 = new Case(My_Skill__c='English', Priority='Medium');
        
        // Insert the test cases
        insert new List<Case>{testCase1, testCase2};
        
        // Create test user skills
        Skill__c testUserSkill1 = new Skill__c(Name='English', Skill_Start_Date__c=Date.today(), Skill_End_Date__c =Date.today().addDays(10));
        Skill__c testUserSkill2 = new Skill__c(Name='English', Skill_Start_Date__c=Date.today(), Skill_End_Date__c =Date.today().addDays(10));
        
        // Insert the test user skills
        insert new List<Skill__c>{testUserSkill1, testUserSkill2};
        
        Test.startTest();
        
        // Assign the test cases
        CaseActionsApexClass.assignCases(new List<Case>{testCase1, testCase2});
        
        Test.stopTest();
        
        // Verify that the cases were assigned to users with matching skills
        testCase1 = [SELECT OwnerId FROM Case WHERE Id = :testCase1.Id];
        testCase2 = [SELECT OwnerId FROM Case WHERE Id = :testCase2.Id];
        System.assertEquals('00G5i000002DD1NEAW', testCase1.OwnerId);
        System.assertEquals('00G5i000002DD1NEAW', testCase2.OwnerId);
    }
    
    
    @isTest
     static void testAssignCasesWithOutMatchingSkills() {
        // Create test cases with matching skills
        Case testCase1 = new Case(My_Skill__c='Java', Priority='High');
        Case testCase2 = new Case(Product__c='Mobile', Priority='Medium');
        
        // Insert the test cases
        insert new List<Case>{testCase1, testCase2};
        
        // Create test user skills
        Skill__c testUserSkill1 = new Skill__c(Name='Social',Skill_Start_Date__c=Date.today(), Skill_End_Date__c =Date.today().addDays(10));
        Skill__c testUserSkill2 = new Skill__c(Name='Social', Skill_Start_Date__c=Date.today(), Skill_End_Date__c =Date.today().addDays(10));
        
        // Insert the test user skills
        insert new List<Skill__c>{testUserSkill1, testUserSkill2};
        
        Test.startTest();
        
        // Assign the test cases
        CaseActionsApexClass.assignCases(new List<Case>{testCase1, testCase2});
        
        Test.stopTest();
        
        // Verify that the cases were assigned to users with matching skills
        testCase1 = [SELECT OwnerId FROM Case WHERE Id = :testCase1.Id];
        testCase2 = [SELECT OwnerId FROM Case WHERE Id = :testCase2.Id];
        System.assertEquals('00G5i000002DD1NEAW', testCase1.OwnerId);
        System.assertEquals('00G5i000002DD1NEAW', testCase2.OwnerId);
    }
}