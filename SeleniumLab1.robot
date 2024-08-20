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
    Open Browser    https://sverigesradio.se/goteborg    browser=headlesschrome
    Go To   https://sverigesradio.se/goteborg

click gothenburg radio
    [Documentation]     logging in
    [Tags]
    Click Element    //span[@class='title']

*** Test Cases ***
website opens successfully
    given website opens correctly
