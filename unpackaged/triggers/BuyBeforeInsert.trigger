trigger BuyBeforeInsert on Buy__c (before insert) {
	TriggerHandlerHelper.addTradingPoint(Trigger.new);
}