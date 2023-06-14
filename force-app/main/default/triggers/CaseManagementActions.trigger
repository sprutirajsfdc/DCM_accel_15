trigger CaseManagementActions on Case (before insert, after insert) {
if(trigger.Isbefore && trigger.isInsert){
        skillBasedCaseApexClass.assignCases(trigger.new);
    }
    if(trigger.Isbefore && trigger.isInsert){
        CaseActionsApexClass.assignCases(trigger.new);
    }
    if(Trigger.IsBefore && Trigger.IsInsert){
        AssignCasetoShiftQueue.casetoshiftqueue(Trigger.New);
    } 
    if(trigger.IsAfter && trigger.isInsert){
        EscalationTriggerHandler.scheduleEscalation(trigger.new);
    } 
     if(trigger.IsAfter && trigger.isInsert){
        BeforeEscalationMailHandler.schedulebeforeEscalation(trigger.new);
    } 
}