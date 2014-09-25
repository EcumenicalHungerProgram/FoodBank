trigger updateTimeSlots on Service__c (before update, after update, after delete, after insert, after undelete) {
    set<string> timeslots = new set<string>();

    if (trigger.isInsert) {
        for (Service__c service : Trigger.new)
            timeslots.add(service.TimeSlot__c);
    } else if (trigger.isDelete) {
        for (Service__c service : Trigger.old)
            timeslots.add(service.TimeSlot__c);
    } else if (trigger.isUnDelete) {
        for (Service__c service : Trigger.new)
            timeslots.add(service.TimeSlot__c);
    } else if (trigger.isUpdate) {
        for (Service__c service : Trigger.new)
            timeslots.add(service.TimeSlot__c);
        for (Service__c service : Trigger.old)
            timeslots.add(service.TimeSlot__c);
    }

    if(!timeslots.isEmpty()) {
        TimeSlotHelper helper = new TimeSlotHelper();
        helper.updateAllocatedCount(timeslots);
    }
}