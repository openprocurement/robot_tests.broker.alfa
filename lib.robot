*** Settings ***
Library  Selenium2Library
Library  alfa_service.py
Resource  locators.robot

*** Keywords ***
Домашня сторінка
  [Arguments]  ${username}
  ${broker}=  Get Variable Value  ${USERS.users['${username}'].broker}
  [Return]  ${BROKERS['${broker}'].homepage}

Підготувати клієнт для користувача
  [Arguments]  ${username}
  Set Global Variable  ${question_click_counter}  0
  ${homepage}=  Домашня сторінка  ${username}
  Open Browser  ${homepage}  ${USERS.users['${username}'].browser}  alias=${username}
  Set Window Size   @{USERS.users['${username}'].size}
  Set Window Position  @{USERS.users['${username}'].position}
  Run Keyword If  '${username}' != 'alfa_Viewer'  Login  ${username}

Дочекатися елемента
  [Arguments]  ${selector}
  Wait Until Page Contains Element   ${selector}
  Wait Until Element Is Visible  ${selector}

Натиснути кнопку
  [Arguments]  ${selector}
  Дочекатися елемента  ${selector}
  Click Element  ${selector}

Ввести значення в поле
  [Arguments]  ${selector}  ${value}
  Дочекатися елемента  ${selector}
  Clear Element Text  ${selector}
  Input text   ${selector}  ${value}

#####
### Работа с тендером
###
Заповнити дані тендеру
  [Arguments]  ${tender_data}
  Input text  ${locator.auction.edit.title}  ${tender_data.data.title}
  Input text  ${locator.auction.edit.description}  ${tender_data.data.description}
  Input Date  ${locator.auction.edit.enquiryPeriod.startDate}  ${tender_data.data.enquiryPeriod.startDate}
  Input Date  ${locator.auction.edit.enquiryPeriod.endDate}  ${tender_data.data.enquiryPeriod.endDate}
  Input Date  ${locator.auction.edit.tenderPeriod.startDate}  ${tender_data.data.tenderPeriod.startDate}
  Input Date  ${locator.auction.edit.tenderPeriod.endDate}  ${tender_data.data.tenderPeriod.endDate}
  ${amount}=  Convert To String  ${tender_data.data.value.amount}
  Input text  ${locator.auction.edit.value.amount}  ${amount}
  Select From List  ${locator.auction.edit.value.currency}  ${tender_data.data.value.currency}
  Run Keyword If  ${tender_data.data.value.valueAddedTaxIncluded}  Select Checkbox  ${locator.auction.edit.value.valueAddedTaxIncluded}
  Select Checkbox  id=Auction_MinimalStep_ValueAddedTaxIncluded
  ${amount}=  Convert To String  ${tender_data.data.minimalStep.amount}
  Input text  ${locator.auction.edit.minimalStep.amount}  ${amount}
  Select From List  ${locator.auction.edit.minimalStep.currency}  ${tender_data.data.minimalStep.currency}
  Input text  ${locator.auction.edit.ProcuringEntity.Name}  ${tender_data.data.procuringEntity.name}
  Input text  ${locator.auction.edit.ProcuringEntity.Identifier.Scheme}  ${tender_data.data.procuringEntity.identifier.scheme}
  Input text  ${locator.auction.edit.ProcuringEntity.Identifier.Id}  ${tender_data.data.procuringEntity.identifier.id}
  ${legalName}=  Отримати значення зі словника  ${tender_data.data.procuringEntity.identifier}  legalName
  Input text  ${locator.auction.edit.ProcuringEntity.Identifier.LegalName}  ${legalName}
  Input text  ${locator.auction.edit.procuringEntity.address.countryName}  ${tender_data.data.procuringEntity.address.countryName}
  Input text  ${locator.auction.edit.procuringEntity.address.region}  ${tender_data.data.procuringEntity.address.region}
  Input text  ${locator.auction.edit.procuringEntity.address.locality}  ${tender_data.data.procuringEntity.address.locality}
  Input text  ${locator.auction.edit.procuringEntity.address.streetAddress}  ${tender_data.data.procuringEntity.address.streetAddress}
  Input text  ${locator.auction.edit.procuringEntity.address.postalCode}  ${tender_data.data.procuringEntity.address.postalCode}
  Input text  ${locator.auction.edit.procuringEntity.contactPoint.name}  ${tender_data.data.procuringEntity.contactPoint.name}
  Input text  ${locator.auction.edit.procuringEntity.contactPoint.telephone}  ${tender_data.data.procuringEntity.contactPoint.telephone}

