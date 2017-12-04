trigger ProductProductTypeJunctionAfter on Product_ProductType_Junction__c (after insert, after delete) {
	Set<Id> productIds = new Set<Id>();
	List<Product_ProductType_Junction__c> js = Trigger.isDelete ? Trigger.old : Trigger.new;
	for (Product_ProductType_Junction__c j : js) {
		productIds.add(j.Product__c);
	}
	List<Product__c> products = [SELECT Id, CustomMargin__c,
			(SELECT Id, ProductType__r.Margin__c FROM Product_Types_Junctions__r)
			FROM Product__c WHERE Id IN :productIds];
	TriggerHandlerHelper.updateProductsCustomMargin(products);
}