({
	searchProducts : function(component, event, helper) {
		var searchName = component.get("v.searchName");
		var searchEvent = component.getEvent("searchForProducts");
        searchEvent.setParams({ "searchName": searchName });
        searchEvent.fire();
	}
})