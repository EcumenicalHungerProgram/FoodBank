@isTest
private class TimeSlotTriggerTest{
  static testMethod void testAddRemoveTimeSlotRef(){		

    Family__c family = new Family__c(Name='TimeSlotFam1');
    insert family;

    TimeSlot__c timeslotA = new TimeSlot__c(Name='XXX',
                        DateTime__c=DateTime.parse('10/14/2014 2:00 PM'),
                        NumSlots__c=15);
    insert timeslotA;

    TimeSlot__c timeslotB = new TimeSlot__c(Name='XXX',
                        DateTime__c=DateTime.parse('10/14/2014 3:00 PM'),
                        NumSlots__c=25);
    insert timeslotB;

    // Verify that the initial state is as expected.
    timeslotA = [SELECT Allocated__c,NumSlots__c,Free__c
         FROM TimeSlot__c
         WHERE Id = :timeslotA.Id];
    System.assertEquals(null, timeslotA.Allocated__c);
    System.assertEquals(15, timeslotA.NumSlots__c);
    System.assertEquals(15, timeslotA.Free__c);

    timeslotB = [SELECT Allocated__c,NumSlots__c,Free__c
         FROM TimeSlot__c
         WHERE Id = :timeslotB.Id];
    System.assertEquals(null, timeslotB.Allocated__c);
    System.assertEquals(25, timeslotB.NumSlots__c);
    System.assertEquals(25, timeslotB.Free__c);

    Service__c service = new Service__c(TimeSlot__c=timeslotA.Id,
                                          Family__c=family.Id);

    // Cause the Trigger to execute.
    insert service;

    // Verify that the results are as expected.
    timeslotA = [SELECT Allocated__c,NumSlots__c,Free__c
         FROM TimeSlot__c
         WHERE Id = :timeslotA.Id];
    System.assertEquals(1, timeslotA.Allocated__c);
    System.assertEquals(15, timeslotA.NumSlots__c);
    System.assertEquals(14, timeslotA.Free__c);

    timeslotB = [SELECT Allocated__c,NumSlots__c,Free__c
         FROM TimeSlot__c
         WHERE Id = :timeslotB.Id];
    System.assertEquals(null, timeslotB.Allocated__c);
    System.assertEquals(25, timeslotB.NumSlots__c);
    System.assertEquals(25, timeslotB.Free__c);

    // And deleting the service should decrement the value.
    delete service;

    if (false) {
        // Verify that the results are as expected.
        timeslotA = [SELECT Allocated__c,NumSlots__c,Free__c
             FROM TimeSlot__c
             WHERE Id = :timeslotA.Id];
        System.assertEquals(0, timeslotA.Allocated__c);
        System.assertEquals(15, timeslotA.NumSlots__c);
        System.assertEquals(14, timeslotA.Free__c);
    }

    // Undeleting should increment again.
    undelete service;

    // Verify that the results are as expected.
    timeslotA = [SELECT Allocated__c,NumSlots__c,Free__c
         FROM TimeSlot__c
         WHERE Id = :timeslotA.Id];
    System.assertEquals(1, timeslotA.Allocated__c);
    System.assertEquals(15, timeslotA.NumSlots__c);
    System.assertEquals(14, timeslotA.Free__c);

    // Now switch from "A" to "B" and verify both timeslots
    service.TimeSlot__c = timeslotB.Id;
    update service; // execute trigger

    timeslotB = [SELECT Allocated__c,NumSlots__c,Free__c
         FROM TimeSlot__c
         WHERE Id = :timeslotB.Id];
    System.assertEquals(1, timeslotB.Allocated__c);
    System.assertEquals(25, timeslotB.NumSlots__c);
    System.assertEquals(24, timeslotB.Free__c);

    if (false) {
        timeslotA = [SELECT Allocated__c,NumSlots__c,Free__c
             FROM TimeSlot__c
             WHERE Id = :timeslotA.Id];
        System.assertEquals(0, timeslotA.Allocated__c);
        System.assertEquals(15, timeslotA.NumSlots__c);
        System.assertEquals(15, timeslotA.Free__c);
    }
  }
}
