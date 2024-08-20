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
    Open Browser    browser=headlessChrome
    Go To   https://sverigesradio.se/goteborg


click gothenburg radio
    [Documentation]     logging innnnnnndrr
    [Tags]
    Click Element    //span[@class='title']



*** Test Cases ***
website opnes successfuly
    given website opens correctly


#click button
    #given website opens correctly
    #then click gothenburg radio
