Feature: Get Course Category by ID via API
# Kapsam: /api/category/{id} başarılı, olmayan id, id yok, invalid token

  @API
  Scenario Outline: GET /api/category/<id> with valid auth returns 200 and remark "success"
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/category/<id>" path parameters.
    # Api kullanıcısı "api/category/<id>" path parametrelerini oluşturur.
    * The api user sends a GET request and saves the returned response.
    # Api kullanıcısı GET isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 200.
    # Api kullanıcısı status code'un 200 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "success".
    # Api kullanıcısı response body’deki remark bilgisinin "success" olduğunu doğrular.
    * The api user verifies that the response body contains <id>, "<slug>", "<icon>", <order>, <category_id>, "<locale>" and "<title>".
    # Api kullanıcısı response body’deki alanları doğrular.

    Examples:
      | id  | slug    | icon                                                                | order | category_id | locale | title    |
      | 614 | Testing | /store/1/default_images/categories_icons/sub_categories/zap.png     | 45    | 614         | en     | Testing  |

  @API
  Scenario Outline: GET /api/category/<id> with non-existent id returns 203 and "There is not category for this id."
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/category/<id>" path parameters.
    # Api kullanıcısı "api/category/<id>" path parametrelerini oluşturur.
    * The api user sends a GET request and saves the returned response.
    # Api kullanıcısı GET isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı response body’deki remark bilgisinin "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "There is not category for this id.".
    # Api kullanıcısı response body’deki data.message bilgisinin doğru olduğunu doğrular.

    Examples:
      | id    |
      | 25416 |

  @API
  Scenario: GET /api/category endpoint without id returns 203 and "No id"
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/category" path parameters.
    # Api kullanıcısı "api/category" path parametrelerini oluşturur.
    * The api user sends a GET request and saves the returned response.
    # Api kullanıcısı GET isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı response body’deki remark bilgisinin "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "No id".
    # Api kullanıcısı response body’deki data.message bilgisinin "No id" olduğunu doğrular.

  @API
  Scenario Outline: GET /api/category/<id> with invalid token returns 401 and "Unauthenticated."
    * The api user constructs the base url with the "invalid" token.
    # Api kullanıcısı "invalid" token ile base URL'i oluşturur.
    * The api user sets "api/category/<id>" path parameters.
    # Api kullanıcısı "api/category/<id>" path parametrelerini oluşturur.
    * The api user sends a GET request and saves the returned response.
    # Api kullanıcısı GET isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 401.
    # Api kullanıcısı status code'un 401 olduğunu doğrular.
    * The api user verifies that the "message" information in the response body is "Unauthenticated.".
    # Api kullanıcısı response body’deki message bilgisinin "Unauthenticated." olduğunu doğrular.

    Examples:
      | id |
      | 883 |