Додати предмет
  [Arguments]  ${item}
  Input text  ${locator.auction.edit.items.item0.description}  ${item.description}
  Input text  ${locator.auction.edit.items.item0.quantity}  ${item.quantity}
  Select From List  ${locator.auction.edit.items.item0.unit.code}  ${item.unit.code}
  Input text  ${locator.auction.edit.items.item0.classification.scheme}  ${item.classification.scheme}
  Input text  ${locator.auction.edit.items.item0.classification.id}  ${item.classification.id}
  Input text  ${locator.auction.edit.items.item0.classification.description}  ${item.classification.description}
  Input text  ${locator.auction.edit.items.item0.deliveryAddress.countryName}  ${item.deliveryAddress.countryName}
  Input text  ${locator.auction.edit.items.item0.deliveryAddress.region}  ${item.deliveryAddress.region}
  Input text  ${locator.auction.edit.items.item0.deliveryAddress.locality}  ${item.deliveryAddress.locality}
  Input text  ${locator.auction.edit.items.item0.deliveryAddress.streetAddress}  ${item.deliveryAddress.streetAddress}
  Input text  ${locator.auction.edit.items.item0.deliveryAddress.postalCode}  ${item.deliveryAddress.postalCode}

Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}
  ${homepage}=  Домашня сторінка  ${username}
  Go To  ${homepage}
  Натиснути кнопку  ${locator.link.auctionsList}
  Wait Until Keyword Succeeds  31 x  10 s  Знайти тендер  ${tender_uaid}

Знайти тендер
  [Arguments]  ${tender_uaid}
  Ввести значення в поле  ${locator.auctionsList.field.search}  ${tender_uaid}
  Select Checkbox  ${locator.auctionsList.button.accurate}
  Натиснути кнопку  ${locator.auctionsList.button.search}
  Натиснути кнопку  ${locator.auctionsList.button.auctionUaid}[contains(text(),'${tender_uaid}')]

Input Date
  [Arguments]  ${elem_name_locator}  ${date}
  ${date}=   convert_date_to_alfa_format   ${date}
  Input Text  ${elem_name_locator}  ${date}

Отримати значення зі словника
  [Arguments]  ${Dictionary Name}  ${Key}
  ${KeyIsPresent}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${Dictionary Name}  ${Key}
  ${Value}=  Run Keyword If  ${KeyIsPresent}  Get From Dictionary  ${Dictionary Name}  ${Key}
  ...  ELSE  Set Variable  ${EMPTY}
  [Return]  ${Value}

Розгорнути коментарi тiльки раз
  ${question_click_counter}=  ${question_click_counter} + 1
  Run Keyword If  ${question_click_counter}==1  Розгорнути коментарi

Розгорнути коментарi
  Execute Javascript  $('div[role=button]').click();

######
#### Проверка отображения
####
Отримати текст із поля і показати на сторінці
  [Arguments]  ${fieldname}
  Wait Until Element Is Visible   ${${fieldname}}
  ${Return_value}=   Get Text   ${${fieldname}}
  [Return]  ${Return_value}

Отримати значення із поля і показати на сторінці
  [Arguments]  ${fieldname}
  Wait Until Element Is Visible   ${${fieldname}}
  ${Return_value}=   Get Value   ${${fieldname}}
  [Return]  ${Return_value}

