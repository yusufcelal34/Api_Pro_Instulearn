
Feature: US07 As an administrator, I want to access detailed information about the course category with the specified ID via an API connection.
  Background:
    * no explicit token

  # AC01: Valid token + correct id → 200 & remark=success
  Scenario: AC01 GET /api/category/{id} with valid token and correct id returns success
    Given The api user constructs the base url with the "admin" token.
    And The api user sets "api/category/1005" path parameters.
    When The api user sends a GET request and saves the returned response.
    Then The api user verifies that the status code is 200.
    And The api user verifies that the "remark" information in the response body is "success".

  # AC02: Response body field doğrulamaları
  Scenario: AC02 Verify list data fields in the response body
    Given The api user constructs the base url with the "admin" token.
    And The api user sets "api/category/1005" path parameters.
    When The api user sends a GET request and saves the returned response.
    Then The fields and values in the response body are verified:
      | data.parent_id                   | null                                              |
      | data.icon                        | /store/1/default_images/categories_icons/code.png |
      | data.order                       | 68                                                |
      | data.translations[0].id          | 448                                               |
      | data.translations[0].category_id | 1005                                              |
      | data.translations[0].locale      | en                                                |
      | data.translations[0].title       | Health And Fitness4                               |

  # AC03: Valid token + non-existent id → 203, remark=failed, message=There is not category for this id.
  Scenario: AC03 GET /api/category/{id} with non-existent id returns failed
    Given The api user constructs the base url with the "admin" token.
    And The api user sets "api/category/10055555555555" path parameters.
    When The api user sends a GET request and saves the returned response.
    Then The api user verifies that the status code is 203.
    And The api user verifies that the "remark" information in the response body is "failed".
    And The api user verifies that the "message" information in the response body is "There is not category for this id.".

  # AC04: Id yok (0 veya boş) → 203, remark=failed, message=No id
  Scenario: AC04 GET /api/category/{id} without id returns failed
    Given The api user constructs the base url with the "admin" token.
    And The api user sets "api/category/0" path parameters.
    When The api user sends a GET request and saves the returned response.
    Then The api user verifies that the status code is 203.
    And The api user verifies that the "remark" information in the response body is "failed".
    And The api user verifies that the "data.message" information in the response body is "No id".

  # AC05: Invalid token + valid id → 401, message=Unauthenticated.
  Scenario: AC05 GET /api/category/{id} with invalid token returns unauthenticated
    Given The api user constructs the base url with the "invalidtoken" token.
    And The api user sets "api/category/1005" path parameters.
    When The api user sends a GET request and saves the returned response.
    Then The api user verifies that the status code is 401.
      And The api user verifies that the "data.message" information in the response body is "Unauthenticated.".