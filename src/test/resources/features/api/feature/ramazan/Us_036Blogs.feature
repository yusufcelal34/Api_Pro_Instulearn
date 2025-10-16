
Feature: As an administrator I want to be able to access blogs via API connection.

  @otuzAltiBir
  Scenario:  When a GET request is sent to the /api/blogs endpoint with valid authorization information, it should be verified that
      the status code returned is 200 and the remark in the response body is “success”.

    * The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * The api user sets "api/blogs" path parameters.
    # Api kullanicisi "api/blogs" path parametrelerini olusturuR
    * The api user sends a GET request and saves the returned response.
    # Api kullanicisi GET request gonderir ve donen responsei kaydeder
    * The api user verifies that the status code is 200.
    # Api kullanicisi status codeun 200 oldugunu dogrular
    * The api user verifies that the "remark" information in the response body is "success".


  @otuzAltiIki
  Scenario Outline: The information returned in the response body for id(x) must be verified
  # When a GET request containing valid authorization information is sent to the /api/blogs endpoint,
  # the information returned in the response body must be validated for a specific item (by dataIndex).

    * The api user constructs the base url with the "admin" token
  # Api kullanicisi "admin" token ile base url'i olusturur

    * The api user sets "api/blogs" path parameters
  # Api kullanicisi "api/blogs" path parametrelerini olusturur

    * The api user sends a GET request and saves the returned response
  # Api kullanicisi GET request gonderir ve donen response'i kaydeder

    * The api user36 verifies that the status code is 200
  # Api kullanicisi status code'un 200 oldugunu dogrular

    * The api user36 verifies that the "remark" information in the response body is "success"
  # Api kullanicisi response body'deki "remark" bilgisinin "success" oldugunu dogrular

    * The api user verifies that <category_id>, <author_id>, "<slug>", "<image>", <visit_count>, <enable_comment>, "<status>", "<created_at>", "<updated_at>", <comments_count> information of the item at <dataIndex> in the response body
  # Api kullanicisi response body'deki belirtilen alanlari dogrular

    Examples:
      | dataIndex | category_id | author_id | slug        | image        | visit_count | enable_comment | status | created_at   | updated_at   | comments_count |
      | 0         | 5           | 2         | tech-news   | img1.jpg     | 150         | 5              | publish      | 1760257872   | 1760257872   | 12             |

    Scenario: When a GET request is sent to the /api/blogs endpoint with invalid token authorization information,
    it should be verified that the status code returned is 401 and the message
    information in the response body is “Unauthenticated.”

      * The api user constructs the base url with the "invalid" token.
    # Api kullanicisi "invalid" token ile base urli olusturur
      * The api user sets "api/blogs" path parameters.
    # Api kullanicisi "api/categories" path parametrelerini olusturur
      * The api user sends a GET request and saves the returned response.
    # Api kullanicisi GET request gonderir ve donen responsei kaydeder
      * The api user verifies that the status code is 401.
    # Api kullanicisi status codeun 401 oldugunu dogrular
      * The api user verifies that the "message" information in the response body is "Unauthenticated.".
    # Api kullanicisi response bodydeki message bilgisinin "Unauthenticated." oldugunu dogrular



