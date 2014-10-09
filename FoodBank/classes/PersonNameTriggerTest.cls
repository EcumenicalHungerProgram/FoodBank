@isTest
private class PersonNameTriggerTest{
  static testMethod void testUpdatePersonName(){		

    Family__c family = new Family__c(Name='PersonFam1');
    insert family;

    Person__c person = new Person__c(Family__c=family.Id,
                                    FirstName__c='Joe',
                                    LastName__c='Smith');

    // Cause the Trigger to execute.
    insert person;

    // Verify that the results are as expected.
    person = [SELECT Name
         FROM Person__c
         WHERE Family__c = :family.Id];
    System.assertEquals('Smith, Joe', person.Name);

    delete person;
  }
}