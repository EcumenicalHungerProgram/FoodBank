public with sharing class TimeSlotHelper {

    final Integer maxTimesInSlot = 200;
    final Integer maxResultSetLen = 50000;
    final Integer maxTimeSlotIDs = maxResultSetLen / maxTimesInSlot;

    private static Set<String> extractSubset(Set<String> full, Integer numVals) {
        List<String> fullList = new List<String>(full);
        Integer numMoved = 0;
        Set<String> subset = new Set<String>();
        while (numMoved < numVals && !full.isEmpty()) {
            String val = fullList.get(numMoved);
            subset.add(val);
            full.remove(val);
            numMoved++;
        }
        return subset;
    }

    // Update the allocated counts for the supplied set of TimeSlot ID's
    public void updateAllocatedCount(set<string> timeslotIDs) {

        if (timeslotIDs == null || timeslotIDs.isEmpty()) {
            return;
        }

        if (timeslotIDs.size() > maxTimeSlotIDs) {
            while (!timeslotIDs.isEmpty()) {
                updateAllocatedCount(extractSubset(timeslotIDs, maxTimeSlotIDs));
            }
            return;
        }

        // First sum up all timeslots in use by any service
        list<Service__c> serviceIDs = new list<Service__c>();
        serviceIDs = [SELECT TimeSlot__c
                    FROM Service__c
                    WHERE TimeSlot__c IN :timeslotIDs];

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
        for (string slotID : timeSlotIDToCountMap.keySet()) {
            if (String.isEmpty(slotID))
                continue;
            slotTemp = new TimeSlot__c();
            slotTemp.ID = slotID;
            slotTemp.Allocated__c = timeSlotIDToCountMap.get(slotID);
            slotUpdateList.add(slotTemp);
        }
        if (!slotUpdateList.isEmpty()) {
            update slotUpdateList;
        }
    }
}