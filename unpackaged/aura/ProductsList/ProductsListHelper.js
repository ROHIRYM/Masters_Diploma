({
	searchAllProducts : function(component, searchName) {
		var action = component.get("c.findAllProducts");
        action.setParams({
            name: searchName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var products = response.getReturnValue();
                component.set("v.products", products);
            }
        });
        $A.enqueueAction(action);
	}
})