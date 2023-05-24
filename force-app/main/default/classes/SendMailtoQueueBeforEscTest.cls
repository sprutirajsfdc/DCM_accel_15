@isTest
public class SendMailtoQueueBeforEscTest 
{
    @IsTest(seeAllData=True)
    static void testSendMailtoQueueMembers() {
        list<case> lstcase = [Select Id,Ownerid,CaseNumber,Status,Owner.Name,Subject,Description,Priority from Case where Status='New' AND CreatedDate <= :System.now().addHours(-7) limit 1];
        
        Test.startTest();
        SendMailtoQueueMembers job = new SendMailtoQueueMembers();
        SendMailtoQueueMembers.scheduleJob();
        job.execute(null); // Pass null for SchedulableContext as it is not used in this example
        Test.stopTest();
        
        List<String> recipientEmails = new List<String>{'subbareddy.bollapu8500@gmail.com'};
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        for (case c : lstcase) {
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setToAddresses(recipientEmails);
            String body = '<p>Dear Team,</p>';
            body += '<p>This is to inform you that Case ' + c.CaseNumber + ' needs your attention. The Case has been assigned to the ' + c.Owner.Name + ' owner, but it has not been resolved yet.</p>';
            body += '<p>Please review the details below and take appropriate action before the Case is escalated:</p>';
            body += '<p><li>Case Number: ' + c.CaseNumber + ' </li><br/><li> Subject: ' + c.Subject + '</li><br/><li> Description: ' + c.Description + '</li><br/><li>  Priority: ' + c.Priority + '</li><br/><li> Status: ' + c.Status + '</li> <br/> Please note that the Case is scheduled to be escalated in 2 hours. If you are unable to resolve the Case by then, please reassign it to an appropriate resource or escalate it to the next level of support.</p>';
            body += '<p>Thank you for your prompt attention to this matter. Please go through the below case details.</p>';
            body += '<p><a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id + '">View Case Details</a></p>';
            body += '<p>Thanks & Regards,</p>';
            body += '<p>Support Team</p>';
            msg.setHtmlBody(body);
            msg.setSubject('Case is goinig to be Escalate');
            msg.setSenderDisplayName('Salesforce Admin');
            messages.add(msg);
        }
        Messaging.sendEmail(messages);
    }
}