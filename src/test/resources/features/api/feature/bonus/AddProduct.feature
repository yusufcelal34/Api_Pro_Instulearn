Feature: As an administrator, I want to manage course categories via API connection.
# Kapsam: Kategorileri listeleme, ID ile görüntüleme, ekleme, güncelleme ve silme işlemleri.
# Bu dosyada her adımın altında Türkçe açıklama (yorum) bulunmaktadır.

  @API
  # ============================================================
  # GET ALL CATEGORIES
  # ============================================================
  Scenario: Verify that a GET request to /api/categories with valid authorization returns 200 and remark “success”.
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
    # Api kullanıcısı dönen kategorilerin "slug", "icon", "order", "id", "category_id", "locale" ve "title" alanlarını doğrular.

  Scenario: Verify that a GET request to /api/categories with invalid token returns 401 and message “Unauthenticated.”.
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

  # ============================================================
  # GET CATEGORY BY ID
  # ============================================================
  Scenario Outline: Verify that a GET request to /api/category/{id} with valid authorization and correct id returns 200 and remark “success”.
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
    # Api kullanıcısı response body’deki <id>, "<slug>", "<icon>", <order>, <category_id>, "<locale>" ve "<title>" değerlerini doğrular.

    Examples:
      | id  | slug     | icon                                                                 | order | category_id | locale | title    |
      | 614 | Testing  | /store/1/default_images/categories_icons/sub_categories/zap.png      | 45    | 614         | en     | Testing  |

  Scenario Outline: Verify that a GET request to /api/category/{id} with non-existent id returns 203 and message “There is not category for this id.”.
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
    # Api kullanıcısı response body’deki data.message bilgisinin "There is not category for this id." olduğunu doğrular.

    Examples:
      | id    |
      | 25416 |

  Scenario: Verify that a GET request to /api/category endpoint without id returns 203 and message “No id”.
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

  Scenario Outline: Verify that a GET request to /api/category/{id} with invalid token returns 401 and message “Unauthenticated.”.
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

  # ============================================================
  # ADD CATEGORY
  # ============================================================
  Scenario Outline: Verify that a POST request to /api/addCategory with valid authorization and title returns 200 and message “Successfully Added.”.
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

  Scenario: Verify that a POST request to /api/addCategory without body returns 422 and message “The title field is required.”.
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

  Scenario: Verify that a POST request to /api/addCategory with invalid token returns 401 and message “Unauthenticated.”.
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

  # ============================================================
  # UPDATE CATEGORY
  # ============================================================
  Scenario Outline: Verify that a PATCH request to /api/updateCategory/{id} with valid authorization and correct data returns 200 and message “Successfully Updated.”.
    * The api user sends a POST request to "api/addCategory" endpoint to create a new category and records the Added Category ID.
    # Api kullanıcısı yeni bir kategori oluşturmak için "api/addCategory" endpoint'ine POST isteği gönderir ve Added Category ID bilgisini kaydeder.
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/updateCategory" path parameters.
    # Api kullanıcısı "api/updateCategory" path parametrelerini oluşturur.
    * The api user prepares a PATCH request containing "<title>".
    # Api kullanıcısı "<title>" bilgisi içeren bir PATCH body hazırlar.
    * The api user sends a "PATCH" request and saves the returned response.
    # Api kullanıcısı PATCH isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 200.
    # Api kullanıcısı status code'un 200 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "success".
    # Api kullanıcısı response body’deki remark bilgisinin "success" olduğunu doğrular.
    * The api user verifies that the "Message" information in the response body is "Successfully Updated.".
    # Api kullanıcısı response body’deki Message bilgisinin "Successfully Updated." olduğunu doğrular.
    * The api user verifies that the "Updated Category Id" matches the id path parameter.
    # Api kullanıcısı "Updated Category Id" bilgisinin endpoint'teki id path parametresi ile aynı olduğunu doğrular.
    * The api user verifies via GET "api/category" that "data.translations[0].title" equals "<title>".
    # Api kullanıcısı "api/category" endpoint'ine GET isteği göndererek "data.translations[0].title" alanının "<title>" olduğunu doğrular.

    Examples:
      | title                  |
      | Education and Training |

  Scenario: Verify that a PATCH request to /api/updateCategory/{id} without body returns 203 and message “There is no information to update.”.
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/updateCategory" path parameters.
    # Api kullanıcısı "api/updateCategory" path parametrelerini oluşturur.
    * The api user prepares a PATCH request without data.
    # Api kullanıcısı data içermeyen bir PATCH body hazırlar.
    * The api user sends a "PATCH" request and saves the returned response.
    # Api kullanıcısı PATCH isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı response body’deki remark bilgisinin "failed" olduğunu doğrular.
    * The api user verifies that the "message" information in the response body is "There is no information to update.".
    # Api kullanıcısı response body’deki message bilgisinin "There is no information to update." olduğunu doğrular.

  Scenario Outline: Verify that a PATCH request to /api/updateCategory/{id} with non-existent id returns 203 and message “There is not category for this id.”.
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/updateCategory/<id>" path parameters.
    # Api kullanıcısı "api/updateCategory/<id>" path parametrelerini oluşturur.
    * The api user prepares a PATCH request containing "<title>".
    # Api kullanıcısı "<title>" bilgisi içeren bir PATCH body hazırlar.
    * The api user sends a "PATCH" request and saves the returned response.
    # Api kullanıcısı PATCH isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı response body’deki remark bilgisinin "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "There is not category for this id.".
    # Api kullanıcısı response body’deki data.message bilgisinin "There is not category for this id." olduğunu doğrular.

    Examples:
      | id    | title                  |
      | 25416 | Education and Training |

  Scenario Outline: Verify that a PATCH request to /api/updateCategory with no id returns 203 and message “No id”.
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/updateCategory" path parameters.
    # Api kullanıcısı "api/updateCategory" path parametrelerini oluşturur.
    * The api user prepares a PATCH request containing "<title>".
    # Api kullanıcısı "<title>" bilgisi içeren bir PATCH body hazırlar.
    * The api user sends a "PATCH" request and saves the returned response.
    # Api kullanıcısı PATCH isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı response body’deki remark bilgisinin "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "No id".
    # Api kullanıcısı response body’deki data.message bilgisinin "No id" olduğunu doğrular.

    Examples:
      | title                  |
      | Education and Training |

  Scenario Outline: Verify that a PATCH request to /api/updateCategory/{id} with instructor token returns 203 and message “To access this data, you must log in as a admin.”.
    * The api user sends a POST request to "api/addCategory" endpoint to create a new category and records the Added Category ID.
    # Api kullanıcısı yeni bir kategori oluşturmak için "api/addCategory" endpoint'ine POST isteği gönderir ve Added Category ID bilgisini kaydeder.
    * The api user constructs the base url with the "instructor" token.
    # Api kullanıcısı "instructor" token ile base URL'i oluşturur.
    * The api user sets "api/updateCategory" path parameters.
    # Api kullanıcısı "api/updateCategory" path parametrelerini oluşturur.
    * The api user prepares a PATCH request containing "<title>".
    # Api kullanıcısı "<title>" bilgisi içeren bir PATCH body hazırlar.
    * The api user sends a "PATCH" request and saves the returned response.
    # Api kullanıcısı PATCH isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı response body’deki remark bilgisinin "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "To access this data, you must log in as a admin.".
    # Api kullanıcısı response body’deki data.message bilgisinin "To access this data, you must log in as a admin." olduğunu doğrular.

    Examples:
      | title                  |
      | Education and Training |

  Scenario Outline: Verify that a PATCH request to /api/updateCategory/{id} with invalid token returns 401 and message “Unauthenticated.”.
    * The api user sends a POST request to "api/addCategory" endpoint to create a new category and records the Added Category ID.
    # Api kullanıcısı yeni bir kategori oluşturmak için "api/addCategory" endpoint'ine POST isteği gönderir ve Added Category ID bilgisini kaydeder.
    * The api user constructs the base url with the "invalid" token.
    # Api kullanıcısı "invalid" token ile base URL'i oluşturur.
    * The api user sets "api/updateCategory" path parameters.
    # Api kullanıcısı "api/updateCategory" path parametrelerini oluşturur.
    * The api user prepares a PATCH request containing "<title>".
    # Api kullanıcısı "<title>" bilgisi içeren bir PATCH body hazırlar.
    * The api user sends a "PATCH" request, saves the returned response, and verifies that the status code is '401' with the reason phrase Unauthorized.
    # Api kullanıcısı PATCH isteğini gönderir, dönen response'u kaydeder ve status code'un '401' ve reason phrase'in Unauthorized olduğunu doğrular.

    Examples:
      | title                  |
      | Education and Training |

  # ============================================================
  # DELETE CATEGORY
  # ============================================================
  Scenario: Verify that a DELETE request to /api/deleteCategory/{id} with valid authorization deletes category successfully.
    * The api user sends a POST request to "api/addCategory" endpoint to create a new category and records the Added Category ID.
    # Api kullanıcısı yeni bir kategori oluşturmak için "api/addCategory" endpoint'ine POST isteği gönderir ve Added Category ID bilgisini kaydeder.
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/deleteCategory" path parameters.
    # Api kullanıcısı "api/deleteCategory" path parametrelerini oluşturur.
    * The api user sends a "DELETE" request and saves the returned response.
    # Api kullanıcısı DELETE isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 200.
    # Api kullanıcısı status code'un 200 olduğunu doğrular.
    * The api user verifies that the "data.status" information in the response body is "success".
    # Api kullanıcısı response body’deki "data.status" bilgisinin "success" olduğunu doğrular.
    * The api user verifies that the "Message" information in the response body is "Successfully Deleted.".
    # Api kullanıcısı response body’deki Message bilgisinin "Successfully Deleted." olduğunu doğrular.
    * The api user verifies that the "Deleted Category Id" matches the id path parameter.
    # Api kullanıcısı "Deleted Category Id" bilgisinin endpoint'teki id path parametresi ile aynı olduğunu doğrular.
    * The api user verifies via GET "api/category" that the deleted id returns message “There is not category for this id.”.
    # Api kullanıcısı "api/category" endpoint'ine GET isteği göndererek silinen id için “There is not category for this id.” mesajının döndüğünü doğrular.

  Scenario Outline: Verify that a DELETE request to /api/deleteCategory/{id} with non-existent id returns 203 and message “There is not category for this id.”.
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/deleteCategory/<id>" path parameters.
    # Api kullanıcısı "api/deleteCategory/<id>" path parametrelerini oluşturur.
    * The api user sends a "DELETE" request and saves the returned response.
    # Api kullanıcısı DELETE isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı response body’deki remark bilgisinin "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "There is not category for this id.".
    # Api kullanıcısı response body’deki data.message bilgisinin "There is not category for this id." olduğunu doğrular.

    Examples:
      | id    |
      | 25416 |

  Scenario: Verify that a DELETE request to /api/deleteCategory without id returns 203 and message “No id”.
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/deleteCategory" path parameters.
    # Api kullanıcısı "api/deleteCategory" path parametrelerini oluşturur.
    * The api user sends a "DELETE" request and saves the returned response.
    # Api kullanıcısı DELETE isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı response body’deki remark bilgisinin "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "No id".
    # Api kullanıcısı response body’deki data.message bilgisinin "No id" olduğunu doğrular.

  Scenario: Verify that a DELETE request to /api/deleteCategory/{id} with instructor token returns 203 and message “To access this data, you must log in as a admin.”.
    * The api user sends a POST request to "api/addCategory" endpoint to create a new category and records the Added Category ID.
    # Api kullanıcısı yeni bir kategori oluşturmak için "api/addCategory" endpoint'ine POST isteği gönderir ve Added Category ID bilgisini kaydeder.
    * The api user constructs the base url with the "instructor" token.
    # Api kullanıcısı "instructor" token ile base URL'i oluşturur.
    * The api user sets "api/deleteCategory" path parameters.
    # Api kullanıcısı "api/deleteCategory" path parametrelerini oluşturur.
    * The api user sends a "DELETE" request and saves the returned response.
    # Api kullanıcısı DELETE isteğini gönderir ve dönen response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı response body’deki remark bilgisinin "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "To access this data, you must log in as a admin.".
    # Api kullanıcısı response body’deki data.message bilgisinin "To access this data, you must log in as a admin." olduğunu doğrular.

  Scenario: Verify that a DELETE request to /api/deleteCategory/{id} with invalid token returns 401 and message “Unauthenticated.”.
    * The api user sends a POST request to "api/addCategory" endpoint to create a new category and records the Added Category ID.
    # Api kullanıcısı yeni bir kategori oluşturmak için "api/addCategory" endpoint'ine POST isteği gönderir ve Added Category ID bilgisini kaydeder.
    * The api user constructs the base url with the "invalid" token.
    # Api kullanıcısı "invalid" token ile base URL'i oluşturur.
    * The api user sets "api/deleteCategory" path parameters.
    # Api kullanıcısı "api/deleteCategory" path parametrelerini oluşturur.
    * The api user sends a "DELETE" request, saves the returned response, and verifies that the status code is '401' with the reason phrase Unauthorized.
    # Api kullanıcısı DELETE isteğini gönderir, dönen response'u kaydeder ve status code'un '401' ve reason phrase'in Unauthorized olduğunu doğrular.
