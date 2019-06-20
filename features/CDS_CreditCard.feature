@intg
Feature:Verify Bank Info endpoint

  @save-bank-information-end-point
  Scenario Outline: Verify 'Save Bank' End point
    Given I set Authorization header to Authorization
    And I set content-type header to <ContentType>
    And I set SPS_User header to SPSUser
    And I set body to {"depository":{"name":"Test","accountNumber":"1234567890","routingNumber":"123123123"},"fees":{"name":"authfee","accountNumber":"1234567890","routingNumber":"123123123"}}
    When I PUT data for transaction /Applications/215622/CreditCard/BankInfo
    Then response code should be 201
	   #Then response body should contain ^$
	   #'In response empty string came, but in swagger ui 'no conetent' string displayed, so checked for empty string here
    Examples:
      | ContentType      |
      | application/json |
      | text/json        |
#	   |    application/x-www-form-urlencoded |



  @get-bank-information-end-point
  Scenario Outline: Verify 'Get Bank Card' End point
    Given I set Authorization header to Authorization
    And I set content-type header to <ContentType>
    And I set SPS-User header to SPSUser
    When I GET data for transaction /Applications/214389/CreditCard/BankInfo
    Then response code should be 200
#    And response body should contain {"depository":{"name":"Test","accountNumber":"1234567890","routingNumber":"123123123"},"fees":{"name":"auth fee","accountNumber":"1234567890","routingNumber":"123123123"}}
    Examples:
      | ContentType      |
      | application/json |
      | text/json        |
#	   |    application/x-www-form-urlencoded |


	 #************************************Negative Scenarios**************************************

  @save-bank-information-end-point-DepositoryinvalidAcc
  Scenario Outline: Verify 'Save Bank' End point with invalid account no
    Given I set Authorization header to Authorization
    And I set content-type header to <ContentType>
    And I set SPS-User header to SPSUser
    And I set body to {"depository":{"name":"Test","accountNumber":"gggggggggg","routingNumber":"123123123"},"fees":{"name":"auth fee","accountNumber":"1234567890","routingNumber":"123123123"}}
    When I put data for transaction /Applications/214062/CreditCard/BankInfo
    Then response code should be 400
    Then response body should contain {"errorCode":"InvalidRequestData","errorDescription":"bankinfo.depository: The field AccountNumber must match the regular expression '([0-9]*)'."}

    Examples:
      | ContentType      |
      | application/json |
      | text/json        |
