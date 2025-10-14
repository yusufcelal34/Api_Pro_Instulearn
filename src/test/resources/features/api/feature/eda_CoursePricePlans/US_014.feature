Feature: US_014 As an administrator, I want to be able to update the information
  of the course price plan with the specified id number via API connection.

  Scenario: AC_01 When a PATCH body containing the correct (id) and correct data(title, dateRange, discount, capacity, webinar_id)
  with valid authorization information is sent tothe /api/updatePricePlan/{id} endpoint,it should be verified that the status code returned is 200,
  the remark in the response body is “success” and the Message is “Successfully Updated.”.
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/updatePricePlan/280" path parameters.
    * E The api user prepares a PATCH request containing the "ÇOK UYKUM GELDİ" information to send to the api updateCategory endpoint.
    * E The api user sends a PATCH request and saves the returned response.
    * E The api user verifies that the status code is 200.
    * E The api user verifies that the "remark" information in the response body is "success".
    * E The api user verifies that the "Message" information in the response body is "Successfully Updated.".


  Scenario: AC_02 When a PATCH request is sent to the /api/updatePricePlan/{id} endpoint with valid authorization information,
  it should be verified that the status code returned is 203,the remark in the response body is “failed” and the message is “There is no information to update.”.
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/updatePricePlan/280" path parameters.
    * E The api user prepares a PATCH request that contains no data.
    * E The api user sends a PATCH request and saves the returned response.
    * E The api user verifies that the status code is 203.
    * E The api user verifies that the "remark" information in the response body is "failed".
    * E The api user verifies that the "message" information in the response body is "There is no information to update.".

  Scenario: AC_03 When a PATCH body containing an unregistered (id) and correct data (title, dateRange, discount, capacity, webinar_id) with valid authorization information is
  sent to the /api/updatePricePlan/{id} endpoint, the status code returned is 203, the remark in the response body is “failed” and the message is "There is not ticket for this id.",
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/updatePricePlan/300" path parameters.
    * E The api user prepares a PATCH request containing the "ÇOK UYKUM GELDİ" information to send to the api updateCategory endpoint.
    * E The api user sends a PATCH request and saves the returned response.
    * E The api user verifies that the status code is 203.
    * E The api user verifies that the "remark" information in the response body is "failed".
    * E The api user verifies that the "data.message" information in the response body is "There is not ticket for this id.".


  Scenario: AC_04 When sending a PATCH body that does not contain (id) and contains the correct data (title, dateRange, discount, capacity, webinar_id),
  it should be verified that the status code returned is 203, the remark in the response body is ‘failed’ and the message is ”No id".
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/updatePricePlan" path parameters.
    * E The api user prepares a PATCH request containing the "ÇOK UYKUM GELDİ" information to send to the api updateCategory endpoint.
    * E The api user sends a PATCH request and saves the returned response.
    * E The api user verifies that the status code is 203.
    * E The api user verifies that the "remark" information in the response body is "failed".
    * E The api user verifies that the "data.message" information in the response body is "No id".

  Scenario: AC_05 When a PATCH body is sent to /api/updatePricePlan/{id} endpoint with invalid token authorization information and correct (id) and correct data (title,
  dateRange, discount, capacity, webinar_id), it should be verified that the status code returned is 401
  and the message information in the response body is “Unauthenticated.”
    * E The api user constructs the base url with the "invalid" token.
    * E The api user sets "api/updatePricePlan/280" path parameters.
    * E The api user prepares a PATCH request containing the "ÇOK UYKUM GELDİ" information to send to the api updateCategory endpoint.
    * E The api user sends a PATCH request and saves the returned response.
    * E The api user verifies that the status code is 401.
    * E The api user verifies that the "data.message" information in the response body is "Unauthenticated.".

  Scenario Outline: AC_06 The Updated Price Plans ID in the response body returned from the /api/updatePricePlan/{id}
  endpoint must be verified to be the same as the id path parameter in the /api/updatePricePlan/{id} endpoint.
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/updatePricePlan/<id>" path parameters.
    * E The api user prepares a PATCH request containing the "UYKUM VAR" information to send to the api updateCategory endpoint.
    * E The api user sends a PATCH request and saves the returned response.
    * E The api user verifies the <id> <Updated Price Plans ID>
    Examples:
      |id   | | Updated Price Plans ID |
      |280  | | 280                    |

  Scenario: AC_07 The course price plan record that is requested to be updated via API should be verified that it has been updated via API.
    * E The api user constructs the base url with the "admin" token.
    * E The api user sets "api/pricePlan/280" path parameters.
    * E The api user sends a GET request and saves the returned response.
    * E The fields and values in the response body are verified:
      | data.id                   | 280                   |
      | data.translations.title   | [UYKUM VAR]           |