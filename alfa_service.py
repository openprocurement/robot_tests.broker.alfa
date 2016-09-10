 #!/usr/bin/python
 # -*- coding: utf-8 -*-

from datetime import datetime, timedelta
from dateutil import parser

terms_dict = {
    u'Період уточнень': u'active.enquiries',
    u'Період прийому пропозицій': u'active.tendering',
    u'Аукціон': u'active.auction',
    u'Кваліфікація': u'active.qualification',
    u'Оплачено. Очікується підписання договору': u'active.awarded',
    u'Торги не відбулися': u'unsuccessful',
    u'Торги відмінено': u'cancelled',
    u'Завершено': u'complete',

    # u'килограммы': u'кг',
    # u'кілограм': u'кг',
    # u'кілограми': u'кг',
    # u'метри': u'м',
    # u'пара': u'пар',
    # u'літр': u'л',
    # u'набір': u'наб',
    # u'пачок': u'пач',
    # u'послуга': u'посл',
    # u'метри кубічні': u'м.куб',
    # u'тони': u'т',
    # u'метри квадратні': u'м.кв',
    # u'кілометри': u'км',
    # u'штуки': u'шт',
    # u'місяць': u'міс',
    # u'пачка': u'пачка',
    # u'упаковка': u'уп',
    # u'гектар': u'Га',
    # u'лот': u'лот',
    # u"грн": u"UAH",
    # u"(з ПДВ)": u"True",
    # u"(без ПДВ)": u"false",
    # u"Код ДК 021-2015 (CPV)": u"CPV",
    # u"Код ДК": u"ДКПП",
    # u"ДК": u"ДКПП",
    # u"Відкриті торги": u"aboveThresholdUA",
    # u"Відкриті торги з публікацією англ.мовою": u"aboveThresholdEU",
    # u"Переможець": u"active",
    # u"місто Київ": u"м. Київ",
    # u"НЕЦІНОВІ КРИТЕРІЇ ДО ПРЕДМЕТУ ЗАКУПІВЛІ": u"item",
    # u"НЕЦІНОВІ КРИТЕРІЇ ДО ЛОТУ": u"lot",
    # u"ПЕРІОД УТОЧНЕНЬ": u"active.enquiries",
    # u"ПОДАННЯ ПРОПОЗИЦІЙ": u"active.tendering",
    # u"ПРЕДКВАЛІФІКАЦІЯ": u"active.pre-qualification",
    # u"АУКЦІОН": u"active.auction",
    # u"НА РОЗГЛЯДІ": u"claim"
}

def convert_date_to_alfa_format(isodate):
    iso_dt = parser.parse(isodate)
    date_string = iso_dt.strftime("%Y-%m-%d %H:%M")
    return date_string

def convert_date_from_alfa(date_time):
    return datetime.strptime(date_time, "%Y.%m.%d %H:%M:%S").isoformat()

def return_empty_string():
    string = ""
    return string

def get_field_locator(fieldname):
    field_locator = 'name=data[' + fieldname.replace('.', '][') + ']'
    return field_locator

def adapt_data_for_document(field, value):
    # if field == 'tenderPeriod.endDate':
    #     value = convert_date_to_slash_format(value)
    return value

def add_second_sign_after_point(amount):
    amount = str(repr(amount))
    if '.' in amount and len(amount.split('.')[1]) == 1:
        amount = amount + '0'
    return amount

####### review

def adapt_data_for_role(role_name, tender_data):
    if role_name == 'tender_owner':
          tender_data = adapt_unit_names(adapt_procuringEntity(tender_data))
    return tender_data

def adapt_unit_names(tender_data):
    if 'unit' in tender_data['data']['items'][0]:
        for i in tender_data['data']['items']:
            i['unit']['name'] = terms_dict[i['unit']['name']]
    return tender_data

#### check
def adapt_procuringEntity(tender_data):
    tender_data['data']['procuringEntity']['name'] = u"ПрАТ <Комбайн Інк.>"
    return tender_data

def convert_string_from_dict_alfa(string):
    return terms_dict.get(string, string)

def convert_date_to_slash_format(isodate):
    iso_dt = parse_date(isodate)
    date_string = iso_dt.strftime("%d/%m/%Y")
    return date_string

def get_street(value):
    return ','.join(value).strip()