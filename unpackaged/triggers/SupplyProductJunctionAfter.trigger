trigger SupplyProductJunctionAfter on SupplyProductJunction__c (after insert, after update, after delete) {
	List<SupplyProductJunction__c> items = Trigger.isDelete ? Trigger.old : Trigger.new;
	Set<Id> suppliesIds = new Set<Id>();
	for (SupplyProductJunction__c s : items) {
		suppliesIds.add(s.Supply__c);
	}
	List<Supply__c> supplies = [SELECT Id, Sum__c, (SELECT NewBasePrice__c, Quantity__c FROM Supply_Product_Junctions__r)
			FROM Supply__c WHERE Id IN :suppliesIds];
	for (Supply__c sup : supplies) {
		Decimal sum = 0;
		List<SupplyProductJunction__c> js = sup.Supply_Product_Junctions__r;
		for (SupplyProductJunction__c j : js) {
			sum += j.NewBasePrice__c * j.Quantity__c;
		}
		sup.Sum__c = sum;
	}
	update supplies;
}