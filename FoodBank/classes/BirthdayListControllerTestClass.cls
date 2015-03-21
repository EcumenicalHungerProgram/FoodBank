@isTest 
private class BirthdayListControllerTestClass {
    static testMethod void testDefaultConstructor() {

        BirthdayListController controller = new BirthdayListController();
        
        controller.makePrintable();
        controller.birthday_param.Month__c = 'April';
        controller.getReport();
    }
}