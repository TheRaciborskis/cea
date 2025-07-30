{smcl}
{* *! version 1.0.1  27jul2025}{...}
{vieweralsosee "cea" "help cea"}{...}
{vieweralsosee "cea postestimation" "help cea postestimation"}{...}
{viewerjumpto "Syntax" "estat fieller##syntax"}{...}
{viewerjumpto "Description" "estat fieller##description"}{...}
{viewerjumpto "Options" "estat fieller##options"}{...}
{viewerjumpto "Examples" "estat fieller##examples"}{...}
{viewerjumpto "Stored results" "estat fieller##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:estat fieller} {hline 2}}Fieller confidence limits{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:estat} {cmdab:fie:ller} [{cmd:,} {it:options}]


{synoptset 16}{...}
{synopthdr}
{synoptline}
{synopt:{opt lev:el(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opth cformat(%fmt)}}specify output format; default is {cmd:%9.0g}{p_end}
{synopt:{opt nofvlab:el}}display factor-variable level values{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat fieller} displays Fieller confidence limits for the 
incremental cost-effectiveness ratio (ICER) estimated by {helpb cea}. 

{pstd}
{cmd:estat fieller} is not available after {cmd:cea ..., vce(bootstrap)} 
or after {cmd:cea ..., wtp(#)} is used to compute the net monetary benefit
instead of the ICER. 


{marker options}{...}
{title:Options}

{phang}
{opt level(#)}, 
{opth cformat(%fmt)},
{opt nofvlabel}; see {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}
{cmd:. cea cost qaly, treatment(tgroup) vce(delta)}

{pstd}
Display 95% Fieller confidence limits for the estimated ICER{p_end}
{phang2}
{cmd:. estat fieller}

{pstd}
Display instead 90% Fieller confidence limits with whole numbers formatted to 
include a comma{p_end}
{phang2}
{cmd:. estat fieller, level(90) cformat(%9.0fc)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat fieller} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}
{synopt:{cmd:r(icer)}}point estimate of the ICER{p_end}
{synopt:{cmd:r(se)}}delta-method standard error of the ICER{p_end}
{synopt:{cmd:r(ll)}}Fieller confidence interval lower limit{p_end}
{synopt:{cmd:r(ul)}}Fieller confidence interval upper limit{p_end}
{synopt:{cmd:r(t_crit)}}critical value of {it:t} used in calculations{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{p2colreset}{...}


{title:Reference}

{phang}
Glick, H. A., Doshi, J. A., Sonnad, S. S., & Polsky, D. (2014). Economic 
evaluation in clinical trials. OUP Oxford.
