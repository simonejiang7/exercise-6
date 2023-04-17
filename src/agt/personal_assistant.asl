// personal assistant agent

/* Initial goals */ 

// owner_state(_).

// The agent has the goal to start
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: true (the plan is always applicable)
 * Body: greets the user
*/
@start_plan
+!start : true <-
    .print("Hello world");
    !create_and_send;
    !show_owner_state;
    .wait(7000);
    // !send(wristband_manager, askOne, owner_state(State), Answer);
    !show_owner_state.


// the agent has a plan for creating a DweetArtifact, and then using the artifact to send messages.
@create_artifact_and_send_message_plan
+!create_and_send : true
  <- !setUpDweetArtifact;
    sendMessage("New Message from Agent");
    .print("Message sent").

// create a DweetArtifact
+!setUpDweetArtifact : true
  <- makeArtifact("dweet_artifact","room.DweetArtifact").

// +owner_state(State) : true <-
//     .print("The owner state is ", State).

+!show_owner_state : owner_state(State) <-
    .print("The owner state is ", owner_state(State)).

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }