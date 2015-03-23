public with sharing class AddressInfoHelper {

    // Update the address info for the supplied set of Family ID's
    public void updateAddressInfo(set<string> familyIDs) {
        List<Family__c> families = [SELECT AddressCombined__c
                                    FROM Family__c
                                    WHERE ID IN :familyIDs];
        Set<String> addressMD5s = new Set<String>();
        for (Family__c family : families) {     
            addressMD5s.add(EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(family.AddressCombined__c))));
        }
    }
}