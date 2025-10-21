@DataBaseAll @FullStartAll
Feature: BACKEND JDBC TESTING (Instulearn)

  Background: Database connection
    * Database connection is established.

  @US001
  Scenario: US_001 meeting minutes by email
    * US001 calculate total meeting minutes for oske.work@gmail.com
    * Database connection is closed

  @US002
  Scenario: US_002 meeting status counts & ratios
    * US002 list meeting counts and ratios by status
    * Database connection is closed

  @US003
  Scenario: US_003 product orders + gifts
    * US003 join product_orders with gifts and list
    * Database connection is closed

  @US004
  Scenario: US_004 quizzes question count (limited)
    * US004 fetch quizzes with questions_count and limit
    * Database connection is closed

  @US005
  Scenario: US_005 quizzes pass_mark=100 and validate ids
    * US005 list quiz_ids with pass_mark 100 and validate
    * Database connection is closed

  @US006
  Scenario: US_006 supports insert two rows at once
    * US006 insert two rows into supports
    * Database connection is closed

  @US007
  Scenario: US_007 verify webinar id by start timestamp
    * US007 verify webinar id for start_date 1728570600 is 1996
    * Database connection is closed

  @US008
  Scenario: US_008 freeze users with both approvals
    * US008 freeze users with both approvals and validate list
    * Database connection is closed

  @US009
  Scenario: US_009 freeze meetings by total payment>5000
    * US009 freeze meetings with total payment over 5000 and validate count
    * Database connection is closed

  @US010
  Scenario: US_010 users_zoom_api insert+update verify
    * US010 insert into users_zoom_api then update account_id and verify
    * Database connection is closed

  @US011
  Scenario: US_011 verifications insert then delete
    * US011 insert verification then delete and verify
    * Database connection is closed

  @US012
  Scenario: US_012 become_instructors count by role
    * US012 count instructors by role
    * Database connection is closed

  @US013
  Scenario: US_013 accepted instructors in last 15 days
    * US013 list accepted instructors last 15 days with user info
    * Database connection is closed

  @US014
  Scenario: US_014 verify role constraint on become_instructors
    * US014 verify role constraint on become_instructors
    * Database connection is closed

  @US015
  Scenario: US_015 products out of stock (ignore NULLs)
    * US015 list out of stock products
    * Database connection is closed

  @US016
  Scenario: US_016 verify product stock updates after order
    * US016 verify product stock updates after an order
    * Database connection is closed

  @US017
  Scenario: US_017 paid+credit orders sum by date
    * US017 sum paid credit orders for date "2024-10-01"
    * Database connection is closed

  @US018
  Scenario: US_018 high priority discounts physical & virtual
    * US018 list high priority physical and virtual discounts
    * Database connection is closed

  @US019
  Scenario: US_019 failed_jobs insert 5
    * US019 insert 5 rows into failed_jobs
    * Database connection is closed

  @US020
  Scenario: US_020 failed_jobs delete by uuid
    * US020 insert then delete one failed_job by uuid
    * Database connection is closed

  @US021
  Scenario: US_021 users ban metrics
    * US021 compute ban metrics
    * Database connection is closed

  @US022
  Scenario: US_022 users grouped by approvals & signup bonus
    * US022 group users by approvals and signup bonus
    * Database connection is closed

  @US023
  Scenario: US_023 users grouped by language & currency
    * US023 group by language and currency and sum commissions
    * Database connection is closed

  @US024
  Scenario: US_024 webinars grouped by teacher & category
    * US024 avg price capacity last updated grouped by teacher and category
    * Database connection is closed

  @US025
  Scenario: US_025 analyze public & waitlisted webinars
    * US025 analyze public and waitlisted webinars and verify waitlist counts
    * Database connection is closed

  @US026
  Scenario: US_026 webinars groups by certificate & download
    * US026 webinars grouped by certificate and downloadable content
    * Database connection is closed

  @US027
  Scenario: US_027 best-selling product per seller
    * US027 list best selling products per seller with totals
    * Database connection is closed

  @US028
  Scenario: US_028 total sales per seller and max
    * US028 compute total sales per seller and find max
    * Database connection is closed

  @US029
  Scenario: US_029 count order status occurrences
    * US029 count occurrences per order status
    * Database connection is closed

  @US030
  Scenario: US_030 highest capacity webinar and teacher name
    * US030 verify highest capacity webinar and teacher full name
    * Database connection is closed

  @US031
  Scenario Outline: US_031 review stats for a product
    * US031 review stats for product <product_id>
    * Database connection is closed

    Examples:
      | product_id |
      | 101        |

  @US032
  Scenario: US_032 support ticket counts by department & status
    * US032 list support ticket counts by department and status
    * Database connection is closed

  @US033
  Scenario: US_033 active in-stock products last 30 days
    * US033 list active in-stock products last 30 days or print note
    * Database connection is closed
