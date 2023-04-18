// lights controller agent

/* Initial beliefs */

// The agent has a belief about the location of the W3C Web of Thing (WoT) Thing Description (TD)
// that describes a Thing of type https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Lights (was:Lights)
td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Lights", "https://raw.githubusercontent.com/Interactions-HSG/example-tds/was/tds/lights.ttl").

// The agent initially believes that the lights are "off"
lights("off").

/* Initial goals */ 

// The agent has the goal to start
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: the agents believes that a WoT TD of a was:Lights is located at Url
 * Body: greets the user
*/
@start_plan
+!start : td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Lights", Url) <-
    .print("Hello world");
    makeArtifact("lights", "org.hyperagents.jacamo.artifacts.wot.ThingArtifact", [Url], ArtId);
    !set_state_light;
    .wait(10000);
    !react_to_personal_assistant_light.

@set_state_raised_plan
+!set_state_light: lights("off") <-
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState", ["on"]);
    -+lights("on");
    .print("Lights are now ", "on");
    .send(personal_assistant,tell,lights("on"));
    .wait(5000).

@set_state_lowered_plan
+!set_state_light: lights("on") <-
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState", ["off"]);
    -+lights("off");
    .print("Lights are now ", "off");
    .send(personal_assistant,tell,lights("off"));
    .wait(5000).

@react_to_personal_assistant_light_on_plan
+!react_to_personal_assistant_light: lights("off")  & requires_brightening <- 
    .print("turning on lights");
    .send(personal_assistant,tell,lights("on"));
    .wait(5000);
    !react_to_personal_assistant_light.

@react_to_personal_assistant_light_off_plan
+!react_to_personal_assistant_light: lights("on")  & requires_brightening <- 
    .print("lights are already on");
    .send(personal_assistant,tell,lights("on"));
    .wait(5000);
    !react_to_personal_assistant_light.

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }