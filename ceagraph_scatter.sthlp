{smcl}
{* *! version 1.0.0  30jul2025}{...}
{vieweralsosee "cea" "help cea"}{...}
{vieweralsosee "cea (means)" "help cea_means"}{...}
{vieweralsosee "cea (models)" "help cea_models"}{...}
{vieweralsosee "ceagraph accept" "help ceagraph accept"}{...}
{viewerjumpto "Syntax" "ceagraph scatter##syntax"}{...}
{viewerjumpto "Description" "ceagraph scatter##description"}{...}
{viewerjumpto "Options" "ceagraph scatter##options"}{...}
{viewerjumpto "Examples" "ceagraph scatter##examples"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:ceagraph scatter} {hline 2}}Cost-effectiveness scatterplot{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Basic syntax

{p 8 16 2}
{opt ceagr:aph} {opt sc:atter} [{cmd:,} {it:options}]


{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt noicer}}suppress plotting of ICER point estimate{p_end}
{synopt :{cmdab:ci:lines}}show confidence rays on the graph{p_end}
{synopt :{cmdab:ell:ipse}}show a confidence ellipse on the graph{p_end}
{synopt :{cmdab:quad:rants}}force showing all four quadrants of the 
	cost-effectiveness plane{p_end}
{synopt :{opt wtp(#)}}add reference line for specified willingness to pay{p_end}
{synopt :{cmdab:}}{p_end}
{synopt :{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}

{syntab:Plots}
{synopt :{cmd:icer(}{help ceagraph_scatter##iceropts:{it:icer_opts}}{cmd:)}}customize
	plotting and labeling of ICER point estimate{p_end}
{synopt :{cmdab:ci:lines}{cmd:({help ceagraph_scatter##ciopts:{it:ci_opts}})}}plot 
	confidence rays; can be repeated{p_end}
{synopt :{cmdab:el:lipse}{cmd:(}{help ceagraph_scatter##ellopts:{it:ell_opts}})}plot 
	confidence ellipse; can be repeated{p_end}
{synopt :{cmdab:quad:rants}[{cmd:(}{help ceagraph_scatter##quadopts:{it:quad_opts}})]}plot 
	all four quadrants of the cost-effectiveness plane{p_end}
{synopt :{cmd:wtp(}{it:#} [{cmd:,} {help ceagraph_scatter##wtpopts:{it:wtp_opts}}])}add
	and format reference line for specified willingness to pay{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
{manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{marker iceropts}{...}
{synoptset 27 }{...}
{synopthdr:icer_opts}
{synoptline}
{synopt: {opth f:ormat(format)}}apply format to numeric ICER value in legend{p_end}
{synopt: {opt pre:fix(string)}}add text before numeric ICER value in legend{p_end}
{synopt: {opt suf:fix(string)}}add text after numeric ICER value in legend{p_end}
{synopt: {opt mlab:el(string)}}label ICER point in plot with text{p_end}
{synopt: {it:{help marker_options}}}change look of marker (color, size, etc.){p_end}
{synopt: {it:{help marker_label_options:other_label_options}}}change 
look or position of marker labels{p_end}
{synoptline}

{marker ciopts}{...}
{synoptset 27 }{...}
{synopthdr:ci_opts}
{synoptline}
{synopt :{opt level(#)}}set confidence level; default is {bf:level(95)}{p_end}
{synopt: {it:{help line_options}}}affect rendition of the plotted curves{p_end}
{synoptline}
{p 4 6 2}

{marker ellopts}{...}
{synoptset 27 }{...}
{synopthdr:ell_opts}
{synoptline}
{synopt :{opt level(#)}}set confidence level; default is {bf:level(95)}{p_end}
{synopt: {it:{help connect_options}}}change look of line{p_end}
{synoptline}
{p 4 6 2}

{marker quadopts}{...}
{synoptset 27 }{...}
{synopthdr:quad_opts}
{synoptline}
{synopt: {opt show(# [#])}}percentage of 3rd quadrant x- and y-axes to show{p_end}
{synopt: {opt ar:abic}}label the quadrants with Arabic numerals{p_end}
{synopt: {opt ro:man}}label the quadrants with Roman numerals{p_end}
{synopt: {opt out:er}}place the quadrant number in the outer corner{p_end}
{synopt: {it:{help textbox_options}}}change look of text{p_end}
{synoptline}

{marker wtpopts}{...}
{synoptset 27 }{...}
{synopthdr:wtp_opts}
{synoptline}
{synopt: {opth f:ormat(format)}}apply format to numeric WTP value in legend{p_end}
{synopt: {opt pre:fix(string)}}add text before numeric WTP value in legend{p_end}
{synopt: {opt suf:fix(string)}}add text after numeric WTP value in legend{p_end}
{synopt: {it:{help line_options}}}affect rendition of the plotted curves{p_end}
{synoptline}

{marker description}{...}
{title:Description}

{pstd}
{opt ceagraph scatter} plots a cost-effectiveness scatterplot and the calculated
incremental cost-effectiveness ratio (ICER) from the currently-fitted 
{helpb cea} model. Estimates must be from a model estimated with 
{cmd:vce(bootstrap)}.


{marker options}{...}
{title:Options}
{dlgtab:Main}

{phang}
{opt noicer} specifies that the point estimate of the ICER not be shown on the 
graph. By default, the point estimate is shown on top of the bootstrap 
replicate estimates. 

{phang}
{opt cilines} specifies that confidence rays be shown on the graph. By default,
a 95% confidence level or the level set by {helpb set level} is used to draw 
the lines. Confidence rays are drawn to correspond to the bootstrap percentile
confidence limits. To add additional confidence intervals or to customize the 
default lines, use the {cmd:cilines()} specification.

{pmore}
{ul:Note}: If your bootstrap replications cross multiple quadrants, then 
{cmd:ceagraph scatter} prints a note and does not draw the confidence rays. It 
may still be valid to use the percentile confidence limits. If so, you can
add them to the graph by specifying the lower and upper limit values to 
{cmd:wtp()} and customizing the look of the lines using the same
{help ceagraph_scatter##wtpopts:{it:wtp_opts}}. Percentile confidence limits
can be obtained with {helpb estat bootstrap}. 

{phang}
{opt ellipse} specifies that a confidence ellipse be shown on the graph. By 
default, a 95% confidence level or the level set by {helpb set level} is used to 
draw the ellipse. To add additional confidence ellipses or to customize the 
default ellipse, use the {cmd:ellipse()} specification.

{phang}
{opt quadrants} specifies that the graph show all four quadrants of the 
cost-effectiveness plane whether bootstrap replicates fall in a quadrant or not. 
By default, the graph is restricted to the range of the data. To add quadrant
labelling or other customizations, use the 
{cmd:quadrants()} specification.

{phang}
{opt wtp(#)} specifies that a reference line for the specified 
willingness-to-pay be added to the graph. To customize the look of the line, 
use the {cmd:wtp(}{it:#}{cmd:,}{it:wtp_opts}{cmd:)} specification. This option
may be repeated.

{phang}
{it:marker_options} specify how the bootstrap replication points on the graph 
are to be designated.  Markers are the ink used to mark where points are
on a plot.  Markers have shape, color, and size, and other characteristics.  
See {manhelpi marker_options G-3} for a description of markers and the options 
that specify them.

{dlgtab:Plots}

{phang}
{opt icer(icer_opts)} specifies how to format the legend entry for the ICER 
point estimate plot and options for plotting the point itself.

{phang2}
{it:icer_opts} may be any combination of the following:

{phang3}
{opth format(format)} specifies the numeric format for the value of the ICER
point estimate in the legend box. The default is to separate 1000's with a comma
and show no digits to the right of the decimal point.

{phang3}
{opt prefix(string)} and {opt suffix(string)} specify text to include before 
or after the value of the ICER point estimate in the legend box. 
Unicode symbols are supported for the prefix. For a general overview of 
working with Unicode strings in Stata, see {findalias frunicode}.

{phang3}
{opt mlabel(string)} specifies text to include as a marker label for the ICER
in the graph. This option may be combined with {cmd:legend(off)} to label the 
ICER in the graph and suppress the legend entirely.

{phang3}
{it:marker_options} control the symbol, color, and size of the marker for the 
plotted ICER point. See {manhelpi marker_options G-3} for a description of 
markers and the options that specify them.

{phang3}
{it:other_label_options} are any of the marker label options other than 
{opt mlabel(varname)} documented in 
{help scatter##marker_label_options:twoway scatter} for marker label options, 
including {opt mlabposition()}, {opt mlabcolor()}, and {opt mlabsize()} to 
control the label position, color, and text size for the plotted ICER point.

{phang}
{opt cilines(ci_opts)} specifies confidence rays be graphed and customizes their
appearance. This option may be repeated. {it:ci_opts} may be any combination 
of the following:

{phang2}
{opt level(#)} specifies the confidence level, as a percentage, for confidence 
intervals. The default is {cmd:level(95)} or as set by {helpb set level}.

{phang2}
{it:line_options} include 
{cmd:lstyle({it:{help linestyle}})}, 
{cmd:lpattern(}{it:{help linepatternstyle}}{cmd:)}, 
{cmd:lwidth(}{it:{help linewidthstyle}}{cmd:)},
{cmd:lalign(}{it:{help linealignmentstyle}}{cmd:)},
{cmd:lcolor(}{it:{help colorstyle}}{cmd:)}. See 
{bf:{manhelp line G-2:graph twoway line}}.

{phang}
{opt ellipse(ell_opts)} specifies that a confidence ellipse be graphed and 
customizes its appearance. This option may be repeated. {it:ell_opts} may be 
any combination of the following:

{phang2}
{opt level(#)} specifies the confidence level, as a percentage, for confidence 
intervals. The default is {cmd:level(95)} or as set by {helpb set level}.

{phang2}
{it:line_options} are 
{cmd:lstyle({it:{help linestyle}})}, 
{cmd:lpattern(}{it:{help linepatternstyle}}{cmd:)}, 
{cmd:lwidth(}{it:{help linewidthstyle}}{cmd:)},
{cmd:lalign(}{it:{help linealignmentstyle}}{cmd:)},
{cmd:lcolor(}{it:{help colorstyle}}{cmd:)}. See 
{bf:{manhelp line G-2:graph twoway line}}.

{phang}
{opt quadrants(quadopts)} specifies that all four quadrants be graphed, 
regardless of where the bootstrap points lie. {it:quad_opts} may be:

{phang2}
{opt show(# [#])} specifies what percentage of the quadrant on the diagonal to 
    show when the scatter points lie entirely in one quadrant. For example, if
    all points are in the 1st quadrant, {cmd:show()} controls the percentage of
    the 3rd quadrant that is shown. The first # applies to the x-axis and the 
    second # applies to the y-axis. When the second # is not specified, it is 
    the same as the first #. The default is {bf: show(0 0)}.

{phang2}
{opt arabic} and {opt roman} labels the quadrants with either Arabic 
or Roman numerals. Specifying one of these options implies {bf:show(100)}.

{phang3}
{opt outer} specifies that {cmd:ceagraph} place the quadrant number in the
    outer corner instead of the middle of the quadrant. 

{phang2}
{it:{help textbox_options}} include 
{cmdab:tsty:le(}{it:{help textboxstyle}}{cmd:)},
{cmdab:orient:ation(}{it:{help orientationstyle}}{cmd:)},
{cmdab:si:ze(}{it:{help textsizestyle}}{cmd:)},
{cmdab:c:olor(}{it:{help colorstyle}}{cmd:)},
{cmdab:j:ustification(}{it:{help justificationstyle}}{cmd:)},
{cmdab:al:ignment(}{it:{help alignmentstyle}}{cmd:)},
{cmd:box},
{cmdab:bc:olor(}{it:{help colorstyle}}{cmd:)},
{cmdab:fc:olor(}{it:{help colorstyle}}{cmd:)}, and
{cmdab:lsty:le(}{it:{help linestyle}}{cmd:)}. See 
{manhelpi textbox_options G-3}. 

{phang3}
{cmdab:place:ment(}{it:{help compassdirstyle}}{cmd:)} overrides default 
placement of the number relative to its anchoring location, either the center
of the quadrant or the outer corner if {cmd:outer} is specified.

{phang}
{opt wtp(#, wtp_opts)} specifies to plot the line corresponding to a 
    willingness to pay of {it:#} and format it according to {it:wtp_opts}.

{phang2}
{it:wtp_opts} may be any combination of the following:

{phang3}
{opth format(format)} specifies the numeric format for the value of the WTP
point estimate in the legend box. The default is to separate 1000's with a 
comma and show no digits to the right of the decimal point.

{phang3}
{opt prefix(string)} and {opt suffix(string)} specify text to include before 
or after the value of the ICER point estimate in the legend box. 
Unicode symbols are supported for the prefix. For a general overview of 
working with Unicode strings in Stata, see {findalias frunicode}.

{phang3}
{it:line_options} are 
{cmd:lstyle({it:{help linestyle}})}, 
{cmd:lpattern(}{it:{help linepatternstyle}}{cmd:)}, 
{cmd:lwidth(}{it:{help linewidthstyle}}{cmd:)},
{cmd:lalign(}{it:{help linealignmentstyle}}{cmd:)},
{cmd:lcolor(}{it:{help colorstyle}}{cmd:)}. See 
{bf:{manhelp line G-2:graph twoway line}}.

{phang3}
{opt text(text_arg)} is useful for labeling the WTP line if the legend has
been suppressed. See {manhelpi added_text_options G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {cmd:by()}.
These include options for titling the graph (see {manhelpi title_options G-3})
and for saving the graph to disk (see {manhelpi saving_option G-3}).

{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}
{cmd:. cea cost qaly, treatment(tgroup)}{p_end}

{pstd}Draw CE scatterplot{p_end}
{phang2}{cmd:. ceagraph scatter}{p_end}

{pstd}Add default 95% confidence ellipse{p_end}
{phang2}{cmd:. ceagraph scatter, ellipse}{p_end}

{pstd}As above, but put legend under the plot{p_end}
{phang2}{cmd:. ceagraph scatter, ellipse legend(position(6))}{p_end}

{pstd}Customize titles for x- and y-axis{p_end}
{phang2}
{cmd:. ceagraph scatter, xtitle("Change in QALYs") ytitle("Change in Cost ($)")}
{p_end}

{pstd}Suppress ICER value in graph{p_end}
{phang2}{cmd:. ceagraph scatter, noicer}{p_end}

{pstd}
As above and change the plot symbols to blue plusses with 50% transparency
{p_end}
{phang2}
{cmd:. ceagraph scatter, noicer msymbol(+) mcolor(blue%50)}
