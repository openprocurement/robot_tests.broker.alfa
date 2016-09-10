*** Settings ***
Library  Selenium2Library
Library  String
Library  Collections
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
  Input Text   ${locator.auction.edit.${fieldname}}   ${fieldvalue}
  Натиснути кнопку  ${locator.auction.edit.button.edit}

Отримати інформацію із тендера
  [Arguments]  ${username}  ${field_name}
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

Відповісти на питання
  [Arguments]  ${username}  ${tender_uaid}  ${question_index}  ${answer_data}  ${question_id}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Натиснути кнопку  ${locator.auction.view.tab.questions}
  Розгорнути коментарi
  Ввести значення в поле  ${locator.auction.view.questions.question1.field.answer}  ${answer_data.data.answer}
  Натиснути кнопку  ${locator.auction.view.questions.question1.button.sendAnswer}

################################################################################################################
#######################################    ПОДАННЯ ПРОПОЗИЦІЙ   ################################################
################################################################################################################

Подати цінову пропозицію
  [Arguments]   ${username}  ${tender_uaid}  ${bid}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${amount}=   add_second_sign_after_point   ${bid.data.value.amount}
  Натиснути кнопку  ${locator.auction.view.tab.bid}
  Ввести значення в поле  ${locator.auction.view.bid.field.Amount}  ${amount}
  Натиснути кнопку  ${locator.auction.view.bid.button.send}
  Натиснути кнопку  ${locator.auction.view.tab.bid}
  Натиснути кнопку  ${locator.auction.view.bid.button.confirm}
  [Return]  ${bid}

Змінити цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${fieldvalue}=   add_second_sign_after_point   ${fieldvalue}
  Натиснути кнопку  ${locator.auction.view.tab.bid}
  Натиснути кнопку  ${locator.auction.view.bid.button.edit}
  Ввести значення в поле  ${locator.auction.view.bid.field.Amount}  ${fieldvalue}
  Натиснути кнопку  ${locator.auction.view.bid.button.send}
  [Return]  ${fieldname}

Скасувати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${bid}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Натиснути кнопку  ${locator.auction.view.tab.bid}
  Натиснути кнопку  ${locator.auction.view.bid.button.cancel}

Завантажити документ в ставку
  [Arguments]  ${username}  ${filePath}  ${tender_uaid}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Натиснути кнопку  ${locator.auction.view.tab.bid}
  Натиснути кнопку  ${locator.auction.view.bid.button.addDocs}
  Input text  ${locator.auction.view.bid.attachments.field.Title}  Title
  Input text  ${locator.auction.view.bid.attachments.field.Description}  Description
  Choose File  ${locator.auction.view.bid.attachments.field.Document}  ${filepath}
  Натиснути кнопку  ${locator.auction.view.bid.attachments.button.send}

Змінити документ в ставці
  [Arguments]   ${username}  ${path}  ${bidid}  ${docid}
  Натиснути кнопку  ${locator.auction.view.tab.bid}
  Натиснути кнопку  ${locator.auction.view.bid.button.addDocs}
  Input text  ${locator.auction.view.bid.attachments.field.Title}  New Title
  Input text  ${locator.auction.view.bid.attachments.field.Description}  New Description
  Choose File  ${locator.auction.view.bid.attachments.field.Document}  ${path}
  Натиснути кнопку  ${locator.auction.view.bid.attachments.button.send}

Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tenderId}
  alfa.Пошук тендера по ідентифікатору  ${username}  ${tenderId}
  ${url}=  Get Element Attribute  ${locator.auction.view.button.auctionPublicUrl}
  [Return]  ${url}

Отримати посилання на аукціон для учасника
  [Arguments]  ${username}  ${tenderId}
  ${url}=  Get Element Attribute  ${locator.auction.view.button.auctionBidsUrl}
  [Return]  ${url}
