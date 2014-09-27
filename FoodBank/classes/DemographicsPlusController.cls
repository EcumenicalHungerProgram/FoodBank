public class DemographicsPlusController {

    private class GenderInfo {
        public Integer    male {get; set;}
        public Integer    female {get; set;}
        public Integer    unknown {get; set;}
        public Integer    min_age;
        public Integer    max_age;
        public String     title {get; set;}
        public Integer    total {
            get { return male + female + unknown; }
        }
        
        GenderInfo(String title, Integer min, Integer max) {
            male = 0;
            female = 0;
            unknown = 0;
            this.title = title;
            min_age = min;
            max_age = max;
        }
    }

    private Integer k_UnknownAge = -1;
    
    List<GenderInfo> totals = new List<GenderInfo>();
    List<GenderInfo> children = new List<GenderInfo>();
    
    public Integer num_households { get; set; }
    public Integer num_people;
    public Integer num_children { get; set; }
    public Integer num_adults { get { return num_people - num_children; } }
    
    public Boolean show_header { get; set; }
    public String render_as { get; set; }
    
    public Date start_date { get; set; }
    public Date end_date { get; set; }
    
    public List<GenderInfo> stats_all { get { return totals; } }
    public List<GenderInfo> stats_children { get { return children; } }

    private void incrementStats(List<GenderInfo> infos, Person__c person) {
        for (GenderInfo info : infos) {
            
            Decimal age = person.Age__c;
            if (age == null)
                age = k_UnknownAge;
            
            if (age >= info.min_age && age <= info.max_age) {
                if (person.Gender__c == null)
                    info.unknown++;
                else if (person.Gender__c.equals('Male'))
                    info.male++;
                else if (person.Gender__c.equals('Female'))
                    info.female++;
                else
                    info.unknown++;
            }
        }
    }
    
    private void getReportData() {
        AggregateResult[] families_served = [SELECT Family__r.id FROM Service__c WHERE DateOfService__c >= :start_date AND DateOfService__c < :end_date GROUP BY Family__r.id];
        num_households = families_served.size();
        List<Id> family_ids = new List<Id>();
        for (AggregateResult ar : families_served) {
            family_ids.add(ar.id);
        }
        
        Person__c[] people_served = [SELECT Gender__c,Age__c FROM Person__c WHERE Family__r.id in :family_ids];
        num_people = people_served.size();
        
        for (Person__c person : people_served) {
            if (person.Age__c < 18)
                num_children++;
            incrementStats(totals, person);
            incrementStats(children, person);
        }
    }
    
    // Dummy action to refresh the page.
    public PageReference makePrintable() {
        return null;
    }
        
    public DemographicsPlusController() {
        
        end_date = Date.today();
        start_date = end_date;
        start_date = start_date.addYears(-1);
        
        num_households = 0;
        num_people = 0;
        num_children = 0;
        
        show_header = true;
        render_as = 'html';
        
        totals.add(new GenderInfo('Children (Age 0-17)', 0, 17));
        totals.add(new GenderInfo('Adults (18-64)', 18, 64));
        totals.add(new GenderInfo('Seniors (65+)', 65, 200));
        totals.add(new GenderInfo('Unknown', k_UnknownAge, k_UnknownAge));

        children.add(new GenderInfo('Age 0-2', 0, 2));
        children.add(new GenderInfo('Age 3-5', 3, 5));
        children.add(new GenderInfo('Age 6-7', 6, 7));
        children.add(new GenderInfo('Age 8-10', 8, 10));
        children.add(new GenderInfo('Age 11-17', 11, 17));
        
        getReportData();
    }
}