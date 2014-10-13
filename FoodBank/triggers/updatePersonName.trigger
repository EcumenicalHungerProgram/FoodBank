trigger updatePersonName on Person__c (before update, before insert) {
    for (Person__c person : Trigger.new) {

        if (person.LastName__c == null && person.FirstName__c == null) {
            person.Name = '<unknown>';
            return;
        }

        String lastName;
        if (person.LastName__c != null)
            lastName = person.LastName__c;
        else
            lastName = '<unknown>';

        if (person.FirstName__c != null)
            person.Name = lastName + ', ' + person.FirstName__c;
        else
            person.Name = lastName + ', <unknown>';
    }
}