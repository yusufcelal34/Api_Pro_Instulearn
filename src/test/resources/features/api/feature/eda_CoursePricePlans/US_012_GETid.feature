@eda
Feature: US_12 As an administrator, I should be able to access the detailed information
  of the course price plan with the specified id number via the API connection.


  Scenario: AC_01> adminToken / validId / 200 / "success"
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/pricePlan/272" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The api user verifies that the status code is 200.
    * E The api user verifies that the "remark" information in the response body is "success".

  Scenario: AC_02> adminToken / validId / responseBodyInformation
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/pricePlan/272" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The fields and values in the response body are verified:
      | id                      | 272              |
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

  Scenario: AC_03> adminToken / invalidId / 203 / "failed" / "No id"
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/pricePlan/0" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The api user verifies that the status code is 203.
    * E The api user verifies that the "remark" information in the response body is "failed".
    * E The api user verifies that the "data.message" information in the response body is "No id".

  Scenario: AC_04 invalidToken / validId / 401 / "Unauthenticated."
    * E The api user constructs the base url with the "invalid" token.
    * E The api user sets "api/pricePlan/272" path parameters.
    * E The api user sends a GET request and saves the returned response.
    #* E The api user verifies that the status code is 401.
    #* E The api user verifies that the "message" information in the response body is "Unauthenticated.".