*** Settings ***
Library  Selenium2Screenshots
Library  Selenium2Library
Library  String
Library  Collections
Library  DateTime
Library  alfa_service.py

*** Variables ***
${locator.auctionID}               xpath=//td[contains(text(),'Ідентифікатор аукціону')]/following-sibling::td[1]
${locator.title}                   xpath=//div[@class='topInfo']/h1
${locator.description}             xpath=//h2[@class='tenderDescr']
${locator.value.amount}            xpath=//section[2]/h3[contains(text(),'Параметри аукціону')]/following-sibling::table//tr[1]/td[2]/span[1]
${locator.legalName}               xpath=//td[contains(text(),'Найменування організатора')]/following-sibling::td//span
${locator.minimalStep.amount}      xpath=//td[contains(text(),'Мінімальний крок аукціону')]/following-sibling::td/span[1]
${locator.enquiryPeriod.endDate}   xpath=//td[contains(text(),'Дата завершення періоду уточнень')]/following-sibling::td[1]
${locator.tenderPeriod.endDate}    xpath=//td[contains(text(),'Кінцевий строк подання пропозицій')]/following-sibling::td[1]
${locator.tenderPeriod.startDate}  xpath=//td[contains(text(),'Дата початку прийому пропозицій')]/following-sibling::td[1]
${locator.items.Description}       xpath=//div[@class="tenderItemElement"]/table/tbody/tr[1]/td[2]
${locator.items.deliveryAddress.countryName}      xpath=//div[@class="tenderItemElement"]/table/tbody/tr[4]/td[2]
${locator.items.deliveryAddress.postalCode}       xpath=//div[@class="tenderItemElement"]/table/tbody/tr[4]/td[2]
${locator.items.deliveryAddress.locality}         xpath=//div[@class="tenderItemElement"]/table/tbody/tr[4]/td[2]
${locator.items.deliveryAddress.streetAddress}    xpath=//div[@class="tenderItemElement"]/table/tbody/tr[4]/td[2]
${locator.items.deliveryAddress.region}           xpath=//div[@class="tenderItemElement"]/table/tbody/tr[4]/td[2]
${locator.items.deliveryDate.endDate}             xpath=//div[@class="tenderItemElement"]/table/tbody/tr[5]/td[2]
${locator.items.classification.scheme}            xpath=//div[@class="tenderItemElement"]/table/tbody/tr[2]/td[1]
${locator.items.classification.id}                xpath=//div[@class="tenderItemElement"]/table/tbody/tr[2]/td[2]/span[1]
${locator.items.classification.description}       xpath=//div[@class="tenderItemElement"]/table/tbody/tr[2]/td[2]/span[2]
${locator.items.quantity}         xpath=//div[@class="tenderItemElement"]/table/tbody/tr[3]/td[2]/span[1]
${locator.items.unit.code}        xpath=//div[@class="tenderItemElement"]/table/tbody/tr[3]/td[2]/span[2]
${locator.items.unit.name}        xpath=//div[@class="tenderItemElement"]/table/tbody/tr[3]/td[2]/span[2]
${locator.questions.title}        xpath=//div[@class = 'question relative']//div[@class = 'title']
${locator.questions.description}  xpath=//div[@class='text']
${locator.questions.date}         xpath=//div[@class='date']
${locator.questions.answer}       xpath=//div[@class = 'answer relative']//div[@class = 'text']
${locator.currency}                  xpath=//section[2]/h3[contains(text(),'Параметри аукціону')]/following-sibling::table//tr[1]/td[2]/span[2]
${locator.tax}                       xpath=//span[@class='taxIncluded']
${locator.ModalOK}                   xpath=//a[@class="jBtn green"]
${locator.auctionPeriod.startDate}     xpath=//td[contains(text(), 'Дата початку аукціону')]/following-sibling::td[1]


