public class HolidayGiveawayController {
 
  public boolean show_header {get; set;}
  public String render_as {get; set;}
 
  public Service__c service {get; set;}
  public List<Phone__c> phones {get; set;}
  public List<Person__c> people {get; set;}
  public String head {get; set;}

  private void getReportData(Id service_id) {
    if (service_id == null)
      return;
    service = [SELECT id, BoxType__c, BoxSize__c, TypeOfMeat__c, Adopted__c ,DistributionMethod__c,
        TimeSlot__r.DateTime__c,
        Family__r.Name, Family__r.id, Family__r.AddressCombined__c, Family__r.Ethnicity__c, Family__r.SpecialNeeds__c,
                Family__r.NumPeople__c, Family__r.HolidayComments__c
        FROM Service__c
        WHERE id = :service_id];
    phones = [SELECT Number__c, Type__c, BestTime__c
        FROM Phone__c
        WHERE Family__r.id = :service.Family__r.id];
    people = [SELECT FirstName__c, LastName__c, Gender__c, DOB__c, Age__c, Relationship__c, Guest__c, ClothingSize__c
        FROM Person__c
        WHERE Family__r.id = :service.Family__r.id];
    head = HeadOfHouseholdFetcher.fetchSingle(service.Family__r.id);
  }

  public HolidayGiveawayController() {
    render_as = '';
    show_header = true;
    Map<String, String> params = ApexPages.currentPage().getParameters();
    Id service_id = null;
    if (params.containsKey('id')) {
        service_id = Id.valueof(params.get('id'));
    }
    getReportData(service_id);
  }
  
  // Dummy action to refresh the page.
  public PageReference makePrintable() {
    return null;
  }
}