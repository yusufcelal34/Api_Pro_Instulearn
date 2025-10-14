Feature: As an administrator I want to be able to create a new course price plan record via API connection.


  Scenario: AC_01 When a POST body with valid authorization information and correct data(title, dateRange,discount, capacity, webinar_id)
  is sent to /api/addPricePlan endpoint,it should be verified that the status code returned is 200,
  the remark in the response body is “success” and the Message is “Successfully Added.”.
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/addPricePlan" path parameters.
    * E The api user prepares a POST request to send to the api addPricePlan "UYKUM GELDİ","2025-10-11 - 2025-10-15", 20, 50, 2002.
    * E The api user sends a "POST" request and saves the returned response.
    * E The api user verifies that the status code is 200.
    * E The api user verifies that the "remark" information in the response body is "success".
    * E The api user verifies that the "Message" information in the response body is "Successfully Added.".

  Scenario: AC_02 When a POST request is sent to /api/addPricePlan endpoint without valid authorization information and data,
  it should be verified that the status code returned is 422 and the message information in the response body is “The title field is required. (and 3 more errors)”
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/addPricePlan" path parameters.
    * E The api user prepares a POST request that contains no data.
    * E The api user sends a "POST" request and saves the returned response.
    * E The api user verifies that the status code is 422.
    * E The api user verifies that the "message" information in the response body is "The title field is required. (and 3 more errors)".

  Scenario: AC_03 When a POST body with invalid authorization information (invalid token) and correct data (title, dateRange, discount, capacity, webinar_id)
  is sent to /api/addPricePlan endpoint, it should be verified that the status code returned is 401 and the message information in the response body is “Unauthenticated.”
    * E The api user constructs the base url with the "invalid" token.
    * E The api user sets "api/addPricePlan" path parameters.
    * E The api user prepares a POST request to send to the api addPricePlan "UYKUM GELDİ","2025-10-11 - 2025-10-15", 20, 50, 2002.
    * E The api user sends a "POST" request and saves the returned response.
    * E The api user verifies that the status code is 401.
    * E The api user verifies that the "message" information in the response body is "Unauthenticated.".

  Scenario: AC_04 The new course price plan record to be created through the API must be verified from the API.
  (It can be verified that the record was created by sending a GET request to the /api/pricePlan/{id}
  endpoint with the Added Price Plans ID returned in the response body).
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/pricePlan/280" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The api user verifies that the status code is 200.
    * E The api user verifies that the "remark" information in the response body is "success".