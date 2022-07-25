public class AccountHandler {
    public static void createVisitAccount(List<Account> lstNewAcc){
        
        RecordType AccountRecordType = [	SELECT Id
                                        FROM RecordType
                                        WHERE SobjectType = 'Account' AND Name = 'Visit Account'
                                        LIMIT 1];

        for(Account objAccount : lstNewAcc){

            if(objAccount.RecordTypeId == AccountRecordType.Id){

                for(Integer i = 0; i < objAccount.Number_of_Visits_to_Plan__c; i++){

                    Visit__c objVisit = new Visit__c();
                    objVisit.Status__c = 'Open';
                    objVisit.AccountId__c = objAccount.Id;
                    upsert objVisit;
                }
            }
        }
    }
}