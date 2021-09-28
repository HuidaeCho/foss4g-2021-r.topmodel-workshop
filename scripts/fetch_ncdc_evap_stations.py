#!/usr/bin/env python3
# AUTHOR:       Huidae Cho
# COPYRIGHT:    (C) 2021 by Huidae Cho
# LICENSE:      GNU General Public License v3

import os
import json
import sqlite3

import ncdc

json_path = "ncdc_evap_stations.json"

if os.path.isfile(json_path):
    with open(json_path) as f:
        ncdc_evap_stations = json.load(f)
else:
    ncdc_evap_stations = ncdc.fetch_all("stations?datatypeid=EVAP")
    with open(json_path, "w") as f:
        json.dump(ncdc_evap_stations, f)

with sqlite3.connect("data.db") as con:
    con.execute("""CREATE TABLE ncdc_evap_stations (
                        cat INTEGER PRIMARY KEY,
                        id VARCHAR(20),
                        name VARCHAR(100),
                        latitude REAL,
                        longitude REAL,
                        elevation REAL,
                        elevationUnit VARCHAR(10),
                        datacoverage REAL,
                        mindate VARCHAR(10),
                        maxdate VARCHAR(10))""")
    con.commit()

    cat = 0
    for station in ncdc_evap_stations:
        cat += 1
        id_ = station.get("id")
        name = station.get("name")
        latitude = station.get("latitude")
        longitude = station.get("longitude")
        elevation = station.get("elevation")
        elevationUnit = station.get("elevationUnit")
        datacoverage = station.get("datacoverage")
        mindate = station.get("mindate")
        maxdate = station.get("maxdate")
        con.execute("""INSERT INTO ncdc_evap_stations
                       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
                    (cat, id_, name, latitude, longitude, elevation,
                     elevationUnit, datacoverage, mindate, maxdate))
