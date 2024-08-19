*** Settings ***
Documentation    lab-1 using docker
Library    SeleniumLibrary
Library    Collections

*** Variables ***

${Welcome}      Welcome

*** Keywords ***
website opens correctly
    [Documentation]     check if website is open correctly
    [Tags]
    Open Browser    browser=Chrome
    Go To   https://sverigesradio.se/goteborg


click button
    [Documentation]     logging in
    [Tags]       VG_test
    Click Element    https://sverigesradio.se/goteborg



*** Test Cases ***
website opnes successfuly
    given website opens correctly
