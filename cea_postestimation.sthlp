{smcl}
{* *! version 1.0.0  30jul2025}{...}
{vieweralsosee "cea" "help cea"}{...}
{title:Postestimation tools after cea}

{pstd}
The following postestimation commands are available after {helpb cea}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt:{helpb ceagraph accept}}plot cost-effectiveness acceptability curve
(CEAC){p_end}
{synopt:{helpb ceagraph scatter}}plot cost-effectiveness scatterplot{p_end}
{synopt:{opt {helpb estat fieller}}}report Fieller confidence limits{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{cmd:ceagraph scatter} is only available when {cmd:vce(bootstrap)} was specified.{p_end}
{p 4 6 2}{cmd:estat fieller} is not available with {cmd:vce(bootstrap)}.{p_end}


{pstd}
The following standard postestimation commands are also available:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt:{helpb estat summarize}}summary statistics for the estimation sample
{p_end}
{synopt:{helpb test}}Wald tests of simple and composite linear hypotheses{p_end}
{synoptline}
{p2colreset}{...}
