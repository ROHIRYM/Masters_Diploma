trigger SupplyBeforeInsert on Supply__c (before insert) {
	TriggerHandlerHelper.addTradingPoint(Trigger.new);
}