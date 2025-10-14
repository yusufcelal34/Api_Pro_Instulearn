Feature: As an administrator, I want to access course categories via an API connection.
  @cenn
  Scenario: When a GET request is sent to the /api/categories endpoint with valid authorization,
  the response status code should be 200, the remark should be “success”, and the information of id(x)
  (slug, parent_id, icon, order, title, category_id, locale) should be validated.

    * C  The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * C The api user sets "api/categories" path parameters.
    # Api kullanicisi "api/categories" path parametrelerini olusturur
    * C The api user sends a GET request and saves the returned response.
    # Api kullanicisi GET request gonderir ve donen responsei kaydeder
    * C The api user verifies that the status code is 200.
    # Api kullanicisi status codeun 200 oldugunu dogrular
    * C The api user verifies that the "remark" information in the response body is "success".


  Scenario Outline: The information of id(x) (slug, parent_id, icon, order, title, category_id, locale) should be validated.
    * The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * The api user sets "api/categories" path parameters.
    # Api kullanicisi "api/categories" path parametrelerini olusturur
    * The api user sends a GET request and saves the returned response.
    # Api kullanicisi GET request gonderir ve donen responsei kaydeder
    * The api user verifies the "<slug>", "<icon>", <order>, <id>, <category_id>, "<locale>" and "<title>" information of the item at <dataIndex> in the response body.
    #Api kullanıcısı response body icindeki <dataIndex> indexe sahip olanin "<slug>", "<icon>", <order>, <id>, <category_id>, "<locale>" ve "<title>" bilgilerini doğrular.

    Examples:
      | dataIndex | slug    | icon                                                            | order | id | category_id | locale | title
      |           | Testing | /store/1/default_images/categories_icons/sub_categories/zap.png | 45    | 57 | 614         | en     | Testing