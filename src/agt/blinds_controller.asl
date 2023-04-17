// blinds controller agent

/* Initial beliefs */

// The agent has a belief about the location of the W3C Web of Thing (WoT) Thing Description (TD)
// that describes a Thing of type https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Blinds (was:Blinds)
td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Blinds", "https://raw.githubusercontent.com/Interactions-HSG/example-tds/was/tds/blinds.ttl").

// the agent initially believes that the blinds are "lowered"
blinds("lowered").

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
    !set_state_to_raised;
    !set_state_to_lowered. 

@set_state_raised_plan
+!set_state_to_raised: true <-
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState", ["raised"]);
    -+blinds("raised");
    .print("Blinds are now ", "raised").

@set_state_lowered_plan
+!set_state_to_lowered: true <-
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState", ["lowered"]);
    -+blinds("lowered");
    .print("Blinds are now ", "lowered").

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }