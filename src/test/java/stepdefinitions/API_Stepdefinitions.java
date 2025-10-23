package stepdefinitions;

import config_Requirements.ConfigLoader;
import hooks.HooksAPI;
import io.cucumber.java.en.Given;
import io.restassured.http.ContentType;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import org.hamcrest.Matchers;
import org.json.JSONObject;
import org.junit.Assert;
import utilities.API_Utilities.API_Methods;
import utilities.API_Utilities.TestData;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.nullValue;
import static org.hamcrest.Matchers.containsString;
import static org.junit.Assert.*;

public class API_Stepdefinitions {

    Response response;
    JsonPath jsonPath;

    JSONObject jsonObjectBody = new JSONObject();
    HashMap<String, Object> responseMap;
    TestData testdata = new TestData();
    String exceptionMesaj;
    ConfigLoader configLoader = new ConfigLoader();

    @Given("The api user constructs the base url with the {string} token.")
    public void the_api_user_constructs_the_base_url_with_the_token(String userType) {
        HooksAPI.setUpApi(userType);
    }

    @Given("The api user sets {string} path parameters.")
    public void the_api_user_sets_path_parameters(String pathParam) {
        API_Methods.pathParam(pathParam);
    }

    @Given("The api user sends a GET request and saves the returned response.")
    public void the_api_user_sends_a_get_request_and_saves_the_returned_response() {
        response = given()
                .spec(HooksAPI.spec)
                .when()
                .get(API_Methods.fullPath);

        response.prettyPrint();
    }

    @Given("The api user verifies that the status code is {int}.")
    public void the_api_user_verifies_that_the_status_code_is(int code) {
        response.then()
                .assertThat()
                .statusCode(code);
    }

    @Given("The api user verifies that the {string} information in the response body is {string}.")
    public void the_api_user_verifies_that_the_information_in_the_response_body_is(String key, String value) {
        response.then()
                .assertThat()
                .body(key, Matchers.equalTo(value));
    }

    @Given("The api user sends a {string} request, saves the returned response, and verifies that the status code is '401' with the reason phrase Unauthorized.")
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

    @Given("The api user verifies the {string}, {string}, {int}, {int}, {int}, {string} and {string} information of the item at {int} in the response body.")
    public void the_api_user_verifies_the_and_information_of_the_item_at_in_the_response_body(String slug, String icon, int order, Integer int2, Integer int3, String string3, String title, int dataIndex) {
        jsonPath = response.jsonPath();
        Assert.assertEquals(slug, jsonPath.getString("data.categories[" + dataIndex + "].slug"));
        Assert.assertNull(jsonPath.get("data.categories[" + dataIndex + "].parent_id"));
        Assert.assertEquals(order, jsonPath.getInt("data.categories[" + dataIndex + "].order"));
        Assert.assertEquals(title, jsonPath.getString("data.categories[" + dataIndex + "].translations[0].title"));
    }

    // **************************************** /api/category/{id} ************************************************
    @Given("The api user verifies that the data in the response body includes {int}, {string}, {string}, {int}, {int}, {int}, {string} and {string}.")
    public void the_api_user_verifies_that_the_data_in_the_response_body_includes_and(int data_id, String slug, String icon, int order, int translations_id, int category_id, String locale, String title) {
        jsonPath = response.jsonPath();

        assertEquals(data_id, jsonPath.getInt("data.id"));
        assertEquals(slug, jsonPath.getString("data.slug"));
        assertNull(jsonPath.get("data.parent_id"));
        assertEquals(icon, jsonPath.getString("data.icon"));
        assertEquals(order, jsonPath.getInt("data.order"));
        assertNull(jsonPath.get("data.title"));

        assertEquals(category_id, jsonPath.getInt("data.translations[0].category_id"));
        assertEquals(locale, jsonPath.getString("data.translations[0].locale"));
        assertEquals(title, jsonPath.getString("data.translations[0].title"));

        response.then()
                .assertThat()
                .body("data.id", equalTo(data_id),
                        "data.slug", equalTo(slug),
                        "data.parent_id", nullValue(),
                        "data.translations[0].title", equalTo(title));
    }

