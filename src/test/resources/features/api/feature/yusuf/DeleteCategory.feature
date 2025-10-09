Feature: Delete Course Category via API
# Kapsam: /api/deleteCategory silme akışları

  @API
  Scenario: DELETE /api/deleteCategory/{id} with valid auth deletes successfully
    * The api user sends a POST request to "api/addCategory" endpoint to create a new category and records the Added Category ID.
    # Api kullanıcısı test amacıyla yeni bir kategori oluşturur ve dönen Added Category ID (oluşturulan kategori ID'si) bilgisini kaydeder.
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı yetkili istek göndermek için "admin" token ile base URL'i oluşturur.
    * The api user sets "api/deleteCategory" path parameters.
    # Api kullanıcısı endpoint yolunu "api/deleteCategory/{id}" olacak şekilde path parametrelerini (Added Category ID) ayarlar.
    * The api user sends a "DELETE" request and saves the returned response.
    # Api kullanıcısı DELETE isteğini gönderir ve dönen response'u doğrulamalar için kaydeder.
    * The api user verifies that the status code is 200.
    # Api kullanıcısı response status code'un 200 (OK) olduğunu doğrular.
    * The api user verifies that the "data.status" information in the response body is "success".
    # Api kullanıcısı response body içindeki "data.status" alanının "success" olduğunu doğrular.
    * The api user verifies that the "Message" information in the response body is "Successfully Deleted.".
    # Api kullanıcısı response body içindeki "Message" alanının "Successfully Deleted." olduğunu doğrular.
    * The api user verifies that the "Deleted Category Id" matches the id path parameter.
    # Api kullanıcısı response içindeki "Deleted Category Id" değerinin endpoint'e gönderilen id path parametresi ile aynı olduğunu doğrular.
    * The api user verifies via GET "api/category" that the deleted id returns message “There is not category for this id.”.
    # Api kullanıcısı "api/category/{id}" endpoint'ine GET isteği atarak silinen id için “There is not category for this id.” mesajının döndüğünü doğrular.

  @API
  Scenario Outline: DELETE /api/deleteCategory/<id> with non-existent id returns 203 and "There is not category for this id."
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı yetkili istek göndermek için "admin" token ile base URL'i oluşturur.
    * The api user sets "api/deleteCategory/<id>" path parameters.
    # Api kullanıcısı endpoint yolunu "api/deleteCategory/<id>" olacak şekilde, var olmayan bir id değeriyle ayarlar.
    * The api user sends a "DELETE" request and saves the returned response.
    # Api kullanıcısı DELETE isteğini gönderir ve response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 döndüğünü doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcı response body'deki "remark" alanının "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "There is not category for this id.".
    # Api kullanıcısı "data.message" alanının "There is not category for this id." olduğunu doğrular.
    Examples:
      | id    |
      | 25416 |

  @API
  Scenario: DELETE /api/deleteCategory without id returns 203 and "No id"
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/deleteCategory" path parameters.
    # Api kullanıcısı endpoint yolunu id belirtmeden "api/deleteCategory" olarak ayarlar (path parametresi yok).
    * The api user sends a "DELETE" request and saves the returned response.
    # Api kullanıcısı DELETE isteğini gönderir ve response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı "remark" alanının "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "No id".
    # Api kullanıcısı "data.message" alanının "No id" olduğunu doğrular.

  @API
  Scenario: DELETE /api/deleteCategory/{id} with instructor token returns 203 and "To access this data, you must log in as a admin."
    * The api user sends a POST request to "api/addCategory" endpoint to create a new category and records the Added Category ID.
    # Api kullanıcısı test için yeni bir kategori oluşturur ve Added Category ID'yi kaydeder.
    * The api user constructs the base url with the "instructor" token.
    # Api kullanıcısı yetkisi yetersiz bir rolü simüle etmek için "instructor" token ile base URL'i oluşturur.
    * The api user sets "api/deleteCategory" path parameters.
    # Api kullanıcısı "api/deleteCategory/{id}" endpoint'i için path parametrelerini (Added Category ID) ayarlar.
    * The api user sends a "DELETE" request and saves the returned response.
    # Api kullanıcısı DELETE isteğini gönderir ve response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı "remark" alanının "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "To access this data, you must log in as a admin.".
    # Api kullanıcısı "data.message" alanının "To access this data, you must log in as a admin." olduğunu doğrular.

  @API
  Scenario: DELETE /api/deleteCategory/{id} with invalid token returns 401 Unauthorized
    * The api user sends a POST request to "api/addCategory" endpoint to create a new category and records the Added Category ID.
    # Api kullanıcısı test için yeni bir kategori oluşturur ve Added Category ID'yi kaydeder.
    * The api user constructs the base url with the "invalid" token.
    # Api kullanıcısı geçersiz kimlik doğrulama senaryosunu test etmek için "invalid" token ile base URL'i oluşturur.
    * The api user sets "api/deleteCategory" path parameters.
    # Api kullanıcısı "api/deleteCategory/{id}" endpoint'i için path parametrelerini ayarlar (Added Category ID kullanılır).
    * The api user sends a "DELETE" request, saves the returned response, and verifies that the status code is '401' with the reason phrase Unauthorized.
    # Api kullanıcısı DELETE isteğini gönderir, response'u kaydeder ve status code'un '401' Reason Phrase'in "Unauthorized" olduğunu doğrular.
