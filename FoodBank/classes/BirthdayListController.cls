public class BirthdayListController {

    private class BirthdayInfo {
        public String     name {get; set;}
        public Date       dob {get; set;}
        public Decimal    age {get; set;}
        public String     gender {get; set;}
        public String     file_no {get; set;}
        public String     relation {get; set;}
        public Date       last_service {get; set;}
        public String     phone {get; set;}
    }

    public Date start_date { get; set; }
    public Date end_date { get; set; }
    public Integer birthday_month { get; set; }
    
    public Boolean show_header { get; set; }
    
    public List<BirthdayInfo> birthdays { get; set; }

    private void getReportData() {
        AggregateResult[] families_served = [SELECT Family__r.id FROM Service__c WHERE DateOfService__c >= :start_date AND DateOfService__c < :end_date GROUP BY Family__r.id];
        List<Id> family_ids = new List<Id>();
        for (AggregateResult ar : families_served) {
            family_ids.add(ar.id);
        }
        
        // File home phone's for the families
        Map<String, String> family_phones = new Map<String, String>();
        Phone__c[] phones = [SELECT Number__c,Type__c,Family__r.ID FROM Phone__c WHERE Family__r.id in :family_ids];
        for (Phone__c phone : phones) {
            if (phone.Type__c != null && phone.Type__c.equals('Home')) {
                family_phones.put(phone.Family__r.ID, phone.Number__c);
            }
        }
        
        Person__c[] people_served = [SELECT Gender__c,Age__c,DOB__c,Relationship__c,LastName__c,Family__r.ID FROM Person__c WHERE Family__r.id in :family_ids];
        
        for (Person__c person : people_served) {
            if (person.Age__c >= 4 && person.Age__c <= 14 && person.DOB__c != null && person.DOB__c.month() == birthday_month) {
                BirthdayInfo birthday = new BirthdayInfo();
                birthday.name = person.LastName__c;
                birthday.dob = person.DOB__c;
                birthday.age = person.Age__c;
                birthday.gender = person.Gender__c;
                birthday.relation = person.Relationship__c;
                birthday.phone = family_phones.get(person.Family__r.ID);
                birthdays.add(birthday);
            }
        }
    }
    
    // Dummy action to refresh the page.
    public PageReference makePrintable() {
        return null;
    }
    
    public String month {
        get {
            Date d = Date.newInstance(2000, birthday_month, 1);
            DateTime dt = DateTime.newInstance(d, Time.newInstance(0, 0, 0, 0));
            return dt.format('MMMMM');
        }
    }
    
    public BirthdayListController() {
        birthdays = new List<BirthdayInfo>();
        Map<String, String> params = ApexPages.currentPage().getParameters();
        end_date = params.containsKey('end_date') ? Date.parse(params.get('end_date')) : Date.today();
        start_date = params.containsKey('start_date') ? Date.parse(params.get('start_date')) : end_date.addYears(-15);
        show_header = true;
        birthday_month = 4;
        getReportData();
    }
}