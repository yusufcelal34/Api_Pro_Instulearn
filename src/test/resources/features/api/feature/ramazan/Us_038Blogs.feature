Feature: As an administrator, I want to be able to create a new blog post via API connection.

  Scenario:  POST body containing valid authorization information and correct data (title, category_id, description, content) is sent to the /api/addBlog endpoint, it must be verified that the returned status code is 200, the remark information in the response body is "success",
  and the message information is "Successfully Added."

    * Rekare The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * Rekare The api user sets "api/addBlog" path parameters.
    # Api kullanicisi "api/addBlog" path parametrelerini olusturur
    * Rekare The api user prepares a POST request to send to the API addBlog endpoint.
    # Api kullanicisi api addCategory endpointine gondermek icin bir post request body hazirlar
    * Rekare The api user sends a "POST" request and saves the returned response.
    # Api kullanicisi POST request gonderir ve donen responsei kaydeder
    * Rekare The api user verifies that the status code is 200.
    # Api kullanicisi status codeun 200 oldugunu dogrular
    * Rekare The api user verifies that the "remark" information in the response body is "success".
    # Api kullanicisi response bodydeki remark bilgisinin "success" oldugunu dogrular
    * Rekare The api user verifies that the "Message" information in the response body is "Successfully Added.".
    # Api kullanicisi response bodydeki Message bilgisinin "Successfully Added." oldugunu dogrular

  Scenario: When a POST request is sent to the /api/addBlog endpoint without valid authorization information and data, it should be verified that the status code returned is 422 and the message information in the response body is
  “The title field is required. (and 3 more errors)”

    * Rekare The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * Rekare The api user sets "api/addBlog" path parameters.
    # Api kullanicisi "api/addCategory" path parametrelerini olusturur
    * Rekare The api user prepares a POST request that contains no data.
    # Api kullanicisi api addCategory endpointine gondermek için data içermeyen bir post request hazirlar
    * Rekare The api user sends a "POST" request and saves the returned response.
    # Api kullanicisi POST request gonderir ve donen responsei kaydeder
    * Rekare The api user verifies that the status code is 422.
    # Api kullanicisi status codeun 422 oldugunu dogrular
    * Rekare The api user verifies that the "message" information in the response body is "The title field is required.".
    # Api kullanicisi response bodydeki message bilgisinin "The title field is required." oldugunu