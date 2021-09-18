#!/usr/bin/env python3
import ncdc
import json
import sqlite3

ncdc_prcp_stations = ncdc.fetch_all("stations?datatypeid=PRCP")
with open("ncdc_prcp_stations.json", "w") as f:
    json.dump(ncdc_prcp_stations, f)

with sqlite3.connect("data.db") as con:
    con.execute("""CREATE TABLE ncdc_prcp_stations (
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
    for station in ncdc_prcp_stations:
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
        con.execute("""INSERT INTO ncdc_prcp_stations
                       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
                    (cat, id_, name, latitude, longitude, elevation,
                     elevationUnit, datacoverage, mindate, maxdate))
