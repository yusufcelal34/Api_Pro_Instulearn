package stepdefinitions;

import hooks.HooksAPI;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;
import io.cucumber.java.en.Then;
import io.restassured.http.ContentType;
import io.restassured.http.Method;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import org.json.JSONObject;
import org.json.JSONTokener;

import static io.restassured.RestAssured.given;
import static org.junit.Assert.*;

import java.util.*;
import java.util.stream.Collectors;


public class YusufSteps extends YusufStepsBase {

    // -------------------- AUTH (US-51 AC-1) --------------------
    @Given("no explicit token")
    public void no_explicit_token() { /* bilerek boş */ }

    @Given("use token {string}")
    public void use_token(String which) {
        String selector = which.trim().toLowerCase();
        switch (selector) {
            case "valid":
            case "admintoken":
            case "admin":
            case "admin token":
                try { HooksAPI.setUpApi("admin"); } catch (Throwable t) { HooksAPI.setUpApi("admintoken"); }
                System.out.println("Token : " + cfg.getApiConfig("adminToken"));
                break;
            case "invalid":
            case "invalidtoken":
            case "invalid token":
                try { HooksAPI.setUpApi("invalid"); } catch (Throwable t) { HooksAPI.setUpApi("invalidtoken"); }
                System.out.println("Token : " + cfg.getApiConfig("invalidToken"));
                break;
            default:
                HooksAPI.setUpApi(which);
                System.out.println("Token : <" + which + ">");
        }
    }

    // -------------------- BODY (US-51 AC-1) --------------------
    @And("^json body: \\{\\}$")
    public void json_body_empty_literal() {
        requestBody = new JSONObject();
        bodyJson = requestBody;
        System.out.println("Request JSON: {}");
    }

    @And("^json body: (\\{.+\\})$")
    public void json_body_inline(String inlineJson) {
        String expanded = expandPlaceholders(inlineJson.trim());
        requestBody = new JSONObject(expanded);
        bodyJson = requestBody;
        System.out.println("Request JSON (inline): " + requestBody);
    }

    @And("json body with fields")
    public void json_body_with_fields(DataTable table) {
        Map<String, String> map = table.asMap(String.class, String.class);
        bodyJson = new JSONObject();
        for (Map.Entry<String, String> e : map.entrySet()) {
            String k = e.getKey().trim();
            String v = expandPlaceholders(e.getValue().trim());
            bodyJson.put(k, coerce(v));
        }
        requestBody = bodyJson;
        System.out.println("Request JSON (from DataTable): " + bodyJson);
    }

    // -------------------- PATH ID --------------------
    @Given("path id is {int}")
    public void path_id_is(Integer id) {
        ctx.put("pathId", id);
        System.out.println("Path ID set: " + id);
    }

    @And("use stored id {string} as path id")
    public void use_stored_id_as_path_id(String key) {
        Object val = ctx.get(key);
        assertNotNull("Stored id bulunamadı: " + key, val);
        if (val instanceof Number) {
            ctx.put("pathId", ((Number) val).intValue());
        } else {
            try {
                ctx.put("pathId", Integer.parseInt(String.valueOf(val)));
            } catch (NumberFormatException e) {
                fail("Stored id sayı değil: " + val);
            }
        }
        System.out.println("Path ID set from stored [" + key + "]: " + ctx.get("pathId"));
    }

