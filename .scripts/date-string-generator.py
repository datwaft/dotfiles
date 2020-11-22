from datetime import date, timedelta
from argparse import ArgumentParser
import os.path
import json

data = json.load(open(os.path.expanduser("~/.scripts/.date-string-generator-data.json")))

weekday_parser = data["weekdays"]
month_parser = data["months"]
args_data = data["args_data"]

def calculateClassNumber(number_of_weeks, number_of_days, weekdays):
    if isinstance(weekdays, list):
        weekdays = [int(weekday_parser[i]) for i in weekdays]
        return number_of_weeks * 2 + (1 if min(weekdays) < number_of_days else 0) - 1
    else:
        return number_of_weeks * 2 - 1

def calculateString(initial_date, actual_date, weekdays):
    difference = actual_date - initial_date
    number_of_weeks = difference // timedelta(weeks=1) + 1
    number_of_days = (difference % timedelta(weeks=1)).days

    clase = calculateClassNumber(number_of_weeks, number_of_days, weekdays)
    weeks = number_of_weeks
    day = actual_date.day
    month = month_parser[str(actual_date.month)]

    return f"Clase {clase:02} - Semana {weeks:02} - {day:02} {month}"

if __name__ == "__main__":
    parser = ArgumentParser(description=args_data["description"])
    parser.add_argument('-i', '--init', dest="init", default="2020-07-27",
                        type=date.fromisoformat, help=args_data["init"])
    parser.add_argument('-t', '--this', dest="this", type=date.fromisoformat,
                        help=args_data["this"])
    parser.add_argument('-d', '--days', dest="days", nargs="+", choices=weekday_parser,
                        default=["M", "V"], help=args_data["days"])
    args = parser.parse_args()

    initial = args.init
    actual = args.this
    weekdays = args.days
    print(calculateString(initial, actual, weekdays))
