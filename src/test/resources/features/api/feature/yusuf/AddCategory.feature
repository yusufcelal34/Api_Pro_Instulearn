Feature: Add Course Category via API
# Kapsam: Kategori ekleme (başarılı, body yok, invalid token)

  @API
  Scenario Outline: POST /api/addCategory with valid auth and title returns 200 and "Successfully Added."
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/addCategory" path parameters.
    # Api kullanıcısı "api/addCategory" path parametrelerini oluşturur.
    * The api user prepares a POST request body containing "<title>".
    # Api kullanıcısı "<title>" bilgisi içeren bir POST body hazırlar.
    * The api user sends a "POST" request and saves the returned response.
    # Api kullanıcısı POST isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 200.
    # Api kullanıcısı status code'un 200 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "success".
    # Api kullanıcısı response body’deki remark bilgisinin "success" olduğunu doğrular.
    * The api user verifies that the "Message" information in the response body is "Successfully Added.".
    # Api kullanıcısı response body’deki Message bilgisinin "Successfully Added." olduğunu doğrular.

    Examples:
      | title                  |
      | Education and Training |

  @API
  Scenario: POST /api/addCategory without body returns 422 and "The title field is required."
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/addCategory" path parameters.
    # Api kullanıcısı "api/addCategory" path parametrelerini oluşturur.
    * The api user prepares a POST request without data.
    # Api kullanıcısı data içermeyen bir POST body hazırlar.
    * The api user sends a "POST" request and saves the returned response.
    # Api kullanıcısı POST isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 422.
    # Api kullanıcısı status code'un 422 olduğunu doğrular.
    * The api user verifies that the "message" information in the response body is "The title field is required.".
    # Api kullanıcısı response body’deki message bilgisinin "The title field is required." olduğunu doğrular.

  @API
  Scenario: POST /api/addCategory with invalid token returns 401 and "Unauthenticated."
    * The api user constructs the base url with the "invalid" token.
    # Api kullanıcısı "invalid" token ile base URL'i oluşturur.
    * The api user sets "api/addCategory" path parameters.
    # Api kullanıcısı "api/addCategory" path parametrelerini oluşturur.
    * The api user prepares a POST request body containing "TestCategory".
    # Api kullanıcısı "TestCategory" içeren bir POST body hazırlar.
    * The api user sends a "POST" request and saves the returned response.
    # Api kullanıcısı POST isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 401.
    # Api kullanıcısı status code'un 401 olduğunu doğrular.
    * The api user verifies that the "message" information in the response body is "Unauthenticated.".
    # Api kullanıcısı response body’deki message bilgisinin "Unauthenticated." olduğunu doğrular.
