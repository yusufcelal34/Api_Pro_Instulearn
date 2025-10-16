package stepdefinitions;

import config_Requirements.ConfigLoader;
import hooks.HooksAPI;
import io.cucumber.java.en.Given;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import org.hamcrest.Matchers;
import org.json.JSONObject;
import org.junit.Assert;
import utilities.API_Utilities.API_Methods;
import utilities.API_Utilities.TestData;

import java.util.HashMap;

import static io.restassured.RestAssured.given;

public class CennetSteps {

    @Given("C  The api user constructs the base url with the {string} token.")
    public void c_the_api_user_constructs_the_base_url_with_the_token(String string) {
        // Write code here that turns the phrase above into concrete actions
        throw new io.cucumber.java.PendingException();
    }
    @Given("C The api user sets {string} path parameters.")
    public void c_the_api_user_sets_path_parameters(String string) {
        // Write code here that turns the phrase above into concrete actions
        throw new io.cucumber.java.PendingException();
    }
    @Given("C The api user sends a GET request and saves the returned response.")
    public void c_the_api_user_sends_a_get_request_and_saves_the_returned_response() {
        // Write code here that turns the phrase above into concrete actions
        throw new io.cucumber.java.PendingException();
    }
    @Given("C The api user verifies that the status code is {int}.")
    public void c_the_api_user_verifies_that_the_status_code_is(Integer int1) {
        // Write code here that turns the phrase above into concrete actions
        throw new io.cucumber.java.PendingException();
    }
    @Given("C The api user verifies that the {string} information in the response body is {string}.")
    public void c_the_api_user_verifies_that_the_information_in_the_response_body_is(String string, String string2) {
        // Write code here that turns the phrase above into concrete actions
        throw new io.cucumber.java.PendingException();
    }
}
