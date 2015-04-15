public class IncomeEthnicityController {
  public Integer num_households { get; set;}
  public Integer num_adults {get; set;}
  public Integer num_children {get; set;}
  public Integer num_people {get; set;}
  public Integer num_foodboxes {get; set;}
  public Integer num_newpeople {get; set;}
  
  public Date start_date { get; set;}
  public Date end_date { get; set;}

  private Map<Integer, Integer> service_counts {get; set;}
  public List<ServiceCountInfo> service_counts_out {get; set;}

  private List<String> income_types {get; set;}
  private List<String> ethnicities {get; set;}
  private Map<String, Integer> income_ethnicity {get; set;}
  private Map<String, Integer> income_ethnicity_totals {get; set;}
  private Integer all_total {get; set;}
  public List<List<String>> income_ethnicity_out {get; set;}
  
  public boolean show_header {get; set;}
  
  private class ServiceCountInfo {
    public Integer one_service {get; set;}
    public Integer two_service {get; set;}
    public Integer three_service {get; set;}
    public Integer four_service {get; set;}
    public Integer more_service {get; set;}
  }

  private void getReportData() {
    AggregateResult[] services_provided = [SELECT Family__r.id, Count(id) sc
        FROM Service__c
        WHERE DateOfService__c >= :start_date AND DateOfService__c < :end_date
        GROUP BY Family__r.id];
    Set<Id> family_ids = new Set<Id>();
    for (AggregateResult ar: services_provided) {
      family_ids.add(ar.id);
      updateServiceCount((Integer)ar.get('sc'));
    }
    createServiceCountsOut();
    Map<Id, Person__c> heads = HeadOfHouseholdFetcher.fetch(family_ids);

    num_households = family_ids.size();
    
    Income__c[] family_incomes = [SELECT Income__c.IncomeSource__c, Income__c.Family__r.id
      FROM Income__c
      WHERE Family__R.id in :family_ids];
    for (Income__c i : family_incomes) {
      String t = maybe(i.IncomeSource__c);
      String e = maybe(getEthnicity(heads.get(i.Family__r.id)));
      income_types.add(t);
      ethnicities.add(e);
      updateIncomeEthnicity(t, e);
    }
    income_types = dedupe(income_types);
    ethnicities = dedupe(ethnicities);
    createIncomeEthnicityTotals();
    createIncomeEthnicityOut();
    
    Person__c[] people_served = [SELECT Age__c FROM Person__c WHERE Family__r.id in :family_ids];
    for (Person__c p : people_served) {
      if (p.Age__c != null) {
        if (p.Age__c < 18) {
          num_children++;
        } else {
          num_adults++;
        }
      }
    }
    num_people = people_served.size();
    
    Service__c[] food_services = [SELECT id from Service__c
       WHERE DateOfService__c >= :start_date AND DateOfService__c < :end_date
       AND Service__c.Type__c = 'Food'];
    num_foodboxes = food_services.size();
    
    Person__c[] new_people = [SELECT id from Person__c
       WHERE CreatedDate >= :start_date AND CreatedDate < :end_date];
    num_newpeople = new_people.size();
  }
  
  private void updateIncomeEthnicity(String t, String e) {
    Integer count = income_ethnicity.get(keyOf(t, e));
    income_ethnicity.put(keyOf(t, e), maybeInt(count) + 1);
  }
  
  private void createIncomeEthnicityTotals() {
  
    for (String e : ethnicities) {
      Integer total = 0;
      for (String t: income_types) {
        total += maybeInt(income_ethnicity.get(keyOf(t, e)));
      }
      income_ethnicity_totals.put(e, total);
      all_total += total;
    }
    for (String t : income_types) {
      Integer total = 0;
      for (String e: ethnicities) {
        total += maybeInt(income_ethnicity.get(keyOf(t, e)));
      }
      income_ethnicity_totals.put(t, total);
    }
  }
  
  private void createIncomeEthnicityOut() {
    List<String> top_labels = new List<String>();
    top_labels.add('Source of Income');
    top_labels.addAll(ethnicities);
    top_labels.add('Total');
    income_ethnicity_out.add(top_labels);
    for (String t : income_types) {
      List<String> output = new List<String>();
      output.add(t);
      for (String e : ethnicities) {
        Integer val = income_ethnicity.get(keyOf(t,e));
        output.add(string.valueof(maybeInt(val)));
      }
      output.add(string.valueof(income_ethnicity_totals.get(t)));
      income_ethnicity_out.add(output);
    }
    List<String> bottom_totals = new List<String>();
    bottom_totals.add('Totals');
    for (String e : ethnicities) {
      bottom_totals.add(string.valueof(income_ethnicity_totals.get(e)));
    }
    bottom_totals.add(string.valueof(all_total));
    income_ethnicity_out.add(bottom_totals);
  }
  
  private void updateServiceCount(Integer i) {
    i = i > 4 ? 5 : i;
    Integer count = service_counts.get(i);
    service_counts.put(i, maybeInt(count) + 1);
  }

  private void createServiceCountsOut() {
    ServiceCountInfo sci = new ServiceCountInfo();
    sci.one_service = maybeInt(service_counts.get(1));
    sci.two_service = maybeInt(service_counts.get(2));
    sci.three_service = maybeInt(service_counts.get(3));
    sci.four_service = maybeInt(service_counts.get(4));
    sci.more_service = maybeInt(service_counts.get(5));
    service_counts_out.add(sci);
  }


  private String maybe(String source) {
    return source == null ? 'UNKNOWN' : source;
  }
  
  private Integer maybeInt(Integer source) {
    return source == null ? 0 : source;
  }
  
  private String keyOf(String t, String e) {
    return t + ':' + e;
  }

  private List<String> dedupe(List<String> source) {
    Set<String> asSet = new Set<String>(source);
    List<String> asList = new List<String>(asSet);
    asList.sort();
    return asList;
  }

  private String getEthnicity(Person__c person) {
    if (person == null) {
      return null;
    }
    if (person.Hispanic__c) {
      return 'Hispanic';
    }
    return maybe(person.Ethnicity__c);
  }

  private void initValues() {
    num_households = 0;
    service_counts = new Map<Integer, Integer>();
    income_types = new List<String>();
    ethnicities = new List<String>();
    income_ethnicity = new Map<String, Integer>();
    income_ethnicity_out = new List<List<String>>();
    income_ethnicity_totals = new Map<String, Integer>();
    all_total = 0;
    service_counts_out = new List<ServiceCountInfo>();
    num_adults = 0;
    num_children = 0;
    num_people = 0;
    num_foodboxes = 0;
    num_newpeople = 0;
    show_header = true;
  }

  public IncomeEthnicityController () {
    Map<String, String> params = ApexPages.currentPage().getParameters();
    end_date = params.containsKey('end_date') ? Date.parse(params.get('end_date')) : Date.today();
    start_date = params.containsKey('start_date') ? Date.parse(params.get('start_date')) : end_date.addYears(-1);
    initValues();
    getReportData();
  }
  
  // Dummy action to refresh the page.
  public PageReference makePrintable() {
    return null;
  }
}