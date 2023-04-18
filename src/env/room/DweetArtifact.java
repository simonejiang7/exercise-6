package room;

import cartago.Artifact;
import cartago.OPERATION;

import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * A CArtAgO artifact that provides an operation for sending messages to agents 
 * with KQML performatives using the dweet.io API
 */
public class DweetArtifact extends Artifact {

    void init() {
        // not defining any internal state
    }

    @OPERATION void sendMessage(String msg) throws JSONException {

        JSONObject jsonBody = new JSONObject();
        jsonBody.put("newMessage", msg);
        
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(java.net.URI.create("https://dweet.io/dweet/for/agent1?message=" + "tofriends"))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonBody.toString()))
                .build();

        client.sendAsync(request, HttpResponse.BodyHandlers.ofString())
        .thenApply(HttpResponse::body)
        .thenAccept(System.out::println)
        .join();
        
        // observable event
        signal("newMessage",msg);
    }
}
