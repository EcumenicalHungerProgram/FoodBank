@isTest 
private class DemographicsControllerTestClass {
    static testMethod void testDefaultConstructor() {
        Family__c family = new Family__c();
        insert family;

        Service__c service = new Service__c(Family__c = family.id,  DateOfService__c = Date.today() - 1);
        insert service;

        // Add male youth person
        Person__c p1 = new Person__c(Family__c = family.id, DOB__c = Date.today().addYears(-13), Gender__c = 'Male');
        insert p1;
        
        // Add female elderly person
        Person__c p2 = new Person__c(Family__c = family.id, DOB__c = Date.today().addYears(-66), Gender__c = 'Female');
        insert p2;
        
        // Add blank person
        Person__c p3 = new Person__c(Family__c = family.id);
        insert p3;

        DemographicsController controller = new DemographicsController();
    }
}