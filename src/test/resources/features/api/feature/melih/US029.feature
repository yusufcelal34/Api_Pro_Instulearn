Feature: US029 As an administrator, I want to be able to update the information of the product category with the
  specified id number via the API connection.

  Scenario: TC01 When a PATCH body containing the correct (id) and correct data (title) with valid authorization
  information is sent to the /api/updateProductCategory/{id} endpoint, it should be verified that the status code
  returned is 200, the remark in the response body is “success” and the Message is “Successfully Updated.”.

    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/updateProductCategory/103" path parameters.
    * MI The api user sends a "PATCH" request and saves the returned response.
    * MI The api user verifies that the status code is 200.
    * MI The api user verifies that the "remark" information in the response body is "success".
    * MI The api user verifies that the "Message" information in the response body is "Successfully Updated.".

  Scenario: TC02 When a PATCH request is sent to the /api/updateProductCategory/{id} endpoint with valid authorization
  information, it should be verified that the status code returned is 203 and the remark in the response body is
  “failed” and the message is “There is no information to update.”.

    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/updateProductCategory/103" path parameters.
    * MI The api user prepares a PATCH request that contains no data.
    * MI The api user sends a "PATCH" request and saves the returned response.
    * MI The api user verifies that the status code is 203.
    * MI The api user verifies that the "remark" information in the response body is "failed".
    * MI The api user verifies that the "message" information in the response body is "There is no information to update.".


  Scenario: TC03 When a PATCH body is sent to the /api/updateProductCategory/{id} endpoint containing an (id) and
  correct data (title) that is not registered with valid authorization information, the status code returned is 203,
  the remark in the response body is “failed” and the message is "There is not product category for this id.“,


    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/updateProductCategory/103" path parameters.
    * MI The api user prepares a PATCH request containing the "Educational Equipment" information to send to the api updateCategory endpoint.
    * MI The api user sends a "PATCH" request and saves the returned response.
    * MI The api user verifies that the status code is 203.
    * MI The api user verifies that the "remark" information in the response body is "failed".
    * MI The api user verifies that the "data.message" information in the response body is "There is not product category for this id.".

  Scenario: TC04 and when sending a PATCH body that does not contain (id) and contains the correct data (title),
  the status code returned is 203, the remark in the response body is ‘failed’ and the message is ”No id".

    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/updateProductCategory" path parameters.
    * MI The api user prepares a PATCH request containing the "Educational Equipment" information to send to the api updateCategory endpoint.
    * MI The api user sends a "PATCH" request and saves the returned response.
    * MI The api user verifies that the status code is 203.
    * MI The api user verifies that the "remark" information in the response body is "failed".
    * MI The api user verifies that the "data.message" information in the response body is "No id".


  Scenario: TC05 When a PATCH body is sent to the /api/updateProductCategory/{id} endpoint with invalid token
  authorization information and correct data (title), it should be verified that the status code returned is 401 and
  the message information in the response body is “Unauthenticated.”

    * MI The api user constructs the base url with the "invalid" token.
    * MI The api user sets "api/updateProductCategory/103" path parameters.
    * MI The api user prepares a PATCH request containing the "Educational Equipment" information to send to the api updateCategory endpoint.
    * MI The api user sends a "PATCH" request and saves the returned response.
    #* MI The api user verifies that the status code is 401.
    #* MI The api user verifies that the "data.message" information in the response body is "Unauthenticated.".


  Scenario Outline: TC06 Verify that the Updated Category Id in the response body returned from the /api/updateProductCategory/{id}
  endpoint is the same as the id path parameter in the /api/updateProductCategory/{id} endpoint.

    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/updateProductCategory/<id>" path parameters.
    * MI The api user prepares a PATCH request containing the "Equipment" information to send to the api updateCategory endpoint.
    * MI The api user sends a "PATCH" request and saves the returned response.
    * MI The api user verifies the <id> <Update Product Category ID>
    Examples:
      |id   | | Update Product Category ID |
      |103  | | 103                        |

  Scenario: TC07 It should be verified that the product category record that is requested to be updated via API has been
  updated via API. (It can be verified that the record has been updated by sending a GET request to the /api/productCategory/{id}
  endpoint with the Updated Category Id returned in the response body).

    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/productCategory103" path parameters.
    * MI The api user sends a "GET" request and saves the returned response.
    * MI The fields and values in the response body are verified:
      | data.id                   | 103                   |
      | data.translations.title   | [Equipment]           |