    // ******************************************* /api/addCategory ***********************************************
    @Given("The api user prepares a POST request to send to the API addCategory endpoint.")
    public void the_api_user_prepares_a_post_request_to_send_to_the_apı_add_category_endpoint() {
        jsonObjectBody.put("title", "Online Education");
        System.out.println("POST Request Body : " + jsonObjectBody);
    }

    @Given("The api user sends a {string} request and saves the returned response.")
    public void the_api_user_sends_a_request_and_saves_the_returned_response(String httpMethod) {
        response = given()
                .spec(HooksAPI.spec)
                .contentType(ContentType.JSON)
                .when()
                .body(jsonObjectBody.toString())
                .post(API_Methods.fullPath);

        response.prettyPrint();
    }

    @Given("The api user prepares a POST request that contains no data.")
    public void the_api_user_prepares_a_post_request_that_contains_no_data() {
    }

    // ************************************************ /api/products *********************************************
    @Given("The api user verifies that the information for the entry with the specified {int} index in the response body includes {int}, {string}, {string}, {int}, {int}, {int}, {int}, {int}, {int}, {int}, {string}, {string}, {string}, {string} and {string}.")
    public void the_api_user_verifies_that_the_information_for_the_entry_with_the_specified_index_in_the_response_body_includes_and(int dataIndex, int creator_id, String type, String slug, int category_id, int price, int point, int unlimited_inventory, int ordering, int id, int product_id, String locale, String title, String seo_description, String summary, String description) {
        API_Methods.response.then()
                .assertThat()
                .body("data.products[" + dataIndex + "].creator_id", Matchers.equalTo(creator_id),
                        "data.products[" + dataIndex + "].type", Matchers.equalTo(type),
                        "data.products[" + dataIndex + "].slug", Matchers.equalTo(slug),
                        "data.products[" + dataIndex + "].category_id", Matchers.equalTo(category_id),
                        "data.products[" + dataIndex + "].price", Matchers.equalTo(price),
                        "data.products[" + dataIndex + "].point", Matchers.equalTo(point),
                        "data.products[" + dataIndex + "].unlimited_inventory", Matchers.equalTo(unlimited_inventory),
                        "data.products[" + dataIndex + "].ordering", Matchers.equalTo(ordering),
                        "data.products[" + dataIndex + "].translations[0].id", Matchers.equalTo(id),
                        "data.products[" + dataIndex + "].translations[0].product_id", Matchers.equalTo(product_id),
                        "data.products[" + dataIndex + "].translations[0].locale", Matchers.equalTo(locale),
                        "data.products[" + dataIndex + "].translations[0].title", Matchers.equalTo(title),
                        "data.products[" + dataIndex + "].translations[0].seo_description", containsString(seo_description),
                        "data.products[" + dataIndex + "].translations[0].summary", containsString(summary),
                        "data.products[" + dataIndex + "].translations[0].description", containsString(description));
    }

