trigger SupplyProductJunctionBefore on SupplyProductJunction__c (before insert, before update) {
	Set<Id> productsIds = new Set<Id>();
	for (SupplyProductJunction__c j : Trigger.new) {
		if (j.NewBasePrice__c == null || j.NewBasePrice__c <= 0) {
			productsIds.add(j.Product__c);
		}
	}
	Map<Id, Product__c> productsMap =
			new Map<Id, Product__c>([SELECT Id, BasePrice__c FROM Product__c WHERE Id IN :productsIds]);
	for (SupplyProductJunction__c j : Trigger.new) {
		if (j.NewBasePrice__c == null || j.NewBasePrice__c <= 0) {
			j.NewBasePrice__c = productsMap.get(j.Product__c).BasePrice__c;
		}
	}
}