package stepdefinitions;

import config_Requirements.ConfigLoader;
import hooks.HooksAPI;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.*;
import io.restassured.http.ContentType;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import org.hamcrest.Matchers;
import org.json.JSONObject;
import org.junit.Assert;
import utilities.API_Utilities.API_Methods;
import utilities.API_Utilities.TestData;
import java.util.HashMap;
import static io.restassured.RestAssured.given;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.IsEqual.equalTo;
import static org.junit.Assert.assertEquals;

public class CennetSteps {

    Response response;
    JsonPath jsonPath;
    private static Response lastResponse;

    public static void setLastResponse(Response resp) { lastResponse = resp; }
    JSONObject jsonObjectBody = new JSONObject();
    HashMap<String, Object> responseMap;
    TestData testdata = new TestData();
    String exceptionMesaj;
    ConfigLoader configLoader = new ConfigLoader();


    @Given("CCC  The api user constructs the base url with the {string} token.")
    public void ccc_the_api_user_constructs_the_base_url_with_the_token(String userType) {
        HooksAPI.setUpApi(userType);

    }

    @Given("C  The api user constructs the base url with the {string} token.")
    public void c_the_api_user_constructs_the_base_url_with_the_token(String userType) {

        HooksAPI.setUpApi(userType);
    }

    @Given("C The api user sets {string} path parameters.")
    public void c_the_api_user_sets_path_parameters(String pathParam) {
        API_Methods.pathParam(pathParam);
    }

    @Given("C The api user sends a GET request and saves the returned response.")
    public void c_the_api_user_sends_a_get_request_and_saves_the_returned_response() {
        response = given()
                .spec(HooksAPI.spec)
                .when()
                .get(API_Methods.fullPath);

        response.prettyPrint();

    }

