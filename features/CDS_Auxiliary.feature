Feature:Verify Auxiliary endpoint

  @get-industries-end-point
  Scenario: Verify 'Get Industries' End point
    Given I set Authorization header to Authorization
    And I set content_type header to application/json
    And I set SPS_User header to SPSUser
    When I GET data for transaction /Applications/Auxiliary/Industries
    Then response code should be 200
    And response body should contain "id":1
    And response body should contain "title":"Air Carriers, Airlines, Misc.",
    And response body should contain "description":"Air Carriers, Airlines, Misc."
    And response body should contain "isDefault":false,
    And response body should contain "canEdit":false

    @test
  Scenario: Verify 'Get Sic codes' End point
    Given I set Authorization header to Authorization
    And I set content-type header to application/json
    And I set SPS-User header to SPSUser
    When I GET data for transaction /Applications/Auxiliary/Industries/43/SicCodes
    Then response code should be 200
    Then response body should contain "id":5300
    Then response body should contain "title":"5300"
    Then response body should contain "description":"WHOLESALE CLUBS"
    Then response body should contain "isDefault":false
    Then response body should contain "canEdit":false

    #*************************** Negative scenarios ***********************

  @get-industries-end-point-InvalidAuth
  Scenario: Verify 'Get Industries' End point	with InvalidAuth
    Given I set Authorization header to InvalidAuthorization
    And I set content-type header to application/json
    And I set SPS-User header to SPSUser
    When I GET data for transaction /Applications/Auxiliary/Industries
    Then response code should be 401
    Then response body path errorCode should be InvalidHeaders
    Then response body path errorDescription should be Required Authorization header not present

  @get-industries-end-point-InvalidSPSUser
  Scenario: Verify 'Get Industries' End point for Auxiliary	with InvalidSPSUser
    Given I set Authorization header to Authorization
    And I set content-type header to application/json
    And I set SPS-User header to 34888
    When I GET data for transaction /Applications/Auxiliary/Industries
    Then response code should be 500

  @get-siccodes-end-point-InvalidSPSUser
  Scenario: Verify 'Get Industries' End point For SIC codes	with InvalidSPSUser
    Given I set Authorization header to Authorization
    And I set content-type header to application/json
    And I set SPS_User header to 34888
    When I GET data for transaction /Industries/43/SicCodes
    Then response code should be 404


  @get-siccodes-end-point-InvalidContentType
  Scenario: Verify 'Get Industries' End point For SIC codes	with InvalidContentType
    Given I set Authorization header to Authorization
    And I set content-type header to applicationjson
    And I set SPS-User header to SPSUser
    When I GET data for transaction /Industries/43/SicCodes
    Then response code should be 404
