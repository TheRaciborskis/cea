{smcl}
{* *! version 1.0.0  30jul2025}{...}
{vieweralsosee "cea" "help cea"}{...}
{vieweralsosee "cea (means)" "help cea_means"}{...}
{vieweralsosee "cea (models)" "help cea_models"}{...}
{vieweralsosee "ceagraph scatter" "help ceagraph scatter"}{...}
{vieweralsosee "ceai" "help ceai"}{...}
{viewerjumpto "Syntax" "ceagraph accept##syntax"}{...}
{viewerjumpto "Description" "ceagraph accept##description"}{...}
{viewerjumpto "Options" "ceagraph accept##options"}{...}
{viewerjumpto "Remarks" "ceagraph accept##remarks"}{...}
{viewerjumpto "Examples" "ceagraph accept##examples"}{...}
{viewerjumpto "Stored results" "ceagraph accept##results"}{...}
{p2colset 1 20 21 2}{...}
{p2col:{bf:ceagraph accept} {hline 2}}Cost-effectiveness acceptability curve{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Basic syntax

{p 8 16 2}
{opt ceagr:aph} {opt acc:ept} [{cmd:,} {it:options}]


{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{cmd:wtp(}{it:wlist}[{cmd:,} {help ceagraph_accept##wopts:{it:wtp_opts}}])}map
WTP values to acceptability proportions and plot{p_end}
{p2coldent:* {cmdab:fie:ller}}mark WTP values corresponding Fieller confidence
limits{p_end}
{p2coldent:* {cmdab:fie:ller(}{help ceagraph_accept##fopts:{it:fieller_opts}})}change the look of Fieller confidence limits{p_end}
{synopt :{opt level(#)}}set confidence level{p_end}

{syntab:Plot}
{synopt: {it:{help line_options}}}change the look of the line{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
{manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* These options may not be specified with bootstrapped results.{p_end}

{marker wopts}{...}
{synoptset 27 }{...}
{synopthdr:wtp_opts}
{synoptline}
{synopt: {it:{help line_options}}}change the look of paired WTP-proportion 
lines{p_end}
{synopt :{opt drop:lines}{cmd:(}{it:{help line_options}}{cmd:)}}change the look
of dropped lines to WTP values{p_end}
{synopt :{opt p:lines}{cmd:(}{it:{help line_options}}{cmd:)}}change the look of 
lines to proportion acceptable values{p_end}
{synopt :{opt nodrop:lines}}suppress drawing lines from curve to {it:x} axis{p_end}
{synopt :{opt nop:lines}}suppress drawing lines from curve to {it:y} axis{p_end}
{synoptline}
{p 4 6 2}
{it:line_options} in {opt droplines()} and {opt plines()}
override the same options specified in {it:line_options}.

{marker fopts}{...}
{synoptset 27 }{...}
{synopthdr:fieller_opts}
{synoptline}
{synopt: {it:{help line_options}}}change the look of confidence interval and
dropped lines{p_end}
{synopt :{opt drop:lines}{cmd:(}{it:{help line_options}}{cmd:)}}change the look
of dropped lines to WTP values{p_end}
{synopt :{opt ci:lines}{cmd:(}{it:{help line_options}}{cmd:)}}change the look 
of confidence interval lines{p_end}
{synopt :{opt nodrop:lines}}suppress drawing lines from curve to {it:x} axis{p_end}
{synopt :{opt noci:lines}}suppress drawing confidence interval lines{p_end}
{synoptline}
{p 4 6 2}
{it:line_options} in {opt droplines()} and {opt cilines()}
override the same options specified in {it:line_options}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:ceagraph accept} plots the cost-effectiveness acceptability curve (CEAC)
for the currently fitted {helpb cea} model. It may be used immediately after 
{helpb ceai}.

{marker options}{...}
{title:Options}

{dlgtab:Main}
{phang}
{opt wtp(wlist, wtp_opts)} specifies that, for each WTP value in {it:wlist}, 
{cmd:ceagraph accept} finds the corresponding proportion acceptable value and 
draws a dropped line from the curve to the {it:x} axis and a horizontal line 
from the corresponding proportion acceptable on the {it:y} axis to the curve.  

{pmore}
{it:wlist} specifies any combination of {bf:icer}, the stored ICER value after 
{cmd:cea} or {cmd:ceai}; {bf:ci} the lower and upper limits of the 
confidence limit; {bf:ll}, the lower limit of the confidence limit; 
{bf:ul}, the upper limit of the confidence limit; and {it:{help numlist}}, a
user-specified list of non-negative WTP values of interest. 
Specifying keywords {bf:icer}, {bf:ci}, {bf:ll}, or {bf:ul} removes all default 
value labels from the {it:x} axis and replaces default labels other than 0.5 
on the {it:y} axis.
Specifying a {it:numlist} replaces all default values from the {it:x} axis 
except the lower and upper range endpoints for WTP and replaces all default 
labels on the {it:y} axis except 0 and 1 with the mapped proportions.

{pmore}{it:wtp_opts} are:

{phang3}
{opth droplines(line_options)} customize the look of the dropped lines from the
curve to the {it:x} axis.

{phang3}
{opth plines(line_options)} customize the look of the horizontal lines from the
curve to the {it:y} axis.

{phang3}
{opt nodroplines} and {opt noplines} suppress the drawing of the dropped lines 
from the curve or the horizontal lines to coresponding accepted proportion on
the {it:y} axis.

{phang3}
{opth lp:attern(linepatternstyle)}, {opth lw:idth(linewidthstyle)},
{opth lc:olor(colorstyle)}, {opth la:lign(linealignmentstyle)},
and {opth lsty:le(linestyle)}; see {manhelpi line_options G-3}.

{phang}
{cmd:fieller} and {opt fieller(fieller_opts)} specify that Fieller-method
confidence limits are plotted on the graph. {cmd:fieller} plots confidence
limits at the default level unless otherwise specified. 
{opt fieller(fieller_opts)} may be used instead to customize the look of the
confidence and dropped lines. 

{phang2}
{it:fieller_opts} are:

{phang3}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals. The default is {cmd:level(95)}. The confidence limit specified
to {cmd:fieller()} overrides any {cmd:level()} specified for the command.

{phang3}
{opth droplines(line_options)} customize the look of the dropped lines from the
curve to the {it:x} axis.

{phang3}{opth ci:lines(line_options)} customize the look of the confidence
interval lines.

{phang3}
{opt nodroplines} and {opt nocilines} suppress the drawing of the dropped lines 
from the curve or the horizontal confidence interval lines.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals. The default is {cmd:level(95)} or, for results after 
{cmd:cea ..., vce(bootstrap)}, the level specified at estimation. 

{phang3}
{opth lp:attern(linepatternstyle)}, {opth lw:idth(linewidthstyle)},
{opth lc:olor(colorstyle)}, {opth la:lign(linealignmentstyle)},
and {opth lsty:le(linestyle)}; see {manhelpi line_options G-3}.

{dlgtab:Plot}

{phang}
{opth lp:attern(linepatternstyle)}, {opth lw:idth(linewidthstyle)},
{opth lc:olor(colorstyle)}, {opth la:lign(linealignmentstyle)},
and {opth lsty:le(linestyle)} affect the rendition of the plotted acceptance 
curve; see {manhelpi line_options G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {cmd:by()}. 
These include options for titling the graph (see {manhelpi title_options G-3})
and for saving the graph to disk (see {manhelpi saving_option G-3}).

{marker remarks}{...}
{title:Remarks}

{pstd}
After {cmd:cea} with {cmd:vce(delta)} or {cmd:ceai}, {cmd:ceagraph accept} plots 
the cumulative {it:t} distribution with degrees of freedom as saved at 
estimation. 

{pstd}
After {cmd:cea} with {cmd:vce(bootstrap)}, the empirical CEAC is plotted
instead of the cumulative {it:t} distribution. Thus, the proportion 
acceptable is the proportion of bootstrap replications at or below the 
specified WTP value. Sufficient numbers of bootstrap replications are required
for the curve to approach a normal distribution. With too few replications, 
you may observe proportions that are greater than the nominal confidence level.

{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}. use dta/rct2armex2

{phang2}. cea cost qaly, treatment(tgroup) vce(delta)

{pstd}Draw cost-effectiveness acceptability curve{p_end}
{phang2}. ceagraph accept

{pstd}As above, but with Fieller confidence limits marked{p_end}
{phang2}. ceagraph accept, fieller

{pstd}Empirical curve{p_end}
{phang2}. cea (glm cost age, family(gamma) link(log)) (betareg qaly), 
    treatment(tgroup) vce(bootstrap, reps(1000) dots(100))

{phang2}. ceagraph accept

{pstd}Mark ICER and lower & upper CI limits using percentile method{p_end}
{phang2}. ceagraph accept, wtp(icer ll ul)

{pstd}As above, but change the level{p_end}
{phang2}. ceagraph accept, wtp(icer ll ul) level(90)

{pstd}As above but find acceptable percentages for specified WTP{p_end}
{phang2}. ceagraph accept, wtp(50000(50000)250000)

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ceagraph accept} stores the following in {cmd:r()}:

{p2col 5 20 26 2: Macros}{p_end}
{synopt:{cmd:r(wtp)}}specified WTP values{p_end}
{synopt:{cmd:r(xvalues)}}values on the x-axis{p_end}
{synopt:{cmd:r(xlabel)}}x-axis label option{p_end}
{synopt:{cmd:r(ylabel)}}values on the y-axis{p_end}
{synopt:{cmd:r(yvalues)}}y-axis label option{p_end}


{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt :{cmd:r(xvals)}}values used to label the {it:x} axis{p_end}
{synopt :{cmd:r(yvals)}}values used to label the {it:y} axis{p_end}
{p2colreset}{...}
