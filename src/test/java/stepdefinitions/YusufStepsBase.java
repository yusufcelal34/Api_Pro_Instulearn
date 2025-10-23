package stepdefinitions;

import config_Requirements.ConfigLoader;
import hooks.HooksAPI;
import io.restassured.builder.ResponseBuilder;
import io.restassured.http.ContentType;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class YusufStepsBase {

    // --------- Paylaşılan Durum / Alanlar (protected) ---------
    protected Response response;
    protected JSONObject bodyJson;
    protected JSONObject requestBody = new JSONObject();
    protected final Map<String, Object> ctx = new HashMap<>();
    protected final Map<String, String> storedIds = new HashMap<>();
    protected String lastEndpointTried = null;
    protected int lastStatus = -1;

    protected final ConfigLoader cfg = ConfigLoader.getInstance();

    // -------------------- Helper: JSON/HTML tespiti --------------------
    protected boolean isJson(Response r){
        if (r == null) return false;
        String ct = String.valueOf(r.getContentType()).toLowerCase(Locale.ROOT);
        if (ct.contains("json")) return true;
        String b = "";
        try { b = r.asString(); } catch (Throwable ignore) {}
        if (b == null) return false;
        String t = b.trim();
        return t.startsWith("{") || t.startsWith("[");
    }

    // -------------------- Helper: HTTP Exception'dan Response çıkarma --------------------
    protected Response recoverResponseFromHttpResponseException(Throwable t) {
        try {
            java.lang.reflect.Method m = t.getClass().getMethod("getResponse");
            Object raw = m.invoke(t);
            if (raw instanceof Response) {
                return (Response) raw;
            }
            Response built = tryBuildFromHttpResponseDecorator(raw);
            if (built != null) return built;
        } catch (Throwable ignore) { }

        try {
            java.lang.reflect.Field f = t.getClass().getDeclaredField("response");
            f.setAccessible(true);
            Object raw = f.get(t);
            if (raw instanceof Response) return (Response) raw;
            Response built = tryBuildFromHttpResponseDecorator(raw);
            if (built != null) return built;
        } catch (Throwable ignore) { }

        int status = extractStatusCodeSafely(t, 500);
        String msg = t.getMessage() != null ? t.getMessage() : "";
        return new ResponseBuilder()
                .setStatusCode(status)
                .setBody(msg)
                .build();
    }

    protected Response tryBuildFromHttpResponseDecorator(Object raw) {
        if (raw == null) return null;
        if (!"io.restassured.internal.http.HttpResponseDecorator".equals(raw.getClass().getName()))
            return null;

        try {
            int status = 0;
            try {
                java.lang.reflect.Method getStatus = raw.getClass().getMethod("getStatus");
                Object s = getStatus.invoke(raw);
                if (s instanceof Number) status = ((Number) s).intValue();
            } catch (NoSuchMethodException nsme) {
                java.lang.reflect.Field f = raw.getClass().getDeclaredField("status");
                f.setAccessible(true);
                Object s = f.get(raw);
                if (s instanceof Number) status = ((Number) s).intValue();
            }

            String contentType = null;
            try {
                java.lang.reflect.Method getCt = raw.getClass().getMethod("getContentType");
                Object ct = getCt.invoke(raw);
                contentType = (ct != null) ? ct.toString() : null;
            } catch (Throwable ignore) {}

            Object data;
            try {
                java.lang.reflect.Method getData = raw.getClass().getMethod("getData");
                data = getData.invoke(raw);
            } catch (NoSuchMethodException nsme) {
                java.lang.reflect.Field f = raw.getClass().getDeclaredField("data");
                f.setAccessible(true);
                data = f.get(raw);
            }

            String body;
            if (data == null) {
                body = "";
            } else if (data instanceof String) {
                body = (String) data;
            } else if (data instanceof byte[]) {
                body = new String((byte[]) data, java.nio.charset.StandardCharsets.UTF_8);
            } else {
                body = new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(data);
                if (contentType == null) contentType = "application/json";
            }

            ResponseBuilder rb = new ResponseBuilder()
                    .setStatusCode(status)
                    .setBody(body);
            if (contentType != null) rb.setContentType(contentType);

            return rb.build();
        } catch (Throwable ex) {
            return null;
        }
    }

    protected int extractStatusCodeSafely(Throwable t, int fallback) {
        try {
            java.lang.reflect.Method m = t.getClass().getMethod("getStatusCode");
            Object o = m.invoke(t);
            if (o instanceof Number) return ((Number) o).intValue();
        } catch (Throwable ignore) {}
        return fallback;
    }

    // -------------------- Helper: HTML'den Department Id çıkarma --------------------
    protected List<Integer> parseDeptIdsFromHtml(String html) {
        List<Integer> out = new ArrayList<>();
        if (html == null || html.isEmpty()) return out;
        try {
            Matcher mSelect = Pattern
                    .compile("(?is)<select[^>]*name\\s*=\\s*\"department_id\"[^>]*>(.+?)</select>")
                    .matcher(html);
            if (mSelect.find()) {
                String inside = mSelect.group(1);
                Matcher mOpt = Pattern
                        .compile("(?is)<option[^>]*value\\s*=\\s*\"(\\d+)\"[^>]*>")
                        .matcher(inside);
                while (mOpt.find()) {
                    String val = mOpt.group(1);
                    try {
                        int id = Integer.parseInt(val);
                        if (id > 0) out.add(id);
                    } catch (NumberFormatException ignore) {}
                }
            }
        } catch (Throwable ignore) {}
        return out;
    }

    protected void extractIds(List<Map<String, Object>> arr, Set<Integer> out) {
        if (arr == null) return;
        for (Map<String, Object> o : arr) {
            if (o == null) continue;
            Object id = o.get("id");
            if (id == null) id = o.get("department_id");
            if (id == null) id = o.get("value");
            if (id != null) {
                try {
                    int v = Integer.parseInt(String.valueOf(id));
                    if (v > 0) out.add(v);
                } catch (NumberFormatException ignore) {}
            }
        }
    }

    protected void extractIdsFromMapKeys(Map<String, Object> map, Set<Integer> out) {
        if (map == null) return;
        for (String k : map.keySet()) {
            try {
                int v = Integer.parseInt(k);
                if (v > 0) out.add(v);
            } catch (NumberFormatException ignore) {}
        }
    }

    protected Integer firstFrom(Set<Integer> set) {
        if (set == null || set.isEmpty()) return null;
        for (Integer i : set) return i;
        return null;
    }

    protected boolean hasDeptIdError(Response r) {
        try {
            JsonPath jp = r.jsonPath();
            Map<String, Object> errors = jp.getMap("errors");
            if (errors == null) return false;
            Object arr = errors.get("department_id");
            if (arr instanceof List) {
                @SuppressWarnings("unchecked")
                List<Object> list = (List<Object>) arr;
                for (Object o : list) {
                    String s = String.valueOf(o).toLowerCase(Locale.ROOT);
                    if (s.contains("invalid")) return true;
                }
            } else if (arr != null) {
                String s = String.valueOf(arr).toLowerCase(Locale.ROOT);
                if (s.contains("invalid")) return true;
            }
        } catch (Throwable ignore) {}
        return false;
    }

    protected JSONObject cloneBodyWith(JSONObject original, String key, Object value) {
        JSONObject copy = new JSONObject();
        if (original != null) {
            for (String k : original.keySet()) copy.put(k, original.get(k));
        }
        copy.put(key, value);
        return copy;
    }

    // -------------------- Helper: String placeholder genişletme --------------------
    protected String expandPlaceholders(String s) {
        if (s == null) return null;
        Pattern p = Pattern.compile("\\$\\{([^}]+)}");
        Matcher m = p.matcher(s);
        StringBuffer sb = new StringBuffer();
        while (m.find()) {
            String key = m.group(1);
            Object val = ctx.getOrDefault(key, storedIds.get(key));
            String rep = (val == null) ? "" : String.valueOf(val);
            m.appendReplacement(sb, Matcher.quoteReplacement(rep));
        }
        m.appendTail(sb);
        return sb.toString();
    }

    // -------------------- Helper: Body payload, tip dönüşümü vs. --------------------
    protected Object coerce(String s) {
        if (s.equalsIgnoreCase("null")) return JSONObject.NULL;
        if (s.equalsIgnoreCase("true")) return true;
        if (s.equalsIgnoreCase("false")) return false;
        try {
            if (s.matches("-?\\d+")) return Integer.parseInt(s);
            if (s.matches("-?\\d+\\.\\d+")) return Double.parseDouble(s);
        } catch (Exception ignore) {}
        return s;
    }

    protected String payload() {
        return (requestBody != null) ? requestBody.toString()
                : (bodyJson != null ? bodyJson.toString() : "{}");
    }

    // -------------------- Helper: Endpoint özellikleri --------------------
    protected boolean isGood(Response r) {
        if (r == null) return false;
        int code = r.getStatusCode();
        return code / 100 == 2 || code == 401 || code == 403 || code == 422;
    }

    protected boolean isPostAllowed(String path) {
        try {
            Response r = io.restassured.RestAssured.given().spec(HooksAPI.spec).when().options(path);
            String allow = r.getHeader("Allow");
            System.out.println("OPTIONS " + path + " -> " + r.getStatusCode() + " | Allow: " + allow);
            return allow != null && Arrays.stream(allow.split(","))
                    .map(String::trim)
                    .anyMatch("POST"::equalsIgnoreCase);
        } catch (Throwable t) {
            System.out.println("OPTIONS " + path + " threw: " + t);
            return false;
        }
    }

    protected boolean isDeleteAllowed(String path) {
        try {
            Response r = io.restassured.RestAssured.given().spec(HooksAPI.spec).when().options(path);
            String allow = r.getHeader("Allow");
            System.out.println("OPTIONS " + path + " -> " + r.getStatusCode() + " | Allow: " + allow);
            return allow != null && Arrays.stream(allow.split(","))
                    .map(String::trim)
                    .anyMatch("DELETE"::equalsIgnoreCase);
        } catch (Throwable t) {
            System.out.println("OPTIONS " + path + " threw: " + t);
            return false;
        }
    }

    // -------------------- Helper: POST türleri --------------------
    protected Response postJson(String path, String jsonBody) {
        Response r = io.restassured.RestAssured.given()
                .spec(HooksAPI.spec)
                .redirects().follow(false)
                .accept(ContentType.JSON)
                .contentType(ContentType.JSON)
                .body(jsonBody)
                .when()
                .post(path);
        if (r.getStatusCode() == 301 || r.getStatusCode() == 302) {
            System.out.println("Redirect Location (JSON): " + r.getHeader("Location"));
        }
        return r;
    }

    protected Response postForm(String path, JSONObject body) {
        io.restassured.specification.RequestSpecification req = io.restassured.RestAssured.given()
                .spec(HooksAPI.spec)
                .redirects().follow(false)
                .accept(ContentType.JSON)
                .contentType(ContentType.URLENC)
                .when();
        if (body != null) {
            for (String k : body.keySet()) {
                Object v = body.get(k);
                req = req.formParam(k, v == JSONObject.NULL ? "" : String.valueOf(v));
            }
        }
        Response r = req.post(path);
        if (r.getStatusCode() == 301 || r.getStatusCode() == 302) {
            System.out.println("Redirect Location (FORM): " + r.getHeader("Location"));
        }
        return r;
    }

    protected Response postMultipart(String path, JSONObject body) {
        io.restassured.specification.RequestSpecification req = io.restassured.RestAssured.given()
                .spec(HooksAPI.spec)
                .redirects().follow(false)
                .accept(ContentType.JSON)
                .contentType(ContentType.MULTIPART)
                .when();
        if (body != null) {
            for (String k : body.keySet()) {
                Object v = body.get(k);
                req = req.multiPart(k, v == JSONObject.NULL ? "" : String.valueOf(v));
            }
        }
        Response r = req.post(path);
        if (r.getStatusCode() == 301 || r.getStatusCode() == 302) {
            System.out.println("Redirect Location (MULTIPART): " + r.getHeader("Location"));
        }
        return r;
    }

    protected void logPost(String mode, String path, Response resp) {
        System.out.println("POST[" + mode + "] " + path + " -> status=" + (resp == null ? "null" : resp.getStatusCode()));
        if (resp != null) {
            System.out.println("Status line: " + resp.getStatusLine());
            System.out.println("Allow header: " + resp.getHeader("Allow"));
            safePretty(resp);
        }
    }

    protected Response postOverrideDelete(String path) {
        // Birçok back-end _method=DELETE veya X-HTTP-Method-Override kabul eder
        return io.restassured.RestAssured.given()
                .spec(HooksAPI.spec)
                .redirects().follow(false)
                .accept(ContentType.JSON)
                .contentType(ContentType.URLENC)
                .formParam("_method", "DELETE")
                .when()
                .post(path);
    }

    // -------------------- Helper: JSON Path çıkarma --------------------
    protected Object tryJsonPath(Response resp, String path) {
        try {
            return resp.jsonPath().get(path);
        } catch (Throwable ignore) {
            return null;
        }
    }

    protected Object extractFirstValue(Response resp, String expr) {
        if (resp == null) return null;
        if (expr == null || expr.trim().isEmpty()) return null;

        String[] candidates = expr.split("\\|\\|");
        for (String raw : candidates) {
            String c = raw.trim();
            if (c.isEmpty()) continue;

            Object v = tryJsonPath(resp, c);
            if (v != null) return v;

            if ((c.startsWith("'") && c.endsWith("'")) || (c.startsWith("\"") && c.endsWith("\""))) {
                String keyOnly = c.substring(1, c.length() - 1);
                v = tryJsonPath(resp, "$['" + keyOnly + "']");
                if (v == null) v = tryJsonPath(resp, "['" + keyOnly + "']");
                if (v == null) v = tryJsonPath(resp, keyOnly);
                if (v != null) return v;
            } else if (c.contains(" ")) {
                v = tryJsonPath(resp, "$['" + c + "']");
                if (v == null) v = tryJsonPath(resp, "['" + c + "']");
                if (v != null) return v;
            }
        }
        return null;
    }

    // -------------------- Helper: Pretty --------------------
    protected void safePretty(Response resp) {
        try { if (resp != null) resp.prettyPrint(); } catch (Throwable ignore) {}
    }

    // -------------------- Helper: Map extract --------------------
    @SuppressWarnings("unchecked")
    protected Object extractValue(Map<String, Object> root, String key) {
        if ("full_name".equals(key) || "role_name".equals(key)) {
            Object u = root.get("user");
            return (u instanceof Map) ? ((Map<?, ?>) u).get(key) : null;
        }
        if (key.contains(".")) {
            String[] parts = key.split("\\.");
            Object cur = root;
            for (String p : parts) {
                if (!(cur instanceof Map)) return null;
                cur = ((Map<?, ?>) cur).get(p);
            }
            return cur;
        }
        return root.get(key);
    }

    @SuppressWarnings("unchecked")
    protected boolean hasKey(Map<String, Object> root, String key) {
        if ("full_name".equals(key) || "role_name".equals(key)) {
            Object u = root.get("user");
            return (u instanceof Map) && ((Map<?, ?>) u).containsKey(key);
        }
        if (key.contains(".")) {
            String[] parts = key.split("\\.");
            Object cur = root;
            for (int i = 0; i < parts.length - 1; i++) {
                if (!(cur instanceof Map)) return false;
                cur = ((Map<?, ?>) cur).get(parts[i]);
            }
            return (cur instanceof Map) && ((Map<?, ?>) cur).containsKey(parts[parts.length - 1]);
        }
        return root.containsKey(key);
    }

    // -------------------- Helper: Department keşfi --------------------
    protected Set<Integer> collectValidDepartmentIds() {
        Set<Integer> bag = new LinkedHashSet<>();

        String[] htmlProbes = {
                "/api/addSupport", "/support/create", "/supports/create",
                "/support", "/supports", "/contact"
        };
        for (String p : htmlProbes) {
            try {
                Response r = io.restassured.RestAssured.given().spec(HooksAPI.spec).when().get(p);
                System.out.println("GET " + p + " -> " + r.getStatusCode() + " | CT=" + r.getHeader("Content-Type"));
                if (r.getStatusCode() == 200) {
                    List<Integer> ids = parseDeptIdsFromHtml(r.getBody().asString());
                    bag.addAll(ids);
                }
            } catch (Throwable t) {
                System.out.println("GET " + p + " threw: " + t);
            }
        }

        String[] jsonCandidates = new String[] {
                "/api/departments", "/api/support/departments", "/api/supports/departments",
                "/api/ticket/departments", "/api/helpdesk/departments", "/api/departments/list",
                "/departments", "/support/departments"
        };

        for (String p : jsonCandidates) {
            try {
                Response r = io.restassured.RestAssured.given().spec(HooksAPI.spec).when().get(p);
                System.out.println("GET " + p + " -> " + r.getStatusCode());
                if (r.getStatusCode() != 200) continue;
                String ct = String.valueOf(r.getHeader("Content-Type")).toLowerCase(Locale.ROOT);
                if (!ct.contains("json")) continue;

                JsonPath jp = r.jsonPath();

                try {
                    List<Map<String, Object>> arr = jp.getList("$");
                    if (arr != null) extractIds(arr, bag);
                } catch (Throwable ignore) {}

                try {
                    List<Map<String, Object>> data = jp.getList("data");
                    if (data != null) extractIds(data, bag);
                } catch (Throwable ignore) {}

                try {
                    List<Map<String, Object>> deps = jp.getList("departments");
                    if (deps != null) extractIds(deps, bag);
                } catch (Throwable ignore) {}
                try {
                    List<Map<String, Object>> deps2 = jp.getList("data.departments");
                    if (deps2 != null) extractIds(deps2, bag);
                } catch (Throwable ignore) {}

                try {
                    Map<String, Object> map1 = jp.getMap("departments");
                    if (map1 != null) extractIdsFromMapKeys(map1, bag);
                } catch (Throwable ignore) {}
                try {
                    Map<String, Object> map2 = jp.getMap("data.departments");
                    if (map2 != null) extractIdsFromMapKeys(map2, bag);
                } catch (Throwable ignore) {}

                try {
                    Integer single = jp.getInt("department_id");
                    if (single != null && single > 0) bag.add(single);
                } catch (Throwable ignore) {}

            } catch (Throwable t) {
                System.out.println("GET " + p + " threw: " + t);
            }
        }

        return bag;
    }

    protected Integer discoverValidDepartmentByProbing(String fieldName, int start, int endInclusive) {
        final String endpoint = "/api/addSupport";
        if (!isPostAllowed(endpoint)) {
            System.out.println("Probe aborted: POST not allowed on " + endpoint);
            return null;
        }

        for (int candidate = start; candidate <= endInclusive; candidate++) {
            JSONObject body = cloneBodyWith(requestBody, fieldName, candidate);
            Response r = postJson(endpoint, body.toString());
            int code = r.getStatusCode();
            String msgHead = "PROBE dept_id=" + candidate + " -> " + code;
            System.out.println(msgHead);

            if (code / 100 == 2) {
                System.out.println(msgHead + " (SUCCESS)");
                return candidate;
            }

            if (code == 422 && !hasDeptIdError(r)) {
                System.out.println(msgHead + " (422 but department_id accepted; other validation failed)");
                return candidate;
            }

            if (code == 401 || code == 403) {
                System.out.println(msgHead + " (AUTH issue — check token/role)");
            }
        }
        return null;
    }

    // -------------------- Helper: store_first_valid_int_field --------------------
    protected Integer tryPathInt(Object root, List<String> objKeys, int arrIndex, String fieldName) {
        Object cur = root;
        for (String key : objKeys) {
            if (!(cur instanceof JSONObject)) return null;
            cur = ((JSONObject) cur).opt(key);
            if (cur == null) return null;
        }
        if (!(cur instanceof JSONArray)) return null;
        JSONArray arr = (JSONArray) cur;
        if (arrIndex < 0 || arrIndex >= arr.length()) return null;
        Object nth = arr.opt(arrIndex);
        if (!(nth instanceof JSONObject)) return null;
        Object candidate = ((JSONObject) nth).opt(fieldName);
        return toPositiveIntOrNull(candidate);
    }

    protected Integer tryArrayIndexInt(Object root, int idx, String fieldName) {
        if (!(root instanceof JSONArray)) return null;
        JSONArray arr = (JSONArray) root;
        if (idx < 0 || idx >= arr.length()) return null;
        Object nth = arr.opt(idx);
        if (!(nth instanceof JSONObject)) return null;
        Object candidate = ((JSONObject) nth).opt(fieldName);
        return toPositiveIntOrNull(candidate);
    }

    protected Integer toPositiveIntOrNull(Object o) {
        if (o == null) return null;
        if (o instanceof Number) {
            int v = ((Number) o).intValue();
            return v > 0 ? v : null;
        }
        if (o instanceof String) {
            String s = ((String) o).trim();
            if (s.matches("-?\\d+")) {
                try {
                    int v = Integer.parseInt(s);
                    return v > 0 ? v : null;
                } catch (NumberFormatException ignore) {}
            }
        }
        return null;
    }

    protected Integer findFirstIntFieldDeep(Object root, String fieldName) {
        if (root == null) return null;

        Integer v = tryPathInt(root, Arrays.asList("data", "departments"), 0, fieldName);
        if (v != null) return v;

        v = tryPathInt(root, Collections.singletonList("data"), 0, fieldName);
        if (v != null) return v;

        v = tryArrayIndexInt(root, 0, fieldName);
        if (v != null) return v;

        Deque<Object> q = new ArrayDeque<>();
        q.add(root);
        int visited = 0, maxVisit = 20000;

        while (!q.isEmpty() && visited++ < maxVisit) {
            Object cur = q.poll();
            if (cur instanceof JSONObject) {
                JSONObject obj = (JSONObject) cur;

                if (obj.has(fieldName)) {
                    Object candidate = obj.opt(fieldName);
                    Integer asInt = toPositiveIntOrNull(candidate);
                    if (asInt != null) return asInt;
                }

                for (String k : obj.keySet()) {
                    Object child = obj.opt(k);
                    if (child != null) q.add(child);
                }
            } else if (cur instanceof JSONArray) {
                JSONArray arr = (JSONArray) cur;
                for (int i = 0; i < arr.length(); i++) {
                    Object child = arr.opt(i);
                    if (child != null) q.add(child);
                }
            }
        }
        return null;
    }
}
