public class TriggerHandlerHelper {

	public static void addTradingPoint(List<sObject> items) {
		Set<Id> employeesIds = new Set<Id>();
		for (sObject so : items) {
			employeesIds.add((Id)so.get('Employee__c'));
		}

		Map<Id, Employee__c> employeesMap = new Map<Id, Employee__c>([SELECT Id, TradingPoint__c FROM Employee__c WHERE Id IN :employeesIds]);
		for (sObject so : items) {
			so.put('TradingPoint__c', employeesMap.get((Id)so.get('Employee__c')).TradingPoint__c);
		}
	}

	public static void updateProductsCustomMargin(List<Product__c> products) {
		for (Product__c p : products) {
			List<Product_ProductType_Junction__c> tmpJuncs = p.Product_Types_Junctions__r;
			Integer cnt = 0;
			Decimal customMarginTmp = 0;
			for (Product_ProductType_Junction__c pj : tmpJuncs) {
				customMarginTmp += pj.ProductType__r.Margin__c;
				cnt ++;
			}
			p.CustomMargin__c = cnt > 0 ? customMarginTmp/cnt : 0;
		}
		update products;
	}
	//
}