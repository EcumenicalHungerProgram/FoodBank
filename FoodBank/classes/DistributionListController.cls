public class DistributionListController {
  public Date start_date { get; set;}
  public Date end_date { get; set;}
  
  public boolean show_header {get; set;}
  public String render_as {get; set;}
  
  public List<Service__c> services {get; set;}
  public Map<Id, String> heads {get; set;}

  private void getReportData() {
    services = [SELECT id, TimeSlot__r.DateTime__c, BoxType__c, BoxSize__c, TypeOfMeat__c, Adopted__c, Family__r.id, DistributionMethod__c, DateOfService__c
        FROM Service__c
        WHERE TimeSlot__r.DateTime__c >= :start_date
            AND TimeSlot__r.DateTime__c < :end_date];
    
    Set<Id> family_ids = new Set<Id>();
    for (Service__c s: services) {
      family_ids.add(s.Family__r.id);
    }
    heads = HeadOfHouseholdFetcher.fetch(family_ids);
  }

  public DistributionListController() {
    Map<String, String> params = ApexPages.currentPage().getParameters();
    end_date = params.containsKey('end_date') ? Date.parse(params.get('end_date')) : Date.today();
    start_date = params.containsKey('start_date') ? Date.parse(params.get('start_date')) : end_date.addYears(-15);
    render_as = '';
    show_header = true;
    getReportData();
  }
  
  // Dummy action to refresh the page.
  public PageReference makePrintable() {
    return null;
  }
}