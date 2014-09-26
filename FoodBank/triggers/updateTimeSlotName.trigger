trigger updateTimeSlotName on TimeSlot__c (before update, before insert) {
    for (TimeSlot__c timeslot : Trigger.new) {
        Time midnight = Time.newInstance(0, 0, 0, 0);
        Time t = timeslot.DateTime__c.time();
        String d;
        if (t == midnight)
            d = timeslot.DateTime__c.format('yyyy-MM-dd');
        else
            d = timeslot.DateTime__c.format('yyyy-MM-dd hh:mm a');
        if (timeslot.FamilySize__c != null)
            timeslot.Name = d + ' ' + timeslot.Type__c + ' ' + timeslot.FamilySize__c;
        else
            timeslot.Name = d + ' ' + timeslot.Type__c;
    }
}