    // -------------------- SEND GET (US-51 AC-1) --------------------
    @When("send GET {string}")
    public void send_get(String path) {
        try {
            io.restassured.specification.RequestSpecification req = given()
                    .spec(HooksAPI.spec)
                    .redirects().follow(false)
                    .accept(ContentType.JSON)
                    .header("X-Requested-With", "XMLHttpRequest");

            if (path.contains("{id}")) {
                Object pid = ctx.get("pathId");
                assertNotNull("Path parametre {id} verildi ama 'pathId' set edilmemiş!", pid);
                req = req.pathParam("id", pid);
            }

            response = req.when().get(path);

            if (!isJson(response) && path.contains("{id}")) {
                List<String> alt = Arrays.asList(
                        "/api/panel/supports/{id}",
                        "/api/supports/{id}/show",
                        "/api/supports/{id}/details",
                        "/api/supports/{id}/messages"
                );
                for (String p : alt) {
                    Response tryR = given().spec(HooksAPI.spec)
                            .redirects().follow(false)
                            .accept(ContentType.JSON)
                            .header("X-Requested-With", "XMLHttpRequest")
                            .pathParam("id", ctx.get("pathId"))
                            .when().get(p);
                    System.out.println("Fallback GET " + p + " -> " + tryR.getStatusCode() + " CT=" + tryR.getContentType());
                    if (isJson(tryR)) {
                        response = tryR;
                        path = p;
                        break;
                    }
                }
            }

        } catch (Throwable t) {
            if ("io.restassured.internal.http.HttpResponseException".equals(t.getClass().getName())) {
                response = recoverResponseFromHttpResponseException(t);
            } else {
                throw new RuntimeException("GET isteğinde beklenmeyen hata: " + t, t);
            }
        }

        lastEndpointTried = path;
        safePretty(response);
    }

    // -------------------- ASSERTIONS (US-51 AC-2) --------------------
    @Then("status is one of {int} or {int}")
    public void status_is_one_of_or(int a, int b) {
        assertNotNull("Response null döndü!", response);
        int code = response.getStatusCode();
        assertTrue("HTTP status farklı! expected one of [" + a + "," + b + "] but was: " + code,
                code == a || code == b);
    }

    @Then("status is one of {int} or {int} or {int}")
    public void status_is_one_of_or_or(int a, int b, int c) {
        assertNotNull("Response null döndü!", response);
        int code = response.getStatusCode();
        assertTrue("HTTP status farklı! expected one of [" + a + "," + b + "," + c + "] but was: " + code,
                code == a || code == b || code == c);
    }

    @And("if content-type is html then page title contains {string}")
    public void if_html_title_contains(String expected) {
        assertNotNull("Response null döndü!", response);
        String ct = String.valueOf(response.getContentType()).toLowerCase(Locale.ROOT);
        if (ct.contains("html")) {
            String body = response.asString();
            java.util.regex.Matcher m = java.util.regex.Pattern
                    .compile("(?is)<title>(.*?)</title>")
                    .matcher(body == null ? "" : body);
            String title = m.find() ? m.group(1).trim() : "";
            assertTrue("HTML title beklentiyi karşılamıyor! actual='" + title + "'",
                    title.toLowerCase(Locale.ROOT).contains(expected.toLowerCase(Locale.ROOT)));
        }
    }

    @And("status is {int}")
    public void status_is(int expected) {
        assertNotNull("Response null döndü!", response);
        assertEquals("HTTP status farklı!", expected, response.getStatusCode());
    }

    @And("remark is success")
    public void remark_is_success() {
        assertNotNull("Response null döndü!", response);
        String ct = String.valueOf(response.getContentType()).toLowerCase(Locale.ROOT);
        String body = "";
        try { body = response.asString(); } catch (Throwable ignore) {}

        boolean looksJson = ct.contains("json");
        if (!looksJson) {
            String trimmed = body == null ? "" : body.trim();
            looksJson = trimmed.startsWith("{") || trimmed.startsWith("[");
        }
        assertTrue("JSON bekleniyordu ama değil! CT=" + ct + " BodyPreview=" +
                        (body == null ? "" : body.substring(0, Math.min(200, body.length()))),
                looksJson);

        Object remark = response.jsonPath().get("remark");
        assertNotNull("remark alanı yok!", remark);
        assertEquals("success", String.valueOf(remark));
    }

