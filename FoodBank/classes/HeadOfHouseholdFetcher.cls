public class HeadOfHouseholdFetcher {
  
  public static Map<Id, String> fetch(Set<Id> family_ids) {
    List<Person__c> people = [SELECT FirstName__c, LastName__c, Relationship__c, Person__c.Family__r.id
        FROM Person__c
        WHERE Person__c.Family__r.id in :family_ids];
    Map<Id, String> heads = new Map<Id, String>();
    for (Id i : family_ids) {
      heads.put(i, '');
    }
    for (Person__c p : people) {
      Id family_id = p.Family__r.id;
      String entry = heads.get(family_id);
      if (String.isBlank(entry) || p.Relationship__c == 'HEAD') {
        heads.put(family_id, p.FirstName__c + ' ' + p.LastName__c);
      }
    }
    return heads;
  }
}