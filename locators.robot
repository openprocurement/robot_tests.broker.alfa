*** Variables ***
${locator.link.login}  id=loginLink
${locator.login.field.login}  id=Phone
${locator.login.field.sms}  id=Code
${locator.login.button.login}  xpath=//input[contains(@class, 'btn')][@value='Вхід']

${locator.link.auctionsList}  xpath=//a[contains(text(),'Торгівельний майданчик')]
${locator.auctionsList.field.search}  id=search-term
${locator.auctionsList.button.search}  xpath=//input[@value='Пошук']
${locator.auctionsList.button.accurate}  id=accurate
${locator.auctionsList.item.auctionsTable}  id=searchTable
${locator.auctionsList.button.auctionUaid}  //table[@id='searchTable']/tbody/tr/td//a
${locator.auctionsList.button.addAuction}  id=createOrderBtn


${locator.auction.view.button.editAuction}  xpath=//a[contains(@class, 'btn')][contains(text(), 'Редагувати')]
${locator.auction.view.AuctionID}  id=AuctionID
${locator.auction.view.Title}  id=Title
${locator.auction.view.Description}  id=Description
${locator.auction.view.Value.Amount}  id=Value.Amount
${locator.auction.view.Value.Currency}  id=Value.Currency
${locator.auction.view.MinimalStep.Amount}  id=MinimalStep.Amount
# TODO remove ${locator.auction.view.MinimalStep.Currency}  id=MinimalStep.Currency
${locator.auction.view.enquiryPeriod.startDate}  id=EnquiryPeriod_StartDate
${locator.auction.view.enquiryPeriod.endDate}  id=EnquiryPeriod_EndDate
${locator.auction.view.tenderPeriod.startDate}  id=TenderPeriod_StartDate
${locator.auction.view.tenderPeriod.endDate}  id=TenderPeriod_EndDate
${locator.auction.view.value.valueAddedTaxIncluded}  //div[@id='Value.ValueAddedTaxIncluded']/select/option[@selected]
${locator.auction.view.ProcuringEntity.Name}  id=ProcuringEntity.Name

${locator.auction.view.item.DeliveryAddress.CountryName0}  id=item.DeliveryAddress.CountryName0
${locator.auction.view.item.DeliveryAddress.PostalCode0}  id=item.DeliveryAddress.PostalCode0
${locator.auction.view.item.DeliveryAddress.Region0}  id=item.DeliveryAddress.Region0
${locator.auction.view.item.DeliveryAddress.Locality0}  id=item.DeliveryAddress.Locality0
${locator.auction.view.item.DeliveryAddress.StreetAddress0}  id=item.DeliveryAddress.StreetAddress0

${locator.auction.view.item.Classification.scheme0}  id=item.Classification.scheme0
${locator.auction.view.item.Classification.Id0}  id=item.Classification.Id0
${locator.auction.view.item.Classification.Description0}  id=item.Classification.Description0
${locator.auction.view.item.Unit.Name0}  id=item.Unit.Name0
${locator.auction.view.item.Unit.Code0}  id=item.Unit.Code0
${locator.auction.view.item.Quantity0}  id=item.Quantity0
${locator.auction.view.item.Description0}  id=item.Description0

${locator.auction.view.tab.questions}  xpath=//div/ul[@id='AuctionTabs']/li/a[@href='#Questions']
${locator.auction.view.questions.field.Title}  id=item.Title1
${locator.auction.view.questions.field.Date}  id=item.Date1
${locator.auction.view.questions.field.Description}  id=item.Description1
${locator.auction.view.questions.field.Answer}  id=item.Answer1

${locator.auction.view.questions.question1.field.answer}  id=item.Answer11
${locator.auction.view.questions.question1.button.sendAnswer}  id=answerbutton1/


${locator.auction.view.tab.bid}  xpath=//div/ul[@id='AuctionTabs']/li/a[@href='#Bid']
${locator.auction.view.bid.field.Amount}  xpath=//div[@id='CreateBidForm']//input[@name='Amount']
${locator.auction.view.bid.button.send}  xpath=//div[@id='CreateBidForm']//input[@type='submit']
${locator.auction.view.bid.button.edit}  xpath=//input[contains(@class, 'bidButon')][@value='Редагувати']


${locator.auction.view.tab.attachments}  xpath=//div/ul[@id='AuctionTabs']/li/a[@href='#Attachments']
${locator.auction.view.attachments.field.Title}  xpath=//div[@id='AttachmentsBody']//input[@id='Title']
${locator.auction.view.attachments.field.Description}  xpath=//div[@id='AttachmentsBody']//input[@id='Description']
${locator.auction.view.attachments.field.Document}  xpath=//div[@id='AttachmentsBody']//input[@id='Document']
${locator.auction.view.attachments.button.send}  xpath=//div[@id='AttachmentsBody']//button[@type='submit']

