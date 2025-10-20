
  Feature: US026 As an administrator, I want to be able to access product categories via API connection.

    Scenario: TC01 When a GET request is sent to /api/productCategories endpoint with valid authorization information,
    it should be verified that the status code returned is 200 and the remark in the response body is “success”.

      * MI The api user constructs the base url with the "admin" token.
      * MI The api user sets "api/productCategories" path parameters.
      * MI The api user sends a "GET" request and saves the returned response.
      * MI The api user verifies that the status code is 200.
      * MI The api user verifies that the "remark" information in the response body is "success".

    Scenario: TC02 The information (parent_id, icon, order, title, id, product_category_id, locale, title)
    in the response body of id(x) should be validated.

      * MI The api user constructs the base url with the "admin" token.
      * MI The api user sets "api/productCategories/" path parameters.
      * MI The api user sends a "GET" request and saves the returned response.
      * MI The fields and values in the response body are verified:
        | data.categories[0].parent_id                           | null                                                |
        | data.categories[0].icon                                | /store/1/default_images/categories_icons/code.png   |
        | data.categories[0].order                               | null                                                |
        | data.categories[0].title                               | null                                                |
        | data.categories[0].id                                  | 104                                                 |
        | data.categories[0].translations[0].product_category_id | 104                                                 |
        | data.categories[0].translations[0].locale              | en                                                  |
        | data.categories[0].translations[0].title               | Educational Equipment                               |



    Scenario: TC03 When a GET request is sent to the /api/productCategories endpoint with invalid token
    authorization information, it should be verified that the status code returned is 401 and the message
    information in the response body is “Unauthenticated.”.

      * MI The api user constructs the base url with the "admin" token.
      * MI The api user sets "api/productCategories" path parameters.
      * MI The api user sends a "GET" request and saves the returned response.
      * MI The api user verifies that the status code is 401.
      * MI The api user verifies that the "message" information in the response body is "Unauthenticated.".