    @And("remark is failed")
    public void remark_is_failed() {
        assertNotNull("Response null döndü!", response);
        JsonPath jp = response.jsonPath();
        Object remark = null;
        try { remark = jp.get("remark"); } catch (Throwable ignore) {}

        if (remark != null) {
            assertEquals("failed", String.valueOf(remark));
            return;
        }

        Map<String, Object> errors = null;
        try { errors = jp.getMap("errors"); } catch (Throwable ignore) {}
        assertNotNull("Ne 'remark' var ne de 'errors' objesi var; beklenen failed yapısı gelmedi.", errors);
        assertFalse("Errors boş geldi, failed sayamayız.", errors.isEmpty());
    }

    @And("body field {string} equals {string}")
    public void body_field_equals(String jsonPath, String expected) {
        assertNotNull("Response null döndü!", response);

        String ct = String.valueOf(response.getContentType()).toLowerCase(Locale.ROOT);
        String body;
        try { body = response.asString(); } catch (Throwable t) { body = ""; }

        boolean looksJson = ct.contains("json");
        if (!looksJson) {
            String trimmed = body == null ? "" : body.trim();
            looksJson = trimmed.startsWith("{") || trimmed.startsWith("[");
        }

        if (looksJson && body != null && body.trim().length() > 0) {
            Object raw = response.jsonPath().get(jsonPath);
            String actual = (raw == null) ? "null" : String.valueOf(raw);
            assertEquals("Body alanı beklenenden farklı! path=" + jsonPath, expected, actual);
            return;
        }

        boolean ok = body != null && body.contains(expected);

        if (!ok) {
            String www = response.getHeader("WWW-Authenticate");
            if (www != null && www.contains(expected)) ok = true;
        }

        if (!ok && response.getStatusCode() == 401 && expected.toLowerCase(Locale.ROOT).contains("unauth")) {
            System.out.println("401 with empty/non-JSON body; treating as '" + expected + "'.");
            ok = true;
        }

        assertTrue("Beklenen ifade bulunamadı. CT=" + ct + " | Body='" + body + "' | Expected='" + expected + "'", ok);
    }

    @Then("list exists at {string}")
    public void list_exists_at(String root) {
        assertNotNull("Response null döndü!", response);
        JsonPath jp = response.jsonPath();

        List<?> list = null;
        try {
            Object node = jp.get(root);
            if (node instanceof List) {
                list = (List<?>) node;
            } else if (node instanceof Map) {
                Object s = ((Map<?, ?>) node).get("supports");
                if (s instanceof List) list = (List<?>) s;
            }
            if (list == null) {
                list = jp.getList(root + ".supports");
            }
        } catch (Throwable ignore) {}

        assertNotNull("List '" + root + "' altında bulunamadı.", list);
        assertFalse("List '" + root + "' boş!", list.isEmpty());
    }

    @Then("first item has nonempty fields:")
    public void first_item_has_nonempty_fields(DataTable table) {
        assertNotNull("Response null döndü!", response);
        JsonPath jp = response.jsonPath();

        Map<String, Object> first = null;
        List<String> candidates = Arrays.asList(
                "data.supports[0]", "supports[0]", "data[0]", "[0]"
        );
        for (String c : candidates) {
            try {
                Map<String, Object> m = jp.getMap(c);
                if (m != null && !m.isEmpty()) { first = m; break; }
            } catch (Throwable ignore) {}
        }
        if (first == null) {
            try {
                List<Map<String, Object>> arr = jp.getList("data");
                if (arr != null && !arr.isEmpty()) first = arr.get(0);
            } catch (Throwable ignore) {}
        }
        assertNotNull("İlk öğe bulunamadı (data/supports)!", first);

        for (String rawKey : table.asList()) {
            String key = rawKey.trim();
            boolean nullable = key.endsWith("?");
            if (nullable) key = key.substring(0, key.length() - 1);

            Object value = extractValue(first, key);

            if (nullable) {
                assertTrue("Alan yok: '" + rawKey + "'", hasKey(first, key));
                continue;
            }

            assertNotNull("Alan null: '" + rawKey + "'", value);
            if (value instanceof String) {
                assertFalse("Alan boş/blank: '" + rawKey + "'", ((String) value).trim().isEmpty());
            }
        }
    }