${locator.auction.view.button.auction}  xpath=//a[contains(@class, 'btn')][contains(text(), 'перейти на аукціон')]@href

${locator.auction.edit.button.create}  id=createOrder
${locator.auction.edit.button.edit}  id=editOrder
# TODO Auction_ProcurementMethodType
${locator.auction.edit.title}  id=Auction_Title
${locator.auction.edit.description}  id=Auction_Description

${locator.auction.edit.enquiryPeriod.startDate}  id=Auction_EnquiryPeriod_StartDate
${locator.auction.edit.enquiryPeriod.endDate}  id=Auction_EnquiryPeriod_EndDate
${locator.auction.edit.tenderPeriod.startDate}  id=Auction_TenderPeriod_StartDate
${locator.auction.edit.tenderPeriod.endDate}  id=Auction_TenderPeriod_EndDate

${locator.auction.edit.value.amount}  id=Auction_Value_Amount
${locator.auction.edit.value.currency}  id=Auction_Value_Currency
${locator.auction.edit.value.valueAddedTaxIncluded}  id=Auction_Value_ValueAddedTaxIncluded
${locator.auction.edit.minimalStep.amount}  id=Auction_MinimalStep_Amount
${locator.auction.edit.minimalStep.currency}  id=Auction_MinimalStep_Currency

${locator.auction.edit.ProcuringEntity.Name}  id=Auction_ProcuringEntity_Name
${locator.auction.edit.ProcuringEntity.Identifier.Scheme}  id=Auction_ProcuringEntity_Identifier_Scheme
${locator.auction.edit.ProcuringEntity.Identifier.Id}  id=Auction_ProcuringEntity_Identifier_Id
${locator.auction.edit.ProcuringEntity.Identifier.LegalName}  id=Auction_ProcuringEntity_Identifier_LegalName

${locator.auction.edit.procuringEntity.address.countryName}  id=Auction_ProcuringEntity_Address_CountryName
${locator.auction.edit.procuringEntity.address.region}  id=Auction_ProcuringEntity_Address_Region
${locator.auction.edit.procuringEntity.address.locality}  id=Auction_ProcuringEntity_Address_Locality
${locator.auction.edit.procuringEntity.address.streetAddress}  id=Auction_ProcuringEntity_Address_StreetAddress
${locator.auction.edit.procuringEntity.address.postalCode}  id=Auction_ProcuringEntity_Address_PostalCode

${locator.auction.edit.procuringEntity.contactPoint.name}  id=Auction_ProcuringEntity_ContactPoint_Name
${locator.auction.edit.procuringEntity.contactPoint.telephone}  id=Auction_ProcuringEntity_ContactPoint_Telephone
${locator.auction.edit.procuringEntity.contactPoint.url}  id=Auction_ProcuringEntity_ContactPoint_Url

${locator.auction.edit.items.item0.description}  id=Auction_Items_0__Description
${locator.auction.edit.items.item0.quantity}  id=Auction_Items_0__Quantity
${locator.auction.edit.items.item0.unit.code}  id=Auction_Items_0__Unit_unit
${locator.auction.edit.items.item0.classification.scheme}  id=Auction_Items_0__Classification_CavClassification
${locator.auction.edit.items.item0.classification.id}  id=Auction_Items_0__Classification_Id
${locator.auction.edit.items.item0.classification.description}  id=Auction_Items_0__Classification_Description

${locator.auction.edit.items.item0.deliveryAddress.countryName}  id=Auction_Items_0__DeliveryAddress_CountryName
${locator.auction.edit.items.item0.deliveryAddress.region}  id=Auction_Items_0__DeliveryAddress_Region
${locator.auction.edit.items.item0.deliveryAddress.locality}  id=Auction_Items_0__DeliveryAddress_Locality
${locator.auction.edit.items.item0.deliveryAddress.streetAddress}  id=Auction_Items_0__DeliveryAddress_StreetAddress
${locator.auction.edit.items.item0.deliveryAddress.postalCode}  id=Auction_Items_0__DeliveryAddress_PostalCode

${locator.auction.edit.questions.field.Title}  xpath=//input[@id='Title']
${locator.auction.edit.questions.field.Description}  //textarea[@id='Description']
${locator.auction.edit.questions.button.sendQuestion}  xpath=//input[@value='Задати питання']
