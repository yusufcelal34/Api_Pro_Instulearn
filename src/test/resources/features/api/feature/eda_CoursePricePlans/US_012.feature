Feature: As an administrator, I should be able to access the detailed information
  of the course price plan with the specified id number via the API connection.


  Scenario: AC_01 When a GET request with valid authorization information and correct data (id) is sent to the /api/pricePlan/{id} endpoint,
  it should be verified that the status code returned is 200 and the remark in the response body is “success”.
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/pricePlan/272" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The api user verifies that the status code is 200.
    * E The api user verifies that the "remark" information in the response body is "success".

  Scenario: AC_02 The contents of the list data (id, creator_id, webinar_id, bundle_id, start_date, end_date, discount, capacity, order, created_at,
  updated_at, deleted_at, title, id, ticket_id, locale, title) in the response body must be verified.
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

  Scenario: AC_03 It should be verified that when a GET request is sent to the endpoint /api/pricePlan/{id} with valid authorization information and an unregistered (id),
  the status code returned is 203, the remark in the response body is “failed” and the message is "There is not ticket for this id.",
  and when a GET request is sent without (id), the status code returned is 203, the remark in the response body is ‘failed’ and the message is “No id”.
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/pricePlan/0" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The api user verifies that the status code is 203.
    * E The api user verifies that the "remark" information in the response body is "failed".
    * E The api user verifies that the "data.message" information in the response body is "No id".

  Scenario: AC_04 When a GET request is sent to the /api/pricePlan/{id} endpoint with invalid token authorization information and correct data (id),
  it should be verified that the status code returned is 401 and the message in the response body is “Unauthenticated.”.
    * E The api user constructs the base url with the "invalid" token.
    * E The api user sets "api/pricePlan/272" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The api user verifies that the status code is 401.
    * E The api user verifies that the "message" information in the response body is "Unauthenticated.".