public class ServiceHistoryController{

  public Date start_date { get; set;}
  public Date end_date { get; set;}
  
  public boolean show_header {get; set;}
  public List<Service__c> services {get; set;}

  private void getReportData() {
    services = [SELECT id, BoxType__c, BoxSize__c, TypeOfMeat__c, Adopted__c, Family__r.Name, Type__c, DateOfService__c, DistributionMethod__c, TimeSlot__r.DateTime__c
        FROM Service__c
        WHERE DateOfService__c >= :start_date AND DateOfService__c < :end_date];
  }
  
  public ServiceHistoryController() {
    Map<String, String> params = ApexPages.currentPage().getParameters();
    end_date = params.containsKey('end_date') ? Date.parse(params.get('end_date')) : Date.today();
    start_date = params.containsKey('start_date') ? Date.parse(params.get('start_date')) : end_date.addYears(-1);
    show_header = true;
    getReportData();
  }
  
  // Dummy action to refresh the page.
  public PageReference makePrintable() {
    return null;
  }
}