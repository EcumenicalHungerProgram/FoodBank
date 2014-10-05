global class DataDeleter {
    
    private Integer currentQueryIdx = -1;
    private String[] deleteQeries = new List<String> {
        'SELECT Id FROM Person__c',
        'SELECT Id FROM Income__c',
        'SELECT Id FROM Expense__c',
        'SELECT Id FROM Verification__c',
        'SELECT Id FROM Phone__c',
        'SELECT Id FROM Note__c',
        'SELECT Id FROM Service__c',
        'SELECT Id FROM GroupService__c',
        'SELECT Id FROM TimeSlot__c',
        'SELECT Id FROM Family__c'
    };
    
    void startNextBatch() {
        currentQueryIdx += 1;
        if (currentQueryIdx >= deleteQeries.size()) {
            System.debug('All objects have been deleted');
            return;
        }
        BatchDelete BDel = new BatchDelete(this);
        BDel.query = deleteQeries[currentQueryIdx];
        ID batchProcessId = Database.executeBatch(BDel);
        System.debug('Started batch process ID: ' + batchProcessId);
    }
    
    public void deleteAllData() {
        startNextBatch();
    }
    
    public void batchFinished(BatchDelete batch) {
        System.debug('Batch finished: ' + batch.query);
    }
}