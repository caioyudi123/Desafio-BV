trigger VisitTrigger on Visit__c (before update, before insert, after delete) {
    
    if(Trigger.isUpdate || Trigger.isInsert){
    	if(Trigger.isBefore){
            VisitHandler.visitManager(Trigger.new);
        }
    }

    if (Trigger.isDelete) {
        if (Trigger.isAfter) {
            VisitHandler.deletedVisit(Trigger.old);
        }
    }
}