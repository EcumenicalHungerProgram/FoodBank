trigger updateTimeSlotName on TimeSlot__c (before update, before insert) {
    for (TimeSlot__c timeslot : Trigger.new) {
        if (timeslot.FamilySize__c != null)
            timeslot.Name = timeslot.DateTime__c.format() + ' ' + timeslot.Type__c + ' ' + timeslot.FamilySize__c;
        else
            timeslot.Name = timeslot.DateTime__c.format() + ' ' + timeslot.Type__c;
    }
}