Отримати інформацію про status
  Reload Page
  ${status}=   Get Text   ${locator.auction.view.auctionStatus}
  ${status}=   convert_string_from_dict_alfa  ${status}
  [Return]  ${status}

Отримати інформацію про title
  ${title}=  Отримати текст із поля і показати на сторінці  locator.auction.view.Title
  [Return]  ${title}

Отримати інформацію про description
  ${description}=  Отримати текст із поля і показати на сторінці  locator.auction.view.Description
  [Return]  ${description}

Отримати інформацію про auctionID
  ${auctionID}=  Отримати текст із поля і показати на сторінці  locator.auction.view.AuctionID
  [Return]  ${auctionID}

Отримати інформацію про value.amount
  ${valueAmount}=  Отримати текст із поля і показати на сторінці  locator.auction.view.Value.Amount
  ${valueAmount}=  Convert To Number   ${valueAmount}
  [Return]  ${valueAmount}

Отримати інформацію про value.currency
  ${currency}=  Отримати текст із поля і показати на сторінці  locator.auction.view.Value.Currency
  ${currency}=  convert_string_from_dict_alfa  ${currency}
  [Return]  ${currency}

Отримати інформацію про minimalStep.amount
  ${minimalStepAmount}=  Отримати текст із поля і показати на сторінці  locator.auction.view.MinimalStep.Amount
  ${minimalStepAmount}=  Convert To Number   ${minimalStepAmount}
  [Return]  ${minimalStepAmount}

Отримати інформацію про enquiryPeriod.startDate
  ${enquiryPeriodStartDate}=  Отримати значення із поля і показати на сторінці  locator.auction.view.enquiryPeriod.startDate
  ${enquiryPeriodStartDate}=  convert_date_from_alfa  ${enquiryPeriodStartDate}
  [Return]  ${enquiryPeriodStartDate}

Отримати інформацію про enquiryPeriod.endDate
  ${enquiryPeriodEndDate}=  Отримати значення із поля і показати на сторінці  locator.auction.view.enquiryPeriod.endDate
  ${enquiryPeriodEndDate}=  convert_date_from_alfa  ${enquiryPeriodEndDate}
  [Return]  ${enquiryPeriodEndDate}

Отримати інформацію про tenderPeriod.startDate
  ${tenderPeriodStartDate}=  Отримати значення із поля і показати на сторінці  locator.auction.view.tenderPeriod.startDate
  ${tenderPeriodStartDate}=  convert_date_from_alfa  ${tenderPeriodStartDate}
  [Return]  ${tenderPeriodStartDate}

Отримати інформацію про tenderPeriod.endDate
  ${tenderPeriodEndDate}=  Отримати значення із поля і показати на сторінці  locator.auction.view.tenderPeriod.endDate
  ${tenderPeriodEndDate}=  convert_date_from_alfa  ${tenderPeriodEndDate}
  [Return]  ${tenderPeriodEndDate}

Отримати інформацію про value.valueAddedTaxIncluded
  ${tax}=  Отримати текст із поля і показати на сторінці  locator.auction.view.value.valueAddedTaxIncluded
  ${tax}=  Convert To Boolean  ${tax}
  [Return]  ${tax}

Отримати інформацію про procuringEntity.name
  ${legalName}=  Отримати текст із поля і показати на сторінці  locator.auction.view.ProcuringEntity.Name
  [Return]  ${legalName}

Отримати інформацію про items[0].deliveryDate.endDate
  Fail   ***** Не підтримується *****

Отримати інформацію про items[0].deliveryLocation.latitude
  Fail   ***** Не підтримується *****

Отримати інформацію про items[0].deliveryLocation.longitude
  Fail   ***** Не підтримується *****

