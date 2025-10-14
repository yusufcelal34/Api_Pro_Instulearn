Feature: As an administrator, I want to update the information of the course category with the specified ID via an API connection.

  Scenario: Verify that a PATCH request to /api/updateCategory/{id} with valid authorization and correct data
  (title) returns status 200, remark “success”, message “Successfully Updated.”, and the Updated Category Id in the
  response matches the {id} path parameter.

    * The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * The api user sets "api/updateCategory/886" path parameters.
    # Api kullanicisi "api/updateCategory/id" path parametrelerini olusturur
    * The api user prepares a PATCH request containing the "<title>" information to send to the api updateCategory endpoint.
    # Api kullanicisi api updateCategory endpointine gondermek icin bir patch request body hazirlar
    * The api user sends a "PATCH" request and saves the returned response.
    # Api kullanicisi PATCH request gonderir ve donen responsei kaydeder
    * The api user verifies that the status code is 200.
    # Api kullanicisi status codeun 200 oldugunu dogrular
    * The api user verifies that the "remark" information in the response body is "success".
    # Api kullanicisi response bodydeki remark bilgisinin "success" oldugunu dogrular
    * The api user verifies that the "Message" information in the response body is "Successfully Updated.".
    # Api kullanicisi response bodydeki Message bilgisinin "Successfully Updated." oldugunu dogrular
    * The api user verifies that the "Updated Category Id" information in the response body is the same as the id path parameter in the endpoint.
    # Api kullanıcısı response body icindeki "Updated Category Id" bilgisinin endpointde yazan id path parametresi ile ayni oldugunu dogrular.


  Scenario: When a PATCH body containing an unregistered (id) with valid authorization information and the correct
  data (title) is sent to the /api/updateCategory/{id} endpoint, it should be verified that the returned status code is 203,
  the remark information in the response body is "failed" and the message information is "There is not category for this id."

    * The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * The api user sets "api/updateCategory/12547" path parameters.
    # Api kullanicisi "api/updateCategory/id" path parametrelerini olusturur
    * The api user prepares a POST request to send to the API addCategory endpoint.
    # Api kullanicisi api updateCategory endpointine gondermek icin bir patch request body hazirlar
    * The api user sends a "PATCH" request and saves the returned response.
    # Api kullanicisi PATCH request gonderir ve donen responsei kaydeder
    * The api user verifies that the status code is 203.
    # Api kullanicisi status codeun 203 oldugunu dogrular
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanicisi response bodydeki remark bilgisinin "failed" oldugunu dogrular
    * The api user verifies that the "data.message" information in the response body is "There is not category for this id.".
    # Api kullanicisi response bodydeki message bilgisinin "There is not category for this id." oldugunu dogrular


  Scenario: When a PATCH body that does not contain valid authorization information (id) but contains correct data
  (title) is sent to the /api/updateCategory/{id} endpoint, it should be verified that the returned status code is 203, the
  remark information in the response body is "failed" and the message information is "No id".

    * The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * The api user sets "api/updateCategory" path parameters.
    # Api kullanicisi "api/updateCategory/id" path parametrelerini olusturur
    * The api user prepares a patch request body to send to the api updateCategory endpoint.
    # Api kullanicisi api updateCategory endpointine gondermek icin bir patch request body hazirlar
    * The api user sends a PATCH request and saves the returned response.
    # Api kullanicisi PATCH request gonderir ve donen responsei kaydeder
    * The api user verifies that the status code is 203.
    # Api kullanicisi status codeun 203 oldugunu dogrular
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanicisi response bodydeki remark bilgisinin "failed" oldugunu dogrular
    * The api user verifies that the "data.message" information in the response body is "No id".
    # Api kullanicisi response bodydeki message bilgisinin "No id" oldugunu dogrular


  Scenario: Verify that a PATCH request to /api/updateCategory/{id} with invalid token, correct id, and valid title
  returns status 401 and message “Unauthenticated.”

    * The api user constructs the base url with the "invalid" token.
    # Api kullanicisi "invalid" token ile base urli olusturur
    * The api user sets "api/updateCategory/886" path parameters.
    # Api kullanicisi "api/updateCategory/id" path parametrelerini olusturur
    * The api user prepares a patch request body to send to the api updateCategory endpoint.
    # Api kullanicisi api updateCategory endpointine gondermek icin bir patch request body hazirlar
    * The api user sends a PATCH request and saves the returned response.
    # Api kullanicisi PATCH request gonderir ve donen responsei kaydeder
    * The api user verifies that the status code is 401.
    # Api kullanicisi status codeun 401 oldugunu dogrular
    * The api user verifies that the "message" information in the response body is "Unauthenticated.".
    # Api kullanicisi response bodydeki message bilgisinin "Unauthenticated." oldugunu dogrular

    * The api user sends a PATCH request, saves the returned response, and verifies that the status code is '401' with the reason phrase Unauthorized.
    # Api kullanicisi PATCH request gonderir, donen responsei kaydeder, status codeun '401' ve reason phrase bilgisinin Unauthorized oldugunu dogrular


  Scenario Outline: Verify that the updated course category via API is correctly updated by sending a GET request to
  /api/category/{id} using the Updated Category ID from the response.

    * The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * The api user sets "api/category/<id>" path parameters.
    # Api kullanicisi "api/category/<id>" path parametrelerini olusturur
    * The api user sends a GET request and saves the returned response.
    # Api kullanicisi GET request gonderir ve donen responsei kaydeder
    * The api user verifies that the title information is "Education and Training"
    # Api kullanıcısı title bilgisinin "Education and Training" olduğunu doğrular

    Examples:
      | id  |
      | 886 |
