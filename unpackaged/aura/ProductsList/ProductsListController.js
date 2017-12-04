({
	doInit : function(component, event, helper) {
	    var searchName = "";
        helper.searchAllProducts(component, searchName);
	},

	handleSearch : function(component, event, helper) {
	    var searchName = event.getParam("searchName");
        helper.searchAllProducts(component, searchName);
    }
})