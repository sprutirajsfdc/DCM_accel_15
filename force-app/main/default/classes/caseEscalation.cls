public class caseEscalation implements System.Schedulable {
    private Case newListCase;
    private Id caseId;
    
    public caseEscalation(Case newListCase, Id caseId) {
        this.newListCase = newListCase;
        this.caseId = caseId;
    }    
    public void execute(SchedulableContext sc) {
        system.debug('newListCase' + newListCase);
        system.debug('caseId' + caseId);
        Case c = [SELECT Id, Status, OwnerId, createdDate FROM Case WHERE Id = :caseId and status !='Escalated' limit 1];
        if (c != null) { // check if case still needs to be escalated
            // get the queue id for assigning new high priority cases
            Group highPriorityQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Escalated or Urgent Case Team' LIMIT 1];
            if (highPriorityQueue != null) {
                // Update the case to escalate it
                c.OwnerId = highPriorityQueue.Id; // set the Id of the user or queue to escalate the case to
                c.IsEscalated = true; // mark the case as escalated
                c.Status = 'Escalated';
                // Save the updated case
                update c;
            } else {
                // Handle the case where the high priority queue is not found
                System.debug('High priority queue not found');
            }
        }
    }
}