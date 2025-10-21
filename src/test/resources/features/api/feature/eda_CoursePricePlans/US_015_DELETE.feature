@eda @FullStartAll
Feature: US_015 As an administrator, I want to be able to delete course price plan information with the specified id number via API connection.

  Scenario: AC_01> adminToken / invalidId / deleteRuquest / 200 / "success" / "Successfully Deleted."
    * The api user constructs the base url with the "admin" token.
    * E The api user sets "api/deletePricePlan/319" path parameters.
    * E The api user sends a DELETE request and saves the returned response.
    * E The api user verifies that the status code is 200.
    * E The api user verifies that the "remark" information in the response body is "success".
    * E The api user verifies that the "Message" information in the response body is "Successfully Deleted.".

  Scenario: AC_02> adminToken / deleteId / deleteRequest / 203 / "failed" / "There is not ticket for this id."
    * The api user constructs the base url with the "admin" token.
    * E The api user sets "api/deletePricePlan/285" path parameters.
    * E The api user sends a DELETE request and saves the returned response.
    * E The api user verifies that the status code is 203.
    * E The api user verifies that the "remark" information in the response body is "failed".
    * E The api user verifies that the "data.message" information in the response body is "There is not ticket for this id.".

  Scenario: AC_03> adminToken / id no data / deleteRequest / 203 / "failed" / "No id"
    * The api user constructs the base url with the "admin" token.
    * E The api user sets "api/deletePricePlan" path parameters.
    * E The api user sends a DELETE request and saves the returned response.
    * E The api user verifies that the status code is 203.
    * E The api user verifies that the "remark" information in the response body is "failed".
    * E The api user verifies that the "data.message" information in the response body is "No id".

  Scenario: AC_04> invalidToken / validId / 401 / "Unauthenticated."
    * E The api user constructs the base url with the "invalid" token.
    * E The api user sets "api/deletePricePlan/291" path parameters.
    * E The api user sends a DELETE request and saves the returned response.
    #* E The api user verifies that the status code is 401.
    #* E The api user verifies that the "data.message" information in the response body is "Unauthenticated.".

  Scenario Outline: AC_05> adminToken / validId / Deleted Price Plans ID = validId
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/deletePricePlan/<id>" path parameters.
    * E The api user sends a DELETE request and saves the returned response.
    * E The api user verifies the <id> <Deleted Price Plan Id>
    Examples:
      |id   | | Deleted Price Plan Id |
      |320  | | 320                   |

  Scenario: AC_06> adminToken / deleteId / getRequest / 203 / "failed" / "There is not ticket for this id."
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/pricePlan/310" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The api user verifies that the status code is 203.
    * E The api user verifies that the "remark" information in the response body is "failed".
    * E The api user verifies that the "data.message" information in the response body is "There is not ticket for this id.".




















