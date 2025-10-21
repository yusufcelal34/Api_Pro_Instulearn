package hooks;

import config_Requirements.ConfigLoader;
import io.qameta.allure.Allure;
import io.qameta.allure.Attachment;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.http.ContentType;
import io.restassured.specification.RequestSpecification;
import io.restassured.filter.log.RequestLoggingFilter;
import io.restassured.filter.log.ResponseLoggingFilter;
import io.cucumber.java.After;
import io.cucumber.java.Scenario;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import utilities.API_Utilities.Driver;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

/**
 * API ve (gerekirse) UI testleri için ortak Hooks sınıfı.
 * - RestAssured RequestSpecification üretimi
 * - Allure log/ekleri
 * - Hata durumunda ekran görüntüsü
 * - İstendiğinde manuel screenshot ekleme
 */
public class HooksAPI {

    public static RequestSpecification spec;

    /**
     * API testleri için base request oluşturur ve Allure'a log ekler.
     * userType: admin | admintoken | invalid | invalidtoken
     */
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

        // Request ve Response logları Allure'a aktarılacak
        ByteArrayOutputStream requestLog = new ByteArrayOutputStream();
        ByteArrayOutputStream responseLog = new ByteArrayOutputStream();

        RequestLoggingFilter requestLogging = new RequestLoggingFilter(new PrintStream(requestLog));
        ResponseLoggingFilter responseLogging = new ResponseLoggingFilter(new PrintStream(responseLog));

        RequestSpecBuilder b = new RequestSpecBuilder()
                .setBaseUri(baseUrl)
                .addHeader("Authorization", "Bearer " + token)
                .setContentType(ContentType.JSON)
                .addFilter(requestLogging)
                .addFilter(responseLogging);

        if (apiKey != null && !apiKey.isBlank()) {
            b.addHeader("x-api-key", apiKey);
        }

        spec = b.build();

        // Allure'a logları ekle (bilgilendirme amaçlı anlık dump)
        attachText("API Request Log", requestLog.toString());
        attachText("API Response Log", responseLog.toString());
    }

    /**
     * Authorization'suz base request (örneğin public endpoint'ler için)
     */
    public static RequestSpecification freshSpecNoAuth() {
        ConfigLoader config = ConfigLoader.getInstance();
        String baseUrl = config.getApiConfig("base_url");
        String apiKey = config.getApiConfig("apiKey");

        ByteArrayOutputStream requestLog = new ByteArrayOutputStream();
        ByteArrayOutputStream responseLog = new ByteArrayOutputStream();

        RequestSpecBuilder b = new RequestSpecBuilder()
                .setBaseUri(baseUrl)
                .setContentType(ContentType.JSON)
                .addFilter(new RequestLoggingFilter(new PrintStream(requestLog)))
                .addFilter(new ResponseLoggingFilter(new PrintStream(responseLog)));

        if (apiKey != null && !apiKey.isBlank()) {
            b.addHeader("x-api-key", apiKey);
        }

        RequestSpecification s = b.build();

        attachText("Unauthenticated API Request Log", requestLog.toString());
        attachText("Unauthenticated API Response Log", responseLog.toString());

        return s;
    }

    /**
     * Eski step'ler için alias
     */
    public static RequestSpecification freshSpec() {
        return freshSpecNoAuth();
    }

    // =========================
    // Allure Attachment Helpers
    // =========================

    @Attachment(value = "{attachName}", type = "text/plain")
    public static String attachText(String attachName, String message) {
        if (message == null || message.isEmpty()) {
            return "No log data available";
        }
        return message;
    }

    @Attachment(value = "{attachName}", type = "application/json", fileExtension = ".json")
    public static byte[] attachJson(String attachName, String json) {
        if (json == null) json = "";
        return json.getBytes(java.nio.charset.StandardCharsets.UTF_8);
    }

    @Attachment(value = "{attachName}", type = "text/html", fileExtension = ".html")
    public static byte[] attachHtml(String attachName, String html) {
        if (html == null) html = "";
        return html.getBytes(java.nio.charset.StandardCharsets.UTF_8);
    }

    @Attachment(value = "{attachName}", type = "image/png")
    public static byte[] attachPng(String attachName, byte[] png) {
        return png;
    }

    /**
     * Exception durumlarını Allure raporuna ekler
     */
    public static void attachException(Throwable e) {
        Allure.addAttachment("Exception", e.toString());
        if (e.getMessage() != null) {
            attachText("Exception Message", e.getMessage());
        }
    }

    /**
     * İstenildiğinde manuel screenshot almak için (örneğin API'den HTML sayfa döndüğünde veya adım ortasında)
     * Örnek kullanım: HooksAPI.attachScreenshot("HTML Ekran Görüntüsü");
     */
    @Attachment(value = "{attachName}", type = "image/png")
    public static byte[] attachScreenshot(String attachName) {
        try {
            if (Driver.getDriver() != null) {
                return ((TakesScreenshot) Driver.getDriver()).getScreenshotAs(OutputType.BYTES);
            } else {
                Allure.addAttachment(attachName + " (info)", "WebDriver null veya başlatılmamış.");
                return null;
            }
        } catch (Throwable t) {
            Allure.addAttachment(attachName + " (error)", "Screenshot alınamadı: " + t.getMessage());
            return null;
        }
    }

    /**
     * Senaryo başarısız olduğunda otomatik screenshot al ve Allure'a ekle.
     * UI testlerinde etkin çalışır; API testlerinde WebDriver yoksa bilgi mesajı düşer.
     */
    @After(order = 1)
    public void captureScreenshotOnFailure(Scenario scenario) {
        if (scenario.isFailed()) {
            try {
                if (Driver.getDriver() != null) {
                    final byte[] screenshot = ((TakesScreenshot) Driver.getDriver()).getScreenshotAs(OutputType.BYTES);
                    scenario.attach(screenshot, "image/png", "Failure Screenshot");
                    Allure.addAttachment("Failure Screenshot", "image/png", new ByteArrayInputStream(screenshot), "png");
                } else {
                    Allure.addAttachment("Failure Screenshot (info)", "WebDriver null veya başlatılmamış.");
                }
            } catch (Exception e) {
                attachException(e);
            }
        }
    }

    /**
     * (Opsiyonel) Başka @After hook'ların varsa sırayla çalışması için order değerini değiştirebilirsin.
     * Mevcut tek @After bu ise ek bir şey yapmana gerek yok.
     */
}