*** Keywords ***
Підготувати дані для оголошення тендера користувачем
  [Arguments]  ${username}  ${tender_data}  ${role_name}
  ${tender_data}=   adapt_data_for_role   ${role_name}   ${tender_data}
  [return]  ${tender_data}

Підготувати клієнт для користувача
  [Arguments]  ${username}
  Open Browser   ${USERS.users['${username}'].homepage}   ${USERS.users['${username}'].browser}   alias=${username}
  Set Window Size   @{USERS.users['${username}'].size}
  Set Window Position   @{USERS.users['${username}'].position}
  Wait Until Element Is Visible   name=siteLogin
  Input Text   name=siteLogin   admin
  Input Text   name=sitePass   uStudio_alfa
  Click Element   xpath=//input[@value="Войти"]
  Run Keyword If   '${username}' != 'alfa_viewer'   Login   ${username}

Login
  [Arguments]  ${username}
  Wait Until Page Contains Element   jquery=a[href="/cabinet"]
  Click Element   jquery=a[href="/cabinet"]
  Wait Until Page Contains Element   name=email   10
  Input text   name=email   ${USERS.users['${username}'].login}
  Execute Javascript   $('input[name="email"]').attr('rel','CHANGE');
  Wait Until Element Is Visible   name=psw
  Input text   name=psw   ${USERS.users['${username}'].password}
  Wait Until Page Contains Element   xpath=//button[contains(@class, 'btn')][./text()='Вхід в кабінет']   20
  Click Element   xpath=//button[contains(@class, 'btn')][./text()='Вхід в кабінет']


###############################################################################################################
######################################    СТВОРЕННЯ ТЕНДЕРУ    ################################################
###############################################################################################################

Створити тендер
  [Arguments]  ${username}  ${tender_data} 
  ${items}=   Get From Dictionary   ${tender_data.data}   items
  ${budget}=   add_second_sign_after_point   ${tender_data.data.value.amount}
  ${tax}=   Convert To String   ${tender_data.data.value.valueAddedTaxIncluded}
  ${minimalStep}=   add_second_sign_after_point   ${tender_data.data.minimalStep.amount}
  Wait Until Page Contains Element   jquery=a[href="/tenders/new"]   30
  Click Element   jquery=a[href="/tenders/new"]
  Wait Until Page Contains Element   name=data[title]   30
  Run Keyword And Ignore Error   Click Element   xpath=//a[@class="close icons"]
  Execute Javascript   $(".topFixed").remove();
  Wait Until Page Contains Element   name=data[title]   30
  Input Text   name=data[value][amount]   ${budget}
  Input Text   name=data[minimalStep][amount]   ${minimalStep}
  Select From List By Value   name=data[value][currency]   ${tender_data.data.value.currency}
  Select From List By Value   name=data[value][valueAddedTaxIncluded]   ${tax.lower()}
  Click Element   xpath=//section[@id="multiItems"]/a
  Додати предмет   ${items[0]}
  Input text   name=data[title]   ${tender_data.data.title}
  Input text   name=data[description]   ${tender_data.data.description}  
  Input Date   data[enquiryPeriod][endDate]   ${tender_data.data.enquiryPeriod.endDate}
  Input Date   data[tenderPeriod][endDate]   ${tender_data.data.tenderPeriod.endDate}
  Click Element   xpath= //button[@value='publicate']
  Wait Until Page Contains   Аукціон опубліковано   10
  ${tender_uaid}=   Get Text   ${locator.auctionID}  
  [return]  ${tender_uaid}

