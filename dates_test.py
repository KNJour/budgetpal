from datetime import datetime
from datetime import date

datetime_object = datetime.now()
print(datetime_object)


def date_difference(date1, date2):
    return abs(date2-date1).days

def main():
    d1 = date(2021,4,1)
    d2 = date(2021,5,1)
    duration = date_difference(d2, d1)
    print("here goes")
    print(f"{duration} days between {d1} and {d2}")
    return duration
main()

def percentage(a,b):
    c = a / b
    return round(c * 100, 2)


print(percentage(14,30))