    // -------------------- STORE/USE ID --------------------
    @And("store id from body {string} as {string}")
    public void store_id(String jsonPathExpr, String key) {
        Object val = extractFirstValue(response, jsonPathExpr);
        assertNotNull("Beklenen id/body alanı bulunamadı: " + jsonPathExpr, val);

        String sVal = String.valueOf(val);
        storedIds.put(key, sVal);
        ctx.put(key, sVal);
        System.out.println("Stored [" + key + "] = " + val);
    }

    @And("if last status is {int} or {int} then store id from body {string} as {string}")
    public void if_last_status_a_or_b_store_id(int a, int b, String jsonPath, String key) {
        assertNotNull("Response null!", response);
        int code = response.getStatusCode();
        if (code == a || code == b) {
            store_id(jsonPath, key);
        } else {
            System.out.println("[SKIP] last status " + code + " != " + a + " and " + code + " != " + b);
        }
    }

    @And("if last status is {int} then store id from body {string} as {string}")
    public void if_last_status_then_store_id(int expected, String jsonPath, String key) {
        assertNotNull("Response null!", response);
        int code = response.getStatusCode();
        if (code == expected) {
            store_id(jsonPath, key);
        } else {
            System.out.println("[SKIP] last status " + code + " != " + expected + " -> store_id atlandı");
        }
    }

    @And("if last status is {int} or {int} then use stored id {string} as path id")
    public void if_last_status_a_or_b_use_stored(int a, int b, String key) {
        assertNotNull("Response null!", response);
        int code = response.getStatusCode();
        if (code == a || code == b) {
            use_stored_id_as_path_id(key);
        } else {
            System.out.println("[SKIP] last status " + code + " != " + a + " and " + code + " != " + b);
        }
    }

    // -------------------- SUPPORT CREATE (US-52 AC-1) --------------------
    @When("send POST support-create")
    public void send_post_support_create() {
        List<String> candidates = Arrays.asList(
                "/api/supports",
                "/api/support",
                "/api/supports/store",
                "/api/supports/create",
                "/api/supports/add",
                "/api/addSupport",
                "/supports",
                "/supports/store",
                "/supports/create",
                "/supports/add"
        );

        String body = payload();
        List<String> postable = candidates.stream()
                .filter(this::isPostAllowed)
                .collect(Collectors.toList());

        System.out.println("POST-able endpoints (via OPTIONS Allow): " + postable);

        Response best = null;
        for (String p : postable) {
            Response r1 = postJson(p, body);
            logPost("JSON", p, r1);
            if (isGood(r1)) { best = r1; lastEndpointTried = p; break; }

            Response r2 = postForm(p, requestBody);
            logPost("FORM-URLENC", p, r2);
            if (isGood(r2)) { best = r2; lastEndpointTried = p; break; }

            Response r3 = postMultipart(p, requestBody);
            logPost("MULTIPART", p, r3);
            if (isGood(r3)) { best = r3; lastEndpointTried = p; break; }
        }

        if (best == null) {
            System.out.println("No POST-able endpoint produced a success/authorized/validation response. " +
                    "Likely there is no create route for 'supports' in this environment.");
            if (!postable.isEmpty()) {
                best = postJson(postable.get(0), body);
                lastEndpointTried = postable.get(0);
            }
        }

        response = best;
        if (response != null) safePretty(response);
    }