Додати предмет
  [Arguments]  ${item}
  ${index}=   Get Element Attribute   xpath=(//div[@class="tenderItemElement tenderItemPositionElement"])[last()]@data-multiline
  Execute Javascript   $(".topFixed").remove();
  Wait Until Page Contains Element   name=data[items][${index}][description]
  Input text   name=data[items][${index}][description]   ${item.description}
  Input text   name=data[items][${index}][quantity]   ${item.quantity}
  Select From List By Label   name=data[items][${index}][unit_id]   ${item.unit.name}
  Click Element   xpath=//input[@name='data[items][${index}][cpv_id]']/preceding-sibling::a
  Select Frame   xpath=//iframe[contains(@src,'/js/classifications/universal/index.htm?lang=uk&shema=CAV&relation=true')]
  Wait Until Page Contains   ${item.classification.id}
  Click Element   xpath=//a[contains(@id,'${item.classification.id.replace('-','_')}')]
  Click Element   xpath=//*[@id='select']
  Unselect Frame
  Select From List By Label   name=data[items][${index}][country_id]   ${item.deliveryAddress.countryName}
  Select From List By Label   name=data[items][${index}][region_id]   ${item.deliveryAddress.region}
  Input text   name=data[items][${index}][deliveryAddress][locality]   ${item.deliveryAddress.locality}
  Input text   name=data[items][${index}][deliveryAddress][streetAddress]   ${item.deliveryAddress.streetAddress}
  Input text   name=data[items][${index}][deliveryAddress][postalCode]   ${item.deliveryAddress.postalCode}
  
Input Date
  [Arguments]  ${elem_name_locator}  ${date}
  ${date}=   convert_date_to_slash_format   ${date}
  Focus   name=${elem_name_locator}
  Execute Javascript   $("input[name|='${elem_name_locator}']").removeAttr('readonly'); $("input[name|='${elem_name_locator}']").unbind();
  Input Text  ${elem_name_locator}  ${date}

Завантажити документ
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}
  alfa.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
  Wait Until Element Is Visible   xpath=//a[contains(text(),'Редагувати')]
  Click Element   xpath=//a[contains(text(),'Редагувати')]
  Wait Until Element Is Visible   xpath=//h3[contains(text(),'Документація до аукціону')]/following-sibling::a
  Click Element   xpath=//h3[contains(text(),'Документація до аукціону')]/following-sibling::a  
  Execute Javascript   $('body > div').attr('style', '');
  Choose File   xpath=//div[1]/form/input[@name="upload"]  ${filepath}
  Click Button   xpath=//button[@value='save']

Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}
  Switch browser   ${username}
  Go To   ${USERS.users['${username}'].homepage}
  Wait Until Page Contains   Держзакупівлі.онлайн   10
  Click Element   xpath=//a[text()='Аукціони']
  Wait Until Element Is Visible   xpath=//a[@href='/tenders/all']
  Click Element   xpath=//a[@href='/tenders/all']
  Wait Until Page Contains Element   xpath=//select[@name='filter[object]']/option[@value='tenderID']
  Click Element   xpath=//select[@name='filter[object]']/option[@value='tenderID']
  Input text   xpath=//input[@name='filter[search]']   ${tender_uaid}
  Focus   name=filter[search2]
  Wait Until Keyword Succeeds   12 x   10 s   Знайти тендер   ${tender_uaid}
  
Знайти тендер
  [Arguments]  ${tender_uaid}
  Click Element   xpath=//button[@class='btn not_toExtend'][./text()='Пошук']
  Wait Until Page Contains   ${tender_uaid}   10
  Click Element   xpath=//span[contains('${tender_uaid}', text()) and contains(text(), '${tender_uaid}')]/../preceding-sibling::h2/a
  Wait Until Page Contains    ${tender_uaid}


###############################################################################################################
###########################################    ПИТАННЯ    #####################################################
###############################################################################################################

Задати питання
  [Arguments]  ${username}  ${tender_uaid}  ${question}
  alfa.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
  Execute Javascript   window.scroll(2500,2500)
  Click Element   xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]
  Wait Until Element Is Visible   xpath=//form[@id="question_form"]/descendant::input[@name="title"]
  Input Text   xpath=//form[@id="question_form"]/descendant::input[@name="title"]   ${question.data.title}
  Input Text   xpath=//form[@id="question_form"]/descendant::textarea[@name="description"]   ${question.data.description}
  Click Element   xpath=//button[contains(text(), 'Надіслати запитання')]
  Wait Until Element Is Visible   xpath=//a[./text()= 'Закрити']
  Click Element   xpath=//a[./text()= 'Закрити']
  
