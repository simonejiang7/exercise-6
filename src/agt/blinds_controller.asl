// blinds controller agent

/* Initial beliefs */

// The agent has a belief about the location of the W3C Web of Thing (WoT) Thing Description (TD)
// that describes a Thing of type https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Blinds (was:Blinds)
td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Blinds", "https://raw.githubusercontent.com/Interactions-HSG/example-tds/was/tds/blinds.ttl").

// the agent initially believes that the blinds are "lowered"
// blinds("lowered").
blinds("raised").
protocol_state_blinds("accept").

/* Initial goals */ 

// The agent has the goal to start
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: the agents believes that a WoT TD of a was:Blinds is located at Url
 * Body: greets the user
*/
@start_plan
+!start : td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Blinds", Url) <-
    .print("Hello world");
    makeArtifact("blinds", "org.hyperagents.jacamo.artifacts.wot.ThingArtifact", [Url], ArtId);
    !set_state_blinds;
    .wait(10000);
    !react_to_personal_assistant.

@set_state_raised_plan
+!set_state_blinds: blinds("lowered") <-
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState", ["raised"]);
    -+blinds("raised");
    .print("Blinds are now ", "raised");
    .send(personal_assistant,tell,blinds("raised"));
    .wait(5000).

@set_state_lowered_plan
+!set_state_blinds: blinds("raised") <-
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState", ["lowered"]);
    -+blinds("lowered");
    .print("Blinds are now ", "lowered");
    .send(personal_assistant,tell,blinds("lowered"));
    .wait(5000).

@react_to_personal_assistant_plan_lowerd
+!react_to_personal_assistant: blinds("lowered") & requires_brightening <-
    .print("raising the blinds");
    -+blinds("raised");
    .send(personal_assistant,tell,blinds("raised"));
    .send(personal_assistant,tell,accepts_protocol_state_blinds("accept"));
    .wait(5000);
    !react_to_personal_assistant.

@react_to_personal_assistant_plan_raised
+!react_to_personal_assistant: blinds("raised") & requires_brightening <-
    .print("the blinds are already raised");
    -+protocol_state_blinds("refuse");
    .send(personal_assistant,tell,protocol_state_blinds("refuse"));
    .wait(5000);
    !react_to_personal_assistant.


/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }