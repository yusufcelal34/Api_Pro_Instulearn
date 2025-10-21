@Erkan87
Feature: As an administrator, I want to create a new course category record via an API connection.

  Scenario: [US21_TC_Get_001] Listing products with valid authorization
    Given valid authorization credentials are available
    When the user sends a GET request to the "/api/products" endpoint
    Then the returned HTTP Status Code should be "200"
    And the "remark" field in the response body should be "success"


  Scenario: [US21_TC_Get_002] Listing products with valid authorization
    Then the response body for product with ID 251 should contain the following fields:
      | field_name |
      | creator_id |
      | type |
      | slug |
      | category_id |
      | price |
      | point |
      | unlimited_inventory |
      | ordering |
      | inventory |
      | id |
      | product_id |
      | locale |
      | title |
      | seo_description |
      | summary |
      | description |

  Scenario: [US21_TC_Get_003] Listing products with valid authorization
    Given an invalid authorization token is available
    When the user sends a GET request to the "/api/products" endpoint
    Then the returned HTTP Status Code should be 401
    And the message field in the response body should be Unauthenticated.