Відповісти на питання
  [Arguments]  ${username}  ${tender_uaid}  ${question_index}  ${answer_data}  ${question_id}
  alfa.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
  Execute Javascript   window.scroll(2500,2500)
  Click Element   xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]
  Input Text   xpath=//div[contains(text(), '${question_id}')]/../following-sibling::div/descendant::textarea[@name="answer"]   ${answer_data.data.answer}
  Click Element   xpath=//button[contains(text(), 'Опублікувати відповідь')]
  Wait Until Element Is Visible   xpath=//a[./text()= 'Закрити']
  Click Element   xpath=//a[./text()= 'Закрити']


###############################################################################################################
###################################    ВНЕСЕННЯ ЗМІН У ТЕНДЕР   ###############################################
###############################################################################################################

Внести зміни в тендер
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  ${field_locator}=   get_field_locator   ${fieldname}
  ${fieldvalue}=   adapt_data_for_document   ${fieldname}   ${fieldvalue}
  alfa.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
  Click Element   xpath=//a[@class='button save'][./text()='Редагувати']
  sleep   1
  Run Keyword If   '${fieldname}' != 'tenderPeriod.endDate'   Input Text   ${field_locator}   ${fieldvalue}
  ...   ELSE   Execute Javascript   $("input[name|='data[tenderPeriod][endDate]']").attr('value', '${fieldvalue}');
  sleep   1
  Click Element   xpath=//button[@value='save']
  
  
###############################################################################################################

Оновити сторінку з тендером
  [Arguments]  ${username}  ${tender_uaid}
  Reload Page


###############################################################################################################
###################################    ПЕРЕВІРКА ВІДОБРАЖЕННЯ   ###############################################
###############################################################################################################

Отримати інформацію із тендера
  [Arguments]  ${username}  ${field_name}
  Switch browser   ${username}
  Run Keyword And Return   Отримати інформацію про ${field_name}

Отримати текст із поля і показати на сторінці
  [Arguments]  ${fieldname}
  Wait Until Element Is Visible   ${locator.${fieldname}}
  ${return_value}=   Get Text   ${locator.${fieldname}}
  [return]  ${return_value}
  
Отримати інформацію про status
  Reload Page
  ${status}=   Get Text   xpath=//div[@class="statusItem active"]/descendant::div[@class="statusName"]
  ${status}=   convert_string_from_dict_alfa  ${status} 
  [return]  ${status}

Отримати інформацію про title
  Execute Javascript   $('.topInfo>h1').css('text-transform', 'initial');
  ${title}=   Отримати текст із поля і показати на сторінці   title
  [return]  ${title}

Отримати інформацію про description
  ${description}=   Отримати текст із поля і показати на сторінці   description
  [return]  ${description}

Отримати інформацію про auctionID
  ${auctionID}=   Отримати текст із поля і показати на сторінці   auctionID
  [return]  ${auctionID}

Отримати інформацію про value.amount
  ${valueAmount}=   Отримати текст із поля і показати на сторінці   value.amount
  ${valueAmount}=   Replace String   ${valueAmount}   `   ${EMPTY}
  ${valueAmount}=   Convert To Number   ${valueAmount}
  [return]  ${valueAmount}

Отримати інформацію про minimalStep.amount
  ${minimalStepAmount}=   Отримати текст із поля і показати на сторінці   minimalStep.amount
  ${minimalStepAmount}=   Replace String   ${minimalStepAmount}   `   ${EMPTY}
  ${minimalStepAmount}=   Convert To Number   ${minimalStepAmount.split(' ')[0]}
  [return]  ${minimalStepAmount}

Отримати інформацію про enquiryPeriod.startDate
  Fail    ***** Дата початку періоду уточнень не виводиться на ДЗО *****

Отримати інформацію про enquiryPeriod.endDate
  ${enquiryPeriodEndDate}=   Отримати текст із поля і показати на сторінці   enquiryPeriod.endDate
  ${enquiryPeriodEndDate}=   subtract_from_time   ${enquiryPeriodEndDate}   0   -1
  [return]  ${enquiryPeriodEndDate}

Отримати інформацію про tenderPeriod.startDate
  ${tenderPeriodStartDate}=   Отримати текст із поля і показати на сторінці   tenderPeriod.startDate
  ${tenderPeriodStartDate}=   subtract_from_time   ${tenderPeriodStartDate}   -1   0
  [return]  ${tenderPeriodStartDate}

Отримати інформацію про tenderPeriod.endDate
  ${tenderPeriodEndDate}=   Отримати текст із поля і показати на сторінці   tenderPeriod.endDate
  ${tenderPeriodEndDate}=   subtract_from_time   ${tenderPeriodEndDate}   0   0
  [return]  ${tenderPeriodEndDate}

Отримати інформацію про items[0].deliveryDate.endDate
  ${deliveryDateEndDate}=   Отримати текст із поля і показати на сторінці   items.deliveryDate.endDate
  ${deliveryDateEndDate}=   subtract_from_time   ${deliveryDateEndDate}   0   0
  [return]  ${deliveryDateEndDate}

Отримати інформацію про items[0].classification.id
  ${classificationId}=   Отримати текст із поля і показати на сторінці   items.classification.id
  [return]  ${classificationId}

Отримати інформацію про items[0].classification.description
  ${classificationDescription}=   Отримати текст із поля і показати на сторінці   items.classification.description
  ${classificationDescription}=   convert_string_from_dict_alfa   ${classificationDescription}
  [return]  ${classificationDescription}

Отримати інформацію про items[0].classification.scheme
  ${classificationScheme}=   Отримати текст із поля і показати на сторінці   items.classification.scheme
  [return]  ${classificationScheme.split(' ')[1]}

Отримати інформацію про items[0].quantity
  ${itemsQuantity}=   Отримати текст із поля і показати на сторінці   items.quantity
  ${itemsQuantity}=   Convert To Integer   ${itemsQuantity}
  [return]  ${itemsQuantity}

Отримати інформацію про items[0].unit.code
  Fail   ***** Код одиниці вимірювання не виводиться на ДЗО *****

Отримати інформацію про items[0].deliveryLocation.longitude
  Fail   ***** Довгота не виводиться на ДЗО *****

Отримати інформацію про items[0].deliveryLocation.latitude
  Fail   ***** Широта не виводиться на ДЗО *****

Отримати інформацію про items[0].unit.name
  ${unitName}=   Отримати текст із поля і показати на сторінці   items.unit.name
  [return]  ${unitName}

Отримати інформацію про items[0].description
  ${itemsDescription}=   Отримати текст із поля і показати на сторінці   items.Description
  [return]  ${itemsDescription}
  
Отримати інформацію про items[0].deliveryAddress.countryName
  ${countryName}=   Отримати текст із поля і показати на сторінці   items.deliveryAddress.countryName
  [return]  ${countryName.split(',')[1].strip()}

Отримати інформацію про items[0].deliveryAddress.postalCode
  ${postalCode}=   Отримати текст із поля і показати на сторінці   items.deliveryAddress.postalCode
  [return]  ${postalCode.split(',')[0]}

Отримати інформацію про items[0].deliveryAddress.locality
  ${locality}=   Отримати текст із поля і показати на сторінці   items.deliveryAddress.locality
  [return]  ${locality.split(',')[3].strip()}

Отримати інформацію про items[0].deliveryAddress.streetAddress
  ${streetAddress}=   Отримати текст із поля і показати на сторінці   items.deliveryAddress.streetAddress
  ${streetAddress}=   get_street   ${streetAddress.split(',')[4:]}
  [return]  ${streetAddress}

