{smcl}
{* *! version 1.0.0  30jul2025}{...}
{vieweralsosee "cea" "help cea"}{...}
{vieweralsosee "ceagraph accept" "help ceagraph accept"}{...}
{viewerjumpto "Syntax" "ceai##syntax"}{...}
{viewerjumpto "Description" "ceai##description"}{...}
{viewerjumpto "Options" "ceai##options"}{...}
{viewerjumpto "Examples" "ceai##examples"}{...}
{viewerjumpto "Stored results" "ceai##results"}{...}
{p 1 14 0 0}{...}
{bf:ceai} {hline 2} Immediate version of cost-effectiveness analysis (CEA){p_end}
{...}

{marker syntax}{...}
{title:Syntax}

{phang}
Compute incremental cost-effectiveness ratio

{phang2}
{cmd:ceai} {cmd:,} {opt costd:iff(#)} {opt effd:iff(#)} {opt n:0(#)}
[{it:{help ceai##options:options}}]


{synoptset 30 tabbed}{...}
{marker options}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{p2coldent:* {opt costd:iff(#)}}difference in cost between treatment 
	groups{p_end}
{p2coldent:* {opt effd:iff(#)}}difference in effect between treatment 
	groups{p_end}
{p2coldent:* {opt n:0(#)}}number of subjects in first (control) treatment 
	group{p_end}
{synopt:{opt n1(#)}}number of subjects in second treatment group; default
	is to assume equal-sized groups if {cmd:n1()} is not specified{p_end}
{synopt:{opt cov:ariance(matname)}}variance-covariance matrix for cost and 
	effect differences{p_end}
{synopt:{opt costse(#)}}standard error for difference in cost{p_end}
{synopt:{opt effse(#)}}standard error for difference in effect{p_end}
{synopt:{opt rho(#)}}correlation of differences{p_end}
   
{syntab:Reporting}
{synopt:{opt level(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt fieller}}report Fieller confidence limits{p_end}
{synopt:[{bf:{ul:no}}]{opt tab:le}}suppress table or 
   display results as a table; default is to display{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* These options are required.{p_end}

{marker description}{...}
{title:Description}

{pstd}
{cmd:ceai} is the immediate form of {cmd:cea}; see {help immed}.
{p_end}

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt costdiff(#)} specifies the difference in average treatment cost, computed
as average cost for the control (or reference) group minus the average cost for 
the treatment (comparison) group. This option is required.

{phang}
{opt effdiff(#)} specifies the difference in the average of treatment effects, 
computed as the average effect observed for the control (or reference) group 
minus the average effect observed for the treatment (comparison) group.
This option is required.
	
{phang}
{opt n0(#)} specifies the number of subjects in the control or reference group.
This option is required.

{phang}
{opt n1(#)} specifies the number of subjects in the treatment or comparison 
group. If {cmd:n1()} is not specified, equal-sized groups are assumed.
	
{phang}
{opt covariance(matname)} specifies the variance-covariance matrix corresponding
to cost and effect differences. Either {cmd:covariance()} or the set of options 
{cmd:costse()}, {cmd:effse()}, and {cmd:rho()} is required. 

{phang}
{opt costse(#)} specifies the standard error of the difference in average 
cost. {cmd:costse()} must be specified with {cmd:effse()} and {cmd:rho()}. If 
{cmd:costse()} is not specified, {cmd:covariance()} is required.

{phang}
{opt effse(#)} specifies the standard error of the difference in average 
cost. {cmd:effse()} must be specified with {cmd:costse()} and {cmd:rho()}. If 
{cmd:effse()} is not specified, {cmd:covariance()} is required.
	
{phang}
{opt rho(#)} specifies the correlation between the difference in cost and the
difference in effect. {cmd:rho()} must be specified with {cmd:costse()} and 
{cmd:effse()}. If {cmd:rho()} is not specified, {cmd:covariance()} is required.

	
{dlgtab:Reporting}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
   intervals. The default is {cmd:level(95)} or as set by {helpb set level}.
  
{phang}
{opt fieller} specifies that Fieller confidence limits be reported. 

{phang}
{opt table} and {opt notable} specifies whether the results table should be 
displayed or suppressed; the default is to display the table showing the
ICER or NMB.


{marker examples}{...}
{title:Examples}

{pstd}
Compute ICER from difference in cost and effect{p_end}
{phang2}
{cmd:. ceai, costdiff(986) costse(326) effdiff(.01) effse(.0019) rho(-.693) n0(250)}
{p_end}


{pstd}
Specify Fieller's method for SEs{p_end}
{phang2}
{cmd:. ceai, costdiff(986) costse(326) effdiff(.01) effse(.0019) rho(-.693) n0(250) fieller}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ceai} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(n1)}}number of control observations{p_end}
{synopt:{cmd:r(n2)}}number of treatment observations{p_end}
{synopt:{cmd:r(df_r)}}degrees of freedom{p_end}
{synopt:{cmd:r(costse)}}standard error of difference for cost{p_end}
{synopt:{cmd:r(effse)}}standar error of difference for effect{p_end}
{synopt:{cmd:r(rho)}}correlation between cost and effect{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(b)}}vector of ICER or NMB values{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix{p_end}


{title:Reference}

{phang}
Glick, H. A., Doshi, J. A., Sonnad, S. S., & Polsky, D. (2014). Economic 
evaluation in clinical trials. OUP Oxford.
