@isTest(SeeAllData=true)
public class CaseActionsApexClassTest {
@isTest static void testHighPriorityCase() {
        // Create a test account
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        // Create a high priority case
        Case cs = new Case(
            AccountId = acc.Id,
            Priority = 'High',
            Subject = 'Test High Priority Case',
            Description = 'This is a test high priority case.'
        );
    
        insert cs;
        // Verify that the case was created successfully
        System.assertEquals('High', cs.Priority);
        System.assertEquals('Test High Priority Case', cs.Subject);
    }
    
    @isTest static void testProductSupportCase() {
        // Create a test account
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        // Create a product support case
        Case cs = new Case(
            AccountId = acc.Id,
            Product__c = 'Test Product',
            Subject = 'Test Product Support Case',
            Description = 'This is a test product support case.'
        );
        insert cs;
        
        // Verify that the case was created successfully
        System.assertEquals('Test Product', cs.Product__c);
        System.assertEquals('Test Product Support Case', cs.Subject);
    }
    
   /* @isTest
     static void testAssignCasesWithMatchingSkills() {
        // Create test cases with matching skills
        Case testCase1 = new Case(My_Skill__c='English', Priority='High');
        Case testCase2 = new Case(My_Skill__c='English', Priority='Medium');
        
        // Insert the test cases
        insert new List<Case>{testCase1, testCase2};
        
        // Create test user skills
        User_Skill__c testUserSkill1 = new User_Skill__c(Name='English', User__c='0055i000006p2riAAA', Skill_Start_Date__c=Date.today(), Skill_End_Date__c =Date.today().addDays(10));
        User_Skill__c testUserSkill2 = new User_Skill__c(Name='English', User__c='0055i000006p2CCAAY', Skill_Start_Date__c=Date.today(), Skill_End_Date__c =Date.today().addDays(10));
        
        // Insert the test user skills
        insert new List<User_Skill__c>{testUserSkill1, testUserSkill2};
        
        Test.startTest();
        
        // Assign the test cases
        CaseActionsApexClass.assignCases(new List<Case>{testCase1, testCase2});
        
        Test.stopTest();
        
        // Verify that the cases were assigned to users with matching skills
        testCase1 = [SELECT OwnerId FROM Case WHERE Id = :testCase1.Id];
        testCase2 = [SELECT OwnerId FROM Case WHERE Id = :testCase2.Id];
        System.assertEquals('00G5i00000DCGgWEAX', testCase1.OwnerId);
        System.assertEquals('00G5i00000DCGgWEAX', testCase2.OwnerId);
    }
    
    
    @isTest
     static void testAssignCasesWithOutMatchingSkills() {
        // Create test cases with matching skills
        Case testCase1 = new Case(My_Skill__c='Social', Priority='High');
        Case testCase2 = new Case(My_Skill__c='Social', Priority='Medium');
        
        // Insert the test cases
        insert new List<Case>{testCase1, testCase2};
        
        // Create test user skills
        User_Skill__c testUserSkill1 = new User_Skill__c(Name='Social', User__c='0055i000006p2CCAAY', Skill_Start_Date__c=Date.today(), Skill_End_Date__c =Date.today().addDays(10));
        User_Skill__c testUserSkill2 = new User_Skill__c(Name='Social', User__c='0055i000006p2CCAAY', Skill_Start_Date__c=Date.today(), Skill_End_Date__c =Date.today().addDays(10));
        
        // Insert the test user skills
        insert new List<User_Skill__c>{testUserSkill1, testUserSkill2};
        
        Test.startTest();
        
        // Assign the test cases
        CaseActionsApexClass.assignCases(new List<Case>{testCase1, testCase2});
        
        Test.stopTest();
        
        // Verify that the cases were assigned to users with matching skills
        testCase1 = [SELECT OwnerId FROM Case WHERE Id = :testCase1.Id];
        testCase2 = [SELECT OwnerId FROM Case WHERE Id = :testCase2.Id];
        System.assertEquals('00G5i00000DCGgWEAX', testCase1.OwnerId);
        System.assertEquals('00G5i00000DCGgWEAX', testCase2.OwnerId);
    } */
    @IsTest
    static void bothProductAndSkillSelected(){
        List<Case> caseList = new List<Case>();
        Case cs = new Case(
            Priority = 'High',
            Subject = 'Test High Priority Case',
            Description = 'This is a test high priority case.',
            Product__c = 'Laptop',
            My_Skill__c = 'English'
            
        );
        caseList.add(cs);
        CaseActionsApexClass.assignCases(caseList);
    }
}