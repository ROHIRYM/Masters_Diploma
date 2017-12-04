trigger ProductTypeAfterUpdate on ProductType__c (after update) {
	List<Product__c> products = [SELECT Id, CustomMargin__c,
			(SELECT Id, ProductType__r.Margin__c FROM Product_Types_Junctions__r)
			FROM Product__c WHERE Id IN (SELECT Product__c
			FROM Product_ProductType_Junction__c WHERE ProductType__c IN :Trigger.newMap.keySet())];
	TriggerHandlerHelper.updateProductsCustomMargin(products);
}