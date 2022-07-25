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

// O campo "Number of Visits to Plan", não poderá receber um valor maior que 5 e só
// poderá ser alterado na inclusão da Account;
// Ao incluir um registro de Account com o Tipo de Registro "Visit Account" (E APENAS 
// esse Tipo de Registro), deverá criar automaticamente os registros no objeto "Visit" 
// conforme a quantidade no campo "Number of Visits to Plan", o campo "Status" no 
// objeto "Visit" deverá receber o valor "Open";
// O campo "Cost of Visits Realized", deverá apresentar a soma dos custos das visitas 
// realizadas (Status = "Realized") e que são relacionadas a Account;
// O campo "Number of Visits Realized", deverá apresentar a quantidade de visitas 
// realizadas (Status ="Realized") e que são relacionadas a Account;
// O campo "Total Cost of Visits", deverá apresentar a soma de todas as visitas 
// relacionadas a Account;
// O campo "Average Cost of Visits Realized", deverá apresentar a média de custo das 
// visitas realizadas (Status = "Realized") e que são relacionadas a Account;
// ATENÇÃO: Caso o usuário inclua, altere ou exclua uma visita, os valores nos campos 
// "Number of Visits Realized", "Cost of Visits Realized", "Total Cost of Visits" e "Average 
// Cost of Visits Realized" deverão ser atualizados na Account;
// Todos os cálculos deverão ser feitos a partir de uma trigger;
// ATENÇÃO: A Visita poderá ter a Conta(AccountId) alterada! Não esqueça de atualizar 
// os valores das Accounts!