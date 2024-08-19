
*** Settings ***
Documentation    lab-1 using docker
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${login-E-mail}        //input[@id='email']
${loginButton}     //button[@id='login']
${primaryEmail}        deebarf@gmail.com
${primaryPassword}        infotiv2024
${continueButton}       //button[@id='continue']
${backToDate}       //button[@id='backToDateButton']
${confirmButton}        //button[@id='confirm']
${passengersButton}         //div[@id='ms-list-2']//button[@type='button']
${Audi}     //input[@id='ms-opt-1']
${passengerNum}     //input[@id='ms-opt-9']
${mypageButton}       //button[@id='mypage']
${cardNumber}      1234567812345678
${cardMonth}       6
${cardYear}         2018
${cardCVC}        123
${cardHolder}      Deba
${about-button}         //a[@id='about']
${Welcome}      Welcome

*** Keywords ***
website opens correctly and make sure user is not logged in
    [Documentation]     check if website is open correctly
    [Tags]        VG_test
    Open Browser    browser=Chrome
    Go To   https://rental13.infotiv.net/
    Maximize Browser Window
    ${infotivLogo}=       Run Keyword And Return Status      Wait Until Element Is Visible    //h1[@id='title']
    IF    '${infotivLogo}' == 'True'
        Log    website status: website opened successfuly infotivLogo is visible
    ELSE
        Log    website status: website could not be opened and infotivLogo is not visible
    END
    Wait Until Page Contains    When do you want to make your trip?
    Wait Until Element Is Visible   //h1[@id='questionText']
    Wait Until Element Is Visible    ${login-E-mail}


user enters correct password and email to log in using existing credentials
    [Documentation]     logging in
    [Tags]       VG_test
    [Arguments]     ${email}     ${password}
    Input Text      ${login-E-mail}       ${email}
    Input Password     //input[@id='password']      ${password}
    Click Button    ${loginButton}
    Wait Until Page Contains    You are signed in as Deba
    ${account}=       Run Keyword And Return Status      Wait Until Page Contains    You are signed in as Sara
    IF    '${account}' == 'True'
        Log    login status: You are signed-in by secondary account
    ELSE
        Log    login status: You are signed-in by primary account
    END


user can click on my page to see booking history
   [Documentation]     to make sure all functionality is working after user logged in
   [Tags]       VG_test
   Click Button    ${mypageButton}


user can click log out button after signing in
    [Documentation]     logging out
    [Tags]       VG_test
    Click Button    //button[@id='logout']
    Wait Until Element Is Visible    ${loginButton}
    Close Browser


user books a car and see booking confirmation text
  [Documentation]     to click continue and use the defualt today date
  [Tags]        VG_test
  [Arguments]       ${cardNumberArg}       ${cardHolderArg}       ${cardMonthArg}        ${cardYearArg}     ${cardCVCArg}
  Click Button    ${continueButton}
  Wait Until Page Contains    What would you like to drive?
  Wait Until Element Is Visible    ${backToDate}
  Click Button    //tbody/tr[1]/td[5]/form[1]/input[4]
  Wait Until Element Is Visible    ${confirmButton}
  Wait Until Element Is Visible    //h1[@id='questionText']
  Input Text    //input[@id='cardNum']    ${cardNumberArg}
  Input Text    //input[@id='fullName']    ${cardHolderArg}
  Select From List By Label    //select[@title='Month']       ${cardMonthArg}
  Select From List By Label    //select[@title='Year']       ${cardYearArg}
  Input Text    //input[@id='cvc']    ${cardCVCArg}
  Click Button    ${confirmButton}
  Wait Until Page Contains    is now ready for pickup
  Wait Until Page Contains    You can view your booking on your page
  Wait Until Element Is Visible       //h1[@id='questionTextSmall']
  Wait Until Element Is Visible       //button[@id='home']


user can verify that the car is booked by clicking on my page
    [Documentation]     to be able to go to my page and see user history
    [Tags]        VG_test
    Click Button       ${mypageButton}
    Wait Until Element Is Visible       //td[@id='licenseNumber1']
    Wait Until Element Is Visible    //button[@id='unBook1']
    Close Browser


user filter car according to number of passenger
    [Documentation]     to filter car according to number of passenger
    [Tags]      VG_test
    [Arguments]    ${passengerNumArg}
    Click Button    ${continueButton}
    Wait Until Element Is Visible    ${passengersButton}
    Click Element    ${passengersButton}
    Click Element    ${passengerNumArg}
    Wait Until Element Is Visible    //td[normalize-space()='Vivaro']
    Wait Until Page Contains    Opel
    Wait Until Page Contains    9