Отримати інформацію про items[0].deliveryAddress.region
  ${region}=   Отримати текст із поля і показати на сторінці   items.deliveryAddress.region
  [return]  ${region.split(',')[2].strip()}

Отримати інформацію про questions[0].title
  Click Element   xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]
  ${questionsTitle}=   Отримати текст із поля і показати на сторінці   questions.title
  [return]  ${questionsTitle}

Отримати інформацію про questions[0].description
  ${questionsDescription}=   Отримати текст із поля і показати на сторінці   questions.description
  [return]  ${questionsDescription}

Отримати інформацію про questions[0].date
  ${questionsDate}=   Отримати текст із поля і показати на сторінці   questions.date
  ${questionsDate}=   subtract_from_time   ${questionsDate}   0   0   ,
  [return]  ${questionsDate}

Отримати інформацію про questions[0].answer
  Click Element   xpath=//a[@class='reverse openCPart'][span[text()='Обговорення']]
  ${questionsAnswer}=   Отримати текст із поля і показати на сторінці   questions.answer
  [return]  ${questionsAnswer}
  
Отримати інформацію про procuringEntity.name
  ${legalName}=   Отримати текст із поля і показати на сторінці   legalName
  [return]  ${legalName}

Отримати інформацію про value.currency
  ${currency}=   Отримати текст із поля і показати на сторінці   currency
  ${currency}=   convert_string_from_dict_alfa   ${currency}
  [return]  ${currency}

Отримати інформацію про value.valueAddedTaxIncluded
  ${tax}=   Отримати текст із поля і показати на сторінці   tax
  ${tax}=   convert_string_from_dict_alfa   ${tax}
  ${tax}=   Convert To Boolean   ${tax}
  [return]  ${tax}

Отримати інформацію про auctionPeriod.startDate
  ${auction_startDate}=   Get Text   ${locator.auctionPeriod.startDate}
  [return]  ${auction_startDate}
  

###############################################################################################################
######################################    ПОДАННЯ ПРОПОЗИЦІЙ   ################################################
###############################################################################################################

Подати цінову пропозицію
  [Arguments]   ${username}  ${tender_uaid}  ${bid}
  ${amount}=   add_second_sign_after_point   ${bid.data.value.amount}
  alfa.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
  Run keyword if   '${TEST NAME}' != 'Неможливість подати цінову пропозицію до початку періоду подачі пропозицій першим учасником'
  ...   Wait Until Keyword Succeeds   10 x   60 s   Дочекатися синхронізації для періоду подачі пропозицій
  Input Text   name=data[value][amount]   ${amount}
  Click Button   name=do
  Wait Until Element Is Visible   xpath=//a[./text()= 'Закрити']
  Click Element   xpath=//a[./text()= 'Закрити']
  Wait Until Element Is Not Visible   id=jAlertBack
  Click Button   name=pay
  Wait Until Element Is Visible   xpath=//a[./text()= 'OK']
  Click Element   xpath=//a[./text()= 'OK']
  [return]  ${bid}

########## Видалити після встановлення коректних часових проміжків для періодів #######################
Дочекатися синхронізації для періоду подачі пропозицій
  Reload Page
  Wait Until Page Contains    Ваша пропозиція
  
Дочекатися синхронізації для періоду аукціон
  Reload Page
  Wait Until Page Contains Element   xpath=//div[@class="statusItem active" ][@data-status="3"]
#######################################################################################################

