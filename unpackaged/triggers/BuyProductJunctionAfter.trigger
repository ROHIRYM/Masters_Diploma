trigger BuyProductJunctionAfter on BuyProductJunction__c (after insert, after update, after delete) {
	List<BuyProductJunction__c> items = Trigger.isDelete ? Trigger.old : Trigger.new;
	Set<Id> buysIds = new Set<Id>();
	for (BuyProductJunction__c b : items) {
		buysIds.add(b.Buy__c);
	}
	List<Buy__c> buys = [SELECT Id, Sum__c, (SELECT Product__r.RetailPrice__c, Quantity__c FROM Buy_Product_Junctions__r)
			FROM Buy__c WHERE Id IN :buysIds];
	for (Buy__c buy : buys) {
		Decimal sum = 0;
		List<BuyProductJunction__c> js = buy.Buy_Product_Junctions__r;
		for (BuyProductJunction__c j : js) {
			sum += j.Product__r.RetailPrice__c * j.Quantity__c;
		}
		buy.Sum__c = sum;
	}
	update buys;
}