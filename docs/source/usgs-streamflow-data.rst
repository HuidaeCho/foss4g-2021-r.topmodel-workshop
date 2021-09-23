USGS streamflow data
====================

Since we used the USGS gauge 02331600 for watershed delineation, go to `USGS 02331600 <https://waterdata.usgs.gov/nwis/uv?site_no=02331600>`_ and download `its daily time series tab-separated data <https://github.com/HuidaeCho/foss4g-2021-r.topmodel-workshop/raw/master/outputs/usgs_02331600_data.txt>`_ from 2011-09-20.

.. code-block:: bash

    curl -o usgs_02331600_data.txt "https://waterdata.usgs.gov/nwis/dv?cb_00045=on&cb_00060=on&cb_00065=on&format=rdb&site_no=02331600&referred_module=sw&begin_date=2011-09-20"
