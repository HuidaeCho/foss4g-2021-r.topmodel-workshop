r.topmodel topidxstats
======================

`r.topmodel <https://grass.osgeo.org/grass78/manuals/r.topmodel.html>`_ provides a preprocessing flag ``-p`` to generate a topidxstats file from a topidx raster created by `r.topidx <https://grass.osgeo.org/grass78/manuals/r.topidx.html>`_.
The following command calculates statistics about topographic indices in the topidx raster by splitting the entire range into 30 classes:

.. code-block:: bash

    r.topmodel -p topidx=topidx ntopidxclasses=30 outtopidxstats=topidxstats.txt

This is my `topidxstats.txt <https://github.com/HuidaeCho/foss4g-2021-r.topmodel-workshop/raw/master/data/topidxstats.txt>`_.

.. code-block::

     1.709e+01  0.000e+00
     1.667e+01  1.742e-06
     1.625e+01  1.045e-05
     1.583e+01  2.569e-05
     1.540e+01  7.838e-05
     1.498e+01  1.607e-04
     1.456e+01  3.997e-04
     1.413e+01  8.017e-04
     1.371e+01  1.584e-03
     1.329e+01  2.955e-03
     1.287e+01  5.333e-03
     1.244e+01  8.724e-03
     1.202e+01  1.380e-02
     1.160e+01  2.058e-02
     1.118e+01  2.968e-02
     1.075e+01  4.057e-02
     1.033e+01  5.265e-02
     9.909e+00  6.663e-02
     9.487e+00  8.124e-02
     9.064e+00  9.726e-02
     8.642e+00  1.153e-01
     8.219e+00  1.298e-01
     7.797e+00  1.306e-01
     7.374e+00  1.064e-01
     6.952e+00  6.378e-02
     6.529e+00  2.499e-02
     6.107e+00  5.808e-03
     5.684e+00  7.577e-04
     5.261e+00  4.703e-05
     4.839e+00  2.613e-06

Each line starts with the upper limit of a topographic index range whose ratio is recorded in the next line in the second column with its lower limit in the first column.
For example, topographic indices between 16.67 and 17.09 covers the 1.742e-4% of the watershed.

These pairs are sorted by the topographic index in an descending order.
Since the first line represents the maximum topographic index, its second column must always be 0.
