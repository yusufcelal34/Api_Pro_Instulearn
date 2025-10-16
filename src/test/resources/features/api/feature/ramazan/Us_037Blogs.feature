Feature:As an administrator, I should be able to access the detailed information of the blog with the
  specified id number via the API connection.

  Scenario Outline: When a GET request is sent to the /api/blog/{id} endpoint with valid authorization information and the correct data (id),
  it should be verified that the status code returned is 200
  and the remark in the response body is “success”.

    * The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * The api user sets "api/blog/<id>" path parameters.
    # Api kullanicisi "api/category/<id>" path parametrelerini olusturur
    * The api user sends a GET request and saves the returned response.
    # Api kullanicisi GET request gonderir ve donen responsei kaydeder
    * The api user verifies that the status code is 200.
    # Api kullanicisi status codeun 203 oldugunu dogrular
    * The api user verifies that the "remark" information in the response body is "success".
    # Api kullanicisi response bodydeki remark bilgisinin "failed" oldugunu dogrular

Examples:
    |id|
    |58|

  Scenario Outline: The contents of the list data (id, category_id, author_id, slug, image, visit_count, enable_comment, status, created_at, updated_at,
  id, blog_id, locale, title) in the response body must be verified.
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
      | dataIndex | category_id | author_id | slug                                          | image           | visit_count | enable_comment | status       | created_at   | updated_at   | comments_count |
      | 0         | 34           | 1817         | The-Growing-Impact-of-Online-Education-21 | /store/1/blog-default.jpg| 1           | 0              | publish      | 1760287080   | 1760287080        | 0             |


    Scenario Outline: It should be verified that when a GET request containing an id without valid authorization
    information and a record is sent to the /api/blog/{id} endpoint, the returned status code is 203,
    the remark in the response body is "failed", and the message is "There is not blog for this id.";
    when a GET request without an id is sent, the returned status code is 203,
    the remark in the response body is "failed", and the message is "No id".

      * The api user constructs the base url with the "admin" token.
       # Api kullanicisi "admin" token ile base url'i olusturur

      * The api user sets "api/blog/<id>" path parameters.

      * The api user sends a GET request and saves the returned response

      * The api user36 verifies that the status code is 203

      * The api user36 verifies that the "remark" information in the response body is "failed"

      * The api user36 verifies that the "data.message" information in the response body is "There is not blog for this id."

    Examples:
      |id|
      |25416 |

Scenario: When a GET request is sent that does not include (id), it should be verified that
the returned status code is 203, the remark information in the response body is "failed"
and the message information is "No id".

  * The api user constructs the base url with the "admin" token.

  * The api user sets "api/blog" path parameters

  * The api user sends a GET request and saves the returned response.

  * The api user36 verifies that the status code is 203

  * The api user36 verifies that the "remark" information in the response body is "failed"

  * The api user36 verifies that the "data.message" information in the response body is "No id"

  ###BU ÇALIŞMIYOR BAKILACAK...

  Scenario Outline: When a GET request is sent to the /api/blog/{id} endpoint with invalid token authorization information and correct data (id), it should be verified that the status
  code returned is 401 and the message in the response body is “Unauthenticated.”.

    * The api user constructs the base url with the "invalid" token.
    # Api kullanicisi "invalid" token ile base urli olusturur
    * The api user sets "api/blog/<id>" path parameters.
    # Api kullanicisi "api/categories" path parametrelerini olusturur
    * The api user sends a GET request and saves the returned response.
    # Api kullanicisi GET request gonderir ve donen responsei kaydeder
    * The api user36 verifies that the status code is 401
    # Api kullanicisi status codeun 401 oldugunu dogrular
    * The api user36 verifies that the "message" information in the response body is "Unauthenticated."
    # Api kullanicisi response bodydeki message bilgisinin "Unauthenticated." oldugunu dogrular

     Examples:
    | id  |
    | 58  |



