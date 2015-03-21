public class DemographicsController {
    
    public Integer num_gender_blank { get; set; }
    public Integer percent_gender_blank {get; set;}
    public Integer num_gender_female { get; set; }
    public Integer percent_gender_female { get; set; }
    public Integer num_gender_male { get; set; }
    public Integer percent_gender_male { get; set; }

    public Integer num_age_blank { get; set; }
    public Integer percent_age_blank { get; set; }
    public Integer num_age_youth { get; set; }
    public Integer percent_age_youth { get; set; }
    public Integer num_age_adult { get; set; }
    public Integer percent_age_adult { get; set; }
    public Integer num_age_elderly { get; set; }
    public Integer percent_age_elderly { get; set; }

    public Integer num_age_non_youth { get; set; }
    public Integer percent_age_non_youth { get; set; }
    public Integer num_people { get; set; }
    public Integer num_households { get; set; }
    
    public Date start_date { get; set; }
    public Date end_date { get; set; }
    
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
            if (String.isEmpty(person.Gender__c))
                num_gender_blank++;
            else if (person.Gender__c.equals('Male'))
                num_gender_male++;
            else if (person.Gender__c.equals('Female'))
                num_gender_female++;
            
            if (person.Age__c == null)
                num_age_blank++;
            else if (person.Age__c < 18)
                num_age_youth++;
            else if (person.Age__c < 65)
                num_age_adult++;
            else
                num_age_elderly++;
        }
        
        num_age_non_youth = num_people - num_age_youth;
        if (num_people != 0) {
            percent_gender_blank = (num_gender_blank * 100) / num_people;
            percent_gender_female = (num_gender_female * 100) / num_people;
            percent_gender_male = (num_gender_male * 100) / num_people;
    
            percent_age_blank = (num_age_blank * 100) / num_people;
            percent_age_youth = (num_age_youth * 100) / num_people;
            percent_age_adult = (num_age_adult * 100) / num_people;
            percent_age_elderly = (num_age_elderly * 100) / num_people;
    
            percent_age_non_youth = (num_age_non_youth * 100) / num_people;
        }
    }
    
    public DemographicsController() {
        num_gender_blank = 0;
        percent_gender_blank = 0;
        num_gender_female = 0;
        percent_gender_female = 0;
        num_gender_male = 0;
        percent_gender_male = 0;

        num_age_blank = 0;
        percent_age_blank = 0;
        num_age_youth = 0;
        percent_age_youth = 0;
        num_age_adult = 0;
        percent_age_adult = 0;
        num_age_elderly = 0;
        percent_age_elderly = 0;

        num_age_non_youth = 0;
        num_households = 0;
        num_people = 0;
        
        Map<String, String> params = ApexPages.currentPage().getParameters();
        end_date = params.containsKey('end_date') ? Date.parse(params.get('end_date')) : Date.today();
        start_date = params.containsKey('start_date') ? Date.parse(params.get('start_date')) : end_date.addYears(-1);
        
        getReportData();
    }
}