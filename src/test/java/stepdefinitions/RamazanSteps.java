package stepdefinitions;

import hooks.HooksAPI;
import io.cucumber.java.en.*;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import org.hamcrest.Matchers;
import utilities.API_Utilities.API_Methods;

import static io.restassured.RestAssured.given;
import static org.junit.Assert.*;

public class RamazanSteps {

    Response response;
    JsonPath jsonPath;

    @Given("The api user constructs the base url with the {string} token")
    public void the_api_user_constructs_the_base_url_with_the_token(String userType) {
        HooksAPI.setUpApi(userType);
    }

    @Given("The api user sets {string} path parameters")
    public void the_api_user_sets_path_parameters(String pathParam) {
        API_Methods.pathParam(pathParam);
    }

    @Given("The api user sends a GET request and saves the returned response")
    public void the_api_user_sends_a_get_request_and_saves_the_returned_response() {
        response = given().spec(HooksAPI.spec)
                .when().get(API_Methods.fullPath);
        response.prettyPrint();
    }

    @Then("The api user36 verifies that the status code is {int}")
    public void the_api_user36_verifies_that_the_status_code_is(int code) {
        response.then()
                .assertThat()
                .statusCode(code);
    }

    @Then("The api user36 verifies that the {string} information in the response body is {string}")
    public void the_api_user36_verifies_that_the_information_in_the_response_body_is(String key,String value) {
        response.then()
                .assertThat()
                .body(key, Matchers.equalTo(value));
    }

    @Then("The api user verifies that {int}, {int}, {string}, {string}, {int}, {int}, {string}, {string}, {string}, {int} information of the item at {int} in the response body")
    public void theApiUserVerifiesData(
            int category_id,
            int author_id,
            String slug,
            String image,
            int visit_count,
            int enable_comment,
            String status,
            String created_at,
            String updated_at,
            int comments_count,
            int dataIndex) {

        JsonPath json = response.jsonPath();
        String basePath = "data.blog[" + dataIndex + "]";

        assertEquals(category_id, json.getInt(basePath + ".category_id"));
        assertEquals(author_id, json.getInt(basePath + ".author_id"));
        assertEquals(slug, json.getString(basePath + ".slug"));
        assertEquals(image, json.getString(basePath + ".image"));
        assertEquals(visit_count, json.getInt(basePath + ".visit_count"));
        assertEquals(enable_comment, json.getInt(basePath + ".enable_comment"));
        assertEquals(status, json.getString(basePath + ".status"));
        assertEquals(created_at, json.getString(basePath + ".created_at"));
        assertEquals(updated_at, json.getString(basePath + ".updated_at"));
        assertEquals(comments_count, json.getInt(basePath + ".comments_count"));
    }
}
