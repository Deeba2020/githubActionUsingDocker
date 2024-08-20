*** Settings ***
Documentation    lab-1 using docker
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${CHROME_OPTIONS}   --headless  --no-sandbox  --disable-dev-shm-usage  --disable-gpu

*** Keywords ***
website opens correctly
    [Documentation]     Check if the website opens correctly.
    Open Browser    https://sverigesradio.se/goteborg   chrome  options=${CHROME_OPTIONS}

click gothenburg radio
    [Documentation]     Click on the Gothenburg Radio link.
    Click Element    //span[@class='title']
    Click Element    //span[@class='title']

*** Test Cases ***
website opens successfully
    [Documentation]     Test to ensure the website opens successfully.
    website opens correctly
    # click gothenburg radio    # Uncomment if you need to click after opening
    Close Browser
