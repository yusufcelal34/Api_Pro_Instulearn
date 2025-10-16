
Feature: As an administrator, I want to access course categories via an API connection.
  Background:

  Scenario: AC_01 When a GET request is sent to the /api/categories endpoint with valid authorization,
  the response status code should be 200, the remark should be “success”.

    * C  The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * C The api user sets "api/categories" path parameters.
    # Api kullanicisi "api/categories" path parametrelerini olusturur
    * C The api user sends a GET request and saves the returned response.
    # Api kullanicisi GET request gonderir ve donen responsei kaydeder
    * C The api user verifies that the status code is 200.
    # Api kullanicisi status codeun 200 oldugunu dogrular
    * C The api user verifies that the "remark" information in the response body is "success".


  Scenario: AC_02 The  information of id(x) (slug, parent_id, icon, order, title, category_id, locale) should be validated.
    * C  The api user constructs the base url with the "admin" token.
    # Api kullanicisi "admin" token ile base urli olusturur
    * C The api user sets "api/category/1005" path parameters.
    # Api kullanicisi "api/categories" path parametrelerini olusturur
    * C The api user sends a GET request and saves the returned response.
    # Api kullanicisi GET request gonderir ve donen responsei kaydeder
    * C The fields and values in the response body are verified:
  | data.parent_id                   | null                                              |
  | data.icon                        | /store/1/default_images/categories_icons/code.png |
  | data.order                       | 68                                                |
  | data.translations[0].id          | 448                                               |
  | data.translations[0].category_id | 1005                                              |
  | data.translations[0].locale      | en                                                |
  | data.translations[0].title       | Health And Fitness4                               |


    Scenario: AC_03 When a GET request is sent to the /api/categories endpoint with invalid authorization (invalid token),
    the returned status code should be 401, and the message field in the response body should be "Unauthenticated.".

      * CCC  The api user constructs the base url with the "invalid" token.
    # Api kullanicisi "admin" token ile base urli olusturur
      * C The api user sets "api/categories" path parameters.
    # Api kullanicisi "api/categories" path parametrelerini olusturur
      * C The api user sends a GET request and saves the returned response.
    # Api kullanicisi GET request gonderir ve donen responsei kaydeder
      * CC The api user verifies that the status code is 401.
    # Api kullanicisi status codeun 401 oldugunu dogrular
      * CC The api user verifies that the "message" information in the response body is "Unauthenticated.".
    # Api kullanicisi response bodydeki message bilgisinin "Unauthenticated." oldugunu dogrular
