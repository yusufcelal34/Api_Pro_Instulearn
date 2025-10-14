
Feature: US_011: As an administrator I want to be able to access course price plans via API connection.


  Scenario: AC_01: When a GET request is sent to /api/pricePlans endpoint with valid authorization information,
  it should be verified that the status code returned is 200 and the remark in the response body is “success”.
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/pricePlans" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The api user verifies that the status code is 200.
    * E The api user verifies that the "remark" information in the response body is "success".


  Scenario: AC_02 The information (creator_id, webinar_id, bundle_id, start_date, end_date, discount, capacity, order, created_at, updated_at,
  deleted_at, title, id, ticket_id, locale, title) of id(x) in response body should be verified.
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/pricePlan/272" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The fields and values in the response body are verified:
      | creator_id              | 1800             |
      | webinar_id              | 2002             |
      | bundle_id               | null             |
      | start_date              | 1717200000       |
      | end_date                | 1719705600       |
      | discount                | 20               |
      | capacity                | 50               |
      | order                   | null             |
      | created_at              | 1759949764       |
      | updated_at              | null             |
      | deleted_at              | null             |
      | title                   | null             |
      | translations[0].id      | 245              |
      |translations[0].ticket_id| 272              |
      | translations[0].locale  | en               |
      | translations[0].title   | Test Price Plans |

  @eda
  Scenario: AC_03 When a GET request is sent to the /api/pricePlans endpoint with invalid token authorization information,
  it should be verified that the status code returned is 401 and the message information in the response body is “Unauthenticated.”.
    * E The api user constructs the base url with the "invalid" token.
    * E The api user sets "api/pricePlan/272" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The api user verifies that the status code is 401.
    * E The api user verifies that the "message" information in the response body is "Unauthenticated.".

