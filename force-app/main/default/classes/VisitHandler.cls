public with sharing class VisitHandler {
    
    public static void visitManager(List<Visit__c> lstVisit){
        
        for(Visit__c objVisit : lstVisit){
            
            Account objAcc = [SELECT Id, Cost_of_Visits_Realized__c, Number_of_Visits_Realized__c, Total_Cost_of_Visits__c, Average_Cost_of_Visits_Realized__c FROM Account WHERE Id =: objVisit.AccountId__c];
            
            if(objAcc.Number_of_Visits_Realized__c == null){
                objAcc.Number_of_Visits_Realized__c = 0;
            }
            if(objAcc.Cost_of_Visits_Realized__c == null){
                objAcc.Cost_of_Visits_Realized__c = 0;
            }
            if(objAcc.Average_Cost_of_Visits_Realized__c == null){
                objAcc.Average_Cost_of_Visits_Realized__c = 0;
            }
            if(objAcc.Total_Cost_of_Visits__c == null){
                objAcc.Total_Cost_of_Visits__c = 0;
            }

            if(objVisit.Cost__c != null && objAcc.Number_of_Visits_Realized__c != null){

                if(objVisit.Status__c == 'Realized'){
                    
                    objAcc.Cost_of_Visits_Realized__c += objVisit.Cost__c;
                    objAcc.Number_of_Visits_Realized__c += 1;
                    objAcc.Average_Cost_of_Visits_Realized__c = (objAcc.Cost_of_Visits_Realized__c / objAcc.Number_of_Visits_Realized__c);
                    
                    upsert objAcc;
                }
    
                objAcc.Total_Cost_of_Visits__c += objVisit.Cost__c; 
                upsert objAcc;
            }
        }
    }

    public static void deletedVisit(List<Visit__c> lstVisit){
        for(Visit__c objVisit : lstVisit){
            Account objAcc = [SELECT Id, Cost_of_Visits_Realized__c, Number_of_Visits_Realized__c, Total_Cost_of_Visits__c, Average_Cost_of_Visits_Realized__c FROM Account WHERE Id =: objVisit.AccountId__c];
            
            objAcc.Cost_of_Visits_Realized__c -= objVisit.Cost__c;
            objAcc.Number_of_Visits_Realized__c -= 1;
            objAcc.Average_Cost_of_Visits_Realized__c = (objAcc.Cost_of_Visits_Realized__c / objAcc.Number_of_Visits_Realized__c);
            objAcc.Total_Cost_of_Visits__c -= objVisit.Cost__c;
            update objAcc;
        }
    }
}