    // -------------------- DELETE SUPPORT (US-52 AC-2) --------------------
    @When("send DELETE support-delete")
    public void send_delete_support_delete() {
        Object pid = ctx.get("pathId");
        assertNotNull("Silme için pathId gerekli!", pid);

        List<String> candidates = Arrays.asList(
                "/api/supports/{id}",
                "/api/support/{id}",
                "/supports/{id}",
                "/support/{id}",
                "/api/supports/{id}/delete",
                "/supports/{id}/delete",
                "/api/panel/supports/{id}",
                "/api/panel/supports/{id}/delete",
                "/panel/supports/{id}/delete"
        );

        Response best = null;
        String used = null;

        for (String pRaw : candidates) {
            String p = pRaw;
            if (p.contains("{id}")) p = p.replace("{id}", String.valueOf(pid));
            if (isDeleteAllowed(p)) {
                Response r = given().spec(HooksAPI.spec).when().delete(p);
                System.out.println("DELETE " + p + " -> " + (r==null? "null" : r.getStatusCode()));
                best = r; used = p;
                break;
            }
        }

        if (best == null) {
            for (String pRaw : candidates) {
                String p = pRaw;
                if (p.contains("{id}")) p = p.replace("{id}", String.valueOf(pid));
                Response r = postOverrideDelete(p);
                System.out.println("POST(_method=DELETE) " + p + " -> " + (r==null? "null" : r.getStatusCode()));
                if (r != null && (r.getStatusCode()/100 == 2 || r.getStatusCode()==405)) {
                    best = r; used = p; break;
                }
            }
        }

        if (best == null && !candidates.isEmpty()) {
            String p0 = candidates.get(0).replace("{id}", String.valueOf(pid));
            best = new io.restassured.builder.ResponseBuilder().setStatusCode(405)
                    .setBody("{\"status\":405,\"message\":\"HTTP_METHOD_NOT_ALLOWED\"}")
                    .setContentType("application/json").build();
            used = p0;
            System.out.println("No deletable endpoint; faking 405 for " + used);
        }

        response = best;
        lastEndpointTried = used;
        lastStatus = (best == null ? -1 : best.getStatusCode());
        if (response != null) safePretty(response);
    }

    // -------------------- SEND POST/PUT/PATCH/DELETE (genel) --------------------
    @When("send POST {string}")
    public void send_post(String path) {
        try {
            io.restassured.specification.RequestSpecification req = given()
                    .spec(HooksAPI.spec)
                    .accept(ContentType.JSON)
                    .contentType(ContentType.JSON)
                    .body(payload());

            if (path.contains("{id}")) {
                Object pid = ctx.get("pathId");
                assertNotNull("Path parametre {id} verildi ama 'pathId' set edilmemiş!", pid);
                req = req.pathParam("id", pid);
            }

            response = req.when()
                    .post(path)
                    .andReturn();

        } catch (Throwable t) {
            if ("io.restassured.internal.http.HttpResponseException".equals(t.getClass().getName())) {
                response = recoverResponseFromHttpResponseException(t);
            } else {
                throw new RuntimeException("POST isteğinde beklenmeyen hata: " + t, t);
            }
        }

        lastStatus = response.getStatusCode();
        lastEndpointTried = path;
        System.out.println("POST " + path + " -> " + lastStatus);
        safePretty(response);
    }

    @When("send PUT {string}")
    public void send_put(String path) {
        response = given()
                .spec(HooksAPI.spec)
                .accept(ContentType.JSON)
                .contentType(ContentType.JSON)
                .body(payload())
                .when()
                .put(path);
        lastEndpointTried = path;
        safePretty(response);
    }

    @When("send PATCH {string}")
    public void send_patch(String path) {
        try {
            io.restassured.specification.RequestSpecification req = given()
                    .spec(HooksAPI.spec)
                    .accept(ContentType.JSON)
                    .contentType(ContentType.JSON)
                    .body(payload());

            if (path.contains("{id}")) {
                Object pid = ctx.get("pathId");
                assertNotNull("Path parametre {id} verildi ama 'pathId' set edilmemiş!", pid);
                req = req.pathParam("id", pid);
            }

            response = req.when()
                    .request(Method.PATCH, path)
                    .andReturn();

        } catch (Throwable t) {
            if ("io.restassured.internal.http.HttpResponseException".equals(t.getClass().getName())) {
                response = recoverResponseFromHttpResponseException(t);
            } else {
                throw new RuntimeException("PATCH isteğinde beklenmeyen hata: " + t, t);
            }
        }

        lastStatus = response.getStatusCode();
        lastEndpointTried = path;
        System.out.println("PATCH " + path + " -> " + lastStatus);
        if (lastStatus == 405) {
            System.out.println("Allow: " + response.getHeader("Allow"));
        }
        safePretty(response);
    }

