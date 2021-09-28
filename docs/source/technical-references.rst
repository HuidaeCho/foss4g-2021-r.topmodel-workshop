Technical references
====================

read_write_rtopmodel.R
----------------------

* write_rtopmodel_params(): Updates an existing r.topmodel parameters file.
  NULL parameters are not updated.

  * file="params.txt"
  * qs0=NULL
  * lnTe=NULL
  * m=NULL
  * Sr0=NULL
  * Srmax=NULL
  * td=NULL
  * vch=NULL
  * vr=NULL
  * infex=NULL
  * K0=NULL
  * psi=NULL
  * dtheta=NULL

* write_rtopmodel_x(): Updates an existing r.topmodel parameters file using parameter values normalized to [0, 1].

  * file="params.txt"
  * x: All parameter values need to be passed in the order of parameter arguments for write_rtopmodel_params().

* read_rtopmodel_params: Reads parameter values from an existing r.topmodel parameters file and returns them as a list.

  * file="params.txt"

* read_rtopmodel_params_from_lnes(): Reads parameter values from lines read by readLine().

  * lines

* read_rtopmodel_output(): Reads a variable from an r.topmodel output file.

  * file="output.txt"
  * name="Qt": Either "Qt", "qt", "qo", "qs", "qv", "S_mean", "f", or "fex".

run_rtopmodel.R
---------------

* par.name: Parameter names.
* par.dim: Number of parameters.
* par.min: Lower limits of parameter values.
* par.max: Upper limits of parameter values.
* run_rtopmodel_x(): Runs r.topmodel with parameter values normalized to [0, 1].

  * x: All parameter values need to be passed in the order of parameter arguments for write_rtopmodel_params().
  * path=list(params="params.txt", topidxstats="topidxstats.txt", input="input.txt", output="output.txt", sim="sim")
  * append=FALSE: If TRUE, x will be appended to sim/x.txt and unnormalized parameter values to sim/parval.txt.

* run_rtopmodel(): Runs r.topmodel with the current parameters file.

  * path=list(params="params.txt", topidxstats="topidxstats.txt", input="input.txt", output="output.txt", sim="sim")
