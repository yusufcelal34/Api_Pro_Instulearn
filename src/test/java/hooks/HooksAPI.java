package hooks;

import config_Requirements.ConfigLoader;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.http.ContentType;
import io.restassured.specification.RequestSpecification;

public class HooksAPI {

    public static RequestSpecification spec;

    public static void setUpApi(String userType) {
        ConfigLoader config = ConfigLoader.getInstance();

        String baseUrl = config.getApiConfig("base_url");
        String token;
        String apiKey = config.getApiConfig("apiKey"); // config.yaml'da varsa

        switch (userType.toLowerCase()) {
            case "admin":
            case "admintoken":
                token = config.getApiConfig("adminToken");
                break;
            case "invalid":
            case "invalidtoken":
                token = config.getApiConfig("invalidtoken");
                break;
            default:
                throw new IllegalArgumentException("Unknown user type: " + userType);
        }

        RequestSpecBuilder b = new RequestSpecBuilder()
                .setBaseUri(baseUrl)
                .addHeader("Authorization", "Bearer " + token)
                .setContentType(ContentType.JSON);

        if (apiKey != null && !apiKey.isBlank()) {
            b.addHeader("x-api-key", apiKey);
        }

        spec = b.build();
    }

    public static RequestSpecification freshSpecNoAuth() {
        ConfigLoader config = ConfigLoader.getInstance();
        String baseUrl = config.getApiConfig("base_url");
        String apiKey = config.getApiConfig("apiKey");

        RequestSpecBuilder b = new RequestSpecBuilder()
                .setBaseUri(baseUrl)
                .setContentType(ContentType.JSON);

        if (apiKey != null && !apiKey.isBlank()) {
            b.addHeader("x-api-key", apiKey);
        }

        return b.build();
    }

    // Eski step'ler için alias
    public static RequestSpecification freshSpec() {
        return freshSpecNoAuth();
    }
}
