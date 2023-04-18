// personal assistant agent

/* Initial goals */ 

requires_brightening:- blinds("lowered") & lights("off").

// beliefs
ranking_artificial_light(1).
ranking_natural_light(0).

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
    .wait(10000);
    !react_to_upcoming_events;
    .wait(30000);
    !create_and_send. // create a DweetArtifact and send message to the owner's friends
    // !start.   // uncomment this line to make the agent repeat the behavior

// the agent has a plan for creating a DweetArtifact, and then using the artifact to send messages.

// option 1: send messages when no proposals are received
// @create_artifact_and_send_message_plan
// +!create_and_send : owner_state("asleep") & protocol_state_blinds("refuse") & protocol_state_light("refuse")
//   <- !setUpDweetArtifact;
//     sendMessage("This is Personal Assistant Agent. Please help me to wake up my owner.");
//     .print("Message sent to the owner's friends").

// option 2: send messages even when proposals are received but the owner is still asleep
@create_artifact_and_send_message_plan
+!create_and_send : owner_state("asleep")
  <- !setUpDweetArtifact;
    sendMessage("This is Personal Assistant Agent. Please help me to wake up my owner.");
    .print("Message sent to the owner's friends").



// create a DweetArtifact
+!setUpDweetArtifact : true
  <- makeArtifact("dweet_artifact","room.DweetArtifact").

@react_to_upcoming_events_awake_plan
+!react_to_upcoming_events : upcoming_event("now") & owner_state("awake") <-
    .print("Enjoy your event").

@react_to_upcoming_events_asleep_plan
+!react_to_upcoming_events : upcoming_event("now") & owner_state("asleep") <-
    .print("Starting wake-up routine");
    !increase_illuminance.

@increase_illuminance_plan
+!increase_illuminance: true <- 
    .print("Increasing illuminance");
    .broadcast(tell,requires_brightening);
    .wait(15000);
    !accept_protocol.

@accept_protocol_with_ranking_plan
+!accept_protocol: (ranking_artificial_light < ranking_natural_light) & protocol_state_blinds("accept") & protocol_state_light("accept") <-
    !accept_blinds_protocol;
    !accept_lights_protocol.

+!accept_protocol: (ranking_artificial_light >= ranking_natural_light) & protocol_state_blinds("accept") & protocol_state_light("accept") <-
    !accept_lights_protocol;
    !accept_blinds_protocol.

+!accept_protocol: protocol_state_blinds("refuse") & protocol_state_light("accept") <-
    !accept_lights_protocol.

+!accept_protocol: protocol_state_blinds("accept") & protocol_state_light("refuse") <-
    !accept_blinds_protocol.

+!accept_protocol: protocol_state_blinds("refuse") & protocol_state_light("refuse") <-
    .print("No protocol accepted").

@accept_blinds_protocol_plan
+!accept_blinds_protocol : blinds("raised") & owner_state("asleep") <-
    .print("Accepting blinds protocol");
    .print("Owner is still asleep").

@accept_light_protocol_plan
+!accept_lights_protocol : lights("on") & owner_state("asleep") <-
    .print("Accepting lights protocol");
    .print("Owner is still asleep").

// beliefs

@owner_state_plan
+owner_state(OwnerState) <- 
    -+owner_state("asleep");
    .print("The owner is ", OwnerState).

@upcoming_events_plan
+upcoming_event(UpcomingEvents) <-
    -+upcoming_event("now");
    .print("The upcoming events are ", UpcomingEvents).

@blinds_plan
+blinds(BlindStatus) <-
    .print("The blinds are ", BlindStatus).

@lights_plan
+lights(LightStatus) <- 
    .print("The light is ", LightStatus).

+protocol_state_blinds(BlindProtocolStatus) <- 
    .print("The blinds protocol is ", BlindProtocolStatus).

+protocol_state_light(LightProtocolStatus) <-
    .print("The light protocol is ", LightProtocolStatus).

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }