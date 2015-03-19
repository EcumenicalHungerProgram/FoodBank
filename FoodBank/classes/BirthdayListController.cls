public class BirthdayListController {

    private class BirthdayInfo {
        public String     name {get; set;}
        public String     family_name {get; set;}
        public Id         family_id {get; set;}
        public Date       dob {get; set;}
        public Decimal    age {get; set;}
        public String     gender {get; set;}
        public String     file_no {get; set;}
        public String     relation {get; set;}
        public Date       last_service {get; set;}
        public String     phone {get; set;}
    }

    private Map<String, Integer> monthsMap = new Map<String, Integer>{
        'January' => 1,
        'February' => 2,   
        'March' => 3,
        'April' => 4,
        'May' => 5,
        'June' => 6,
        'July' => 7,
        'August' => 8,
        'September' => 9,
        'October' => 10,
        'November' => 11,
        'December' => 12
    };

    public Date start_date { get; set; }
    public Date end_date { get; set; }

    public Integer birthday_month { get; set; }
    public BirthdayParam__c birthday_param {get; set;}
    public Boolean has_month {get; set;}
    
    public Boolean show_header { get; set; }
    
    public List<BirthdayInfo> birthdays { get; set; }

    private void getReportData() {
        birthdays = new List<BirthdayInfo>();
        
        Map<String, String> params = ApexPages.currentPage().getParameters();
        end_date = params.containsKey('end_date') ? Date.parse(params.get('end_date')) : Date.today();
        start_date = params.containsKey('start_date') ? Date.parse(params.get('start_date')) : end_date.addYears(-15);

        AggregateResult[] families_served = [SELECT Family__r.id FROM Service__c WHERE DateOfService__c >= :start_date AND DateOfService__c < :end_date GROUP BY Family__r.id];
        Set<Id> family_ids = new Set<Id>();
        for (AggregateResult ar : families_served) {
            family_ids.add(ar.id);
        }
        
        Person__c[] people_served = [SELECT Gender__c, Age__c, DOB__c, Relationship__c, FirstName__c, LastName__c, Family__r.ID, Family__r.Name, Family__r.Phone__c
                FROM Person__c WHERE Family__r.id in :family_ids];
        
        for (Person__c person : people_served) {
            if (person.Age__c >= 4 && person.Age__c <= 14 && person.DOB__c != null && person.DOB__c.month() == birthday_month) {
                BirthdayInfo birthday = new BirthdayInfo();
                birthday.name = person.FirstName__c + ' ' + person.LastName__c;
                birthday.dob = person.DOB__c;
                birthday.age = person.Age__c;
                birthday.gender = person.Gender__c;
                birthday.relation = person.Relationship__c;
                birthday.family_id = person.Family__r.ID;
                birthday.family_name = person.Family__r.Name;
                birthday.phone = person.Family__r.Phone__c;
                birthdays.add(birthday);
            }
        }
    }
    
    // Dummy action to refresh the page.
    public PageReference makePrintable() {
        return null;
    }

    public BirthdayListController() {
        birthday_param = new BirthdayParam__c();
        has_month = false;
        birthday_month = 1;
        show_header = true;
        getReportData();
    }
    
  
    public PageReference getReport() {
        birthday_month = monthsMap.get(birthday_param.Month__c);
        has_month = true;
        getReportData();
        return null;
    }
}