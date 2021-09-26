USGS streamflow data
====================

Downloading streamflow data
---------------------------

Since we used the USGS gauge 02331600 for watershed delineation, download its daily streamflow data from January 1, 2010 to December 31, 2020.
Using `tmod.usgs <https://github.com/HuidaeCho/foss4g-2021-r.topmodel-workshop/raw/master/scripts/tmod.usgs>`_, create `obs.txt <https://github.com/HuidaeCho/foss4g-2021-r.topmodel-workshop/raw/master/data/obs.txt>`_.

.. code-block:: bash

    tmod.usgs site_no=02331600 start_date=2010-01-01 end_date=2020-12-31 output=obs.txt