    // ********************************************* /api/product/{id} ********************************************
    @Given("The api user verifies the content of the data in the response body, including {int}, {int}, {string}, {string}, {int}, {int}, {int}, {int}, {int}, {int}, {int}, {string}, {string}, {string}, {string} and {string}.")
    public void the_api_user_verifies_the_content_of_the_data_in_the_response_body_including_and(int data_id, int creator_id, String type, String slug, int category_id, int price, int point, int unlimited_inventory, int ordering, int translations_id, int product_id, String locale, String title, String seo_description, String summary, String description) {
        jsonPath = API_Methods.response.jsonPath();

        assertEquals(data_id, jsonPath.getInt("data.id"));
        assertEquals(creator_id, jsonPath.getInt("data.creator_id"));
        assertEquals(type, jsonPath.getString("data.type"));
        assertEquals(slug, jsonPath.getString("data.slug"));
        assertEquals(category_id, jsonPath.getInt("data.category_id"));
        assertEquals(price, jsonPath.getInt("data.price"));
        assertEquals(point, jsonPath.getInt("data.point"));
        assertEquals(unlimited_inventory, jsonPath.getInt("data.unlimited_inventory"));
        assertEquals(ordering, jsonPath.getInt("data.ordering"));
        assertEquals(translations_id, jsonPath.getInt("data.translations[0].id"));
        assertEquals(product_id, jsonPath.getInt("data.translations[0].product_id"));
        assertEquals(locale, jsonPath.getString("data.translations[0].locale"));
        assertEquals(title, jsonPath.getString("data.translations[0].title"));
        assertTrue(jsonPath.getString("data.translations[0].seo_description").contains(seo_description));
        assertTrue(jsonPath.getString("data.translations[0].summary").contains(summary));
        assertTrue(jsonPath.getString("data.translations[0].description").contains(description));
    }

    // *********************************************** /api/addProduct ********************************************
    @Given("The api user prepares a POST request to send to the api addProduct endpoint containing the information {string}, {int}, {int}, {string}, {string} and {string}.")
    public void the_api_user_prepares_a_post_request_to_send_to_the_api_add_product_endpoint_containing_the_information_and(String type, int price, int category_id, String title, String summary, String description) {
        JSONObject requestBody = new JSONObject();
        requestBody.put("type", type);
        requestBody.put("price", price);
        requestBody.put("category_id", category_id);
        requestBody.put("title", title);
        requestBody.put("summary", summary);
        requestBody.put("description", description);

        jsonObjectBody = requestBody;
    }

