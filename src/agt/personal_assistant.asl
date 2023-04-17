// personal assistant agent

/* Initial goals */ 

// owner_state(_).
// blinds("lowered").

// The agent has the goal to start
!start.
!create_and_send.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: true (the plan is always applicable)
 * Body: greets the user
*/
@start_plan
+!start : true <-
    .print("Hello world");
    .wait(7000);
    !start.

// the agent has a plan for creating a DweetArtifact, and then using the artifact to send messages.
@create_artifact_and_send_message_plan
+!create_and_send : true
  <- !setUpDweetArtifact;
    sendMessage("New Message from Agent");
    .print("Message sent").

// create a DweetArtifact
+!setUpDweetArtifact : true
  <- makeArtifact("dweet_artifact","room.DweetArtifact").

// +!read_state : true <- 
//     !read_owner_state;
//     !read_upcoming_events;
//     !read_blinds_state;
//     !read_light_state;
//     .wait(3000).

// +!read_owner_state : owner_state(OwnerState) <- 
//     .print("The owner is ", OwnerState).

// +!read_upcoming_events : upcoming_event(UpcomingEvents) <- 
//     .print("The upcoming events are ", UpcomingEvents).

// +!read_blinds_state : blinds("lowered") <-
//     .print("The blinds are lowered.").

// +!read_blinds_state : blinds("raised") <-
//     .print("The blinds are raised.").

// +!read_light_state : lights("on") <-
//     .print("The light is on.").

// +!read_light_state : lights("off") <-
//     .print("The light is off.").

+owner_state(OwnerState) <- 
    .print("The owner is ", OwnerState).

+upcoming_event(UpcomingEvents) <-
    .print("The upcoming events are ", UpcomingEvents).

+blinds(BlindStatus) <-
    .print("The blinds are ", BlindStatus).

+lights(LightStatus) <- 
    .print("The light is ", LightStatus).

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }