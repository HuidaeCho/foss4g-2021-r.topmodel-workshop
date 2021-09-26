Validation
==========

In R, let's validate our calibrated model.

.. code-block:: R

    obs_v <- read.table("obs_v.txt")[[1]]
    sim_v <- run_rtopmodel(path_v)

    calc_nse(obs_v, sim_v, skip_v)

This step will create `output_v <https://github.com/HuidaeCho/foss4g-2021-r.topmodel-workshop/raw/master/data/output_v>`_.
My NSE for validation is 0.7745305, which is not bad.