    // *********************************************** Category Validation ********************************************
    @Given("The api user verifies the {string}, {string}, {string}, {string}, {string}, {string} and {string} information of the returned categories.")
    public void the_api_user_verifies_the_and_information_of_the_returned_categories(
            String slugKey, String iconKey, String orderKey, String idKey, String categoryIdKey, String localeKey, String titleKey) {

        JsonPath json = response.jsonPath();
        List<Map<String, Object>> categories = findCategories(json);
        Assert.assertFalse("Category list is empty", categories.isEmpty());

        for (Map<String, Object> category : categories) {
            Assert.assertTrue(slugKey + " must exist", category.containsKey(slugKey));
            Assert.assertNotNull(slugKey + " is null", category.get(slugKey));

            Assert.assertTrue(iconKey + " must exist", category.containsKey(iconKey));
            Assert.assertNotNull(iconKey + " is null", category.get(iconKey));

            Assert.assertTrue(orderKey + " must exist", category.containsKey(orderKey));
            Assert.assertTrue(orderKey + " must be a number", category.get(orderKey) instanceof Number);

            Assert.assertTrue(idKey + " must exist", category.containsKey(idKey));
            Assert.assertTrue(idKey + " must be a number", category.get(idKey) instanceof Number);

            if (category.containsKey(titleKey) && category.get(titleKey) != null) {
                Assert.assertTrue(titleKey + " must be String when present", category.get(titleKey) instanceof String);
            }

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> translations = (List<Map<String, Object>>) category.get("translations");
            Assert.assertNotNull("translations must exist", translations);
            Assert.assertFalse("translations must not be empty", translations.isEmpty());

            for (Map<String, Object> tr : translations) {
                Assert.assertTrue(categoryIdKey + " must exist", tr.containsKey(categoryIdKey));
                Assert.assertTrue(categoryIdKey + " must be a number", tr.get(categoryIdKey) instanceof Number);

                Assert.assertTrue(localeKey + " must exist", tr.containsKey(localeKey));
                Assert.assertNotNull(localeKey + " is null", tr.get(localeKey));
                Assert.assertTrue(localeKey + " must be String", tr.get(localeKey) instanceof String);

                Assert.assertTrue(titleKey + " must exist in translations", tr.containsKey(titleKey));
                Assert.assertNotNull("translations." + titleKey + " is null", tr.get(titleKey));
                Assert.assertTrue("translations." + titleKey + " must be String", tr.get(titleKey) instanceof String);
            }

            Object sc = category.get("sub_categories");
            if (sc instanceof List) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> subs = (List<Map<String, Object>>) sc;
                for (Map<String, Object> sub : subs) {
                    Assert.assertTrue(slugKey + " must exist (sub)", sub.containsKey(slugKey));
                    Assert.assertNotNull(slugKey + " is null (sub)", sub.get(slugKey));

                    Assert.assertTrue(iconKey + " must exist (sub)", sub.containsKey(iconKey));
                    Assert.assertNotNull(iconKey + " is null (sub)", sub.get(iconKey));

                    Assert.assertTrue(orderKey + " must exist (sub)", sub.containsKey(orderKey));
                    Assert.assertTrue(orderKey + " must be a number (sub)", sub.get(orderKey) instanceof Number);

                    Assert.assertTrue(idKey + " must exist (sub)", sub.containsKey(idKey));
                    Assert.assertTrue(idKey + " must be a number (sub)", sub.get(idKey) instanceof Number);

                    Object subTrObj = sub.get("translations");
                    if (subTrObj instanceof List) {
                        @SuppressWarnings("unchecked")
                        List<Map<String, Object>> subTrs = (List<Map<String, Object>>) subTrObj;
                        for (Map<String, Object> tr : subTrs) {
                            Assert.assertTrue(categoryIdKey + " must exist (sub.tr)", tr.containsKey(categoryIdKey));
                            Assert.assertTrue(categoryIdKey + " must be a number (sub.tr)", tr.get(categoryIdKey) instanceof Number);

                            Assert.assertTrue(localeKey + " must exist (sub.tr)", tr.containsKey(localeKey));
                            Assert.assertNotNull(localeKey + " is null (sub.tr)", tr.get(localeKey));
                            Assert.assertTrue(localeKey + " must be String (sub.tr)", tr.get(localeKey) instanceof String);

                            Assert.assertTrue(titleKey + " must exist (sub.tr)", tr.containsKey(titleKey));
                            Assert.assertNotNull("sub.translations." + titleKey + " is null", tr.get(titleKey));
                            Assert.assertTrue("sub.translations." + titleKey + " must be String", tr.get(titleKey) instanceof String);
                        }
                    }
                }
            }
        }
    }

    // --- Akıllı kategori listesi bulucu ---
    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> findCategories(JsonPath json) {
        java.util.function.Function<String, List<Map<String, Object>>> asList = (path) -> {
            Object v = (path == null || path.isEmpty()) ? json.get("$") : json.get(path);
            if (v instanceof List) return (List<Map<String, Object>>) v;
            return null;
        };

        List<Map<String, Object>> categories =
                asList.apply("$") != null ? asList.apply("$")
                        : asList.apply("data") != null ? asList.apply("data")
                        : asList.apply("data.data") != null ? asList.apply("data.data")
                        : asList.apply("categories") != null ? asList.apply("categories")
                        : asList.apply("data.categories");

        if (categories == null) {
            try {
                Map<String, Object> rootMap = json.getMap("$");
                System.out.println("ROOT keys: " + (rootMap == null ? "not a map" : rootMap.keySet()));
                if (rootMap != null && rootMap.get("data") instanceof Map) {
                    System.out.println("data keys: " + ((Map<?, ?>) rootMap.get("data")).keySet());
                }
            } catch (Exception ignore) {
            }
            Assert.fail("Category list not found. Tried: $, data, data.data, categories, data.categories");
        }
        return categories;
    }
}
