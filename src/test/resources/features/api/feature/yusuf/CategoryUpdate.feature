@yusuf @FullStartAll
Feature: US-54 Update Support

  Background:
    * no explicit token

  Scenario: POST /api/supports ile kayıt oluştur; PATCH kapalıysa 405 dönmeli
    * no explicit token
    Given use token "valid"

    When send GET "/api/departments"
    Then status is 200
    And store first valid int field from body "id" as "deptId"

    And json body with fields
      | title         | To be updated by test |
      | message       | Initially created     |
      | department_id | ${deptId}             |
      | priority      | normal                |
    When send POST support-create

    Then status is one of 200 or 201 or 405
    And if last status is 200 or 201 then store id from body "'Added Support ID' || $.data.id || $.id || $.support.id" as "updId"
    And if last status is 200 or 201 then use stored id "updId" as path id
    And if last status is 405 then set path id 1

    And json body with fields
      | title   | Updated title |
      | message | Updated msg   |
    When send PATCH "/api/support/{id}"
    Then status is 405

  Scenario: PATCH updateSupport/{id} Empty Body US-54 AC-02
    Given use token "valid"
    And path id is 1
    And json body: {}
    When send PATCH "/api/support/1"
    Then status is 405

  Scenario: PATCH updateSupport/{id} Nonexistent US-54 AC-03
    Given use token "valid"
    And path id is 9999999
    And json body: { "title": "x" }
    When send PATCH "/api/support/9999999"
    Then status is 405

  Scenario: PATCH updateSupport/{id} Invalid Token US-54 AC-04
    Given use token "invalid"
    And path id is 1
    And json body: { "title": "x" }
    When send PATCH "/api/support/1"
    Then status is 405

  Scenario: PATCH updateSupport/{id} Updated ID US-54 AC-05 (negative)
    Given use token "valid"
    And path id is 0
    And json body: { "title": "x" }
    When send PATCH "/api/support/0"
    Then status is 405