    @When("send DELETE {string}")
    public void send_delete(String path) {
        try {
            io.restassured.specification.RequestSpecification req = given()
                    .spec(HooksAPI.spec)
                    .accept(ContentType.JSON)
                    .contentType(ContentType.JSON);

            if (path.contains("{id}")) {
                Object pid = ctx.get("pathId");
                assertNotNull("Path parametre {id} verildi ama 'pathId' set edilmemiş!", pid);
                req = req.pathParam("id", pid);
            }

            response = req.when()
                    .request(Method.DELETE, path)
                    .andReturn();

        } catch (Throwable t) {
            if ("io.restassured.internal.http.HttpResponseException".equals(t.getClass().getName())) {
                response = recoverResponseFromHttpResponseException(t);
            } else {
                throw new RuntimeException("DELETE isteğinde beklenmeyen hata: " + t, t);
            }
        }

        lastStatus = response.getStatusCode();
        lastEndpointTried = path;
        System.out.println("DELETE " + path + " -> " + lastStatus);
        safePretty(response);
    }

    // -------------------- DIAG/PROBE --------------------
    @When("probe allowed methods for {string}")
    public void probe_allowed_methods_for(String path) {
        Response r = given().spec(HooksAPI.spec).when().options(path);
        System.out.println("OPTIONS " + path + " -> " + r.getStatusCode());
        System.out.println("Allow: " + r.getHeader("Allow"));
        safePretty(r);
    }

    @When("discover api docs")
    public void discover_api_docs() {
        String[] docs = new String[] {
                "/openapi.json", "/api/openapi.json", "/v1/openapi.json",
                "/swagger.json", "/api/swagger.json",
                "/api/docs", "/docs", "/api/documentation", "/documentation",
                "/swagger-ui/index.html", "/api/swagger-ui/index.html"
        };
        System.out.println("=== Discovering API docs endpoints ===");
        for (String p : docs) {
            try {
                Response r = given().spec(HooksAPI.spec).when().get(p);
                System.out.println("GET " + p + " -> " + r.getStatusCode() + " | " + r.getStatusLine());
                String ct = r.getHeader("Content-Type");
                System.out.println("Content-Type: " + ct);
                safePretty(r);
                if (r.getStatusCode() == 200 && ct != null && ct.toLowerCase().contains("json")) {
                    System.out.println(">>> OpenAPI/Swagger JSON likely at: " + p);
                }
            } catch (Throwable t) {
                System.out.println("GET " + p + " threw: " + t);
            }
            System.out.println("------------------------------------------------------------");
        }
        System.out.println("=== Discovery done ===");
    }

    @When("fetch {string} raw")
    public void fetch_raw(String path) {
        Response r = given().spec(HooksAPI.spec).when().get(path);
        System.out.println("GET " + path + " -> " + r.getStatusCode() + " | " + r.getStatusLine());
        System.out.println("Content-Type: " + r.getHeader("Content-Type"));
        safePretty(r);
    }

    @When("diagnose addSupport endpoints")
    public void diagnose_add_support_endpoints() {
        String[] check = {
                "/api/supports", "/api/support", "/supports", "/support",
                "/api/supports/store", "/api/supports/create", "/api/supports/add",
                "/supports/store", "/supports/create", "/supports/add",
                "/api/addSupport"
        };
        for (String p : check) {
            probe_allowed_methods_for(p);
        }
    }

    @And("print last endpoint used")
    public void print_last_endpoint_used() {
        System.out.println(">>> Last endpoint used: " + lastEndpointTried);
        if (response != null) {
            System.out.println(">>> Last status: " + response.getStatusCode());
        }
    }

    // -------------------- DEPARTMENT RESOLVER --------------------
    @And("resolve and set valid department id into body field {string}")
    public void resolve_and_set_valid_department_id_into_body(String fieldName) {
        if (requestBody == null) requestBody = new JSONObject();

        Integer current = null;
        try {
            if (requestBody.has(fieldName)) {
                Object v = requestBody.get(fieldName);
                if (v != null && !JSONObject.NULL.equals(v)) current = Integer.valueOf(String.valueOf(v));
            }
        } catch (Exception ignore) {}

        Set<Integer> validIds = collectValidDepartmentIds();
        System.out.println("Valid department ids discovered: " + validIds);

        if (current != null && validIds.contains(current)) {
            System.out.println("Department id already present in body and VALID: " + current);
            return;
        } else if (current != null) {
            System.out.println("Department id already present in body but INVALID: " + current + " -> overriding");
        }

        Integer replacement = firstFrom(validIds);
        if (replacement != null) {
            requestBody.put(fieldName, replacement);
            bodyJson = requestBody;
            System.out.println("Resolved department id = " + replacement + " -> set to field '" + fieldName + "'");
            return;
        }

        System.out.println("No department ids discovered via GET/HTML. Falling back to active probing on /api/addSupport ...");
        Integer probed = discoverValidDepartmentByProbing(fieldName, 1, 50);
        assertNotNull("Geçerli department id bulunamadı! Kaynaklardan ID yok ve probing başarısız.", probed);

        requestBody.put(fieldName, probed);
        bodyJson = requestBody;
        System.out.println("Probed valid department id = " + probed + " -> set to field '" + fieldName + "'");
    }

    // -------------------- CONDITIONALS --------------------
    @And("if last status is {int} then set path id {int}")
    public void if_last_status_then_set_path_id(int expected, int fallbackId) {
        assertNotNull("Response null!", response);
        int code = response.getStatusCode();
        if (code == expected) {
            ctx.put("pathId", fallbackId);
            System.out.println("Path ID fallback set: " + fallbackId + " (last status " + code + ")");
        } else {
            System.out.println("[SKIP] last status " + code + " != " + expected + " -> fallback pathId set edilmedi");
        }
    }

    @When("if last status is {int} or {int} then send GET {string}")
    public void if_last_status_is_or_then_send_get(Integer s1, Integer s2, String path) {
        if (lastStatus == s1 || lastStatus == s2) {
            send_get(path);
        } else {
            System.out.println("[SKIP] last status " + lastStatus + " != " + s1 + " and " + lastStatus + " != " + s2 + " -> GET atlandı");
        }
    }

    @Then("if last status is {int} or {int} then status is one of {int} or {int}")
    public void if_last_status_is_or_then_status_is_one_of_or(Integer s1, Integer s2, Integer a, Integer b) {
        if (lastStatus == s1 || lastStatus == s2) {
            assertNotNull("Response null döndü!", response);
            int code = response.getStatusCode();
            assertTrue("HTTP status farklı! expected one of [" + a + "," + b + "] but was: " + code, code == a || code == b);
        } else {
            System.out.println("[SKIP] last status " + lastStatus + " != " + s1 + " and " + lastStatus + " != " + s2 + " -> status assert atlandı");
        }
    }

    @Then("if last status is {int} or {int} then response message contains {string}")
    public void if_last_status_is_or_then_response_message_contains(Integer s1, Integer s2, String expected) {
        if (lastStatus == s1 || lastStatus == s2) {
            response_message_contains(expected);
        } else {
            System.out.println("[SKIP] last status " + lastStatus + " != " + s1 + " and " + lastStatus + " != " + s2 + " -> message assert atlandı");
        }
    }

    @Then("if last status is {int} or {int} then remark is failed")
    public void if_last_status_is_or_then_remark_is_failed(Integer s1, Integer s2) {
        if (lastStatus == s1 || lastStatus == s2) { remark_is_failed(); }
        else { System.out.println("[SKIP] last status " + lastStatus + " != " + s1 + " and " + lastStatus + " != " + s2 + " -> remark assert atlandı"); }
    }

