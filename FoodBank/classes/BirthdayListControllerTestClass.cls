@isTest 
private class BirthdayListControllerTestClass {
    static testMethod void testDefaultConstructor() {

        Family__c family = new Family__c();
        insert family;

        Service__c service = new Service__c(Family__c = family.id,  DateOfService__c = Date.today() - 1);
        insert service;

        Integer current_year = Date.today().year();
        // Sample user is around 13 years old, born on April 1
        Date birthday = date.newinstance(current_year - 13, 4, 1);
        Person__c person = new Person__c(Family__c = family.id, DOB__c = birthday);
        insert person;

        BirthdayListController controller = new BirthdayListController();
        controller.makePrintable();
        controller.birthday_param.Month__c = 'April';
        controller.getReport();
    }
}