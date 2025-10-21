@yusuf @FullStartAll
Feature: US-53 Support Add

  Background:
    * no explicit token

  Scenario: Diagnose addSupport endpoint  US-53 AC-01 candidates
    Given use token "adminToken"
    And json body with fields
      | title         | Test support from Cucumber |
      | message       | Created by automated test  |
      | department_id | 1                          |
      | priority      | normal                     |
    When diagnose addSupport endpoints
    And discover api docs
    And probe allowed methods for "/api/supports"
    And probe allowed methods for "/api/support"
    And probe allowed methods for "/supports"
    And probe allowed methods for "/support"



  Scenario: POST addSupport US-53 AC-02 (valid)
    * no explicit token
    Given use token "adminToken"

    And json body with fields
      | title         | Test support from Cucumber |
      | message       | Created by automated test  |
      | department_id | 1                          |
      | priority      | normal                     |

    And resolve and set valid department id into body field "department_id"
    When send POST support-create
    Then status is 200
    And remark is success
    And store id from body "'Added Support ID'" as "createdSupportId"


  Scenario: POST addSupport Empty Body (422) US-53 AC-03
    Given use token "adminToken"
    And json body: {}
    When send POST support-create
    And print last endpoint used
    Then status is 422
    And remark is failed


  Scenario: POST addSupport Invalid Token US-53 AC-04
    Given use token "invalidToken"
    And json body: { "title": "X", "message": "Y", "department_id": 1 }
    When send POST support-create
    And print last endpoint used
    Then status is 401
    And body field "message" equals "Unauthenticated."
