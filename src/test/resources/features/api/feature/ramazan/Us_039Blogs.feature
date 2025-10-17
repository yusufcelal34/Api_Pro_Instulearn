Feature: As an administrator, I want to be able to update the information
  of the blog with the specified id number via the API connection.

  Scenario:Verify a PATCH body containing valid authorization information and the correct
  (id) and correct data (title, category_id, description, content) is
  sent to the api/updateBlog/{id} endpoint, it must be verified that the returned status code is 200,
  the remark informationin the response body is "success" and the message information is "Successfully Updated."

    * Rekare The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * Rekare The api user sets "api/updateBlog/58" path parameters.
    # Api kullanicisi "api/updateCategory/id" path parametrelerini olusturur
    * Rekare The api user prepares a PATCH request containing the "<title>" information to send to the api updateBlog endpoint.
    # Api kullanicisi api updateCategory endpointine gondermek icin bir patch request body hazirlar
    * Rekare The api user sends a "PATCH" request and saves the returned response.
    # Api kullanicisi PATCH request gonderir ve donen responsei kaydeder
    * Rekare The api user verifies that the status code is 200.
    # Api kullanicisi status codeun 200 oldugunu dogrular
    * Rekare The api user verifies that the "remark" information in the response body is "success".
    # Api kullanicisi response bodydeki remark bilgisinin "success" oldugunu dogrular
    * Rekare The api user verifies that the "Message" information in the response body is "Successfully Updated.".
    # Api kullanicisi response bodydeki Message bilgisinin "Successfully Updated." oldugunu dogrular
    * Rekare The api user verifies that the "Updated Blog Id" information in the response body is the same as the id path parameter in the endpoint.
    # Api kullanıcısı response body icindeki "Updated Category Id" bilgisinin endpointde yazan id path parametresi ile ayni oldugunu dogrular.
