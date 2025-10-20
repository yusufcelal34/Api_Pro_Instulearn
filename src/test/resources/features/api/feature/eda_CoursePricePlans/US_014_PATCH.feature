@edaa
Feature: US_014 As an administrator, I want to be able to update the information
  of the course price plan with the specified id number via API connection.

  Scenario: AC_01> adminToken / creatId / patchRequest / 200 / "success" / "Successfully Updated."
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/updatePricePlan/280" path parameters.
    * E The api user prepares a PATCH request containing the "ÇOK UYKUM GELDİ" information to send to the api updateCategory endpoint.
    * E The api user sends a PATCH request and saves the returned response.
    * E The api user verifies that the status code is 200.
    * E The api user verifies that the "remark" information in the response body is "success".
    * E The api user verifies that the "Message" information in the response body is "Successfully Updated.".


  Scenario: AC_02> adminToken / creatId / patchRequest no data / 203 / "failed" / "There is no information to update."
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/updatePricePlan/280" path parameters.
    * E The api user prepares a PATCH request that contains no data.
    * E The api user sends a PATCH request and saves the returned response.
    * E The api user verifies that the status code is 203.
    * E The api user verifies that the "remark" information in the response body is "failed".
    * E The api user verifies that the "message" information in the response body is "There is no information to update.".

  Scenario: AC_03> adminToken / invalidId / patchRequest / 203 / "failed" / "There is not ticket for this id."
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/updatePricePlan/400" path parameters.
    * E The api user prepares a PATCH request containing the "ÇOK UYKUM GELDİ" information to send to the api updateCategory endpoint.
    * E The api user sends a PATCH request and saves the returned response.
    * E The api user verifies that the status code is 203.
    * E The api user verifies that the "remark" information in the response body is "failed".
    * E The api user verifies that the "data.message" information in the response body is "There is not ticket for this id.".


  Scenario: AC_04> adminToken / id no data / patchRequest / 203 / "failed" / "No id"
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/updatePricePlan" path parameters.
    * E The api user prepares a PATCH request containing the "ÇOK UYKUM GELDİ" information to send to the api updateCategory endpoint.
    * E The api user sends a PATCH request and saves the returned response.
    * E The api user verifies that the status code is 203.
    * E The api user verifies that the "remark" information in the response body is "failed".
    * E The api user verifies that the "data.message" information in the response body is "No id".

  Scenario: AC_05> invalidToken / validId / 401 / "Unauthenticated."
    * E The api user constructs the base url with the "invalid" token.
    * E The api user sets "api/updatePricePlan/280" path parameters.
    * E The api user prepares a PATCH request containing the "ÇOK UYKUM GELDİ" information to send to the api updateCategory endpoint.
    * E The api user sends a PATCH request and saves the returned response.
    #* E The api user verifies that the status code is 401.
    #* E The api user verifies that the "data.message" information in the response body is "Unauthenticated.".

  Scenario Outline: AC_06> adminToken / validId / Updated Price Plans ID = validId
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/updatePricePlan/<id>" path parameters.
    * E The api user prepares a PATCH request containing the "UYKUM VAR" information to send to the api updateCategory endpoint.
    * E The api user sends a PATCH request and saves the returned response.
    * E The api user verifies the <id> <Updated Price Plans ID>
    Examples:
      |id   | | Updated Price Plans ID |
      |280  | | 280                    |

  Scenario: AC_07> adminToken / validId / getRequest / data.title
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/pricePlan/280" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The fields and values in the response body are verified:
      | data.id                   | 280                   |
      | data.translations.title   | [UYKUM VAR]           |
