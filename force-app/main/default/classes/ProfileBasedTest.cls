@isTest
private class ProfileBasedTest {
    @isTest
    static void testGetProfile() {
        // Create a test user
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile LIMIT 1].Id,
            FirstName = 'sfdc2',
            LastName = 'play',
            Email = 'sfdcplay@example.com',
            Username = 'sfdcplay@example.com',
            Alias = 'testusr',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        // Set the test context
        System.runAs(testUser) {
            // Call the method to be tested
            String profileName = ProfileBased.getProfile();
            
            // Verify the result
            //System.assertEquals(testUser.Profile.Name, profileName, 'Incorrect profile name');
        }
    }
}