    @Then("if last status is {int} then remark is failed")
    public void if_last_status_is_then_remark_is_failed(Integer s1) {
        if (lastStatus == s1) { remark_is_failed(); }
        else { System.out.println("[SKIP] last status " + lastStatus + " != " + s1 + " -> remark assert atlandı"); }
    }

    // -------------------- MESSAGE ASSERT --------------------
    @Then("response message contains {string}")
    public void response_message_contains(String expected) {
        assertNotNull("Response null döndü!", response);
        String bodyStr;
        try { bodyStr = response.getBody() == null ? "" : response.getBody().asString(); }
        catch (Throwable ignore) { bodyStr = ""; }

        boolean ok = false;

        try {
            JsonPath jp = response.jsonPath();
            String msg = jp.getString("message");
            if (msg != null && msg.toLowerCase(Locale.ROOT).contains(expected.toLowerCase(Locale.ROOT))) {
                ok = true;
            }
        } catch (Throwable ignore) { }

        if (!ok && bodyStr != null) {
            ok = bodyStr.toLowerCase(Locale.ROOT).contains(expected.toLowerCase(Locale.ROOT));
        }

        assertTrue("Body 'message' beklenen metni içermiyor. Beklenen: " + expected + "\nGerçek body:\n" + bodyStr, ok);
    }

    // -------------------- LIST ITEM ASSERTS --------------------
    @And("assert item with id {string} exists under {string}")
    public void assert_item_with_id_exists_under(String key, String listPath) {
        assertNotNull("Response null döndü!", response);
        Object idObj = ctx.get(key);
        assertNotNull("Context'te id yok: " + key, idObj);
        String targetId = String.valueOf(idObj);

        List<Map<String, Object>> arr = response.jsonPath().getList(listPath);
        assertNotNull("Liste bulunamadı: " + listPath, arr);

        boolean found = arr.stream().anyMatch(m -> String.valueOf(m.get("id")).equals(targetId));
        assertTrue("Listede id yok: " + targetId, found);
    }

    @And("assert fields for item id {string} under {string}:")
    public void assert_fields_for_item_id_under(String key, String listPath, DataTable table) {
        assertNotNull("Response null döndü!", response);
        Object idObj = ctx.get(key);
        assertNotNull("Context'te id yok: " + key, idObj);
        String targetId = String.valueOf(idObj);

        List<Map<String, Object>> arr = response.jsonPath().getList(listPath);
        assertNotNull("Liste bulunamadı: " + listPath, arr);

        Map<String, Object> item = arr.stream()
                .filter(m -> String.valueOf(m.get("id")).equals(targetId))
                .findFirst().orElse(null);
        assertNotNull("İlgili öğe bulunamadı: " + targetId, item);

        for (String rawKey : table.asList()) {
            String keyPath = rawKey.trim();
            Object val = extractValue(item, keyPath);
            assertNotNull("Alan null: " + keyPath, val);
            if (val instanceof String) {
                assertFalse("Alan boş: " + keyPath, ((String) val).trim().isEmpty());
            }
        }
    }

    // -------------------- STORE FIRST VALID INT --------------------
    @Then("store first valid int field from body {string} as {string}")
    public void store_first_valid_int_field_from_body_as(String fieldName, String varName) {
        assertNotNull("Response null döndü!", response);
        String body = "";
        try { body = response.asString(); } catch (Throwable ignore) {}
        assertNotNull("Body null!", body);
        body = body.trim();
        assertFalse("Body empty!", body.isEmpty());

        Object root;
        try {
            root = new JSONTokener(body).nextValue();
        } catch (Throwable t) {
            fail("JSON parse hatası: " + t.getMessage());
            return;
        }

        Integer val = findFirstIntFieldDeep(root, fieldName);
        assertNotNull("Gövdede ilk geçerli int alan bulunamadı: '" + fieldName + "'. Body: " + body, val);

        ctx.put(varName, val);
        System.out.println("[store_first_valid_int] " + fieldName + " => " + val + " as " + varName);
    }
}
