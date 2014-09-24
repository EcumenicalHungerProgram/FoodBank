public with sharing class TimeSlotHelper {

    // Update the allocated counts for the supplied set of TimeSlot ID's
    public void updateAllocatedCount(set<string> timeslotIDs) {
         
        if(timeslotIDs == null || timeslotIDs.isEmpty()){   
            return;
        }
        
        // First sum up all timeslots in use by any service
        list<Service__c> serviceIDs = new list<Service__c>();
        serviceIDs = [Select TimeSlot__c
                    From Service__c
                    Where TimeSlot__c = :timeslotIDS];

        integer totalCount;
        map<string, integer> timeSlotIDToCountMap = new map<string, integer>();       
        for (Service__c serviceItem : serviceIDs) {
            if (timeSlotIDToCountMap.containsKey(serviceItem.TimeSlot__c))
                totalCount = timeSlotIDToCountMap.get(serviceItem.TimeSlot__c);
            else
                totalCount = 0;
            totalCount++;
            timeSlotIDToCountMap.put(serviceItem.TimeSlot__c, totalCount);
        }
        
        // Now update the allocated field in the TimeSlot object
        list<TimeSlot__c> slotUpdateList = new list<TimeSlot__c>();
        TimeSlot__c slotTemp;
        for(string slotID : timeSlotIDToCountMap.keySet()) {
            if (String.isEmpty(slotID))
                continue;
            slotTemp = new TimeSlot__c();
            slotTemp.ID = slotID;
            slotTemp.Allocated__c = timeSlotIDToCountMap.get(slotID);
            slotUpdateList.add(slotTemp);
        }
        if(!slotUpdateList.isEmpty()) {
            update slotUpdateList;
        }
    }
}