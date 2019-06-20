Feature: Verify Legacy OSC Endpoint

  @get-applications-by-status-endpoint
  Scenario Outline: Verify Get Applications by Status
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I GET data for transaction /Applications/Summary<Status>
    Then response code should be 200
    And response body should contain "appInfoId":
    And response body should contain "applicationDate":
    And response body should contain "status":
    And response body should contain "contractor":
    And response body should contain "merchantId":
    And response body should contain "owner":
    And response body should contain "product":
    And response body should contain "statusChangedDate":
    And response body should contain "dba":
    And response body should contain "creditApp":
    And response body should contain "eftApp":
    And response body should contain "contractorId":

    Examples:
      | Status                   |
      | ?status=SentToMerchant   |
      | ?status=SigningStarted   |
      | ?status=SigningCompleted |

  @get-applications-sent-to-merchant-and-date
  Scenario Outline: Verify Get Applications Sent To Merchant with dates
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I GET data for transaction /Applications/Summary?status=SentToMerchant<Status>
    Then response code should be 200
    And response body should contain "appInfoId":
    And response body should contain "applicationDate":
    And response body should contain "status":
    And response body should contain "contractor":
    And response body should contain "merchantId":
    And response body should contain "owner":
    And response body should contain "product":
    And response body should contain "statusChangedDate":
    And response body should contain "dba":
    And response body should contain "creditApp":
    And response body should contain "eftApp":
    And response body should contain "contractorId":

    Examples:
      | Status                                           |
      | &startDate=12%2F12%2F2010                        |
      | &endDate=12%2F12%2F2018                          |
      | &startDate=12%2F12%2F2010&endDate=12%2F12%2F2018 |

  @get-applications-signing-started-and-date
  Scenario Outline: Verify Get Applications Signing Started with dates
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I GET data for transaction /Applications/Summary?status=SigningStarted<Status>
    Then response code should be 200
    And response body should contain "appInfoId":
    And response body should contain "applicationDate":
    And response body should contain "status":
    And response body should contain "contractor":
    And response body should contain "merchantId":
    And response body should contain "owner":
    And response body should contain "product":
    And response body should contain "statusChangedDate":
    And response body should contain "dba":
    And response body should contain "creditApp":
    And response body should contain "eftApp":
    And response body should contain "contractorId":

    Examples:
      | Status                                           |
      | &startDate=12%2F12%2F2010                        |
      | &endDate=12%2F12%2F2018                          |
      | &startDate=12%2F12%2F2010&endDate=12%2F12%2F2018 |

  @get-applications-signing-completed-and-date
  Scenario Outline: Verify Get Applications Signing Completed with dates
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I GET data for transaction /Applications/Summary?status=SigningCompleted<Status>
    Then response code should be 200
    And response body should contain "appInfoId":
    And response body should contain "applicationDate":
    And response body should contain "status":
    And response body should contain "contractor":
    And response body should contain "merchantId":
    And response body should contain "owner":
    And response body should contain "product":
    And response body should contain "statusChangedDate":
    And response body should contain "dba":
    And response body should contain "creditApp":
    And response body should contain "eftApp":
    And response body should contain "contractorId":

    Examples:
      | Status                                           |
      | &startDate=12%2F12%2F2010                        |
      | &endDate=12%2F12%2F2018                          |
      | &startDate=12%2F12%2F2010&endDate=12%2F12%2F2018 |

  @get-applications-with-invalid-dates
  Scenario Outline: Verify Get Applications with invalid dates
    Given I set Authorization header to Authorization
    And I set sps-user header to SPSUser
    And I set content_type header to application/json
    When I GET data for transaction /Applications/Summary<Status>
    Then response code should be 200
    And response body should be blank

    Examples:
      | Status                                                                   |
      | ?status=SentToMerchant&startDate=12%2F12%2F2030                          |
      | ?status=SentToMerchant&endDate=12%2F12%2F2005                            |
      | ?status=SentToMerchant&startDate=12%2F12%2F2000&endDate=12%2F12%2F2005   |
      | ?status=SigningStarted&startDate=12%2F12%2F2030                          |
      | ?status=SigningStarted&endDate=12%2F12%2F2005                            |
      | ?status=SigningStarted&startDate=12%2F12%2F2000&endDate=12%2F12%2F2005   |
      | ?status=SigningCompleted&startDate=12%2F12%2F2030                        |
      | ?status=SigningCompleted&endDate=12%2F12%2F2005                          |
      | ?status=SigningCompleted&startDate=12%2F12%2F2000&endDate=12%2F12%2F2005 |

            #*************************** Negative scenarios ***********************

  @get-applications-with-invalid-sps-user
  Scenario: Verify Get Applications with invalid sps-user
    Given I set Authorization header to Authorization
    And I set sps-user header to 999999
    And I set content_type header to application/json
    When I GET data for transaction /Applications/Summary?status=SentToMerchant
    Then response code should be 500