Змінити цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  ${fieldvalue}=   add_second_sign_after_point   ${fieldvalue}
  alfa.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
  Wait Until Element Is Visible   xpath=//a[@class='button save bidToEdit']
  Click Element   xpath=//a[@class='button save bidToEdit']
  Wait Until Element is Visible   name=data[value][amount]
  Input Text   name=data[value][amount]   ${fieldvalue}
  Click Element   xpath=//button[@value='save']
  Wait Until Page Contains   Підтвердіть зміни в пропозиції
  Input Text   xpath=//div[2]/form/table/tbody/tr[1]/td[2]/div/input   203986723
  Click Element   xpath=//button[./text()='Надіслати']
  [return]  ${fieldname}

Скасувати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${bid}
  alfa.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
  Wait Until Page Contains   Ваша пропозиція   10
  Click Element   xpath=//a[@class='button save bidToEdit']
  Wait Until Page Contains   Відкликати пропозицію   30
  Click Element   xpath=//button[@value='unbid']
  Wait Until Element Is Visible   xpath=//a[@class='jBtn green']
  Click Element   xpath=//a[@class='jBtn green']
  Wait Until Element Is Visible   xpath=//div[2]/form/table/tbody/tr[1]/td[2]/div/input
  Input Text   xpath=//div[2]/form/table/tbody/tr[1]/td[2]/div/input    203986723
  Wait Until Element Is Not Visible   id=jAlertBack
  Click Element   xpath=//button[./text()='Надіслати']
  Wait Until Element Is Visible   xpath=//a[./text()= 'Закрити']
  Click Element   xpath=//a[./text()= 'Закрити']

Завантажити документ в ставку
  [Arguments]  ${username}  ${filePath}  ${tender_uaid}
  alfa.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
  Wait Until Page Contains   Ваша пропозиція   10
  Click Element   xpath=//a[@class='button save bidToEdit']
  Execute Javascript   $('body > div').attr('style', '');
  Choose File   xpath=//div[1]/form/input[@name='upload']   ${filePath}
  Click Element   xpath=//button[@value='save']
  Wait Until Element Is Visible   xpath=//div[2]/form/table/tbody/tr[1]/td[2]/div/input
  Input Text   xpath=//div[2]/form/table/tbody/tr[1]/td[2]/div/input    203986723
  Wait Until Element Is Not Visible   id=jAlertBack
  Click Element   xpath=//button[./text()='Надіслати']

Змінити документ в ставці
  [Arguments]   ${username}  ${path}  ${bidid}  ${docid}
  wait until element is visible   xpath=//a[@class='button save bidToEdit']
  Click Element   xpath=//a[@class='button save bidToEdit']
  Execute Javascript   $(".topFixed").remove(); $('body > div').attr('style', '');
  Wait Until Element Is Visible   xpath=//input[@title='Завантажити оновлену версію']
  Choose File   xpath=//div[2]/form/input[@name='upload']   ${path}
  Click Element   xpath=//button[@value='save']
  Wait Until Element Is Visible   xpath=//div[2]/form/table/tbody/tr[1]/td[2]/div/input
  Input Text   xpath=//div[2]/form/table/tbody/tr[1]/td[2]/div/input    203986723
  Wait Until Element Is Not Visible   id=jAlertBack
  Click Element   xpath=//button[./text()='Надіслати']
  Wait Until Element Is Not Visible   id=jAlertBack

Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tenderId}
  alfa.Пошук тендера по ідентифікатору   ${username}   ${tenderId}
  Wait Until Keyword Succeeds   10 x   60 s   Дочекатися синхронізації для періоду аукціон
  ${url}=   Get Element Attribute   xpath=//section/h3/a[@class="reverse"]@href
  [return]  ${url}

Отримати посилання на аукціон для учасника
  [Arguments]  ${username}  ${tenderId}
  alfa.Пошук тендера по ідентифікатору   ${username}   ${tenderId}
  Wait Until Keyword Succeeds   10 x   60 s   Дочекатися синхронізації для періоду аукціон
  Click Element   xpath=//a[@class="reverse getAuctionUrl"]
  Sleep   3
  ${url}=   Get Element Attribute   xpath=//a[contains(text(),"Перейдіть до редукціону")]@href
  [return]  ${url}