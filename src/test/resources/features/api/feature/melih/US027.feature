Feature: As an administrator, I should be able to access the detailed information of the product
  category with the specified id number via the API connection.

  Scenario: TC01 When a GET request with valid authorization information and correct data (id)
  is sent to the /api/productCategory/{id} endpoint,
  it should be verified that the status code returned is 200 and the remark in the response body is “success”.

    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/productCategory/66" path parameters.
    * MI The api user sends a "GET" request and saves the returned response.
    * MI The api user verifies that the status code is 200.
    * MI The api user verifies that the "remark" information in the response body is "success".

  Scenario: TC02 The contents of the list data (id, parent_id, icon, order, title, id, product_category_id, locale, title)
  in the response body must be validated.

    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/productCategory/66" path parameters.
    * MI The api user sends a "GET" request and saves the returned response.
    * MI The fields and values in the response body are verified:
      | data.id                                  | 66                                                |
      | data.parent_id                           | null                                              |
      | data.icon                                | /store/1/default_images/categories_icons/code.png |
      | data.order                               | null                                              |
      | data.title                               | null                                              |
      | data.translations[0].id                  | 72                                                |
      | data.translations[0].product_category_id | 66                                                |
      | data.translations[0].locale              | en                                                |
      | data.translations[0].title               | Educational Equipment                             |

  Scenario: TC03 It should be verified that when a GET request is sent to the /api/productCategory/{id} endpoint with
  valid authorization information and an unregistered (id), the status code returned is 203, the remark in the response
  body is “failed” and the message is “There is not product category for this id.”,
  and when a GET request is sent without (id), the status code returned is 203, the remark in the
  response body is ‘failed’and the message is “No id”.

    * MI The api user constructs the base url with the "admin" token.
    * MI The api user sets "api/productCategory/999999" path parameters.
    * MI The api user sends a "GET" request and saves the returned response.
    * MI The api user verifies that the status code is 203.
    * MI The api user verifies that the "remark" information in the response body is "failed".
    * MI The api user verifies that the "data.message" information in the response body is "No id".