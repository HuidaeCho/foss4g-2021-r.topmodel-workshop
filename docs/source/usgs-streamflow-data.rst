USGS streamflow data
====================

Since we used the USGS gauge 02331600 for watershed delineation, download its daily streamflow data from January 1, 2010 to December 31, 2020.

.. code-block:: bash

    tmod.observed site_no=02331600 start_date=2010-01-01 end_date=2020-12-31 output=observed.txt
