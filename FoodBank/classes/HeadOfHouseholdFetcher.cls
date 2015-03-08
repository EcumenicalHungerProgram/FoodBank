public class HeadOfHouseholdFetcher {

  public static Map<Id, Person__c> fetch(Set<Id> family_ids) {
    List<Person__c> people = [SELECT FirstName__c, LastName__c, Relationship__c, Person__c.Family__r.id, Ethnicity__c
        FROM Person__c
        WHERE Person__c.Family__r.id in :family_ids];
    Map<Id, Person__c> heads = new Map<Id, Person__c>();
    for (Person__c p : people) {
      Id family_id = p.Family__r.id;
      Person__c entry = heads.get(family_id);
      if (entry == NULL || p.Relationship__c == 'HEAD') {
        heads.put(family_id, p);
      }
    }
    return heads;
  }
  
  public static Person__c fetchSingle(Id family_id) {
    Set<Id> ids = new Set<Id>();
    ids.add(family_id);
    return fetch(ids).get(family_id);
  }
}