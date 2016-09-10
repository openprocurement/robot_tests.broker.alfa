 #!/usr/bin/python
 # -*- coding: utf-8 -*-

from datetime import datetime
from dateutil import parser

terms_dict = {
    u'Період уточнень': u'active.enquiries',
    u'Період прийому пропозицій': u'active.tendering',
    u'Аукціон': u'active.auction',
    u'Кваліфікація': u'active.qualification',
    u'Оплачено. Очікується підписання договору': u'active.awarded',
    u'Торги не відбулися': u'unsuccessful',
    u'Торги відмінено': u'cancelled',
    u'Завершено': u'complete'
}

def convert_date_to_alfa_format(isodate):
    iso_dt = parser.parse(isodate)
    date_string = iso_dt.strftime("%Y-%m-%d %H:%M")
    return date_string

def convert_date_from_alfa(date_time):
    return datetime.strptime(date_time, "%Y.%m.%d %H:%M:%S").isoformat()

def add_second_sign_after_point(amount):
    amount = str(repr(amount))
    if '.' in amount and len(amount.split('.')[1]) == 1:
        amount = amount + '0'
    return amount

def adapt_data_for_role(role_name, tender_data):
    if role_name == 'tender_owner':
          tender_data = adapt_unit_names(tender_data)
    return tender_data

def adapt_unit_names(tender_data):
    if 'unit' in tender_data['data']['items'][0]:
        for i in tender_data['data']['items']:
            i['unit']['name'] = terms_dict[i['unit']['name']]
    return tender_data

def convert_string_from_dict_alfa(string):
    return terms_dict.get(string, string)
