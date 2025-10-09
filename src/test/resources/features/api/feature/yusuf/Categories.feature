Feature: List Course Categories via API
# Kapsam: /api/categories tüm liste, invalid token

  @API
  Scenario: GET /api/categories with valid auth returns 200 and remark "success"
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/categories" path parameters.
    # Api kullanıcısı "api/categories" path parametrelerini oluşturur.
    * The api user sends a GET request and saves the returned response.
    # Api kullanıcısı GET isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 200.
    # Api kullanıcısı status code'un 200 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "success".
    # Api kullanıcısı response body’deki remark bilgisinin "success" olduğunu doğrular.
    * The api user verifies the "slug", "icon", "order", "id", "category_id", "locale" and "title" information of the returned categories.
    # Api kullanıcısı dönen kategorilerin ilgili alanlarını doğrular.

  @API
  Scenario: GET /api/categories with invalid token returns 401 and "Unauthenticated."
    * The api user constructs the base url with the "invalid" token.
    # Api kullanıcısı "invalid" token ile base URL'i oluşturur.
    * The api user sets "api/categories" path parameters.
    # Api kullanıcısı "api/categories" path parametrelerini oluşturur.
    * The api user sends a GET request and saves the returned response.
    # Api kullanıcısı GET isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 401.
    # Api kullanıcısı status code'un 401 olduğunu doğrular.
    * The api user verifies that the "message" information in the response body is "Unauthenticated.".
    # Api kullanıcısı response body’deki message bilgisinin "Unauthenticated." olduğunu doğrular.
