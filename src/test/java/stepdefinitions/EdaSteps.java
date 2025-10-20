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

import static org.junit.Assert.*;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import static io.restassured.RestAssured.given;

// ===== Allure ekleri =====
import io.qameta.allure.Allure;
import io.qameta.allure.Attachment;

// ===== (opsiyonel) WebDriver screenshot için =====
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import utilities.API_Utilities.Driver;

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

    // =========================
    // Allure Attachment Yardımcıları
    // =========================
    @Attachment(value = "{name}", type = "text/plain")
    public String attachText(String name, String content) {
        return content == null ? "" : content;
    }

    @Attachment(value = "{name}", type = "application/json", fileExtension = ".json")
    public byte[] attachJson(String name, String json) {
        if (json == null) json = "";
        return json.getBytes(java.nio.charset.StandardCharsets.UTF_8);
    }

    @Attachment(value = "{name}", type = "text/html", fileExtension = ".html")
    public byte[] attachHtml(String name, String html) {
        if (html == null) html = "";
        return html.getBytes(java.nio.charset.StandardCharsets.UTF_8);
    }

    @Attachment(value = "{name}", type = "image/png")
    public byte[] attachPng(String name, byte[] png) {
        return png;
    }

    /** Response’u Allure’a status, headers, body olarak ekler */
    public void attachResponseAll(String verb, String path, Response r) {
        try {
            if (r == null) {
                attachText(verb + " " + path + " (null response)", "");
                return;
            }
            attachText(verb + " " + path + " | Status", r.getStatusLine());
            attachText(verb + " " + path + " | Headers", String.valueOf(r.getHeaders()));

            String ct = String.valueOf(r.getContentType());
            String body = "";
            try { body = r.getBody() == null ? "" : r.getBody().asString(); } catch (Throwable ignore) {}

            if (ct != null && ct.toLowerCase(Locale.ROOT).contains("json")) {
                attachJson(verb + " " + path + " | Body(JSON)", body);
            } else if (ct != null && ct.toLowerCase(Locale.ROOT).contains("html")) {
                attachHtml(verb + " " + path + " | Body(HTML)", body);
            } else {
                attachText(verb + " " + path + " | Body(text)", body);
            }
        } catch (Throwable t) {
            Allure.addAttachment("attachResponseAll error", String.valueOf(t));
        }
    }

    /** Manuel (veya HTML response durumunda otomatik) ekran görüntüsü */
    public void attachSeleniumScreenshot(String name) {
        try {
            WebDriver drv = Driver.getDriver();
            if (drv != null && drv instanceof TakesScreenshot) {
                byte[] png = ((TakesScreenshot) drv).getScreenshotAs(OutputType.BYTES);
                attachPng(name, png);
            } else {
                attachText(name + " (info)", "WebDriver yok veya TakesScreenshot desteklemiyor.");
            }
        } catch (Throwable t) {
            attachText(name + " (error)", "Screenshot alınamadı: " + t.getMessage());
        }
    }

    /** Response HTML ise ve driver da varsa, sayfanın screenshot’unu dene */
    public void attachHtmlScreenshotIfPossible(String name, Response r) {
        try {
            String ct = String.valueOf(r.getContentType()).toLowerCase(Locale.ROOT);
            if (ct.contains("html")) {
                attachSeleniumScreenshot(name);
            }
        } catch (Throwable ignore) {}
    }

    // =========================
    // Steps
    // =========================

    @Given("E The api user constructs the base url with the {string} token.")
    public void the_api_user_constructs_the_base_url_with_the_token(String userType) {
        HooksAPI.setUpApi(userType);
        attachText("Token UserType", userType);
    }

    @Given("E The api user sets {string} path parameters.")
    public void the_api_user_sets_path_parameters(String pathParam) {
        API_Methods.pathParam(pathParam);
        attachText("Path Params", String.valueOf(API_Methods.fullPath));
    }

    @Given("E The api user sends a GET request and saves the returned response.")
    public void the_api_user_sends_a_get_request_and_saves_the_returned_response() {
        response = given()
                .spec(HooksAPI.spec)
                .when()
                .get(API_Methods.fullPath);

        attachResponseAll("GET", API_Methods.fullPath, response);
        attachHtmlScreenshotIfPossible("GET HTML Screenshot (if any)", response);
        response.prettyPrint();
    }

    @Given("E The api user verifies that the status code is {int}.")
    public void the_api_user_verifies_that_the_status_code_is(int code) {
        attachText("Expect Status", String.valueOf(code));
        response.then().assertThat().statusCode(code);
    }

    @Given("E The api user verifies that the {string} information in the response body is {string}.")
    public void the_api_user_verifies_that_the_information_in_the_response_body_is(String key, String value) {
        attachText("Expect body field", key + " = " + value);
        response.then().assertThat().body(key, Matchers.equalTo(value));
    }

    @Given("E The api user verifies that the {string} information in the response body is {int}.")
    public void the_api_user_verifies_that_the_information_in_the_response_body_is(String key, Integer value) {
        attachText("Expect body field", key + " = " + value);
        response.then().assertThat().body(key, Matchers.equalTo(value));
    }

    @Then("E The fields and values in the response body are verified:")
    public void response_body_deki_alanlar_ve_değerleri_doğrulanır(DataTable dataTable) {
        Map<String, String> expectedFields = dataTable.asMap(String.class, String.class);
        attachJson("Expected fields (table)", new JSONObject(expectedFields).toString());

        for (Map.Entry<String, String> entry : expectedFields.entrySet()) {
            String field = entry.getKey();
            String expectedValue = entry.getValue();

            if (!field.startsWith("data.")) {
                field = "data." + field;
            }

            Object actualValueObj = response.jsonPath().get(field);
            String actualValue = actualValueObj == null ? null : actualValueObj.toString();

            attachText("Verify " + field, "expected=" + expectedValue + " | actual=" + actualValue);

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
            attachResponseAll(httpMethod, API_Methods.fullPath, response);
        } catch (Exception e) {
            exceptionMesaj = e.getMessage();
            attachText("Unauthorized Exception message", exceptionMesaj);
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

        attachJson("POST Body (addPricePlan)", jsonObjectBody.toString());
    }

    @Given("E The api user sends a {string} request and saves the returned response.")
    public void the_api_user_sends_a_request_and_saves_the_returned_response(String httpMethod) {
        response = given()
                .spec(HooksAPI.spec)
                .contentType(ContentType.JSON)
                .when()
                .body(jsonObjectBody.toString())
                .post(API_Methods.fullPath);

        attachResponseAll(httpMethod.toUpperCase(), API_Methods.fullPath, response);
        attachHtmlScreenshotIfPossible(httpMethod.toUpperCase() + " HTML Screenshot (if any)", response);
        response.prettyPrint();
    }

    @Given("E The api user prepares a POST request that contains no data.")
    public void the_api_user_prepares_a_post_request_that_contains_no_data() {
        attachText("POST empty body", "(no content)");
    }

    @Given("NT The api user sends a GET request and saves the returned response.")
    public void NTthe_api_user_sends_a_request_and_saves_the_returned_response() {
        response = given()
                .spec(HooksAPI.spec)
                .contentType(ContentType.JSON)
                .when()
                .body(jsonObjectBody.toString())
                .get(API_Methods.fullPath);

        attachResponseAll("GET (NT)", API_Methods.fullPath, response);
        attachHtmlScreenshotIfPossible("GET (NT) HTML Screenshot (if any)", response);
        response.prettyPrint();
    }

    @Then("E The api user verifies that the status code is {int}")
    public void the_api_user_verifies_status_code(int expectedStatusCode) {
        attachText("Expect Status", String.valueOf(expectedStatusCode));
        response.then().statusCode(expectedStatusCode);
    }

    @Given("E The api user prepares a PATCH request containing the {string} information to send to the api updateCategory endpoint.")
    public void e_the_api_user_prepares_a_patch_request_containing_the_information_to_send_to_the_api_update_category_endpoint(String title) {
        jsonObjectBody.put("title", title);
        attachJson("PATCH Body (updateCategory)", jsonObjectBody.toString());
    }

    @Given("E The api user sends a PATCH request and saves the returned response.")
    public void the_api_user_sends_a_patch_request_and_saves_the_returned_response() {
        response = given()
                .spec(HooksAPI.spec)
                .contentType(ContentType.JSON)
                .when()
                .body(jsonObjectBody.toString())
                .patch(API_Methods.fullPath);

        attachResponseAll("PATCH", API_Methods.fullPath, response);
        attachHtmlScreenshotIfPossible("PATCH HTML Screenshot (if any)", response);
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

        attachResponseAll("DELETE", API_Methods.fullPath, response);
        attachHtmlScreenshotIfPossible("DELETE HTML Screenshot (if any)", response);
        response.prettyPrint();
    }

    @Given("E The api user verifies the {int} {int}")
    public void ee_the_api_user_verifies_the(int id, int expectedId) {
        Map<String, Object> root = response.jsonPath().getMap("$");

        String[] possibleKeys = {
                "Updated Price Plans ID",
                "Deleted Price Plan Id",
                "Created Price Plan Id"
        };

        Object foundValue = null;
        String foundKey = null;

        for (String key : possibleKeys) {
            if (root.containsKey(key)) {
                foundValue = root.get(key);
                foundKey = key;
                break;
            }
        }

        attachText("ID key found", String.valueOf(foundKey));
        assertNotNull("Response'ta beklenen ID alanı bulunamadı!", foundValue);

        int returnedId = (foundValue instanceof Number)
                ? ((Number) foundValue).intValue()
                : Integer.parseInt(foundValue.toString().trim());

        attachText("Returned ID", String.valueOf(returnedId));
        Assert.assertEquals("Path param ID ile dönülen ID eşit değil!", id, returnedId);
        Assert.assertEquals("Examples tablosundaki ID ile dönülen ID eşit değil!", expectedId, returnedId);
    }

    @Given("E The api user prepares a PATCH request that contains no data.")
    public void e_the_api_user_prepares_a_patch_request_that_contains_no_data() {
        attachText("PATCH empty body", "(no content)");
    }
}
