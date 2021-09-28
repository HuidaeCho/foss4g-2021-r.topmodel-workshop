#!/usr/bin/env python3
# AUTHOR:       Huidae Cho
# COPYRIGHT:    (C) 2021 by Huidae Cho
# LICENSE:      GNU General Public License v3

import os
import urllib.request
import sqlite3

txt_path = "ghcnd-inventory.txt"

if os.path.isfile(txt_path):
    with open(txt_path) as f:
        ghcnd_inventory = f.read()
else:
    with urllib.request.urlopen("ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-inventory.txt") as f:
        ghcnd_inventory = f.read().decode()

    with open(txt_path, "w") as f:
        f.write(ghcnd_inventory)

with sqlite3.connect("data.db") as con:
    con.execute("""CREATE TABLE ghcnd_inventory (
                        cat INTEGER PRIMARY KEY,
                        id VARCHAR(20),
                        latitude REAL,
                        longitude REAL,
                        datatypeid VARCHAR(4),
                        minyear INT,
                        maxyear INT)""")
    con.commit()

    cat = 0
    for line in ghcnd_inventory.split("\n"):
        if line == "":
            continue

        cat += 1
        cols = line.split()
        id_ = f"GHCND:{cols[0]}"
        latitude = float(cols[1])
        longitude = float(cols[2])
        datatypeid = cols[3]
        minyear = int(cols[4])
        maxyear = int(cols[5])
        con.execute("""INSERT INTO ghcnd_inventory
                       VALUES (?, ?, ?, ?, ?, ?, ?)""",
                    (cat, id_, latitude, longitude, datatypeid, minyear, maxyear))
