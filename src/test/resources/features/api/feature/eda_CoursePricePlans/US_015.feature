Feature: US_015 As an administrator, I want to be able to delete course price plan information with the specified id number via API connection.

  Scenario: AC_01 When a DELETE request is sent to the /api/deletePricePlan/{id} endpoint with valid authorization information and the correct (id),
  it should be verified that the status code returned is 200, the remark in the response body is “success” and the Message is “Successfully Deleted.”.
