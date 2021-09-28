#!/usr/bin/env python3
# AUTHOR:       Huidae Cho
# COPYRIGHT:    (C) 2021 by Huidae Cho
# LICENSE:      GNU General Public License v3

import os
import sys
import requests
import calendar


def fetch_daily_pet_data(start_date, end_date):
    request_format = "https://edcintl.cr.usgs.gov/downloads/sciweb1/shared/fews/web/global/daily/pet/downloads/daily/et%02d%02d%02d.tar.gz"

    start_year = int(start_date[0:4])
    start_month = int(start_date[5:7])
    start_day = int(start_date[8:10])
    end_year = int(end_date[0:4])
    end_month = int(end_date[5:7])
    end_day = int(end_date[8:10])

    for year in range(start_year, end_year+1):
        if year == start_year:
            startmonth = start_month
            startday = start_day
        else:
            startmonth = 1
            startday = 1

        if year == end_year:
            endmonth = end_month
            endday = end_day
        else:
            endmonth = 12
            endday = 31

        for month in range(startmonth, endmonth+1):
            ndays = calendar.monthrange(year, month)[1]
            for day in range(startday, min(endday, ndays)+1):
                request_url = request_format % (year-2000, month, day)
                ret = requests.get(request_url)
                with open(os.path.basename(request_url), "wb") as f:
                    f.write(ret.content)


if __name__ == "__main__":
    if len(sys.argv) > 2:
        start_date = sys.argv[1]
        end_date = sys.argv[2]
        print(fetch_daily_pet_data(start_date, end_date))
