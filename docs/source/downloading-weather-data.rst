Downloading weather data
========================

Fetching information about weather stations
-------------------------------------------

Using `ncdc.py <https://github.com/HuidaeCho/foss4g-2021-r.topmodel-workshop/blob/master/scripts/ncdc.py>`_, fetch JSON data for all precipitation stations from the CDO database.

.. code-block:: python

    import ncdc
    import json

    ncdc_prcp_stations = ncdc.fetch_all("stations?datatypeid=PRCP")

    with open("ncdc_prcp_stations.json", "w") as f:
        json.dump(ncdc_prcp_stations, f)

Convert the JSON data to a SQLite database.

.. code-block:: python

    import sqlite3

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
            elevation = station.get("elevation", 0)
            elevationUnit = station.get("elevationUnit")
            datacoverage = station.get("datacoverage")
            mindate = station.get("mindate")
            maxdate = station.get("maxdate")
            con.execute("""INSERT INTO ncdc_prcp_stations
                           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
                        (cat, id_, name, latitude, longitude, elevation,
                         elevationUnit, datacoverage, mindate, maxdate))

The above steps can be done using `fetch_ncdc_prcp_stations.py <https://github.com/HuidaeCho/foss4g-2021-r.topmodel-workshop/blob/master/scripts/fetch_ncdc_prcp_stations.py>`_.

Similarly, fetch all evaporation stations from the CDO database.

.. code-block:: python

    import ncdc
    import json

    ncdc_evap_stations = ncdc.fetch_all("stations?datatypeid=EVAP")

    with open("ncdc_evap_stations.json", "w") as f:
        json.dump(ncdc_evap_stations, f)

Convert the JSON data to a SQLite database.

.. code-block:: python

    import sqlite3

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
            elevation = station.get("elevation", 0)
            elevationUnit = station.get("elevationUnit")
            datacoverage = station.get("datacoverage")
            mindate = station.get("mindate")
            maxdate = station.get("maxdate")
            con.execute("""INSERT INTO ncdc_evap_stations
                           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
                        (cat, id_, name, latitude, longitude, elevation,
                         elevationUnit, datacoverage, mindate, maxdate))

The above steps can be done using `fetch_ncdc_evap_stations.py <https://github.com/HuidaeCho/foss4g-2021-r.topmodel-workshop/blob/master/scripts/fetch_ncdc_evap_stations.py>`_.

Creating weather station vectors
--------------------------------

