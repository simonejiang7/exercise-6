// personal assistant agent

/* Initial goals */ 

// owner_state(_).
// blinds("lowered").

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
    // !show_owner_state;
    .wait(7000);
    !read_state.
    // // !send(wristband_manager, askOne, owner_state(State), Answer);
    // !show_owner_state.


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

+!read_state : owner_state(State) & upcoming_event(UpcomingEvent) & blinds(BlindState) & lights (LightState) <-
// +!read_state : owner_state(State) & upcoming_event(UpcomingEvent) <-
    .wait(8000);
    .print("The owner state is ", State);
    .print("The upcoming event is ", UpcomingEvent);
    .print("The blinds state is ", BlindState);
    .print("The lights state is ", LightState);
    !read_state.

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }