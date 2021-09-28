SRTM elevation data
===================

Finding a streamflow gauge
--------------------------

For this workshop, we need to find a watershed that has a streamflow gauge at its outlet for calibration purposes.
Go to `StreamStats <https://streamstats.usgs.gov/ss/>`_ and search for ``02331600``, which is the name of a United States Geological Survey (USGS) streamflow gauge.

.. image:: images/streamstats-02331600-gauge.png
   :align: center
   :width: 75%

Copy the latitude and longitude to a text editor.
We will need this information later.

Select Georgia and delineate a watershed at just the downstream cell of the gauge.
Download the watershed Shapefile as `streamstats_02331600_watershed.zip <https://github.com/HuidaeCho/foss4g-2021-r.topmodel-workshop/raw/master/data/streamstats_02331600_watershed.zip>`_.

.. image:: images/streamstats-02331600-watershed.png
   :align: center
   :width: 75%

Downloading the SRTM DEM
------------------------

Go to `EarthExplorer <https://earthexplorer.usgs.gov/>`_ and zoom to the area of the watershed above.
Draw a polygon that entirely covers the watershed.

.. image:: images/earthexplorer-search-criteria.png
   :align: center
   :width: 75%

We will use the `SRTM DEM <https://www2.jpl.nasa.gov/srtm/>`_.
Click Data Sets and search for "SRTM 1 arc-second".

.. image:: images/earthexplorer-data-sets.png
   :align: center
   :width: 75%

Click Results and download `the GeoTIFF file <https://github.com/HuidaeCho/foss4g-2021-r.topmodel-workshop/raw/master/data/n34_w084_1arc_v3.tif>`_.

.. image:: images/earthexplorer-results.png
   :align: center
   :width: 75%
