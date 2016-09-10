*** Settings ***
Library  Selenium2Screenshots
Library  Selenium2Library
Library  String
Library  Collections
Library  DateTime
Library  alfa_service.py
Resource  locators.robot
Resource  lib.robot

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  ${username}
  lib.Підготувати клієнт для користувача  ${username}

Login
  [Arguments]  ${username}
  Натиснути кнопку  ${locator.link.login}
  Ввести значення в поле  ${locator.login.field.login}  ${USERS.users['${username}'].login}
  Натиснути кнопку  ${locator.login.button.login}
  Ввести значення в поле  ${locator.login.field.sms}  ${USERS.users['${username}'].sms}
  Натиснути кнопку  ${locator.login.button.login}

###############################################################################################################
######################################         ТЕНДЕР          ################################################
###############################################################################################################

Підготувати дані для оголошення тендера користувачем
  [Arguments]  ${username}  ${tender_data}  ${role_name}
  ${tender_data}=  adapt_data_for_role  ${role_name}  ${tender_data}
  [Return]  ${tender_data}

Створити тендер
  [Arguments]  ${username}  ${tender_data}
  Натиснути кнопку  ${locator.link.auctionsList}
  Натиснути кнопку  ${locator.auctionsList.button.addAuction}
  Дочекатися елемента  ${locator.auction.edit.title}
  Заповнити дані тендеру  ${tender_data}
  ${items}=  Get From Dictionary  ${tender_data.data}  items
  Додати предмет  ${items[0]}
  Натиснути кнопку  ${locator.auction.edit.button.create}
  Дочекатися елемента  ${locator.auction.view.AuctionID}
  ${tender_uaid}=   Get Text   ${locator.auction.view.AuctionID}
  [Return]  ${tender_uaid}

Оновити сторінку з тендером
  [Arguments]  ${username}  ${tender_uaid}
  lib.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}

Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}
  lib.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}

Внести зміни в тендер
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Дочекатися елемента  ${locator.auction.view.AuctionID}
  Натиснути кнопку  ${locator.auction.view.button.editAuction}
  Дочекатися елемента  ${locator.auction.edit.title}
  ${fieldvalue}=   adapt_data_for_document   ${fieldname}   ${fieldvalue}
  Input Text   ${locator.auction.edit.${fieldname}}   ${fieldvalue}
  Натиснути кнопку  ${locator.auction.edit.button.edit}

Отримати інформацію із тендера
  [Arguments]  ${username}  ${field_name}
# TODO remove  Switch browser   ${username}
  Run Keyword And Return  lib.Отримати інформацію про ${field_name}

Завантажити документ
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Натиснути кнопку  ${locator.auction.view.tab.attachments}
  Input text  ${locator.auction.view.attachments.field.Title}  Title
  Input text  ${locator.auction.view.attachments.field.Description}  Description
  Choose File  ${locator.auction.view.attachments.field.Document}  ${filepath}
  Натиснути кнопку  ${locator.auction.view.attachments.button.send}

################################################################################################################
############################################    ПИТАННЯ    #####################################################
################################################################################################################

Задати питання
  [Arguments]  ${username}  ${tender_uaid}  ${question}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Натиснути кнопку  ${locator.auction.view.tab.questions}
  Ввести значення в поле  ${locator.auction.edit.questions.field.Title}  ${question.data.title}
  Ввести значення в поле  ${locator.auction.edit.questions.field.Description}  ${question.data.description}
  Натиснути кнопку  ${locator.auction.edit.questions.button.sendQuestion}
  Execute Javascript  window.confirm = function(msg) { return true; }

Відповісти на питання
  [Arguments]  ${username}  ${tender_uaid}  ${question_index}  ${answer_data}  ${question_id}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Натиснути кнопку  ${locator.auction.view.tab.questions}
  Execute Javascript  if ($('div[role=button]').last().hasClass('collapsed')) $('div[role=button]').last().click();
  Ввести значення в поле  ${locator.auction.view.questions.question1.field.answer}  ${answer_data.data.answer}
  Натиснути кнопку  ${locator.auction.view.questions.question1.button.sendAnswer}

################################################################################################################
#######################################    ПОДАННЯ ПРОПОЗИЦІЙ   ################################################
################################################################################################################

Подати цінову пропозицію
  [Arguments]   ${username}  ${tender_uaid}  ${bid}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${amount}=   add_second_sign_after_point   ${bid.data.value.amount}
