package stepdefinitions;

import config_Requirements.ConfigLoader;
import hooks.HooksAPI;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.*;
import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.apache.commons.lang3.Range;
import org.hamcrest.Matchers;
import org.json.JSONObject;
import org.junit.Assert;
import utilities.API_Utilities.API_Methods;
import utilities.API_Utilities.TestData;

import static org.hamcrest.core.IsNot.not;
import static org.junit.Assert.*;
import static org.junit.Assert.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.Assert.fail;



import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;

public class EdaSteps {

    Response response;
    JsonPath jsonPath;

    JSONObject requestBody = new JSONObject();
    JSONObject jsonObjectBody = new JSONObject();
    HashMap<String, Object> responseMap;
    TestData testdata = new TestData();
    String exceptionMesaj;
    ConfigLoader configLoader = new ConfigLoader();

    private String path;


    @Given("E The api user constructs the base url with the {string} token.")
    public void the_api_user_constructs_the_base_url_with_the_token(String userType) {

        HooksAPI.setUpApi(userType);
    }

    @Given("E The api user sets {string} path parameters.")
    public void the_api_user_sets_path_parameters(String pathParam) {
        API_Methods.pathParam(pathParam);
    }

    @Given("E The api user sends a GET request and saves the returned response.")
    public void the_api_user_sends_a_get_request_and_saves_the_returned_response() {
        response = given()
                .spec(HooksAPI.spec)
                .when()
                .get(API_Methods.fullPath);

        response.prettyPrint();
    }

    @Given("E The api user verifies that the status code is {int}.")
    public void the_api_user_verifies_that_the_status_code_is(int code) {
        response.then()
                .assertThat()
                .statusCode(code);
    }

    @Given("E The api user verifies that the {string} information in the response body is {string}.")
    public void the_api_user_verifies_that_the_information_in_the_response_body_is(String key, String value) {
        response.then()
                .assertThat()
                .body(key, Matchers.equalTo(value));
    }

    @Given("E The api user verifies that the {string} information in the response body is {int}.")
    public void the_api_user_verifies_that_the_information_in_the_response_body_is(String key, Integer value) {
        response.then()
                .assertThat()
                .body(key, Matchers.equalTo(value));
    }

    @Then("E The fields and values in the response body are verified:")
    public void response_body_deki_alanlar_ve_değerleri_doğrulanır(DataTable dataTable) {
        Map<String, String> expectedFields = dataTable.asMap(String.class, String.class);

        for (Map.Entry<String, String> entry : expectedFields.entrySet()) {
            String field = entry.getKey();
            String expectedValue = entry.getValue();

            // Eğer "data." ile başlamıyorsa otomatik ekle
            if (!field.startsWith("data.")) {
                field = "data." + field;
            }

            Object actualValueObj = response.jsonPath().get(field);
            String actualValue = actualValueObj == null ? null : actualValueObj.toString();

            System.out.println("Doğrulanıyor: " + field + " → beklenen: " + expectedValue + ", actual: " + actualValue);

            if ("null".equalsIgnoreCase(expectedValue)) {
                assertNull("Alan " + field + " için değer null olmalıydı", actualValueObj);
            } else {
                Assert.assertEquals("Alan uyuşmazlığı: " + field, expectedValue, actualValue);
            }
        }
    }


    @Given("E The api user sends a {string} request, saves the returned response, and verifies that the status code is '401' with the reason phrase Unauthorized.")
    public void the_api_user_sends_a_request_saves_the_returned_response_and_verifies_that_the_status_code_is_with_the_reason_phrase_unauthorized(String httpMethod) {
        try {
            response = given()
                    .spec(HooksAPI.spec)
                    .when()
                    .get(API_Methods.fullPath);
        } catch (Exception e) {
            exceptionMesaj = e.getMessage();
        }
        Assert.assertEquals(configLoader.getApiConfig("status code: 401, reason phrase: Unauthorized"), exceptionMesaj);
    }

    @Given("E The api user prepares a POST request to send to the api addPricePlan {string},{string}, {int}, {int}, {int}.")
    public void e_the_api_user_prepares_a_post_request_to_send_to_the_api_add_price_plan(String string, String string2, Integer int1, Integer int2, Integer int3) {

        requestBody.put("title", string);
        requestBody.put("dateRange", string2);
        requestBody.put("discount", int1);
        requestBody.put("capacity", int2);
        requestBody.put("webinar_id", int3);

        jsonObjectBody = requestBody;
    }

    @Given("E The api user sends a {string} request and saves the returned response.")
    public void the_api_user_sends_a_request_and_saves_the_returned_response(String httpMethod) {
        response=given()
                .spec(HooksAPI.spec)
                .contentType(ContentType.JSON)
                .when()
                .body(jsonObjectBody.toString())
                .post(API_Methods.fullPath);


        response.prettyPrint();
    }

    @Given("E The api user prepares a POST request that contains no data.")
    public void the_api_user_prepares_a_post_request_that_contains_no_data() {

    }

    @Given("NT The api user sends a GET request and saves the returned response.")
    public void NTthe_api_user_sends_a_request_and_saves_the_returned_response() {
        response=given()
                .spec(HooksAPI.spec)
                .contentType(ContentType.JSON)
                .when()
                .body(jsonObjectBody.toString())
                .get(API_Methods.fullPath);


        response.prettyPrint();
        }

        @Then("E The api user verifies that the status code is {int}")
        public void the_api_user_verifies_status_code(int expectedStatusCode) {
            response.then().statusCode(expectedStatusCode); // 401 bekleniyor
    }

    @Given("E The api user prepares a PATCH request containing the {string} information to send to the api updateCategory endpoint.")
    public void e_the_api_user_prepares_a_patch_request_containing_the_information_to_send_to_the_api_update_category_endpoint(String title) {
            jsonObjectBody.put("title", title);

    }

    @Given("E The api user sends a PATCH request and saves the returned response.")
    public void the_api_user_sends_a_patch_request_and_saves_the_returned_response() {

        response = given()
                .spec(HooksAPI.spec)
                .contentType(ContentType.JSON)
                .when()
                .body(jsonObjectBody.toString())
                .patch(API_Methods.fullPath);

        response.prettyPrint();
    }

    @Given("E The api user sends a DELETE request and saves the returned response.")
    public void tthe_api_user_sends_a_request_and_saves_the_returned_response() {
        response = given()
                .spec(HooksAPI.spec)
                .contentType(ContentType.JSON)
                .when()
                .body(jsonObjectBody.toString())
                .delete(API_Methods.fullPath);

        response.prettyPrint();
    }


    @Given("E The api user verifies the {int} {int}")
    public void ee_the_api_user_verifies_the(int id, int expectedId) {
        Map<String, Object> root = response.jsonPath().getMap("$");  // JSON'ı Map olarak al

        // Response'taki olası ID key'leri
        String[] possibleKeys = {
                "Updated Price Plans ID",
                "Deleted Price Plan Id",
                "Created Price Plan Id"
        };

        Object foundValue = null;
        String foundKey = null;

        // Gelen response'ta hangisi varsa onu bul
        for (String key : possibleKeys) {
            if (root.containsKey(key)) {
                foundValue = root.get(key);
                foundKey = key;
                break;
            }
        }

        // Hiçbiri yoksa test fail
        org.junit.Assert.assertNotNull("Response'ta beklenen ID alanı bulunamadı!", foundValue);

        // Tip dönüşümü
        int returnedId = (foundValue instanceof Number)
                ? ((Number) foundValue).intValue()
                : Integer.parseInt(foundValue.toString().trim());

        System.out.println("✅ Bulunan ID alanı: " + foundKey + " = " + returnedId);

        // Eşitlik kontrolleri
        org.junit.Assert.assertEquals("Path param ID ile dönülen ID eşit değil!", id, returnedId);
        org.junit.Assert.assertEquals("Examples tablosundaki ID ile dönülen ID eşit değil!", expectedId, returnedId);
    }
    @Given("E The api user prepares a PATCH request that contains no data.")
    public void e_the_api_user_prepares_a_patch_request_that_contains_no_data() {

    }
    }


