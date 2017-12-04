trigger SupplyProductJunctionToUpdateBasePrice on SupplyProductJunction__c (after insert, after update) {
    List<Id> productsIds = new List<Id>();
    for (SupplyProductJunction__c supplyProductJunction : Trigger.new) {
        productsIds.add(supplyProductJunction.Product__c);
    }
    List<Product__c> productsToUpdate = new List<Product__c>();
    List<Product__c> products = [SELECT Id, BasePrice__c FROM Product__c WHERE Id IN :productsIds];
    for (SupplyProductJunction__c supplyProductJunction : Trigger.new) {
        for (Product__c p : products) {
            if (supplyProductJunction.Product__c == p.Id && supplyProductJunction.NewBasePrice__c != p.BasePrice__c) {
                p.BasePrice__c = supplyProductJunction.NewBasePrice__c;
                productsToUpdate.add(p);
                break;
            }
        }
    }
    update productsToUpdate;
}