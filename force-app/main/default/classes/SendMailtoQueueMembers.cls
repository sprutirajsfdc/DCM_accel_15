public class SendMailtoQueueMembers implements Schedulable {
    public void execute(SchedulableContext sc) {
        Set<Id> userIds = new Set<Id>();
        List<GroupMember> members = [SELECT Id, GroupId, Group.Name, UserOrGroupId, Group.Type FROM GroupMember WHERE Group.Type = 'Queue'];
        if (members.size() > 0) {
            for (GroupMember m : members) {
                userIds.add(m.UserOrGroupId);
            }
        }
        Set<String> emails = new Set<String>();
        List<User> users = [SELECT Id, Email FROM User WHERE Id IN :userIds];
        for (User u : users) {
            emails.add(u.Email);
        }
        System.debug('emails: ' + emails);
        List<String> emailAddresses = new List<String>(emails);
        List<Messaging.SingleEmailMessage> msgEmails = new List<Messaging.SingleEmailMessage>();
        List<Case> cases = [SELECT Id, CaseNumber, Status, Subject, Owner.Name, Priority, Description, CreatedDate FROM Case WHERE Status = 'New' AND CreatedDate <= :System.now().addHours(-7)];
        System.debug('cases: ' + cases);
        for (Case c : cases) {
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setToAddresses(emailAddresses);
            String body = '<p>Dear Team,</p>';
            body += '<p>This is to inform you that Case ' + c.CaseNumber + ' needs your attention. The Case has been assigned to the ' + c.Owner.Name + ' owner, but it has not been resolved yet.</p>';
            body += '<p>Please review the details below and take appropriate action before the Case is escalated:</p>';
            body += '<p><li>Case Number: ' + c.CaseNumber + ' </li><br/><li> Subject: ' + c.Subject + '</li><br/><li> Description: ' + c.Description + '</li><br/><li>  Priority: ' + c.Priority + '</li><br/><li> Status: ' + c.Status + '</li> <br/> Please note that the Case is scheduled to be escalated in 2 hours. If you are unable to resolve the Case by then, please reassign it to an appropriate resource or escalate it to the next level of support.</p>';
            body += '<p>Thank you for your prompt attention to this matter. Please go through the below case details.</p>';
            body += '<p><a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id + '">View Case Details</a></p>';
            body += '<p>Thanks & Regards,</p>';
            body += '<p>Support Team</p>';
            msg.setHtmlBody(body);
            msg.setSubject('Case is going to be Escalate');
            msg.setSenderDisplayName('Salesforce Admin');
            msgEmails.add(msg);
        }
        if (!msgEmails.isEmpty()) {
            Messaging.sendEmail(msgEmails);
        } else {
            System.debug('No new cases found for escalation');
        }
    }
    
    public static void scheduleJob() {
        SendMailtoQueueMembers job = new SendMailtoQueueMembers();
        String scheduleTime = '0 0 * * * ?'; // schedule at midnight every day
        String jobName = 'Before Case Escalation Email Alert Job';
        String jobId = System.schedule(jobName, scheduleTime, job);
        System.debug('Scheduled job with ID: ' + jobId);
    }
}