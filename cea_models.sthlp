{smcl}
{* *! version 1.0.0  30jul2025}{...}
{vieweralsosee "cea (means)" "help cea_means"}{...}
{vieweralsosee "ceagraph accept" "help ceagraph accept"}{...}
{vieweralsosee "ceagraph scatter" "help ceagraph scatter"}{...}
{vieweralsosee "cea postestimation" "help cea postestimation"}{...}
{vieweralsosee "ceai" "help ceai"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "wtp" "help wtp"}{...}
{vieweralsosee "heabs" "help heabs"}{...}
{vieweralsosee "hcost" "help hcost"}{...}
{viewerjumpto "Syntax" "cea_models##syntax"}{...}
{viewerjumpto "Description" "cea_models##description"}{...}
{viewerjumpto "Options" "cea_models##options"}{...}
{viewerjumpto "Examples" "cea_models##examples"}{...}
{viewerjumpto "Stored results" "cea_models##results"}{...}
{p 1 14 16 0}{...}
{bf:cea} {hline 2} Cost-effectiveness from models of cost and outcome{p_end}
{...}

{marker syntax}{...}
{title:Syntax}

{phang}
{cmd:cea} 
{cmd:(}{it:cmodel}{cmd:)} {cmd:(}{it:emodel}{cmd:)}
{ifin}{cmd:,} 
{cmd:{ul:treat}ment(}{it:tvar}{cmd:)} 
[{cmd:wtp(}{it:#}{cmd:)} {it:{help cea_models##ceaopts:ceaopts}}]


{phang}
{it:tvar} must contain non-negative integer values representing the treatment 
levels.

{pstd}
The syntax for {it:cmodel} and {it:emodel} is

{phang2}
{it:model {help depvar} {help indepvars} [, options]}

{phang}
{it:{help cea_models##cmodel:model}} is an estimation command, and {it:options} are 
{it:model}-specific estimation options.

{synoptset 20 tabbed}{...}
{marker ceaopts}{...}
{synopthdr:ceaopts}
{synoptline}
{syntab:Main}
{p2coldent:* {opt treat:ment(tvar)}}specify treatment variable{p_end}
{synopt:{opt wtp(#)}}compute net monetary benefit for specified willingness to
	pay{p_end}
{synopt:{opt con:trol(#)}}specify the level of {it:tvar} that is the control
	{p_end}
{synopt:{opt tlev:el(#)}}specify the level of {it:tvar} that is the treatment
	{p_end}
	
{syntab:Reporting}
{synopt :{opt level(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt aeq:uations}}display auxiliary estimation results{p_end}
{synopt :{it:{help cea_models##display:display_options}}}control columns and column
	formats, row spacing, line width, and factor-variable labeling{p_end}
{synopt :{opt nohe:ader}}suppress output header{p_end}
{synopt :{opt notab:le}}suppress coefficient table{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}* This option is required.{p_end}
{p 4 6 2}{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}


{marker cmodel}{...}
{pstd}
{it:cmodel} and {it:emodel}

{pmore}
{it:cmodel} specifies the model for the cost variable. {it:emodel} specifies
the model for the effect variable. The {it:model} for cost and effect may be 
any single-equation cross-sectional Stata or user-written 
{help u_estimation:estimation command} that supports 
{help fvvarlist:factor variables}, and
{helpb margins}, and models the conditional mean of a single {it:depvar}, 
possibly as a function of covariates. Different models may be used for cost 
and effect.


{marker description}{...}
{title:Description}

{pstd}
{cmd:cea} computes the incremental cost-effectiveness ratio (ICER) or net
monetary benefit (NMB) for a treatment compared to an alternative for the 
bivariate cost and outcome dependent variables. 

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt treatment(tvar)} specifies the name of the variable that indicates 
treatment assignment. {it:tvar} must be nonnegative and integer-valued.

{phang}
{opt wtp(#)} specifies that {cmd:cea} report the net monetary benefit at a
willingness to pay {it:#} instead of the default incremental 
cost-effectiveness ratio.

{phang}
{cmd:control(}{it:#} | {it:label}{cmd:)} specifies the level of {it:tvar} that 
is the control.  The default is the first treatment level.  
You may specify the numeric level {it:#} (a nonnegative integer) or the 
label associated with the numeric level. 
{bf:control()} and {bf:tlevel()} may not specify the same treatment level.

{phang}
{cmd:tlevel(}{it:#} | {it:label}{cmd:)} specifies the level of {it:tvar} that 
is the treatment.  The default is the second (or first non-control) treatment 
level.  
You may specify the numeric level {it:#} (a nonnegative integer) or the 
label associated with the numeric level. 
{bf:tlevel()} and {bf:control()} may not specify the same treatment level.

{dlgtab:SE}

{phang}
{cmd:vce(bootstrap)} specifies how the VCE and, correspondingly, the standard 
errors are calculated. Bootstrap samples are drawn within strata
defined by {it:tvar}. Other standard and reporting options for bootstrap  
are available; see {helpb vce_option:[R] {it:vce_option}}.

{dlgtab:Reporting}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals. The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{cmd:aequations} specifies that the cost and effect model parameters be 
displayed. By default, the results for these auxiliary parameters are not 
displayed. {cmd:aequations} is only available on replay with 
{cmd:vce(}{helpb bootstrap}{cmd:)} standard errors. 

{marker display}{...}
{phang}
{it:display_options} {bf:noci}, {bf:{ul:nopv}alues}, {bf:vsquish}, 
{bf:{ul:noempty}cells}, {bf:{ul:base}levels}, {bf:{ul:allbase}levels}, 
{bf:{ul:nofvlab}el}, {bf:fvwrap(}{it:#}{bf:)}, {bf:fvwrapon(}{it:style}{bf:)},
{bf:cformat(}{help format:{it:%fmt}}{bf:)}, 
{bf:pformat(}{it:%fmt}{bf:)}, 
{bf:sformat(}{it:%fmt}{bf:)}, 
and {bf:nolstretch};
see {helpb estimation_options##display_options:[R] Estimation options}.

{phang}
{opt noheader} suppresses the header information from output. 

{phang}
{opt notable} suppresses the table from output.

{phang}
{opt coeflegend}; 
see {helpb estimation_options##display_options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}
Compute ICER with two treatment conditions, assuming control group is the 
first group using linear regression to adjust for age{p_end}
{phang2}{cmd:. cea (regress cost age) (regress qaly age), treatment(tgroup)}{p_end}

{pstd}Report regression coefficients on replay{p_end}
{phang2}{cmd:. cea, aequations}{p_end}

{pstd}
Use gamma family and log link for cost and beta regression for the outcome
{p_end}
{phang2}
{cmd:. cea (glm cost age, family(gamma) link(log)) (betareg qaly age), }
{cmd: treatment(tgroup)}
{p_end}

{pstd}Compute net monetary benefit for a willingness to pay of $50,000{p_end}
{phang2}{cmd:. cea (regress cost age) (regress qaly age), treatment(tgroup) wtp(50000)}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cea} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 26 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(n0)}}number of control observations{p_end}
{synopt:{cmd:e(n1)}}number of treated observations{p_end}
{synopt:{cmd:e(k_levels)}}number of levels in treatment variable{p_end}
{synopt:{cmd:e(treated)}}level of treatment variable defined as treated{p_end}
{synopt:{cmd:e(control)}}level of treatment variable defined as control{p_end}
{synopt:{cmd:e(icer)}}calculated ICER value{p_end}
{synopt:{cmd:e(wtp)}}WTP value for calculated NMB{p_end}
{synopt:{cmd:e(prop_q}{it:k}{cmd:)}}percent of simulations in the {it:k}th quadrant{p_end}

{p2col 5 20 26 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:cea}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(design)}}study design, RCT{p_end}
{synopt:{cmd:e(costvar)}}name of cost variable{p_end}
{synopt:{cmd:e(effvar)}}name of effect or outcome variable{p_end}
{synopt:{cmd:e(tvar)}}name of treatment variable{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(tlevels)}}levels of treatment variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b} {cmd:V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}

{p2col 5 20 26 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 26 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}

{pstd}
In addition to the above, the following is stored in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 26 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}matrix containing the coefficients with their standard 
errors, test statistics, p-values, and confidence intervals{p_end}
							   
{title:Reference}

{phang}
Glick, H. A., Doshi, J. A., Sonnad, S. S., & Polsky, D. (2014). Economic 
evaluation in clinical trials. OUP Oxford.
