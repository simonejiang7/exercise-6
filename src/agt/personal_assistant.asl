// personal assistant agent

/* Initial goals */ 

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
    !create_and_send.

// the agent has a plan for creating a DweetArtifact, and then using the artifact to send messages.
@create_artifact_and_send_message_plan
+!create_and_send : true
  <- !setUpDweetArtifact;
    sendMessage("New Message from Agent");
    .print("Message sent").

// create a DweetArtifact
+!setUpDweetArtifact : true
  <- makeArtifact("dweet_artifact","room.DweetArtifact").

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }