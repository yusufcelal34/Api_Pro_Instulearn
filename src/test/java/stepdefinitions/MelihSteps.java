package stepdefinitions;

import config_Requirements.ConfigLoader;
import hooks.HooksAPI;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.*;
import io.qameta.allure.Attachment;
import io.restassured.RestAssured;
import io.restassured.builder.RequestSpecBuilder;
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

import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.core.IsNot.not;
import static org.junit.Assert.*;
import static org.junit.Assert.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.Assert.fail;



import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;

public class MelihSteps {

    Response response;
    JsonPath jsonPath;

    JSONObject requestBody = new JSONObject();
    JSONObject jsonObjectBody = new JSONObject();
    HashMap<String, Object> responseMap;
    TestData testdata = new TestData();
    String exceptionMesaj;
    ConfigLoader configLoader = new ConfigLoader();

    private String path;

    @Given("MI The api user constructs the base url with the {string} token.")
    public void the_api_user_constructs_the_base_url_with_the_token(String userType) {

        // Eğer melihAdmin gelirse, HooksAPI'ye admin gönder (spec bozulmasın)
        String hookUserType = userType.equalsIgnoreCase("melihAdmin") ? "admin" : userType;

        HooksAPI.setUpApi(hookUserType);

        ConfigLoader configLoader = ConfigLoader.getInstance();
        String baseUrl = configLoader.getApiConfig("base_url");

        // Eğer melihAdmin çağrılmışsa, melihadminToken key’ini oku
        String tokenKey = userType.equalsIgnoreCase("melihAdmin") ? "melihadminToken" : userType + "Token";
        String token = configLoader.getApiConfig(tokenKey);

        // Yeni spec’i override et — bu token kullanılacak
        HooksAPI.spec = new RequestSpecBuilder()
                .setBaseUri(baseUrl)
                .setContentType(ContentType.JSON)
                .addHeader("Authorization", "Bearer " + token)
                .build();

        System.out.println("🔑 Kullanılan userType: " + userType);
        System.out.println("🔑 Kullanılan token key: " + tokenKey);
        System.out.println("🌍 Base URL: " + baseUrl);
    }

    @Given("MI The api user sets {string} path parameters.")
    public void the_api_user_sets_path_parameters(String pathParam) {
        API_Methods.pathParam(pathParam);
    }

    @Given("MI The api user sends a {string} request and saves the returned response.")
    public void the_api_user_sends_a_request_and_saves_the_returned_response(String httpMethod) {

        switch (httpMethod.toUpperCase()) {
            case "GET":
                response = given()
                        .spec(HooksAPI.spec)
                        .when()
                        .get(API_Methods.fullPath);
                break;

            case "POST":
                response = given()
                        .spec(HooksAPI.spec)
                        .contentType(ContentType.JSON)
                        .body(jsonObjectBody.toString())
                        .when()
                        .post(API_Methods.fullPath);
                break;

            case "PUT":
                response = given()
                        .spec(HooksAPI.spec)
                        .contentType(ContentType.JSON)
                        .body(jsonObjectBody.toString())
                        .when()
                        .put(API_Methods.fullPath);
                break;

            case "PATCH":
                response = given()
                        .spec(HooksAPI.spec)
                        .contentType(ContentType.JSON)
                        .body(jsonObjectBody.toString())
                        .when()
                        .patch(API_Methods.fullPath);
                break;

            case "DELETE":
                response = given()
                        .spec(HooksAPI.spec)
                        .when()
                        .delete(API_Methods.fullPath);
                break;

            default:
                throw new IllegalArgumentException("Unsupported HTTP method: " + httpMethod);
        }

        response.prettyPrint();
    }



    @Given("MI The api user verifies that the status code is {int}.")
    public void the_api_user_verifies_that_the_status_code_is(int code) {
        response.then()
                .assertThat()
                .statusCode(code);
    }

    @Given("MI The api user verifies that the {string} information in the response body is {string}.")
    public void the_api_user_verifies_that_the_information_in_the_response_body_is(String key, String value) {
        response.then()
                .assertThat()
                .body(key, Matchers.equalTo(value));
    }

    @Then("MI The fields and values in the response body are verified:")
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
    @Given("MI The api user prepares a POST request that contains no data.")
    public void the_api_user_prepares_a_post_request_that_contains_no_data() {

    }
    @Given("MI The api user prepares a PATCH request that contains no data.")
    public void e_the_api_user_prepares_a_patch_request_that_contains_no_data() {

    }
    @Attachment(value = "{name}", type = "application/json", fileExtension = ".json")
    public byte[] attachJson(String name, String json) {
        if (json == null) json = "";
        return json.getBytes(java.nio.charset.StandardCharsets.UTF_8);
    }
    @Given("MI The api user prepares a POST request to send to the api addProductCategory {string}")
    public void e_the_api_user_prepares_a_post_request_to_send_to_the_api_add_price_plan(String string) {
        requestBody.put("title", string);

        attachJson("POST Body (addPricePlan)", jsonObjectBody.toString());
    }
    @Given("MI The api user prepares a PATCH request containing the {string} information to send to the api updateCategory endpoint.")
    public void e_the_api_user_prepares_a_patch_request_containing_the_information_to_send_to_the_api_update_category_endpoint(String title) {
        jsonObjectBody.put("title", title);
        attachJson("PATCH Body (updateCategory)", jsonObjectBody.toString());
    }
    @Given("MI The api user verifies the {int} {int}")
    public void mi_the_api_user_verifies_the(int id, int expectedId) {
        Map<String, Object> root = response.jsonPath().getMap("$");

        String[] possibleKeys = {
                "Update Product Category ID",
                "Updated Product Category ID",
                "id",
                "updatedId"
        };

        Object actualId = null;
        for (String key : possibleKeys) {
            if (root.containsKey(key)) {
                actualId = root.get(key);
                break;
            }
        }

        org.junit.Assert.assertNotNull("Response içinde ID alanı bulunamadı!", actualId);
        org.junit.Assert.assertEquals("Beklenen ID ile response ID uyuşmuyor!", expectedId, ((Number) actualId).intValue());

        System.out.println("✅ API Product Category ID doğrulandı: " + actualId);
    }
}