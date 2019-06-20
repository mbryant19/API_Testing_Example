Feature: Verify Business Details Endpoint

  @get-business-details-endpoint
  Scenario: Verify Get Business Details endpoint with valid App ID
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I GET data for transaction /Applications/APPID/BusinessDetails
    Then response code should be 200
    And response body should contain businessDescription
    And response body should contain highVolumeMonths
    And response body should contain returnPolicy
    And response body should contain billingDetails
    And response body should contain fullPayment
    And response body should contain partialPayment
    And response body should contain afterDelivery
    And response body should contain billingFrequency
    And response body should contain outSourcingComments

  @get-business-details-endpoint-invalid-app-id
  Scenario: Verify Get Business Details endpoint with invalid App ID
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I GET data for transaction /Applications/999999/BusinessDetails
    Then response code should be 404
    And response body path errorCode should be InvalidRequestData
    And response body path errorDescription should be The data you requested could not be found

  @get-business-details-endpoint-invalid-sps-user
  Scenario: Verify Get Business Details endpoint with invalid SPS User
    Given I set Authorization header to Authorization
    And I set sps-user header to 999999
    And I set content_type header to application/json
    When I GET data for transaction /Applications/APPID/BusinessDetails
    Then response code should be 500

  @save-business-details-endpoint
  Scenario: Verify Save Business Details endpoint with valid App ID
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content-type header to application/json
    And I set body to BusinessDetails.json
    When I PUT data for transaction /Applications/APPID/BusinessDetails
    Then response code should be 204
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I GET data for transaction /Applications/APPID/BusinessDetails
    Then response code should be 200
    And response body should match BusinessDetails
