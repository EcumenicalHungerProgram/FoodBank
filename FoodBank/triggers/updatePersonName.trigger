trigger updatePersonName on Person__c (before update, before insert) {
    for (Person__c person : Trigger.new) {
        person.Name = person.LastName__c + ', ' + person.FirstName__c;
    }
}