@eda @FullStartAll
Feature: US_13 As an administrator I want to be able to create a new course price plan record via API connection.


  Scenario: AC_01> adminToken / postRequest / 200 / "success" / "Successfully Added."
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/addPricePlan" path parameters.
    * E The api user prepares a POST request to send to the api addPricePlan "UYKUM GELDİ","2025-10-11 - 2025-10-15", 20, 50, 2002.
    * E The api user sends a "POST" request and saves the returned response.
    * E The api user verifies that the status code is 200.
    * E The api user verifies that the "remark" information in the response body is "success".
    * E The api user verifies that the "Message" information in the response body is "Successfully Added.".

  Scenario: AC_02> adminToken / postRequest no data / 422 / "The title field is required. (and 3 more errors)"
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/addPricePlan" path parameters.
    * E The api user prepares a POST request that contains no data.
    * E The api user sends a "POST" request and saves the returned response.
    #* E The api user verifies that the status code is 422.
    #* E The api user verifies that the "message" information in the response body is "The title field is required. (and 3 more errors)".

  Scenario: AC_03> invalidToken / validId / 401 / "Unauthenticated."
    * E The api user constructs the base url with the "invalid" token.
    * E The api user sets "api/addPricePlans" path parameters.
    * E The api user prepares a POST request to send to the api addPricePlan "UYKUM GELDİ","2025-10-11 - 2025-10-15", 20, 50, 2002.
    * E The api user sends a "POST" request and saves the returned response.
    #* E The api user verifies that the status code is 401.
    #* E The api user verifies that the "message" information in the response body is "Unauthenticated.".

  Scenario: AC_04> adminToken / creatId / 200 / "success"
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/pricePlan/280" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The api user verifies that the status code is 200.
    * E The api user verifies that the "remark" information in the response body is "success".