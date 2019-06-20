Feature: Verify Applications Endpoint

  @create-a-new-application-endpoint
  Scenario: Verify Create a new application endpoint with a valid SPS User
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I POST data for transaction /Applications/New
    Then response code should be 200
    And response body should contain "appId":

  @delete-application-endpoint
  Scenario: Verify Delete an application endpoint with a valid SPS User and App ID
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I POST data for transaction /Applications/New
    Then response code should be 200
    And I capture the App ID
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I DELETE data for transaction /Applications/APPID
    Then response code should be 204

        #*************************** Negative scenarios ***********************

  @create-a-new-application-endpoint-invalid-sps-user
  Scenario: Verify Create a new application endpoint with an invalid SPS User
    Given I set Authorization header to Authorization
    And I set sps-user header to 999999
    And I set content_type header to application/json
    When I POST data for transaction /Applications/New
    Then response code should be 500

  @delete-application-endpoint-invalid-sps-user-valid-app-id
  Scenario: Verify Delete an application endpoint with an invalid SPS User and valid App ID
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I POST data for transaction /Applications/New
    Then response code should be 200
    And I capture the App ID
    Given I set Authorization header to Authorization
    And I set sps-user header to 999999
    And I set content_type header to application/json
    When I DELETE data for transaction /Applications/APPID
    Then response code should be 500

  @delete-application-endpoint-valid-sps-user-invalid-app-id
  Scenario: Verify Delete an application endpoint with an invalid SPS User and valid App ID
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I POST data for transaction /Applications/New
    Then response code should be 200
    And I capture the App ID
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I DELETE data for transaction /Applications/invAPPID
    Then response code should be 404
    And response body path errorCode should be InvalidRequestData
    And response body path errorDescription should be The data you requested could not be found
