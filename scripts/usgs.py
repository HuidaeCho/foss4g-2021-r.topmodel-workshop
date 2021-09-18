#!/usr/bin/env python3
# Python script for retreiving USGS streamflow data
#
# AUTHOR:       Huidae Cho
# COPYRIGHT:    (C) 2015 by Huidae Cho
# LICENSE:      GNU Affero General Public License v3

import sys
import requests

def fetch_daily_discharge(siteno, begindate, enddate):
    daily_discharge_url = ("https://waterdata.usgs.gov/nwis/dv?cb_00060=on&" +
        "format=rdb&site_no=%s&referred_module=sw&period=&" +
        "begin_date=%s&end_date=%s")

    request_url = daily_discharge_url % (siteno, begindate, enddate)

    ret = []
    i = 0
    for line in requests.get(request_url).text.split("\n"):
        if line.startswith("#") or line == "":
            continue
        i += 1
        if i < 3:
            continue
        rec = line.split("\t")
        ret.append({"agency_cd": rec[0], "site_no": rec[1], "datetime": rec[2],
            "discharge": float(rec[3]) if rec[3] != "" else 0, "code": rec[4]})

    return ret

if __name__ == "__main__":
    if len(sys.argv) > 3:
        siteno = sys.argv[1]
        begindate = sys.argv[2]
        enddate = sys.argv[3]
        print(fetch_daily_discharge(siteno, begindate, enddate))