#	   |    application/x-www-form-urlencoded |

  @save-bank-information-end-point-feesInvalidAcc
  Scenario Outline: Verify 'Save Bank' End point with invalid account no
    Given I set Authorization header to Authorization
    And I set content-type header to <ContentType>
    And I set SPS-User header to SPSUser
    And I set body to {"depository":{"name":"Test","accountNumber":"34859788","routingNumber":"123123123"},"fees":{"name":"auth fee","accountNumber":"kkkkkkk","routingNumber":"123123123"}}
    When I put data for transaction /Applications/214062/CreditCard/BankInfo
    Then response code should be 400
    Then response body should contain {"errorCode":"InvalidRequestData","errorDescription":"bankinfo.fees: The field AccountNumber must match

    Examples:
      | ContentType      |
      | application/json |
      | text/json        |
#	   |    application/x-www-form-urlencoded |

  @save-bank-information-end-point-DepositoryInvalidRoutNo
  Scenario Outline: Verify 'Save Bank' End point with invalid Routing N0 in fees in depository
    Given I set Authorization header to Authorization
    And I set content-type header to <ContentType>
    And I set SPS-User header to SPSUser
    And I set body to {"depository":{"name":"Test","accountNumber":"34589788488","routingNumber":"ggggggggg"},"fees":{"name":"auth fee","accountNumber":"1234567890","routingNumber":"123123123"}}
    When I put data for transaction /Applications/214062/CreditCard/BankInfo
    Then response code should be 400
    Then response body should contain "errorCode":"InvalidRequestData","errorDescription":"bankinfo.depository: The field RoutingNumber must match the regular

    Examples:
      | ContentType      |
      | application/json |
      | text/json        |
#	   |    application/x-www-form-urlencoded |

  @save-bank-information-end-point-feesInvalidRoutNo
  Scenario Outline: Verify 'Save Bank' End point with invalid Routing N0 in fees
    Given I set Authorization header to Authorization
    And I set content-type header to <ContentType>
    And I set SPS-User header to SPSUser
    And I set body to {"depository":{"name":"Test","accountNumber":"34859788","routingNumber":"123123123"},"fees":{"name":"auth fee","accountNumber":"kkkkkkk","routingNumber":"ggggggggg"}}
    When I put data for transaction /Applications/214062/CreditCard/BankInfo
    Then response code should be 400
    Then response body should contain bankinfo.fees: The field RoutingNumber must match the regular expression

    Examples:
      | ContentType      |
      | application/json |
      | text/json        |
#	   |    application/x-www-form-urlencoded |

  @save-bank-information-end-point-RoutingNo
  Scenario Outline: Verify 'Save Bank' End point with invalid Routing N0 in fees
    Given I set Authorization header to Authorization
    And I set content-type header to <ContentType>
    And I set SPS-User header to SPSUser
    And I set body to {"depository":{"name":"Test","accountNumber":"34859788","routingNumber":"1234567899"},"fees":{"name":"auth fee","accountNumber":"kkkkkkk","routingNumber":"6666666666"}}
    When I put data for transaction /Applications/214062/CreditCard/BankInfo
    Then response code should be 400
	   #And response body should contain "errorCode": "InvalidRequestData"
    And response body should contain "bankinfo.depository: The field RoutingNumber must be a string with a maximum length of 9
    And response body should contain bankinfo.fees: The field RoutingNumber must be a string with a maximum length of 9

    Examples:
      | ContentType      |
      | application/json |
      | text/json        |
#	   |    application/x-www-form-urlencoded |


  @save-bank-information-end-point-EmptyString
  Scenario Outline: Verify 'Save Bank' End point with Empty string
    Given I set Authorization header to Authorization
    And I set content-type header to <ContentType>
    And I set SPS-User header to SPSUser
    And I set body to {}
    When I put data for transaction /Applications/214062/CreditCard/BankInfo
    Then response code should be 400
	  # And response body should contain "bankinfo.depository: The field RoutingNumber must be a string with a maximum length of 9
	  # And response body should contain bankinfo.fees: The field RoutingNumber must be a string with a maximum length of 9

    Examples:
      | ContentType      |
      | application/json |
      | text/json        |
#	   |    application/x-www-form-urlencoded |
  @save-bank-information-end-point-InvalidAuth
  Scenario: Verify 'Save Bank' End point with invalid Authorization
    Given I set Authorization header to InvalidAuthorization
    And I set content-type header to application/json
    And I set SPS-User header to 403652
    And I set body to {"depository":{"name":"Test","accountNumber":"1234567890","routingNumber":"123123123"},"fees":{"name":"auth fee","accountNumber":"1234567890","routingNumber":"123123123"}}
    When I put data for transaction /Applications/214062/CreditCard/BankInfo
    Then response code should be 401
    Then response body should contain {"errorCode":"InvalidHeaders","errorDescription":"Required Authorization header not present"}

  @save-bank-information-end-point-SPSUser
  Scenario: Verify 'Save Bank' End point with inValid SPSUser
    Given I set Authorization header to InvalidAuthorization
    And I set content-type header to application/json
    And I set SPS-User header to InvalidSPSUser
    And I set body to {"depository":{"name":"Test","accountNumber":"1234567890","routingNumber":"123123123"},"fees":{"name":"auth fee","accountNumber":"1234567890","routingNumber":"123123123"}}
    When I put data for transaction /Applications/214062/CreditCard/BankInfo
    Then response code should be 401
	   #Then response body should contain ?????
	   #Then response body should contain {"errorCode":"InvalidHeaders","errorDescription":"Required Authorization header not present"}

  @save-bank-information-end-point-ContentType
  Scenario: Verify 'Save Bank' End pointwith invalid Content type
    Given I set Authorization header to Authorization
    And I set content-type header to application/jso
    And I set SPS-User header to 403652
    And I set body to {"depository":{"name":"Test","accountNumber":"1234567890","routingNumber":"123123123"},"fees":{"name":"auth fee","accountNumber":"1234567890","routingNumber":"123123123"}}
    When I put data for transaction /Applications/214062/CreditCard/BankInfo
    Then response code should be 415
	   #Then response body should contain ?????
	   #Then response body should contain {"errorCode":"InvalidHeaders","errorDescription":"Required Authorization header not present"}


  @get-bank-information-end-point-invalidAuth
  Scenario: Verify 'Get Industries' End point	With invalid Authorization
    Given I set Authorization header to InvalidAuthorization
    And I set content-type header to application/json
    And I set SPS-User header to SPSUser
    When I get data for Templates /Applications/214062/CreditCard/BankInfo
    Then response code should be 401
    And response body should contain {"errorCode":"InvalidHeaders","errorDescription":"Required Authorization header not present"}

  @get-bank-information-end-point-contenttype
  Scenario: Verify 'Get Industries' End point	With invalid Content type
    Given I set Authorization header to Authorization
    And I set content-type header to dddddddddd
    And I set SPS-User header to SPSUser
    When I get data for Templates /Applications/214062/CreditCard/BankInfo
    Then response code should be 401
	  # And response body should contain ????

  @get-bank-information-end-point-spsuser
  Scenario: Verify 'Get Industries' End point	With invalid SPSUser
    Given I set Authorization header to InvalidAuthorization
    And I set content-type header to application/json
    And I set SPS-User header to InvalidSPSUser
    When I get data for Templates /Applications/214062/CreditCard/BankInfo
    Then response code should be 401
    And response body should contain {"errorCode":"InvalidHeaders","errorDescription":"Required Authorization header not present"}