@yusuf
Feature: US-51 Supports List & Field Validation

  Background:
    * no explicit token

  Scenario: GET supports US-51 AC-01
    Given use token "valid"
    When send GET "/api/supports"
    Then status is 200
    And remark is success
    And list exists at "data"
    And first item has nonempty fields:
      | id             |
      | user_id        |
      | webinar_id?    |
      | department_id? |
      | title          |
      | status         |
      | status_order   |
      | full_name      |
      | role_name      |
      | created_at     |
      | updated_at     |

  Scenario: GET Validate fields US-51 AC-02
    Given use token "valid"
    When send GET "/api/supports"
    Then status is 200
    And list exists at "data"
    And first item has nonempty fields:
      | id            |
      | user_id       |
      | department_id |
      | title         |
      | status        |


  Scenario: GET Invalid Token US-51 AC-03
    Given use token "invalid"
    When send GET "/api/supports"
    Then status is 401
    And body field "message" equals "Unauthenticated."
