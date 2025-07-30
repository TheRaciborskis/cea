{smcl}
{* *! version 1.0.0  30jul2025}{...}
{vieweralsosee "cea (means)" "help cea_means"}{...}
{vieweralsosee "cea (models)" "help cea_models"}{...}
{vieweralsosee "cea postestimation" "help cea postestimation"}{...}
{vieweralsosee "ceagraph accept" "help ceagraph accept"}{...}
{vieweralsosee "ceagraph scatter" "help ceagraph scatter"}{...}
{vieweralsosee "ceai" "help ceai"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "wtp" "help wtp"}{...}
{vieweralsosee "heabs" "help heabs"}{...}
{vieweralsosee "hcost" "help hcost"}{...}
{viewerjumpto "Description" "cea##description"}{...}
{p 0 14 16 0}{...}
{bf:cea} {hline 2} Introduction to cost-effectiveness analysis{p_end}
{...}


{marker description}{...}
{title:Description}

{pstd}
Cost-effectiveness analysis (CEA) is used to compare a treatment or treatments 
to an alternative to guide decision-making. The analysis yields either an 
incremental cost-effectiveness ratio (ICER), which is compared to a 
willingness-to-pay (WTP) threshold to determine if the treatment is a good 
value, or a net monetary benefit (NMB), which incorporates the WTP and is
compared to 0 when determining if a treatment is a good value. 

{pstd}
The entries below show how you can use the {cmd:cea} suite of commands to
calculate the ICER or NMB and evaluate the fit of the model. 

{synoptset 29 tabbed}{...}
{syntab:{bf:Obtain cost-effectiveness statistics}}

{synopt: {helpb ceai}}
From numbers typed as arguments{p_end}
{synopt: {helpb cea_means:cea (means)}}
From unadjusted means{p_end}
{synopt: {helpb cea_models:cea (models)}}
From models of cost and outcome{p_end}
	
{syntab:{bf:Cost-effectiveness graphs}}

{synopt :{helpb ceagraph accept}}
C-E acceptability curve{p_end}
{synopt :{helpb ceagraph scatter}}
C-E scatterplot{p_end}

{syntab:{bf:Postestimation}}

{synopt :{helpb cea postestimation}}
Command-specific postestimation{p_end}
{synopt :{helpb estat fieller}}
Fieller confidence limits{p_end}
{p2colreset}{...}



{title:Reference}

{phang}
Glick, H. A., Doshi, J. A., Sonnad, S. S., & Polsky, D. (2014). Economic 
evaluation in clinical trials. OUP Oxford.
