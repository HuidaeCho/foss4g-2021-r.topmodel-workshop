#!/usr/bin/env python3
# Python script for retrieving NCDC weather data
#
# AUTHOR:       Huidae Cho
# COPYRIGHT:    (C) 2015 by Huidae Cho
# LICENSE:      GNU Affero General Public License v3

import os
import sys
import requests
import time

def fetch_once(request, limit, offset):
    # NCDC API tokens
    tokens = os.environ.get("NCDC_API_TOKENS")
    if not tokens:
        raise Exception("Define NCDC_API_TOKENS environment variable")
    tokens = tokens.split(":")

    api_url = "https://www.ncdc.noaa.gov/cdo-web/api/v2"

    if "?" in request:
        limit_param = "&limit"
    else:
        limit_param = "?limit"

    request_url = "%s/%s%s=%d&offset=%d" % (api_url, request, limit_param,
            limit, offset)

    for token in tokens:
        ret = requests.get(request_url, headers={"token": token})
        try:
            data = ret.json()
        except:
            continue
        if "message" in data:
            if (token != tokens[len(tokens)-1] and
                ("per day" in data["message"] or
                 "per second" in data["message"])):
                continue
            else:
                raise Exception(data["message"])
        break

    return data

def fetch_all(request):
    limit = 1000
    offset = 1

    sys.stderr.write("Fetching %d-%d...\n" % (offset, limit))
    data = fetch_once(request, limit, offset)

    if not "metadata" in data:
        return []
        #raise Exception("Empty response")

    count = data["metadata"]["resultset"]["count"]
    output = data["results"]

    offset += limit

    while offset <= count:
        last = min(offset + limit - 1, count)
        sys.stderr.write("Fetching %d-%d of %d...\n" % (offset, last, count))
        data = fetch_once(request, limit, offset)

        if not "results" in data:
            data["results"] = []
            #raise Exception("Empty response")

        for i in data["results"]:
            output.append(i)
        offset += limit

    return output

def fetch_daily_data(datatypeid, stationid, startdate, enddate):
    request_format = ("data?datasetid=GHCND&" +
        "datatypeid=%s&stationid=%s&startdate=%%s&enddate=%%s" %
        (datatypeid, stationid))

    startyear = int(startdate[0:4])
    startmonth = int(startdate[5:7])
    startday = int(startdate[8:10])
    endyear = int(enddate[0:4])
    endmonth = int(enddate[5:7])
    endday = int(enddate[8:10])

    ret = []

    for year in range(startyear, endyear+1):
        if year == startyear:
            start_month = startmonth
            start_day = startday
        else:
            start_month = 1
            start_day = 1

        if year == endyear:
            end_month = endmonth
            end_day = endday
        else:
            end_month = 12
            end_day = 31

        start_date = "%04d-%02d-%02d" % (year, start_month, start_day)
        end_date = "%04d-%02d-%02d" % (year, end_month, end_day)

        sys.stderr.write("%s %s %s %s\n" % (datatypeid, stationid, start_date, end_date))
        request = request_format % (start_date, end_date)
        for rec in fetch_all(request):
            ret.append(rec)

    return ret

def fetch_prcp_data(stationid, startdate, enddate):
    return fetch_daily_data("PRCP", stationid, startdate, enddate)

def fetch_evap_data(stationid, startdate, enddate):
    return fetch_daily_data("EVAP", stationid, startdate, enddate)

if __name__ == "__main__":
    if len(sys.argv) > 4:
        datatypeid = sys.argv[1]
        stationid = sys.argv[2]
        startdate = sys.argv[3]
        enddate = sys.argv[4]
        print(fetch_daily_data(datatypeid, stationid, startdate, enddate))
