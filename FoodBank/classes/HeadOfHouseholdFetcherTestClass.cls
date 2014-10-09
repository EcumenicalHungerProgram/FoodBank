@isTest 
private class HeadOfHouseholdFetcherTestClass {
    static testMethod void testDefaultConstructor() {

        HeadOfHouseholdFetcher fetcher = new HeadOfHouseholdFetcher();
    }

    static testMethod void testFetchOne() {

        Family__c family = new Family__c(Name='XXX');
        insert family;
        
        Person__c person = new Person__c(Family__c=family.Id);
        insert person;
        
        HeadOfHouseholdFetcher.fetchSingle(family.ID);
    }
}