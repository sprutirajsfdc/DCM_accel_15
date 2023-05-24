/**
@Description :After the case is escalated, schedule an Apex job to perform certain actions on the case after a delay of 9 hours.
@Author : Subba Reddy
@Last Modified By : Subba Reddy
@Last Modified On: 28/04/2023
@Modification Log:
Ver    Date            Author          LastModification
1.0   26/04/2023     Subba Reddy        Initial Version
**/
public class EscalationTriggerHandler {
    
    public static void scheduleEscalation(List<Case> newCases) {
        for (Case c : newCases) {
            if (c.status!='Escalated' && c.Status !='Closed') { // only schedule escalation job for non-escalated cases
                String sDay;
                String sHour;
                if(integer.valueOf(c.CreatedDate.hour() + 9) > 23){// check if adding 9 to the hour exceeds 23
                    sHour = string.valueOf(c.CreatedDate.hour() + (9-24)); // subtract 24 from the sum to wrap around to the next day
                    sDay = String.valueOf(c.CreatedDate.day()+1);// increment the day by 1
                    system.debug('sHour...'+sHour);//log the adjusted hour value
                }
                else{
                    sHour = String.valueOf(c.CreatedDate.hour() + 9);// add 9 to the hour
                    sDay = String.valueOf(c.CreatedDate.day());// keep the day the same
                    system.debug('Else sHour' + sHour);// log the hour value
                }
                String sMinute = String.valueOf(c.CreatedDate.minute());// get the minute value
                String sMonth = String.valueOf(c.CreatedDate.month());// get the month value
                String sYear = String.valueOf(c.CreatedDate.year());// get the year value
                String sSec = String.valueOf(c.CreatedDate.second());// get the second value
                String sch = sSec + ' ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;// construct the cron expression
                system.debug('sch...'+sch);
                String jobID = System.schedule('Dynamic Case Escalation Schedule Date and Time -- ' + c.Id, sch, new caseEscalation(c, c.Id));// schedule the escalation job
            }
        }
    }
}