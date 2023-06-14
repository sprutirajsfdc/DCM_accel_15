({
    init: function(component, event, helper) {
        // Fetch the list of queues
        var action = component.get("c.getQueues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.queues", response.getReturnValue());
            } else {
                console.error("Failed to retrieve queues: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    showUserDetails: function(component, event, helper) {
        var selectedQueue = event.getSource().get("v.value");
        component.set("v.selectedQueue", selectedQueue);
        
        // Fetch the user details for the selected queue
        if (selectedQueue && selectedQueue.Id) {
            var action = component.get("c.getQueueUsers");
            action.setParams({ queueId: selectedQueue.Id });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.userDetails", response.getReturnValue());
                } else {
                    console.error("Failed to retrieve user details: " + state);
                }
            });
            $A.enqueueAction(action);
        } else {
            console.error("Invalid selected queue.");
        }
    },
    addUser: function(component, event, helper) {
        var queueId = event.getSource().get("v.value");
        
        // Retrieve the current user's Id
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        
        // Call the server-side controller method to add the user to the queue
        var action = component.get("c.addUserToQueue");
        action.setParams({
            queueId: queueId,
            userId: userId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("User added to the queue");
                // Perform any additional actions or updates on the component as needed
            } else {
                console.error("Failed to add user to the queue: " + response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
     showAvailableUsers: function(component, event, helper) {
        var queueId = event.getSource().get("v.value");
        
        // Call the server-side controller method to retrieve the available users
        var action = component.get("c.getAvailableUsers");
        action.setParams({
            queueId: queueId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var availableUsers = response.getReturnValue();
                // Perform any handling or display logic for the available users
            } else {
                console.error("Failed to retrieve available users: " + response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
   
})