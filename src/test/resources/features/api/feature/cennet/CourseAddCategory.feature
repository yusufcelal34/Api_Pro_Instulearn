Feature: As an administrator, I want to create a new course category record via an API connection.

  Scenario: Verify that a POST request to /api/addCategory with valid authorization and title returns status 200, remark
  “success”, and message “Successfully Added.”

    * The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * The api user sets "api/addCategory" path parameters.
    # Api kullanicisi "api/addCategory" path parametrelerini olusturur
    * The api user prepares a POST request to send to the API addCategory endpoint.
    # Api kullanicisi api addCategory endpointine gondermek icin bir post request body hazirlar
    * The api user sends a "POST" request and saves the returned response.
    # Api kullanicisi POST request gonderir ve donen responsei kaydeder
    * The api user verifies that the status code is 200.
    # Api kullanicisi status codeun 200 oldugunu dogrular
    * The api user verifies that the "remark" information in the response body is "success".
    # Api kullanicisi response bodydeki remark bilgisinin "success" oldugunu dogrular
    * The api user verifies that the "Message" information in the response body is "Successfully Added.".
    # Api kullanicisi response bodydeki Message bilgisinin "Successfully Added." oldugunu dogrular


  Scenario: Verify that a POST request to /api/addCategory with valid authorization but no data returns status 422 and
  message “The title field is required.”

    * The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * The api user sets "api/addCategory" path parameters.
    # Api kullanicisi "api/addCategory" path parametrelerini olusturur
    * The api user prepares a POST request that contains no data.
    # Api kullanicisi api addCategory endpointine gondermek için data içermeyen bir post request hazirlar
    * The api user sends a "POST" request and saves the returned response.
    # Api kullanicisi POST request gonderir ve donen responsei kaydeder
    * The api user verifies that the status code is 422.
    # Api kullanicisi status codeun 422 oldugunu dogrular
    * The api user verifies that the "message" information in the response body is "The title field is required.".
    # Api kullanicisi response bodydeki message bilgisinin "The title field is required." oldugunu dogrular


  Scenario: Verify that a POST request to /api/addCategory with invalid token and valid title returns status 401 and message
  “Unauthenticated.”

    * The api user constructs the base url with the "invalid" token.
    # Api kullanicisi "invalid" token ile base urli olusturur
    * The api user sets "api/addCategory" path parameters.
    # Api kullanicisi "api/addCategory" path parametrelerini olusturur
    * The api user prepares a POST request to send to the API addCategory endpoint.
    # Api kullanicisi api addCategory endpointine gondermek icin bir post request body hazirlar
    * The api user sends a "POST" request and saves the returned response.
    # Api kullanicisi POST request gonderir ve donen responsei kaydeder
    * The api user verifies that the status code is 401.
    # Api kullanicisi status codeun 401 oldugunu dogrular
    * The api user verifies that the "message" information in the response body is "Unauthenticated.".
    # Api kullanicisi response bodydeki message bilgisinin "Unauthenticated." oldugunu dogrular


  Scenario Outline: Verify that the newly created course category via API exists by sending a GET request to
  /api/category/{id} using the Added Category ID from the response.

    * The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * The api user sets "api/category/<id>" path parameters.
    # Api kullanicisi "api/category/<id>" path parametrelerini olusturur
    * The api user sends a GET request and saves the returned response.
    # Api kullanicisi GET request gonderir ve donen responsei kaydeder
    * The api user verifies that the status code is 200.
    # Api kullanicisi status codeun 200 oldugunu dogrular
    * The api user verifies that the "remark" information in the response body is "success".
    # Api kullanicisi response bodydeki remark bilgisinin "success" oldugunu dogrular

    Examples:
      | id  |
      | 941 |