#  Run keyword if   '${TEST NAME}' != 'Неможливість подати цінову пропозицію до початку періоду подачі пропозицій першим учасником'
#  ...   Wait Until Keyword Succeeds   10 x   60 s   Дочекатися синхронізації для періоду подачі пропозицій
  Натиснути кнопку  ${locator.auction.view.tab.bid}
  Ввести значення в поле  ${locator.auction.view.bid.field.Amount}  ${amount}
  Натиснути кнопку  ${locator.auction.view.bid.button.send}
  [Return]  ${bid}

########### Видалити після встановлення коректних часових проміжків для періодів #######################
#Дочекатися синхронізації для періоду подачі пропозицій
#  Reload Page
#  Wait Until Page Contains    Ваша пропозиція
#  Fail  редактировать

#Дочекатися синхронізації для періоду аукціон
#  Reload Page
#  Wait Until Page Contains Element   xpath=//div[@class="statusItem active" ][@data-status="3"]
#  Fail  редактировать
########################################################################################################

Змінити цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${fieldvalue}=   add_second_sign_after_point   ${fieldvalue}
  Натиснути кнопку  ${locator.auction.view.tab.bid}
  Натиснути кнопку  ${locator.auction.view.bid.button.edit}
  Ввести значення в поле  ${locator.auction.view.bid.field.Amount}  ${fieldvalue}
  Натиснути кнопку  ${locator.auction.view.bid.button.send}
# TODO accept
  [Return]  ${fieldname}

Скасувати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${bid}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
#  Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
#  Wait Until Page Contains   Ваша пропозиція   10
#  Click Element   xpath=//a[@class='button save bidToEdit']
#  Wait Until Page Contains   Відкликати пропозицію   30
#  Click Element   xpath=//button[@value='unbid']
#  Wait Until Element Is Visible   xpath=//a[@class='jBtn green']
#  Click Element   xpath=//a[@class='jBtn green']
#  Wait Until Element Is Visible   xpath=//div[2]/form/table/tbody/tr[1]/td[2]/div/input
#  Input Text   xpath=//div[2]/form/table/tbody/tr[1]/td[2]/div/input    203986723
#  Wait Until Element Is Not Visible   id=jAlertBack
#  Click Element   xpath=//button[./text()='Надіслати']
#  Wait Until Element Is Visible   xpath=//a[./text()= 'Закрити']
#  Click Element   xpath=//a[./text()= 'Закрити']
  Fail  *** редактировать ***

Завантажити документ в ставку
  [Arguments]  ${username}  ${filePath}  ${tender_uaid}
#  Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
#  Wait Until Page Contains   Ваша пропозиція   10
#  Click Element   xpath=//a[@class='button save bidToEdit']
#  Execute Javascript   $('body > div').attr('style', '');
#  Choose File   xpath=//div[1]/form/input[@name='upload']   ${filePath}
#  Click Element   xpath=//button[@value='save']
#  Wait Until Element Is Visible   xpath=//div[2]/form/table/tbody/tr[1]/td[2]/div/input
#  Input Text   xpath=//div[2]/form/table/tbody/tr[1]/td[2]/div/input    203986723
#  Wait Until Element Is Not Visible   id=jAlertBack
#  Click Element   xpath=//button[./text()='Надіслати']
  Fail  *** редактировать ***

Змінити документ в ставці
  [Arguments]   ${username}  ${path}  ${bidid}  ${docid}
#  wait until element is visible   xpath=//a[@class='button save bidToEdit']
#  Click Element   xpath=//a[@class='button save bidToEdit']
#  Execute Javascript   $(".topFixed").remove(); $('body > div').attr('style', '');
#  Wait Until Element Is Visible   xpath=//input[@title='Завантажити оновлену версію']
#  Choose File   xpath=//div[2]/form/input[@name='upload']   ${path}
#  Click Element   xpath=//button[@value='save']
#  Wait Until Element Is Visible   xpath=//div[2]/form/table/tbody/tr[1]/td[2]/div/input
#  Input Text   xpath=//div[2]/form/table/tbody/tr[1]/td[2]/div/input    203986723
#  Wait Until Element Is Not Visible   id=jAlertBack
#  Click Element   xpath=//button[./text()='Надіслати']
#  Wait Until Element Is Not Visible   id=jAlertBack
  Fail  *** редактировать ***

Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tenderId}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tenderId}
# TODO uncomment  Wait Until Keyword Succeeds   10 x   60 s   Дочекатися синхронізації для періоду аукціон
# TODO remove  ${url} =  Execute Javascript  return window.location.href;
  ${url}=  Get Location
  [Return]  ${url}

Отримати посилання на аукціон для учасника
  [Arguments]  ${username}  ${tenderId}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tenderId}
  ${url}=  Get Element Attribute  ${locator.auction.view.button.auction}
  [Return]  ${url}
