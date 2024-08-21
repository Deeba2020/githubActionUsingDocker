*** Settings ***
Documentation       Robot Framework sample test case
Library     SeleniumLibrary


*** Variables ***
${url_sample}               https://se.search.yahoo.com/?fr2=p:fprd,mkt:se
${BROWSER}  headlesschrome
${BROWSER_OPTIONS}  add_argument("--no-sandbox"); add_argument("--disable-gpu"); add_argument("window-size=1920,1080");

*** Test Cases ***
Sample test case with Chrome
    Open Browser        browser=${BROWSER}      options=${BROWSER_OPTIONS}
    Sleep               10s
    Go To   ${url_sample}
    Wait Until Page Contains   Inte sidan du förväntade dig?


*** Keywords ***

#new test case
    #[Documentation]     
    #[Tags]      
    #Click Link 
    #Click Link
