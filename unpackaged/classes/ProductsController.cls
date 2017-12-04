/**
 * Created by ROHIRYM on 10/26/17.
 */
public class ProductsController {

    public Product__c searchProd {get;set;}
    public List<Product__c> allFoundProducts {get;set;}
    
    public Id productId {get;set;}
    public Product__c product {get;set;}
    public List<BuyProductJunctionWrapper> buyProductJunctionsWrappers {get;set;}
    
    public Double allSum {get;set;}
    public String employeeId {get;set;}
    
    public ProductsController() {
        searchProd = new Product__c();
        buyProductJunctionsWrappers = new List<BuyProductJunctionWrapper>();
        allSum = 0;
    }
    
    public void findAllProducts() {
        String searchName = '%'+(searchProd.Name == null ? '' : searchProd.Name)+'%';
        allFoundProducts = [SELECT Id, Name, QuantityType__c, RetailPrice__c FROM Product__c WHERE Name LIKE :searchName LIMIT 10];
    }
    
    public void addNewBuyProductJunction() {
        product = [SELECT Id, Name, QuantityType__c, RetailPrice__c FROM Product__c WHERE Id = :productId LIMIT 1];
        for (BuyProductJunctionWrapper bpjw : buyProductJunctionsWrappers) {
            if (bpjw.product.Id == product.Id) {
                bpjw.buyProductJunction.Quantity__c = bpjw.buyProductJunction.Quantity__c + 1;
                bpjw.sum = bpjw.buyProductJunction.Quantity__c * bpjw.product.RetailPrice__c;
                refreshAllSum();
                return;
            }
        }
        BuyProductJunctionWrapper junc = new BuyProductJunctionWrapper();
        junc.product = product;
        junc.buyProductJunction = new BuyProductJunction__c(Product__c = product.Id, Quantity__c = 1);
        junc.sum = junc.buyProductJunction.Quantity__c * junc.product.RetailPrice__c;
        buyProductJunctionsWrappers.add(junc);
        refreshAllSum();
    }
    
    public void refreshSums() {
        for (BuyProductJunctionWrapper bpjw : buyProductJunctionsWrappers) {
            bpjw.sum = bpjw.buyProductJunction.Quantity__c * bpjw.product.RetailPrice__c;
        }
        refreshAllSum();
    }
    
    public void refreshAllSum() {
        allSum = 0;
        for (BuyProductJunctionWrapper bpjw : buyProductJunctionsWrappers) {
            allSum = allSum + bpjw.sum;
        }
    }
    
    public void deleteBuyProductJunction() {
        Integer index = 0;
        for (BuyProductJunctionWrapper bpjw : buyProductJunctionsWrappers) {
            if (bpjw.product.Id == productId) {
                break;
            }
            index++;
        }
        if (index < buyProductJunctionsWrappers.size()) {
            buyProductJunctionsWrappers.remove(index);
        }
        refreshAllSum();
    }
    
    public List<SelectOption> getdynamiclist() {
        List<SelectOption> options = new List<SelectOption>();
        List<Employee__c> employees = [SELECT Id, FirstName__c, LastName__c FROM Employee__c];
        for (Employee__c emp : employees) {
            options.add(new SelectOption(emp.Id, emp.FirstName__c + ' ' + emp.LastName__c));
        }
        return options;
    }
    
    public void saveOrder() {
        try {
            Buy__c buy = new Buy__c(CashRegister__c = 1, DateTime__c = DateTime.now(), Employee__c = employeeId);
            insert buy;
            List<BuyProductJunction__c> juncs = new List<BuyProductJunction__c>();
            for (BuyProductJunctionWrapper bpjw : buyProductJunctionsWrappers) {
                bpjw.buyProductJunction.Buy__c = buy.Id;
                juncs.add(bpjw.buyProductJunction);
            }
            insert juncs;
            buyProductJunctionsWrappers = new List<BuyProductJunctionWrapper>();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Success!'));
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
        }
    }
    
    public class BuyProductJunctionWrapper {
        public Product__c product {get;set;}
        public BuyProductJunction__c buyProductJunction {get;set;}
        public Double sum {get;set;}
    }

}