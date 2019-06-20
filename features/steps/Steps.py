import json
from json import JSONDecodeError

import requests
from behave import *

use_step_matcher("parse")


@step("I set {header} header to {value}")
def step_impl(context, header, value):
    """
    :param header: whose value we wish to set.
    :param value: we want to set in the Header.
    :type context: behave.runner.Context
    """
    # We set a header, given a Header name and a value, first it checks is the value is actually a Config key,
    # if that throws the error KeyError, and then just sets the value gives as the value attached to the header.
    try:
        context.headers[str(header)] = str(context.data[value])
        print(f'{header} was set to {context.data[value]}\n')
    except KeyError:
        context.headers[str(header)] = str(value)
        print(f'{header} was set to {value}\n')


@step('I set body to {request_body}')
def step_impl(context, request_body):
    """
    :param request_body: Body of the request we are going to be submitting
    :type context: behave.runner.Context
    """
    try:
        context.body = str(context.data[request_body])
    except KeyError:
        if request_body == 'BusinessDetails':
            context.body = '{"businessDescription":"shoes","highVolumeMonths":[11],"returnPolicy":"ThirtyDayMoneyBack","billingDetails":{"fullPayment":{"daysUntilDelivery":3},"partialPayment":{"upFrontPercentage":10.00,"daysUntilDelivery":5},"afterDelivery":true,"billingFrequency":["Monthly"],"outSourcingComments":"Example Comment"}}'
        elif '.json' in request_body:
            print(f'Loading file...\n')
            f = open(f'features/support/{request_body}', 'r')
            context.body = f.read().replace('\n', '')
        else:
            context.body = request_body


@step("I {method} data for transaction {endpoint}")
def step_impl(context, method, endpoint):
    """
    :param method: for the request that we will be sending (PUT, GET, POST, etc.)
    :param endpoint: we wish to hit with our request.
    :type context: behave.runner.Context
    """
    url = None
    print(f'These are the current headers of the request: {context.headers}')
    print(f'This is the current body of the request: {context.body}')
    if method == 'POST':
        print(f'Sending {method} request to {context.data["url"]}{endpoint}\n')
        context.res = requests.post(f"{context.data['url']}{endpoint}",
                                    data=context.body,
                                    headers=context.headers)
    elif method == 'PUT':
        if 'APPID' in endpoint:
            url = f"{context.data['url']}{endpoint.replace('APPID', context.appId)}"
            print(f'Replaced AppID.\n')
        else:
            url = f"{context.data['url']}{endpoint}"
        print(f'Sending {method} request to {url}\n')
        context.res = requests.put(url, data=context.body,
                                   headers=context.headers)
    elif method == 'GET':
        if 'APPID' in endpoint:
            url = f"{context.data['url']}{endpoint.replace('APPID', context.appId)}"
            print(f'Replaced AppID.\n')
        else:
            url = f"{context.data['url']}{endpoint}"
        print(f'Sending {method} request to {url}\n')
        context.res = requests.get(url, headers=context.headers)
    elif method == 'PATCH':
        url = f"{context.data['url']}{endpoint}"
        print(f'Sending {method} request to {url}\n')
        context.res = requests.patch(url, data=context.body,
                                     headers=context.headers)
    elif method == 'DELETE':
        if endpoint == '/Applications/APPID':
            url = f"{context.data['url']}{endpoint.replace('APPID', context.token)}"
        if endpoint == '/Applications/invAPPID':
            url = f"{context.data['url']}{endpoint.replace('invAPPID', '999999')}"
        else:
            url = f"{context.data['url']}{endpoint}"
        print(f'Sending {method} request to {url}\n')
        context.res = requests.delete(url, headers=context.headers)


@step("response code should be {response_code}")
def step_impl(context, response_code):
    """
    :param response_code: expected response from the server.
    :type context: behave.runner.Context
    """
    assert str(context.res.status_code) == str(response_code), f'Expected code: {response_code}, ' \
                                                               f'Actual response: {context.res.status_code}\n' \
                                                               f'Response body: {context.res.text}\n'
    print(f'Expected code: {response_code}, ' \
          f'Actual response: {context.res.status_code}\n' \
          f'Response body: {context.res.text}\n')
    if str(response_code) == '201':
        context.token = context.res.text.replace("\"", "")
        response = json.loads(context.res.text)
        try:
            context.reference = str(response["reference"])
        except TypeError:
            pass
    elif str(response_code) == '200':
        try:
            response = json.loads(context.res.text)
            context.recurringID = str(response["recurringScheduleId"])
        except TypeError:
            pass
        except KeyError:
            pass
        except JSONDecodeError:
            pass
    context.headers = None
    context.headers = dict()


@step("response body path {path} should be {message}")
def step_impl(context, path, message):
    """
    :param message: Expected message at the path given.
    :param path: where to look for the error message.
    :type context: behave.runner.Context
    """
    response = json.loads(context.res.text)

    if str(path) == 'Root':
        assert str(response).strip() == str(
            message), f'The response at path {path} is {response} and ' \
                      f'doesn\'t match the expect message: {message}\n'
        print(f'The response at path {path} is {response} and it matches the expect message is {message}\n')
    else:
        assert str(response[str(path)]).strip() == str(
            message), f'The response at path {path} is {response[str(path)]} and ' \
                      f'doesn\'t match the expect message: {message}\n'
        print(f'The response at path {path} is {response[str(path)]} and it matches the expect message is {message}\n')
    context.headers = None
    context.headers = dict()
    context.body = None


@step("I {method} data with existing ref num {endpoint}")
def step_impl(context, method, endpoint):
    """
    :param method: for the request that we will be sending (PUT, GET, POST, etc.)
    :param endpoint: we wish to hit with our request.
    :type context: behave.runner.Context
    """
    print(f'Sending {method} request to {context.data["url"]}{endpoint}{context.reference}\n')
    context.res = requests.post(f"{context.data['url']}{endpoint}{context.reference}",
                                data=context.body,
                                headers=context.headers)


@step("I capture the App ID")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    response = json.loads(context.res.text)
    context.token = str(response['appId']).replace("\"", "")
    print(f'Captured App ID {context.token}.\n')


@step("I capture the Vault Token")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    response = json.loads(context.res.text)
    context.token = str(response['vaultResponse']['data']).replace("\"", "")


@step("I set the newly created token")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.body = context.body.replace('TOKEN', str(context.token))


@step('response body should contain {message}')
def step_impl(context, message):
    """
    :param message: Message to Look for in a string.
    :type context: behave.runner.Context
    """
    assert str(message) in context.res.text


@step('response body should be blank')
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    assert str('') in context.res.text


@step("response body should match {body}")
def step_impl(context, body):
    """
    :param body: body expected to match response
    :type context: behave.runner.Context
    """
    try:
        assert str(context.res.text) == context.data[body]
    except KeyError:
        assert context.res.text.strip() == context.body, f'\nExpected : {context.body}\n' \
                                                 f'Got      : {context.res.text}'
    except AssertionError as e:
        print(f"Assertion Error: {e}")
