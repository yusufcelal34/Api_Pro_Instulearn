Feature:As an administrator, I want to be able to delete product category information with the specified id number
  via API connection.

  Scenario: TC01 When a DELETE request is sent to the /api/deleteProductCategory/{id} endpoint with valid authorization
  information and the correct (id), it should be verified that the status code returned is 200, the remark in the
  response body is “success” and the Message is “Successfully Deleted.”.

    * The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/deleteProductCategory/67" path parameters.
    * MI The api user sends a "DELETE" request and saves the returned response.
    * MI The api user verifies that the status code is 200.
    * MI The api user verifies that the "remark" information in the response body is "success".
    * MI The api user verifies that the "Message" information in the response body is "Successfully Deleted.".

  Scenario: TC02 It should be verified that when a DELETE request is sent to the /api/deleteProductCategory/{id} endpoint
  containing an (id) with valid authorization information and no record, the status code returned is 203,
  the remark in the response body is “failed” and the message is “There is not product category for this id.”,

    * The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/deleteProductCategory/68" path parameters.
    * MI The api user sends a "DELETE" request and saves the returned response.
    * MI The api user verifies that the status code is 203.
    * MI The api user verifies that the "remark" information in the response body is "failed".
    * MI The api user verifies that the "data.message" information in the response body is "There is not product category for this id.".

    Scenario: TC03  and when a DELETE request is sent without (id), the status code returned is 203, the remark in the
    response body is ‘failed’ and the message is “No id”.

      * The api user constructs the base url with the "admin" token.
      * MI The api user sets "api/deleteProductCategory" path parameters.
      * MI The api user sends a "DELETE" request and saves the returned response.
      * MI The api user verifies that the status code is 203.
      * MI The api user verifies that the "remark" information in the response body is "failed".
      * MI The api user verifies that the "data.message" information in the response body is "No id".

  Scenario:When a DELETE request with invalid token authorization information and id is sent to the
  /api/deleteProductCategory/{id} endpoint, it should be verified that the status code returned is 401 and the message
  information in the response body is “Unauthenticated.”

    * MI The api user constructs the base url with the "invalid" token.
    * MI The api user sets "api/deleteProductCategory/69" path parameters.
    * MI The api user sends a "DELETE" request and saves the returned response.
    #* MI The api user verifies that the status code is 401.
    #* MI The api user verifies that the "data.message" information in the response body is "Unauthenticated.".

  Scenario Outline :Verify that the Deleted Product Category Id in the response body returned from the
  /api/deleteProductCategory/{id} endpoint is the same as the id path parameter in the /api/deleteProductCategory/{id}
  endpoint.

    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/deletePricePlan/<id>" path parameters.
    * MI The api user sends a "DELETE" request and saves the returned response.
    * MI The api user verifies the <id> <Deleted Product Category Id>
    Examples:
      |id   | | Deleted Product Category Id |
      |109  | | 109                         |

  Scenario:The deletion of the product category record to be deleted from the API must be verified from the API.
  (It can be verified that the record has been deleted by sending a GET request to the /api/productCategory/{id}
  endpoint with the Deleted Product Category Id returned in the response body).

    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/productCategory/67" path parameters.
    * MI The api user sends a "GET" request and saves the returned response.
    * MI The api user verifies that the status code is 203.
    * MI The api user verifies that the "remark" information in the response body is "failed".
    * MI The api user verifies that the "data.message" information in the response body is "There is not ticket for this id.".