Отримати інформацію про items[0].deliveryAddress.countryName
  ${countryName}=  Отримати текст із поля і показати на сторінці  locator.auction.view.item.DeliveryAddress.CountryName0
  [Return]  ${countryName}

Отримати інформацію про items[0].deliveryAddress.postalCode
  ${postalCode}=  Отримати текст із поля і показати на сторінці  locator.auction.view.item.DeliveryAddress.PostalCode0
  [Return]  ${postalCode}

Отримати інформацію про items[0].deliveryAddress.region
  ${region}=  Отримати текст із поля і показати на сторінці  locator.auction.view.item.DeliveryAddress.Region0
  [Return]  ${region}

Отримати інформацію про items[0].deliveryAddress.locality
  ${locality}=  Отримати текст із поля і показати на сторінці  locator.auction.view.item.DeliveryAddress.Locality0
  [Return]  ${locality}

Отримати інформацію про items[0].deliveryAddress.streetAddress
  ${streetAddress}=  Отримати текст із поля і показати на сторінці  locator.auction.view.item.DeliveryAddress.StreetAddress0
  [Return]  ${streetAddress}

Отримати інформацію про items[0].classification.scheme
  ${classificationScheme}=  Отримати текст із поля і показати на сторінці  locator.auction.view.item.Classification.scheme0
  [Return]  ${classificationScheme}

Отримати інформацію про items[0].classification.id
  ${classificationId}=  Отримати текст із поля і показати на сторінці  locator.auction.view.item.Classification.Id0
  [Return]  ${classificationId}

Отримати інформацію про items[0].classification.description
  ${classificationDescription}=  Отримати текст із поля і показати на сторінці  locator.auction.view.item.Classification.Description0
  ${classificationDescription}=  convert_string_from_dict_alfa  ${classificationDescription}
  [Return]  ${classificationDescription}

Отримати інформацію про items[0].unit.name
  ${unitName}=  Отримати текст із поля і показати на сторінці  locator.auction.view.item.Unit.Name0
  [Return]  ${unitName}

Отримати інформацію про items[0].unit.code
  ${unitCode}=  Отримати текст із поля і показати на сторінці  locator.auction.view.item.Unit.Code0
  [Return]  ${unitCode}

Отримати інформацію про items[0].quantity
  ${itemsQuantity}=  Отримати текст із поля і показати на сторінці  locator.auction.view.item.Quantity0
  ${itemsQuantity}=  Convert To Integer  ${itemsQuantity}
  [Return]  ${itemsQuantity}

Отримати інформацію про items[0].description
  ${itemsDescription}=  Отримати текст із поля і показати на сторінці  locator.auction.view.item.Description0
  [Return]  ${itemsDescription}

######
#### запитання
####
Отримати інформацію про questions[0].answer
  Натиснути кнопку  ${locator.auction.view.tab.questions}
  Розгорнути коментарi
  ${questionsAnswer}=   Отримати текст із поля і показати на сторінці   locator.auction.view.questions.field.Answer
  [Return]  ${questionsAnswer}

Отримати інформацію про questions[0].title
  Натиснути кнопку  ${locator.auction.view.tab.questions}
  Розгорнути коментарi
  ${questionsTitle}=   Отримати текст із поля і показати на сторінці   locator.auction.view.questions.field.Title
  [Return]  ${questionsTitle}

Отримати інформацію про questions[0].description
  Натиснути кнопку  ${locator.auction.view.tab.questions}
  Розгорнути коментарi
  ${questionsDescription}=   Отримати текст із поля і показати на сторінці   locator.auction.view.questions.field.Description
  [Return]  ${questionsDescription}

Отримати інформацію про questions[0].date
  Натиснути кнопку  ${locator.auction.view.tab.questions}
  Розгорнути коментарi
  ${questionsDate}=   Отримати текст із поля і показати на сторінці   locator.auction.view.questions.field.Date
  ${questionsDate}=   convert_date_from_alfa   ${questionsDate}
  [Return]  ${questionsDate}
