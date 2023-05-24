/**
@Description :This schedulable Apex class automatically assigns cases to different shifts based on their respective shift times. 
               Each case is assigned to the appropriate shift queue according to the time boundaries defined for each shift.
@Author :     Surendranath Reddy
@Last Modified By : Surendranath Reddy
@Last Modified On: 21/04/2023
@Modification Log:
Ver    Date            Author           LastModification
1.0   26/04/2023     Surendranath Reddy        Initial Version
**/
public class AssignCasesToShiftQueueScheduler implements Schedulable
{
     // Method to parse time value from string format
    private static time parseTime(String timeValue) {
        
        String[] strTimeSplit = timeValue.split(':');
        Time timeChange = Time.newInstance(Integer.valueOf(strTimeSplit[0]) ,Integer.valueOf(strTimeSplit[1]) ,0 ,0);  
        return timeChange;
    }
    // Scheduler execution method
    public void execute(SchedulableContext sc)
    {
        // Retrieve ShiftTime__c custom settings
        ShiftTime__c shiftTimes = ShiftTime__c.getInstance();
        // Parse shift start and end times
        Time shift1StartTime = parseTime(shiftTimes.Shift1StartTime__c);
        system.debug('shift1StartTime' + shift1StartTime);
        Time shift1EndTime = parseTime(shiftTimes.Shift1EndTime__c);
        system.debug('shift1EndTime' + shift1EndTime);
        Time shift2StartTime = parseTime(shiftTimes.Shift2StartTime__c);
         system.debug('shift2StartTime' + shift2StartTime);
        Time shift2EndTime = parseTime(shiftTimes.Shift2EndTime__c);
        Time shift3StartTime = parseTime(shiftTimes.Shift3StartTime__c);
        Time shift3EndTime = parseTime(shiftTimes.Shift3EndTime__c);
        // Get the Morning shift queue
        Group morningShiftQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Morning Shift'];
        // Get the afternoon shift queue
        Group afternoonShiftQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Afternoon Shift'];
        // Get the night shift queue
        Group nightShiftQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Night Shift'];
        // Create a set of queue Ids
        set<id> ids = new set<id>();
        ids.add(morningShiftQueue.Id);
        ids.add(afternoonShiftQueue.Id);
        ids.add(nightShiftQueue.Id);
        // Get the cases that are in the morning shift queue and not closed yet
        List<Case> allShiftCases = [SELECT Id, OwnerId , Status FROM Case WHERE Status = 'New' AND OwnerId IN: ids];
        // List to store cases that will be updated with new owners
        List<Case> AllShiftsUpdatedCases = new List<Case>();
        // Iterate through the cases and update owner based on current time and shift boundaries
        for(Case cs: allShiftCases){
            Time currentTime = Time.newInstance(
                    Datetime.now().hour(),
                    Datetime.now().minute(),
                    Datetime.now().second(),
                    0
                );
            if(currentTime >= Shift1StartTime && currentTime < Shift1EndTime){
                cs.OwnerId = morningShiftQueue.Id;
                AllShiftsUpdatedCases.Add(cs);
            }
            Else if (currentTime >= Shift2StartTime && currentTime < Shift2EndTime){
                cs.OwnerId = afternoonShiftQueue.Id;
                AllShiftsUpdatedCases.Add(cs);
            }
            Else if (currentTime >= Shift3StartTime && currentTime < Shift3EndTime){
                cs.OwnerId = nightShiftQueue.Id;
                AllShiftsUpdatedCases.Add(cs);
            }
        }
          // Update cases if there are any changes
        if(!AllShiftsUpdatedCases.IsEmpty()){
            update AllShiftsUpdatedCases;
        }
    }
}