/**
@Description :This class assigns cases to different shift queues based on custom-defined shift times.
@Author :     Surendranath Reddy
@Last Modified By : Subba Reddy
@Last Modified On: 20/04/2023
@Modification Log:
Ver    Date            Author                 LastModification
1.0   26/04/2023     Surendranath Reddy        Initial Version
**/
public class AssignCasetoShiftQueue {
    // Parse the time value from a string and return as a Time object
    private static Time parseTime(String timeValue) {
        String[] strTimeSplit = timeValue.split(':');
        Time timeChange = Time.newInstance(Integer.valueOf(strTimeSplit[0]), Integer.valueOf(strTimeSplit[1]), 0, 0);  
        return timeChange;
    }
    // Assign cases to shift queues based on certain conditions
    public static void casetoshiftqueue(List<Case> caseList){
        // Get the shift times from custom settings
        ShiftTime__c shiftTimes = ShiftTime__c.getInstance();
        // Parse the shift start and end times
        Time shift1StartTime = parseTime(shiftTimes.Shift1StartTime__c);
        Time shift1EndTime = parseTime(shiftTimes.Shift1EndTime__c);
        Time shift2StartTime = parseTime(shiftTimes.Shift2StartTime__c);
        Time shift2EndTime = parseTime(shiftTimes.Shift2EndTime__c);
        Time shift3StartTime = parseTime(shiftTimes.Shift3StartTime__c);
        Time shift3EndTime = parseTime(shiftTimes.Shift3EndTime__c);
        
        for (Case c : caseList) {
            if((c.Priority == 'Low' || c.Priority == 'Medium') && c.My_Skill__c == null && c.Product__c == null){
                // Get the current time
                Time currentTime = Time.newInstance(
                    Datetime.now().hour(),
                    Datetime.now().minute(),
                    Datetime.now().second(),
                    0
                );
                
                if (currentTime >= shift1StartTime && currentTime <= shift1EndTime) { 
                    // Assign to morning shift queue
                    c.OwnerId = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name ='Morning Shift'].Id;
                    c.Initial_Shift_Name__c = 'Morning Shift';
                    System.debug('c.OwnerId' + c.OwnerId);
                } else if (currentTime >= shift2StartTime && currentTime <= shift2EndTime) { 
                    // Assign to afternoon shift queue
                    c.OwnerId = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name ='Afternoon Shift'].Id;
                    c.Initial_Shift_Name__c = 'Afternoon Shift';
                    System.debug('c.OwnerId' + c.OwnerId);
                } else { 
                    // Assign to night shift queue
                    c.OwnerId = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name ='Night Shift'].Id;
                    c.Initial_Shift_Name__c = 'Night Shift';
                    System.debug('c.OwnerId' + c.OwnerId);
                }
            }
        }
    }
}