Feature: DB

  Scenario: US_007 Verify that the data with start_date 1722520800 in the webinars table has id 2001
    * The user connects to the InstuLearn database
    * The user queries the "id" from the "webinars" table where the "start_date" column has the value "'1722520800'".
    * The user verifies that the "id" in the query result is 2001
    * The user closes the database connection

  Scenario: US_008 Write the query that freezes the users who have financial approval and installment approval in the users table and verify the freezing list.
    * The user connects to the InstuLearn database
    * The user queries the "full_name" from the "users" table where the "financial_approval" column has the value "1 and installment_approval = 1".
    * The user displays the "full_name" from the query result.
    * The user closes the database connection

  Scenario: US_009 Write the query that freezes the meetings with a total payment of more than 5000 when grouped
  by meeting_ids in the reserve_meetings table. And verify the number of meetings from the list.
    * The user connects to the InstuLearn database
    * The user retrieves meetings grouped by meeting_id with total payment greater than 500
    * the user views how many "meeting_id" are returned
    * The user closes the database connection