@isTest
private class FamilyTriggerTest {
  static testMethod void testOneFamily() {    

    Family__c family = new Family__c(Name='Family1');
    insert family;
  }
}