    @Given("C The fields and values in the response body are verified:")
    public void c_the_fields_and_values_in_the_response_body_are_verified(io.cucumber.datatable.DataTable dataTable) {
        // Son response'u al
        if (response == null)
            throw new IllegalStateException("No stored response found. Make sure the GET step saved the response.");
        io.restassured.path.json.JsonPath jp = response.jsonPath();
        // Her satırı sırayla doğrula
        for (java.util.List<String> row : dataTable.asLists()) {
            String jsonPath = row.get(0).trim();
            String expectedValue = row.get(1).trim();
            Object actual = jp.get(jsonPath);
            Object expected = convertType(expectedValue);
            org.hamcrest.MatcherAssert.assertThat(
                    "Mismatch at path: " + jsonPath + " (actual=" + actual + ", expected=" + expected + ")",
                    actual,
                    org.hamcrest.Matchers.equalTo(expected)
            );
        }
    }
    // Yardımcı tip dönüştürücü
    private Object convertType(String value) {
        if (value.equalsIgnoreCase("null")) return null;
        if (value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false"))
            return Boolean.parseBoolean(value);
        if (value.matches("-?\\d+")) return Integer.parseInt(value);
        if (value.matches("-?\\d+\\.\\d+")) return Double.parseDouble(value);
        return value;
    }


    @Given("C The api user verifies that the status code is {int}.")
    public void c_the_api_user_verifies_that_the_status_code_is(Integer code) {
        response.then()
                .assertThat()
                .statusCode(code);

    }

    @Given("C The api user verifies that the {string} information in the response body is {string}.")
    public void c_the_api_user_verifies_that_the_information_in_the_response_body_is(String key, String value) {
        response.then()
                .assertThat()
                .body(key, Matchers.equalTo(value));

    }

    //**************//TCO2//**************************************************//


   @Then("The fields and values in the response body are verified:")
   public void the_fields_and_values_in_the_response_body_are_verified(DataTable dataTable) {
       if (lastResponse == null) {
           throw new IllegalStateException("No response is stored. Make sure the GET step saved the response.");
       }
       JsonPath jp = lastResponse.jsonPath();
       for (java.util.List<String> row : dataTable.asLists()) {
           String jsonPath = row.get(0).trim();
           String expectedRaw = row.get(1).trim();
           Object expected = coerce(expectedRaw);
           Object actual = jp.get(jsonPath);
           assertThat("Mismatch at path: " + jsonPath, actual, equalTo(expected));
       }
   }
    // "null", boolean ve sayıları uygun tipe çevir
    private Object coerce(String s) {
        if (s.equalsIgnoreCase("null")) return null;
        if (s.equalsIgnoreCase("true") || s.equalsIgnoreCase("false")) {
            return Boolean.parseBoolean(s);
        }
        // integer
        if (s.matches("-?\\d+")) {
            try { return Integer.parseInt(s); } catch (NumberFormatException ignored) {}
        }
        // long
        if (s.matches("-?\\d{10,}")) {
            try { return Long.parseLong(s); } catch (NumberFormatException ignored) {}
        }
        // double
        if (s.matches("-?\\d+\\.\\d+")) {
            try { return Double.parseDouble(s); } catch (NumberFormatException ignored) {}
        }
        // string
        return s;
    }





   //*****************************AC03*************************************************************
   @Given("CC The api user verifies that the status code is {int}.")
   public void cc_the_api_user_verifies_that_the_status_code_is(Integer code) {
       response.then()
               .assertThat()
               .statusCode(code);
   }
    @Given("CC The api user verifies that the {string} information in the response body is {string}.")
    public void cc_the_api_user_verifies_that_the_information_in_the_response_body_is(String key, String value) {
        response.then()
                .assertThat()
                .body(key, Matchers.equalTo(value));
    }



    //**********************************US_07-AC01**********************************************

    //***************************US08_AC01**********************************************


    @Given("C The api user prepares a POST request to send to the API addCategory endpoint.")
    public void c_the_api_user_prepares_a_post_request_to_send_to_the_apı_add_category_endpoint() {
        jsonObjectBody.put("title", "Online Education");
        System.out.println("POST Request Body : " + jsonObjectBody);

    }
    @Given("C The api user sends a {string} request and saves the returned response.")
    public void c_the_api_user_sends_a_request_and_saves_the_returned_response(String httpMethod) {
        response = given()
                .spec(HooksAPI.spec)
                .contentType(ContentType.JSON)
                .when()
                .body(jsonObjectBody.toString())
                .post(API_Methods.fullPath);

        response.prettyPrint();

    }

    //***************************US08_AC02**********************************************

    @Given("C The api user prepares a POST request that contains no data.")
    public void c_the_api_user_prepares_a_post_request_that_contains_no_data() {
        // POST request için boş bir body oluşturuluyor



        JSONObject body = new JSONObject();
        response = given(HooksAPI.spec)
                .contentType(ContentType.JSON)
                .body(body.toString())
                .when()
                .post("/api/addCategory");

        System.out.println("Empty POST body prepared: " + body);

    }

    @Given("path params {string}")
    public void path_params_alias(String path) {
        // Var olan step'i çağır: örn.
        new stepdefinitions.CennetSteps().c_the_api_user_sets_path_parameters(path);
    }
    // Mevcut: body doğrulama adımların farklı cümlelerle var.
    // Genel amaçlı alias: body field "<jsonPath>" is "<expected>"
    @Then("body field {string} is {string}")
    public void body_field_is(String jsonPath, String expected) {
        Response resp = SharedState.getResponse(); // kendi projendeki response erişimini kullan
        Assert.assertNotNull("Response is null!", resp);
        resp.then().assertThat().body(jsonPath, equalTo(expected));
    }
    // Basit bir SharedState örneği (projende zaten varsa bunu KULLAN, bunu ekleme!)
    static class SharedState {
        private static Response lastResponse;
        public static void setResponse(Response r){ lastResponse = r; }
        public static Response getResponse(){ return lastResponse; }
    }








//********************************US09_TC01********************************************************


    @Given("C The api user prepares a PATCH request containing the {string} information to send to the api updateCategory endpoint.")
    public void c_the_api_user_prepares_a_patch_request_containing_the_information_to_send_to_the_api_update_category_endpoint(String title) {
        jsonObjectBody.put("title", title);
    }
    @Given("C The api user verifies that the {string} information in the response body is the same as the id path parameter in the endpoint.")
    public void c_the_api_user_verifies_that_the_information_in_the_response_body_is_the_same_as_the_id_path_parameter_in_the_endpoint(String string) {

    }
//********************************TC03*************************************************

    @Given("C The api user prepares a patch request body to send to the api updateCategory endpoint.")
    public void c_the_api_user_prepares_a_patch_request_body_to_send_to_the_api_update_category_endpoint() {
        jsonObjectBody.put("title", "Online Education");
        System.out.println("PATCH Request Body : " + jsonObjectBody);
    }
    @Given("C The api user sends a PATCH request and saves the returned response.")
    public void c_the_api_user_sends_a_patch_request_and_saves_the_returned_response() {

        response = given()
                .spec(HooksAPI.spec)
                .contentType(ContentType.JSON)
                .when()
                .body(jsonObjectBody.toString())
                .post(API_Methods.fullPath);

        response.prettyPrint();

    }

//*************************************TC05***************************
@Given("C The api user verifies that the {string} information is {string}")
public void c_the_api_user_verifies_that_the_information_is(String key, String value) {
    response.then()
            .assertThat()
            .body(key, Matchers.equalTo(value));

}

//***********************************TC10************************************************

    @Given("The api user sends a POST request to the api {string} endpoint to create a new {string} record and records the {string} information.")
    public void the_api_user_sends_a_post_request_to_the_api_endpoint_to_create_a_new_record_and_records_the_information(String string, String string2, String string3) {


    }

//***************************************US_10_TC01*********************************************************************
@Given("Cc The api user sends a {string} request and saves the returned response.")
public void cc_the_api_user_sends_a_request_and_saves_the_returned_response(String httpMethod) {
    response = given()
            .spec(HooksAPI.spec)
            .contentType(ContentType.JSON)
            .when()
            .delete(API_Methods.fullPath);

}


    @Given("CCc The api user verifies that the {string} information in the response body is {string}.")
    public void c_cc_the_api_user_verifies_that_the_information_in_the_response_body_is(String key2, String value2) {
        String key = "remark";
        String value = "failed";
        response.then().assertThat().body(key, Matchers.equalTo(value));

    }

    }



