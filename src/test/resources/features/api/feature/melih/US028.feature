Feature:US028 As an administrator, I want to be able to create a new product category record via API connection.

  Scenario:When a POST body with valid authorization information and correct data (title) is sent to
  /api/addProductCategory endpoint, it should be verified that the status code returned is 200,
  the remark in the response body is “success” and the Message is “Successfully Added.”.

    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/addProductCategory" path parameters.
    * MI The api user prepares a POST request to send to the api addProductCategory "Educational Equipment"
    * MI The api user sends a "POST" request and saves the returned response.
    * MI The api user verifies that the status code is 200.
    * MI The api user verifies that the "remark" information in the response body is "success".
    * MI The api user verifies that the "Message" information in the response body is "Successfully Added.".

  Scenario:When a POST request is sent to /api/addProductCategory endpoint without valid authorization
  information and data, it should be verified that the status code returned is 422 and the message information
  in the response body is “The title field is required.”

    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/addProductCategory" path parameters.
    * The api user prepares a POST request that contains no data.
    * MI The api user sends a "POST" request and saves the returned response.
    * MI The api user verifies that the status code is 422.
    * MI The api user verifies that the "message" information in the response body is "The title field is required.".

  Scenario:When a POST body with invalid token authorization information and correct data (title) is
  sent to /api/addProductCategory endpoint, it should be verified that the status code returned is 401
  and the message information in the response body is “Unauthenticated.”

    * MI The api user constructs the base url with the "invalid" token.
    * MI The api user sets "api/addProductCategory" path parameters.
    * MI The api user prepares a POST request to send to the api addProductCategory "Educational Equipment"
    * E The api user sends a "POST" request and saves the returned response.
    #* MI The api user verifies that the status code is 401.
    #* MI The api user verifies that the "message" information in the response body is "Unauthenticated.".

  Scenario:The creation of the new product category record to be created via API should be verified via API.
  (It can be verified that the record was created by sending a GET request to the
  /api/productCategory/{id} endpoint with the Added Category ID returned in the response body).

    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/addProductCategory" path parameters.
    * MI The api user sends a "GET" request and saves the returned response.
    * MI The api user verifies that the status code is 200.
    * MI The api user verifies that the "remark" information in the response body is "success".