user can click on back to date button
    [Documentation]     click on back to date button
    [Tags]      VG_test
    Wait Until Element Is Visible    ${backToDate}
    Click Button    ${backToDate}
    Wait Until Page Contains    When do you want to make your trip?
    Close Browser


user can click on about button and about page will be visible
    [Documentation]     click on about button
    [Tags]      VG_test
    Click Button       ${mypageButton}
    Wait Until Element Is Visible    ${about-button}
    Click Element    ${about-button}
    Wait Until Element Is Visible    //div[@id='mainWrapperBody']//a[1]
    ${currentPage}=       Run Keyword And Return Status      Wait Until Page Contains    ${Welcome}
    IF    '${currentPage}' == 'True'
        Log    current page: ${Welcome} text appeared
    ELSE
        Log    current page: ${Welcome} text did not appear
    END


user both filter on car selection page and the filtered car is not available
    [Documentation]     to test the case when filtered car is not available
    [Tags]      VG_test
    [Arguments]    ${passengerNumArg}       ${selectedCarArg}
    Click Button    ${continueButton}
    Wait Until Element Is Visible    ${passengersButton}
    Click Element    ${passengersButton}
    Click Element    ${passengerNumArg}
    Click Element    //div[@id='ms-list-1']//button[@type='button']
    Click Element    ${selectedCarArg}


user gets instruction to choose different car since the filtered car is not available
    [Documentation]     to test the case when filtered car is not available user gets informed
    [Tags]      VG_test
    Wait Until Page Contains    No cars with selected filters. Please edit filter selection.
    Close Browser


select a date which is earlier than today date
  [Documentation]     renting car
  [Tags]        VG_test
  Input Text      //input[@id='start']       02
  Input Text      //input[@id='start']        13
  Input Text      //input[@id='end']       03
  Input Text      //input[@id='end']        13
  Click Button    ${continueButton}


user can not continue to the next page
  [Documentation]     user can not got to next page
  [Tags]        VG_test
  Wait Until Page Does Not Contain    What would you like to drive?
  Close Browser


using today's date automatically
    [Documentation]     set date to today's date automatically
    [Tags]       VG_test
    ${todayDate}=    Get Time    dateFormat=%y-%m-%d
    ${year}=    Evaluate    "${todayDate}"[0:4]
    ${month}=    Evaluate    "${todayDate}"[5:7]
    ${day}=    Evaluate    "${todayDate}"[8:]
    Input Text    //input[@id='start']    ${month}
    Input Text      //input[@id='start']        ${day}
    Click Button    ${continueButton}


user can go to the booking car page and select a car
    [Documentation]     to go to book car page and select a car
    [Tags]       VG_test
    Wait Until Page Contains    Selected trip dates:
    Click Button    //tbody/tr[1]/td[5]/form[1]/input[4]
    Close Browser


*** Test Cases ***
login with existing credentials successfuly
    given website opens correctly and make sure user is not logged in
    when user enters correct password and email to log in using existing credentials       ${primaryEmail}      ${primaryPassword}
    and user can click on my page to see booking history
    then user can click log out button after signing in


to book a car and verify that it is booked
    given website opens correctly and make sure user is not logged in
    and user enters correct password and email to log in using existing credentials     ${primaryEmail}      ${primaryPassword}
    when user books a car and see booking confirmation text       ${cardNumber}      ${cardHolder}      ${cardMonth}       ${cardYear}        ${cardCVC}
    then user can verify that the car is booked by clicking on my page


to filter a car and verify that it is filtered
    given website opens correctly and make sure user is not logged in
    and user enters correct password and email to log in using existing credentials     ${primaryEmail}      ${primaryPassword}
    when user filter car according to number of passenger       ${passengerNum}
    then user can click on back to date button


to test user can go to about page from my page
    given website opens correctly and make sure user is not logged in
    and user enters correct password and email to log in using existing credentials     ${primaryEmail}      ${primaryPassword}
    when user can click on about button and about page will be visible
    then user can click log out button after signing in


to test user gets informed when filtering a car which is not available
    given website opens correctly and make sure user is not logged in
    and user enters correct password and email to log in using existing credentials     ${primaryEmail}      ${primaryPassword}
    when user both filter on car selection page and the filtered car is not available       ${passengerNum}     ${Audi}
    then user gets instruction to choose different car since the filtered car is not available


user fails to continue to next page when entering a date earlier than today date
    given website opens correctly and make sure user is not logged in
    and user enters correct password and email to log in using existing credentials     ${primaryEmail}      ${primaryPassword}
    when select a date which is earlier than today date
    then user can not continue to the next page


use today's date automatically to book car without user interaction
    given website opens correctly and make sure user is not logged in
    and user enters correct password and email to log in using existing credentials     ${primaryEmail}      ${primaryPassword}
    when using today's date automatically
    then user can go to the booking car page and select a car

