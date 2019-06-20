# -*- coding: UTF-8 -*-
"""
before_step(context, step), after_step(context, step)
    These run before and after every step.
    The step passed in is an instance of Step.
before_scenario(context, scenario), after_scenario(context, scenario)
    These run before and after each scenario is run.
    The scenario passed in is an instance of Scenario.
before_feature(context, feature), after_feature(context, feature)
    These run before and after each feature file is exercised.
    The feature passed in is an instance of Feature.
before_tag(context, tag), after_tag(context, tag)
"""
import json
import platform
import os
import re
import requests
import uuid
from behave import use_step_matcher
from features.support import Config

# -- SETUP: Use cfparse as default matcher
use_step_matcher('cfparse')
with_JIRA = False


def before_all(context):
    global with_JIRA
    # Set Config File to Data variable and check if we are running locally or in Jenkins
    try:
        # We set the data for the Autoamtion using the ENV variable passed Thru jenkins.
        context.data = Config.Config(str(os.environ['ENV'])).save_to_var()
        # We turn the API on.
        with_JIRA = True
        # If this fails we set it to a hardcoded Value, that can be changed according to your needs.
    except KeyError:
        context.data = Config.Config('DEV').save_to_var()
    if with_JIRA:
        # Generate Cycle name
        context.data['Cycle'] = f"{os.environ['BUILD']}-{os.environ['USER']}-{platform.system()}-" \
                                f"{platform.release()}-{uuid.uuid4().hex[:8]}"
        print(context.data['Cycle'])
        # Create Test Cycles
        print(f"{context.data['JIRA']}/createtestcycle/{os.environ['TP']}"
              f"/{context.data['Cycle']}/{os.environ['ENV']}")
        r = requests.get(f"{context.data['JIRA']}/createtestcycle/{os.environ['TP']}"
                         f"/{context.data['Cycle']}/{os.environ['ENV']}")
        # Update test cycle to in Progress
        print(f"{context.data['JIRA']}/updatetestcyclestatus/{os.environ['TP']}"
              f"/{context.data['Cycle']}/Start")
        r = requests.get(f"{context.data['JIRA']}/updatetestcyclestatus/{os.environ['TP']}"
                         f"/{context.data['Cycle']}/Start")
    # Generate an APP ID to Use for the entire Automation
    headers = {'Authorization': f'{context.data["Authorization"]}',
               'sps-user': f'{context.data["SPSUser"]}', 'content_type': 'application/json'}
    url = f'{context.data["url"]}/Applications/New'
    # We sent the Post Request to generate the application ID
    r = requests.post(url, headers=headers)
    response = json.loads(r.text)
    # We capture and store it in the context variable
    context.appId = str(response['appId']).replace("\"", "")
    print(f'App ID for the current run: {context.appId}')


def before_scenario(context, scenario):
    # Create the Dict for holding the headers we will send as part of the request.
    context.headers = dict()
    # Set the Request Body to None, this way we ensure we are not Sending Wrong data in between Scenarios.
    context.body = None
    # Print which scenario we are about to test
    print(f'Starting test for {scenario.tags[0]}: {context.scenario.name}\n')


def after_scenario(context, scenario):
    global with_JIRA
    # Clear the Dict holding the headers after the test.
    context.headers = None
    # Clear the body of the request after the test.
    context.body = None
    # Print which scenario we just tested.
    print(f'Finished test for {scenario.tags[0]}: {context.scenario.name}\n')
    if with_JIRA:
        pattern = re.compile('\w+-\d+')
        tags = list(context.tags)
        for i in tags:
            tck = pattern.match(i)
            if tck:
                if "Status.passed" != str(scenario.status):
                    # Set test case to Failed
                    print("Scenario Failed\n")
                    r = requests.get(f"{context.data['JIRA']}/updatetestcyclerun/{os.environ['TP']}"
                                     f"/{context.data['Cycle']}/{i}/Failed/Failed")
                else:
                    # Set Test case to Passed
                    print("Scenario Passed\n")
                    r = requests.get(f"{context.data['JIRA']}/updatetestcyclerun/{os.environ['TP']}"
                                     f"/{context.data['Cycle']}/{i}/Passed/Passed")


def after_all(context):
    global with_JIRA
    if with_JIRA:
        r = requests.get(f"{context.data['JIRA']}/updatetestcyclestatus/{os.environ['TP']}"
                         f"/{context.data['Cycle']}/Complete")
    # Delete the APP ID to avoid cluttering the DB
    headers = {'Authorization': f'{context.data["Authorization"]}',
               'sps-user': f'{context.data["SPSUser"]}', 'content_type': 'application/json'}
    url = f'{context.data["url"]}/Applications/{context.appId}'
    # We sent the delete Request to eliminate the application ID
    r = requests.delete(url, headers=headers)
    print(f'Deleting App ID for the current run: {context.appId}')
    print(f'Delete Response: {r}')
