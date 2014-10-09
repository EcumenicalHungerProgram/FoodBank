@isTest 
private class BirthdayListControllerTestClass {
    static testMethod void testDefaultConstructor() {

        BirthdayListController controller = new BirthdayListController();
        
        controller.makePrintable();
        System.assertEquals('April', controller.month);
    }
}