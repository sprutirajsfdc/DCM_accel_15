/**
@Description :This class assigns cases to different queues based on their priority.
@Author :   Sprutiraj 
@Last Modified By : Subba Reddy
@Last Modified On: 25/04/2023
@Modification Log:
Ver    Date            Author                 LastModification
1.0   26/04/2023     Sprutiraj Panda           Initial Version
**/
public class CaseActionsApexClass 
{
     // Assign cases to appropriate queues based on specific conditions
    public static void assignCases(List<Case> casesToAssign)
    {
        // Get the queue Id for the high priority case team
        Group priorityHighQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'High Priority Case Team' LIMIT 1];
        // Get the queue Id for the product support case team
        Group supportOnProductQueueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Product Support Case Team' LIMIT 1];
       
        for(Case c : casesToAssign){
            // Check if the case has a product but no specific skill assigned
                if(c.Product__c != null && (c.My_Skill__c == null) && (c.Priority == 'Low' || c.Priority == 'Medium' || c.Priority == 'High')){
                    c.OwnerId = supportOnProductQueueId.Id; // Assign the case to the product support queue
                }
            // Check if the case is of high priority and has no specific skill or product assigned
            Else if(c.Priority == 'High' && (c.My_Skill__c == null) && (c.Product__c == null)){
                    c.OwnerId = priorityHighQueueId.Id;// Assign the case to the high priority queue
                }
            // Check if the case has both a product and a specific skill assigned
            Else if((c.Priority == 'High' ||c.Priority == 'Low' || c.Priority == 'Medium') && (c.My_Skill__c != null) && (c.Product__c != null)){
                c.AddError('Both Product and My Skill Do not select at a time');// Display an error message
            }
        }
       
}
}