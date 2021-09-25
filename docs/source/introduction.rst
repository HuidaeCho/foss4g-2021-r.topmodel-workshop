Introduction
============

GRASS GIS
---------

The Geographic Resources Analysis Support System (`GRASS <https://grass.osgeo.org/>`_) is an open-source Geographic Information System (GIS), which was originally developed by the U.S. Army Construction Engineering Research Laboratories (USA-CERL) in 1982 for land management and environmental planning.
Its version 5.0 was released under the GNU General Public License (GPL) as an open-source project in October 1999 (Neteler et al. 2012).

Latest version
^^^^^^^^^^^^^^

Currently, the latest stable version 7.8.5 is available from `here <https://grass.osgeo.org/download/>`_ and the source code is `hosted on GitHub <https://github.com/OSGeo/grass>`_.

TOPMODEL
--------

Beven (1984) introduced the Topography Model (TOPMODEL), which is a physically-based distributed hydrologic model.
It uses the topographic index :math:`\ln{\frac{a_i}{\tan\beta_i}}` where :math:`a_i` is the area of the hillslope per unit contour length draining into point :math:`i` and :math:`\beta_i` is the local slope at this point.
TOPMODEL assumes that areas with similar topographic indices behave in a hydrologically similar manner.

Main assumptions
^^^^^^^^^^^^^^^^

It makes three main assumptions:

#. the hydraulic gradient of the water table can be approximated by the surface slope,
#. dynamic conditions can be assumed to be steady-state, and
#. the saturated hydraulic conductivity decreases exponentially with depth.

It is best applied for watersheds for which these assumptions hold, such as humid watersheds with shallow soil layers Beven et al. (1995).

Total flow consists of direct runoff from saturated areas, return flow from saturated areas where storage deficit is less than 0, and subsurface flow.

r.topmodel and r.topidx
^^^^^^^^^^^^^^^^^^^^^^^

Cho (2000) rewrote TMOD9502.FOR and GRIDATB.FOR, the FORTRAN 77 version of TOPMODEL and the topographic index calculator by Beven, in C and integrated them with GRASS GIS as the `r.topmodel <https://grass.osgeo.org/grass78/manuals/r.topmodel.html>`_ and `r.topidx <https://grass.osgeo.org/grass78/manuals/r.topidx.html>`_ modules, respectively.
Both modules are included in the standard GRASS GIS installation.

We will use these GRASS modules for today's workshop.

ISPSO
-----

Isolated-Speciation-based Particle Swarm Optimization (`ISPSO <https://idea.isnew.info/ispso.html>`_) is a multi-modal optimization algorithm based on Species-based PSO (SPSO) by Li (2004).
It was developed by Cho et al. (2011) to solve multi-modal problems in stochastic rainfall modeling and hydrologic modeling.
It is written in R and available from `its GitHub repository <https://github.com/HuidaeCho/ispso>`_.

Finding minima in the Rastrigin function
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. math::
   F(\vec{x})=\sum_{i=1}^D\left[x_i^2-10\cos(2\pi x_i)+10\right]

.. image:: images/rastrigin.gif
   :align: center

References
----------

Beven, K., 1984. Infiltration into a Class of Vertically Non-Uniform Soils. Hydrological Sciences Journal 29 (4), 425-434. :doi:`10.1080/02626668409490960`.

Beven, K., Lamb, R., Quinn, P., Romanowicz, R., Freer, J., 1995. TOPMODEL. In: Singh, V.P. (Ed.), Computer Models of Watershed Hydrology. Water Resources Publications, pp. 627-668.

Cho, H., 2000. GIS Hydrological Modeling System by Using Programming Interface of GRASS. Master’s Thesis, Department of Civil Engineering, Kyungpook National University, South Korea.

Cho, H., Kim, D., Olivera, F., Guikema, S. D., 2011. Enhanced Speciation in Particle Swarm Optimization for Multi-Modal Problems. European Journal of Operational Research 213 (1), 15-23. :doi:`10.1016/j.ejor.2011.02.026`.

Li, X., 2004. Adaptively Choosing Neighbourhood Bests Using Species in a Particle Swarm Optimizer for Multimodal Function Optimization. Lecture Notes in Computer Science 3102, 105-166. :doi:`10.1007/978-3-540-24854-5_10`.

Neteler, M., Bowman, M. H., Landa, M., Metz, M., 2012. GRASS GIS: A Multi-Purpose Open Source GIS. Environmental Modelling & Software 31, 124-130. :doi:`10.1016/j.envsoft.2011.11.014`.
