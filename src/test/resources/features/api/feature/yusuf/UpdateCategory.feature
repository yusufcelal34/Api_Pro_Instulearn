Feature: Update Course Category via API
# Kapsam: /api/updateCategory güncelleme akışları

  @API
  Scenario Outline: PATCH /api/updateCategory/{id} with valid auth returns 200 and "Successfully Updated."
    * The api user sends a POST request to "api/addCategory" endpoint to create a new category and records the Added Category ID.
    # Api kullanıcısı test verisi oluşturmak için "api/addCategory" endpoint'ine POST isteği gönderir ve dönen Added Category ID (oluşturulan kategori ID'si) bilgisini kaydeder.
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı istekleri yetkili şekilde göndermek için "admin" token'ı ile base URL'i oluşturur.
    * The api user sets "api/updateCategory" path parameters.
    # Api kullanıcısı endpoint yolunu "api/updateCategory/{id}" olacak şekilde path parametrelerini hazırlar (id path parametresi olarak Added Category ID kullanılır).
    * The api user prepares a PATCH request containing "<title>".
    # Api kullanıcısı PATCH gövdesini "<title>" alanını içerecek şekilde hazırlar (ör. { "title": "<title>" }).
    * The api user sends a "PATCH" request and saves the returned response.
    # Api kullanıcısı PATCH isteğini gönderir ve dönen response'u daha sonra doğrulamak için kaydeder.
    * The api user verifies that the status code is 200.
    # Api kullanıcısı response status code'un 200 (OK) olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "success".
    # Api kullanıcısı response body içindeki "remark" alanının "success" olduğunu doğrular.
    * The api user verifies that the "Message" information in the response body is "Successfully Updated.".
    # Api kullanıcısı response body içindeki "Message" alanının "Successfully Updated." olduğunu doğrular.
    * The api user verifies that the "Updated Category Id" matches the id path parameter.
    # Api kullanıcısı response içindeki "Updated Category Id" değerinin endpoint'e gönderilen id path parametresi ile aynı olduğunu doğrular.
    * The api user verifies via GET "api/category" that "data.translations[0].title" equals "<title>".
    # Api kullanıcısı "api/category/{id}" endpoint'ine GET isteği atarak "data.translations[0].title" alanının "<title>" ile güncellendiğini doğrular.

    Examples:
      | title                  |
      | Education and Training |

  @API
  Scenario: PATCH /api/updateCategory/{id} without body returns 203 and "There is no information to update."
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/updateCategory" path parameters.
    # Api kullanıcısı "api/updateCategory/{id}" endpoint'i için path parametrelerini ayarlar (geçerli bir id kullanır).
    * The api user prepares a PATCH request without data.
    # Api kullanıcısı gövdesiz (boş) bir PATCH isteği hazırlar.
    * The api user sends a "PATCH" request and saves the returned response.
    # Api kullanıcısı PATCH isteğini gönderir ve response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı response body'deki "remark" alanının "failed" olduğunu doğrular.
    * The api user verifies that the "message" information in the response body is "There is no information to update.".
    # Api kullanıcısı "message" alanının "There is no information to update." olduğunu doğrular.

  @API
  Scenario Outline: PATCH /api/updateCategory/<id> with non-existent id returns 203 and "There is not category for this id."
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı yetkili istek göndermek için "admin" token ile base URL'i oluşturur.
    * The api user sets "api/updateCategory/<id>" path parameters.
    # Api kullanıcısı endpoint yolunu "api/updateCategory/<id>" olacak şekilde, var olmayan bir id değeriyle ayarlar.
    * The api user prepares a PATCH request containing "<title>".
    # Api kullanıcısı "<title>" alanını içeren bir PATCH gövdesi hazırlar.
    * The api user sends a "PATCH" request and saves the returned response.
    # Api kullanıcısı PATCH isteğini gönderir ve response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 döndüğünü doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı "remark" alanının "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "There is not category for this id.".
    # Api kullanıcısı "data.message" alanının "There is not category for this id." olduğunu doğrular.

    Examples:
      | id    | title                  |
      | 25416 | Education and Training |

  @API
  Scenario Outline: PATCH /api/updateCategory with no id returns 203 and "No id"
    * The api user constructs the base url with the "admin" token.
    # Api kullanıcısı "admin" token ile base URL'i oluşturur.
    * The api user sets "api/updateCategory" path parameters.
    # Api kullanıcısı endpoint yolunu id belirtmeden "api/updateCategory" olarak ayarlar (path parametresi yok).
    * The api user prepares a PATCH request containing "<title>".
    # Api kullanıcısı "<title>" içeren bir PATCH gövdesi hazırlar.
    * The api user sends a "PATCH" request and saves the returned response.
    # Api kullanıcısı PATCH isteğini gönderir ve response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı "remark" alanının "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "No id".
    # Api kullanıcısı "data.message" alanının "No id" olduğunu doğrular.

    Examples:
      | title                  |
      | Education and Training |

  @API
  Scenario Outline: PATCH /api/updateCategory/{id} with instructor token returns 203 and "To access this data, you must log in as a admin."
    * The api user sends a POST request to "api/addCategory" endpoint to create a new category and records the Added Category ID.
    # Api kullanıcısı test için yeni bir kategori oluşturur ve dönen Added Category ID'yi kaydeder.
    * The api user constructs the base url with the "instructor" token.
    # Api kullanıcısı yetkisi yetersiz bir rolü simüle etmek için "instructor" token ile base URL'i oluşturur.
    * The api user sets "api/updateCategory" path parameters.
    # Api kullanıcısı "api/updateCategory/{id}" endpoint'i için path parametrelerini (Added Category ID) ayarlar.
    * The api user prepares a PATCH request containing "<title>".
    # Api kullanıcısı "<title>" içeren bir PATCH gövdesi hazırlar.
    * The api user sends a "PATCH" request and saves the returned response.
    # Api kullanıcısı PATCH isteğini gönderir ve response'u kaydeder.
    * The api user verifies that the status code is 203.
    # Api kullanıcısı status code'un 203 olduğunu doğrular.
    * The api user verifies that the "remark" information in the response body is "failed".
    # Api kullanıcısı "remark" alanının "failed" olduğunu doğrular.
    * The api user verifies that the "data.message" information in the response body is "To access this data, you must log in as a admin.".
    # Api kullanıcısı "data.message" alanının "To access this data, you must log in as a admin." olduğunu doğrular.

    Examples:
      | title                  |
      | Education and Training |

  @API
  Scenario Outline: PATCH /api/updateCategory/{id} with invalid token returns 401 Unauthorized
    * The api user sends a POST request to "api/addCategory" endpoint to create a new category and records the Added Category ID.
    # Api kullanıcısı test için yeni bir kategori oluşturur ve Added Category ID'yi kaydeder.
    * The api user constructs the base url with the "invalid" token.
    # Api kullanıcısı geçersiz kimlik doğrulama senaryosunu test etmek için "invalid" token ile base URL'i oluşturur.
    * The api user sets "api/updateCategory" path parameters.
    # Api kullanıcısı "api/updateCategory/{id}" endpoint'i için path parametrelerini ayarlar (Added Category ID kullanılır).
    * The api user prepares a PATCH request containing "<title>".
    # Api kullanıcısı "<title>" içeren bir PATCH gövdesi hazırlar.
    * The api user sends a "PATCH" request, saves the returned response, and verifies that the status code is '401' with the reason phrase Unauthorized.
    # Api kullanıcısı PATCH isteğini gönderir, response'u kaydeder ve status code'un '401' Reason Phrase'in "Unauthorized" olduğunu doğrular.

    Examples:
      | title                  |
      | Education and Training |
