@cenn
Feature: US08 As an administrator, I want to create a new course category record via an API connection.

  # Amaç: /api/addCategory ile yeni kategori ekleme ve eklenen kaydı /api/category/{id} ile doğrulama
  Background:

    # Ortak başlangıç: token her senaryoda adım içinde verilecek.
  Scenario: AC01 Verify that a POST /api/addCategory with valid authorization and title returns 200, remark "success", message "Successfully Added."
    Given use token "admin"
    And path params "api/addCategory"
    And json body with fields
      | title | Auto Category (US08-AC01) |
    When send POST "/api/addCategory"
    Then status is 200
    And body field "remark" is "success"
    And body field "Message" is "Successfully Added."
    And store id from body "'Added Category ID'" as "catId"
    # Api kullanıcısı geçerli token ve title ile POST atar; 200/success/Successfully Added. doğrulanır ve dönen Added Category ID "catId" olarak saklanır.

  Scenario: Verify the newly created category exists with GET /api/category/{id} using stored Added Category ID
    Given use token "admin"
    And use stored id "catId" as path id
    When send GET "/api/category/{id}"
    Then status is 200
    And body field "remark" is "success"
    # Bir önceki senaryoda saklanan catId ile kayıt varlığı doğrulanır.

  Scenario: Verify that POST /api/addCategory with valid authorization but no data returns 422 and message "The title field is required."
    Given use token "admin"
    And path params "api/addCategory"
    And json body: {}
    When send POST "/api/addCategory"
    Then status is 422
    And body field "message" is "The title field is required."
    # Geçerli token + boş body gönderildiğinde 422 ve zorunlu alan mesajı beklenir.
  @US08 @AC03 @cenn
  Scenario: Verify that POST /api/addCategory with invalid token and valid title returns 401 and message "Unauthenticated."
    Given use token "invalid"
    And path params "api/addCategory"
    And json body with fields
      | title | Auto Category (US08-AC03) |
    When send POST "/api/addCategory"
    Then status is 401
    And body field "message" is "Unauthenticated."
    # Geçersiz token ile istek atıldığında 401 ve "Unauthenticated." beklenir.
  # (İsteğe bağlı alternatif) Eğer sabit bir id ile GET doğrulaması da isteniyorsa aşağıdaki Outline'ı kullanabilirsin:
  @US08 @optional
  Scenario Outline: Verify existing category by id with GET /api/category/{id}
    Given use token "admin"
    And path id is <id>
    When send GET "/api/category/{id}"
    Then status is 200
    And body field "remark" is "success"
    Examples:
      | id   |
      | 1011 |