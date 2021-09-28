#!/usr/bin/env python3
# AUTHOR:       Huidae Cho
# COPYRIGHT:    (C) 2021 by Huidae Cho
# LICENSE:      GNU General Public License v3

import sys
from datetime import date

def get_num_days(start_date, end_date):
    start_year = int(start_date[0:4])
    start_month = int(start_date[5:7])
    start_day = int(start_date[8:10])
    end_year = int(end_date[0:4])
    end_month = int(end_date[5:7])
    end_day = int(end_date[8:10])

    start_date = date(start_year, start_month, start_day)
    end_date = date(end_year, end_month, end_day)

    num_days = (end_date - start_date).days + 1

    return num_days


if __name__ == "__main__":
    if len(sys.argv) > 2:
        start_date = sys.argv[1]
        end_date = sys.argv[2]
        print(get_num_days(start_date, end_date))
