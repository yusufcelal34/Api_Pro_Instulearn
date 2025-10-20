package stepdefinitions;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;
import org.junit.Assert;

import java.sql.*;
import java.util.*;

public class CennetSteps {

    // =========================
    // JDBC (MySQL)
    // =========================
    private static final String JDBC_URL  = "jdbc:mysql://195.35.59.18/u201212290_qainstulearn?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String JDBC_USER = "u201212290_qainstuser";
    private static final String JDBC_PASS = "A/s&Yh[qU0";

    private Connection connection;

    private void ensureConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
        }
    }
    private static void closeQuiet(AutoCloseable c) { if (c != null) try { c.close(); } catch (Exception ignored) {} }

    // =========================
    // Schema yardımcıları
    // =========================
    private String currentSchema() throws SQLException {
        try (Statement st = connection.createStatement();
             ResultSet rs = st.executeQuery("SELECT DATABASE()")) {
            rs.next();
            return rs.getString(1);
        }
    }

    private String findFirstExistingColumn(String table, List<String> candidates) throws SQLException {
        String schema = currentSchema();
        String placeholders = String.join(",", Collections.nCopies(candidates.size(), "?"));
        String orderQuoted  = "'" + String.join("','", candidates) + "'";
        String sql =
                "SELECT COLUMN_NAME FROM information_schema.COLUMNS " +
                        "WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ? AND COLUMN_NAME IN ("+placeholders+") " +
                        "ORDER BY FIELD(COLUMN_NAME, "+orderQuoted+") LIMIT 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int i = 1;
            ps.setString(i++, schema);
            ps.setString(i++, table);
            for (String c : candidates) ps.setString(i++, c);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString(1);
            }
        }
        return null;
    }

    private String findFirstExistingTable(List<String> candidates) throws SQLException {
        String schema = currentSchema();
        String placeholders = String.join(",", Collections.nCopies(candidates.size(), "?"));
        String sql = "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA=? AND TABLE_NAME IN ("+placeholders+") LIMIT 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int i=1; ps.setString(i++, schema);
            for (String t : candidates) ps.setString(i++, t);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString(1);
            }
        }
        return null;
    }

    // =========================
    // State (senaryolar arası)
    // =========================
    private String contactsTable;
    private String colId, colName, colEmail, colMessage, colCreatedAt;

    private Long   lastInsertedId;
    private String testEmail  = "cennet.auto+" + System.currentTimeMillis() + "@example.com";
    private String initialMsg = "hello-from-cennet";
    private String updatedMsg = "updated-by-cennet";

    private List<Map<String,Object>> groupedCouponRows;

    // =========================
    // CONTACT benzeri tabloyu çöz
    // =========================
    private void resolveContacts() throws SQLException {
        ensureConnection();

        if (contactsTable != null) return;

        contactsTable = findFirstExistingTable(Arrays.asList(
                "contacts", "contact", "contact_messages", "messages", "contact_us", "contactus"
        ));
        if (contactsTable == null) throw new RuntimeException("Contact tablosu bulunamadı.");

        colId        = Optional.ofNullable(findFirstExistingColumn(contactsTable, Arrays.asList("id","contact_id"))).orElseThrow(() -> new RuntimeException("Contact id kolonu yok."));
        colName      = Optional.ofNullable(findFirstExistingColumn(contactsTable, Arrays.asList("name","full_name","fullname"))).orElse("name");
        colEmail     = Optional.ofNullable(findFirstExistingColumn(contactsTable, Arrays.asList("email","mail","e_mail"))).orElseThrow(() -> new RuntimeException("Contact email kolonu yok."));
        colMessage   = Optional.ofNullable(findFirstExistingColumn(contactsTable, Arrays.asList("message","msg","content","text","body"))).orElseThrow(() -> new RuntimeException("Contact message kolonu yok."));
        colCreatedAt = Optional.ofNullable(findFirstExistingColumn(contactsTable, Arrays.asList("created_at","createdAt","inserted_at","created_on","createdon","created_date"))).orElse(null);
    }

    // =========================
    // STEPS (Feature’daki * ile birebir)
    // =========================
    @Given("Database connection is established.")
    public void database_connection_is_established() {
        try {
            ensureConnection();
            System.out.println("[db] Connection established.");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Given("Insert contact row")
    public void insert_contact_row() {
        PreparedStatement ps = null; ResultSet rs = null;
        try {
            resolveContacts();
            String sql;
            if (colCreatedAt != null) {
                sql = "INSERT INTO "+contactsTable+" ("+colName+","+colEmail+","+colMessage+","+colCreatedAt+") VALUES (?,?,?,NOW())";
            } else {
                sql = "INSERT INTO "+contactsTable+" ("+colName+","+colEmail+","+colMessage+") VALUES (?,?,?)";
            }
            ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, "Cennet QA");
            ps.setString(2, testEmail);
            ps.setString(3, initialMsg);
            int aff = ps.executeUpdate();
            Assert.assertTrue("Insert başarısız.", aff > 0);

            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                lastInsertedId = rs.getLong(1);
            } else {
                String q = "SELECT "+colId+" FROM "+contactsTable+" WHERE "+colEmail+" = ? ORDER BY "+colId+" DESC LIMIT 1";
                try (PreparedStatement p2 = connection.prepareStatement(q)) {
                    p2.setString(1, testEmail);
                    try (ResultSet r2 = p2.executeQuery()) {
                        if (r2.next()) lastInsertedId = r2.getLong(1);
                    }
                }
            }
            System.out.println("[DB] inserted id = " + lastInsertedId);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally { closeQuiet(rs); closeQuiet(ps); }
    }

    @Given("Update message by id/email")
    public void update_message_by_id_email() {
        PreparedStatement ps = null;
        try {
            resolveContacts();
            String where = (lastInsertedId != null) ? (colId + " = ?") : (colEmail + " = ?");
            String sql = "UPDATE "+contactsTable+" SET "+colMessage+" = ? WHERE " + where;
            ps = connection.prepareStatement(sql);
            ps.setString(1, updatedMsg);
            if (lastInsertedId != null) ps.setLong(2, lastInsertedId); else ps.setString(2, testEmail);
            int aff = ps.executeUpdate();
            Assert.assertTrue("Update etkilenen satır yok.", aff > 0);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally { closeQuiet(ps); }
    }

    @Given("Verify updated value")
    public void verify_updated_value() {
        PreparedStatement ps = null; ResultSet rs = null;
        try {
            resolveContacts();
            String where = (lastInsertedId != null) ? (colId + " = ?") : (colEmail + " = ?");
            String sql = "SELECT "+colMessage+" FROM "+contactsTable+" WHERE "+where+" LIMIT 1";
            ps = connection.prepareStatement(sql);
            if (lastInsertedId != null) ps.setLong(1, lastInsertedId); else ps.setString(1, testEmail);
            rs = ps.executeQuery();
            Assert.assertTrue("Satır bulunamadı.", rs.next());
            String got = rs.getString(1);
            Assert.assertEquals("Mesaj güncellenmedi.", updatedMsg, got);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally { closeQuiet(rs); closeQuiet(ps); }
    }

    @Given("Delete by email")
    public void delete_by_email() {
        PreparedStatement ps = null;
        try {
            resolveContacts();
            String sql = "DELETE FROM "+contactsTable+" WHERE "+colEmail+" = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, testEmail);
            int aff = ps.executeUpdate();
            Assert.assertTrue("Delete etkilenen satır yok.", aff > 0);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally { closeQuiet(ps); }
    }

    @Given("Verify deletion")
    public void verify_deletion() {
        PreparedStatement ps = null; ResultSet rs = null;
        try {
            resolveContacts();
            String sql = "SELECT COUNT(*) FROM "+contactsTable+" WHERE "+colEmail+" = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, testEmail);
            rs = ps.executeQuery();
            Assert.assertTrue(rs.next());
            int cnt = rs.getInt(1);
            Assert.assertEquals("Silme başarısız.", 0, cnt);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally { closeQuiet(rs); closeQuiet(ps); }
    }

    @Given("Run grouped count by coupon_id")
    public void run_grouped_count_by_coupon_id() {
        PreparedStatement ps = null; ResultSet rs = null;
        try {
            ensureConnection();

            String jTable = findFirstExistingTable(Arrays.asList(
                    "coupon_products", "coupons_products", "product_coupons", "products_coupons",
                    "coupon_product", "product_coupon"
            ));
            if (jTable == null) throw new RuntimeException("Kupon-ürün eşleme tablosu bulunamadı.");

            String couponCol  = Optional.ofNullable(findFirstExistingColumn(jTable, Arrays.asList("coupon_id","couponId","cid","coupons_id"))).orElseThrow(() -> new RuntimeException("coupon_id kolonu yok."));
            String productCol = Optional.ofNullable(findFirstExistingColumn(jTable, Arrays.asList("product_id","productId","pid","products_id"))).orElseThrow(() -> new RuntimeException("product_id kolonu yok."));

            String sql = "SELECT "+couponCol+" AS coupon_id, COUNT("+productCol+") AS product_count " +
                    "FROM "+jTable+" GROUP BY "+couponCol+" ORDER BY "+couponCol;

            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();

            groupedCouponRows = new ArrayList<>();
            while (rs.next()) {
                Map<String,Object> row = new LinkedHashMap<>();
                row.put("coupon_id", rs.getObject("coupon_id"));
                row.put("product_count", rs.getObject("product_count"));
                groupedCouponRows.add(row);
            }
            System.out.println("[DB] coupon groups = " + groupedCouponRows.size());

        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally { closeQuiet(rs); closeQuiet(ps); }
    }

    @Given("Verify grouped result")
    public void verify_grouped_result() {
        Assert.assertNotNull("Gruplama sonucu null.", groupedCouponRows);
        System.out.println("[DB] grouped result size = " + groupedCouponRows.size());
    }

    @Given("Database connection is closed")
    public void database_connection_is_closed() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("[db] Connection closed.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            connection = null;
        }
    }


    @When("Update message by id\\/email")
    public void updateMessageByIdEmail() {
    }
}
