package stepdefinitions;

import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

public class CennetStepsBase {
    private static Connection conn;

    private static Properties loadProps() {
        Properties p = new Properties();

        // classpath
        try (InputStream is = CennetStepsBase.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) p.load(is);
        } catch (Exception ignore) {}

        // fallback dosya yolu
        if (p.isEmpty()) {
            try (FileInputStream fis = new FileInputStream("src/test/resources/db.properties")) {
                p.load(fis);
            } catch (Exception ignore) {}
        }

        // ENV baskın
        String[] keys = {"host","port","name","user","pass"};
        for (String k : keys) {
            String env = System.getenv("DB_" + k.toUpperCase());
            if (env != null) p.setProperty("db." + k, env);
        }

        // Varsayılanlar
        p.putIfAbsent("db.useSSL","false");
        p.putIfAbsent("db.serverTimezone","UTC");
        p.putIfAbsent("db.allowPublicKeyRetrieval","true");
        p.putIfAbsent("db.characterEncoding","utf8");
        p.putIfAbsent("db.useUnicode","true");
        p.putIfAbsent("db.autoReconnect","true");
        return p;
    }

    public static synchronized Connection getConnection() {
        try {
            if (conn != null && !conn.isClosed()) return conn;

            Properties p = loadProps();
            String url = String.format(
                    "jdbc:mysql://%s:%s/%s?useSSL=%s&serverTimezone=%s&allowPublicKeyRetrieval=%s&characterEncoding=%s&useUnicode=%s&autoReconnect=%s",
                    p.getProperty("db.host"),
                    p.getProperty("db.port"),
                    p.getProperty("db.name"),
                    p.getProperty("db.useSSL"),
                    p.getProperty("db.serverTimezone"),
                    p.getProperty("db.allowPublicKeyRetrieval"),
                    p.getProperty("db.characterEncoding"),
                    p.getProperty("db.useUnicode"),
                    p.getProperty("db.autoReconnect")
            );
            conn = DriverManager.getConnection(url, p.getProperty("db.user"), p.getProperty("db.pass"));
            conn.setAutoCommit(true);
            return conn;
        } catch (SQLException e) {
            throw new RuntimeException("DB bağlantısı kurulamadı: " + e.getMessage(), e);
        }
    }

    public static void closeQuietly() {
        try { if (conn != null && !conn.isClosed()) conn.close(); } catch (SQLException ignore) {}
        conn = null;
    }

    // ---- yardımcılar (execute/query) istersen ekleyebilirsin; elindeki sınıfta PreparedStatement zaten var
}