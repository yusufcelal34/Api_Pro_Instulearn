@yusuf
Feature: US-55 Delete Support

  Background:
    * no explicit token

  Scenario: DEL deleteSupport/{id} Successfully Deleted US-55 AC-01
    Given use token "valid"
    And json body with fields
      | title         | To be deleted by test |
      | message       | Temp                  |
      | department_id | 1                     |

    And resolve and set valid department id into body field "department_id"

    When send POST support-create
    Then status is one of 201 or 200
    And if last status is 201 or 200 then store id from body "'Added Support ID' || data.id || id || support.id" as "delId"

    Given use token "valid"
    And use stored id "delId" as path id
    When send DELETE "/api/supports/{id}"
    Then status is one of 200 or 204 or 405

    Given use token "valid"
    And if last status is 200 or 204 then use stored id "delId" as path id
    When if last status is 200 or 204 then send GET "/api/supports/{id}"
    Then if last status is 200 or 204 then status is one of 203 or 404
    And if last status is 203 or 404 then remark is failed
    And if last status is 203 or 404 then response message contains "There is not support message for this id"

  Scenario: DEL deleteSupport/{id} Nonexistent US-55 AC-02
    Given use token "valid"
    And path id is 9999999
    When send DELETE "/api/supports/9999999"
    Then status is one of 203 or 404 or 405
    And if last status is 203 or 404 then remark is failed

  Scenario: DEL deleteSupport/{id} equals Path ID US-55 AC-03 (negative)
    Given use token "valid"
    And path id is 0
    When send DELETE "/api/supports/0"
    Then status is one of 203 or 404 or 405
    And if last status is 203 or 404 then remark is failed

  Scenario: DEL deleteSupport/{id} Confirm Deletion US-55 AC-04
    Given use token "valid"
    And path id is 0
    When send GET "/api/supports/0"
    Then status is one of 203 or 200
    And if last status is 203 then remark is failed