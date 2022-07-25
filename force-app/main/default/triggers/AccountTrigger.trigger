trigger AccountTrigger on Account (after insert, after update, after delete) {
	
    if(Trigger.isInsert || Trigger.isUpdate){
        if(Trigger.isAfter){
        AccountHandler.createVisitAccount(Trigger.new);
        }
    }
}