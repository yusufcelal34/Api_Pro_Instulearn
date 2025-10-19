@yusuf
Feature: BACKEND JDBC TESTING

  Background: Database connection

    * Database connection is established.

  @DB31
  Scenario: US31 Review stats for a product; validate min rating < 3
    * Execute review stats query by :product_id
      """
      SELECT product_id,
             COUNT(*) AS total_reviews,
             ROUND(AVG(rating),2) AS avg_rating,
             MAX(rating) AS highest_rating,
             MIN(rating) AS lowest_rating
      FROM product_reviews
      WHERE product_id = :product_id
      GROUP BY product_id
      HAVING MIN(rating) < 3;
      """
    * Verify result exists only if MIN(rating) < 3
    * Database connection is closed

  @DB32
  Scenario: US32 Support tickets by department and status
    * Run grouping by department and status
      """
      SELECT d.id AS department_id, d.title AS department_title,
             s.status, COUNT(*) AS ticket_count
      FROM supports s
      JOIN departments d ON d.id = s.department_id
      GROUP BY d.id, d.title, s.status
      ORDER BY d.id, s.status;
      """
    * Verify grouped counts returned
    * Database connection is closed

  @DB33
  Scenario: US33 Active in-stock products created in last 30 days
    * Execute products filter query for last 30 days
      """
      -- Aktif ve stoklu yeni ürünler (örnek referans)
      SELECT id, title, stock, is_active, created_at
      FROM products
      WHERE stock > 0
        AND is_active = 1
        AND created_at >= NOW() - INTERVAL 30 DAY;
      """
    * If zero rows, assert informational note
    * Database connection is closed