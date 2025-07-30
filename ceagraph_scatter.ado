*! version 1.0.0  21jul2025
program ceagraph_scatter, rclass
	version 18
	syntax,	[ ///
		ICER1(string asis) 		/// plot icer estimate
		noICER					/// not documented
		WTP(string asis) 		/// wtp line
		CIlines					/// draw 95% confidence rays
		CIlines1(string asis)	///
		ELlipse					/// draw a 95% confidence ellipse
		ELlipse1(string asis)	///
		QUADrants				/// make the range symmetric around (0,0)
		QUADrants1(string asis)	///
		*]
	
	if "`e(cmd)'" != "cea" {
		error 301
	}
	
	if "`e(vce)'" != "bootstrap" {
		di as err "ceagraph scatter requires bootstrapped estimates"
		exit 198
	}
	
	local hasquad = `"`quadrants'`quadrants1'"' != ""
	local hasicer = "`icer'" == "" | `"`icer1'"' != ""

	local cix 0
	if "`cilines'" != "" {
		local _cilines1 level(95)
		local ++cix
	}
	while `"`cilines1'"' != "" {
		local ++cix
		local _cilines`cix' `cilines1'
		local 0 , `options'
		syntax , [ CIlines1(string asis) CIlines *]
		local options `options'
	}
	
	local wix 0
	while `"`wtp'"' != "" {
		local ++wix
		local _wtp`wix' `wtp'
		local 0 , `options'
		syntax , [ WTP(string asis) *]
		local options `options'
	}
	
	local eix 0
	if "`ellipse'" != "" {
		local _ellipse1 level(95)
		local ++eix
	}
	while `"`ellipse1'"' != "" {
		local ++eix
		local _ellipse`eix' `ellipse1'	
		local 0 , `options'
		syntax , [ ELlipse1(string asis) ELlipse *]
		local options `options'
	}
	
	// ellipse may extend beyond the data range so process before _natscale
	if `"`_ellipse1'"' != "" {
		forvalues i = 1/`eix' {
			_parse_ellipse, ix(`i') `_ellipse`i''
			local ellgraph `ellgraph' `s(ellgraph)'
			local tangraph `tangraph' `s(tangraph)'
			local e_qmin `s(xmin)'
			local e_qmax `s(xmax)'
			local e_cmin `s(ymin)'
			local e_cmax `s(ymax)'
		}
	}
	
	_get_gropts, graphopts(`options') gettwoway
	local twowayopts `s(twowayopts)'
	_parse_gropts, `s(graphopts)'
	local _legend `s(legend)'
	local scatter_opts `s(opts)'
	
	mata : _getmaxcq()
	
	_get_range, cmin(`c_min') cmax(`c_max') qmin(`q_min') qmax(`q_max') `twowayopts'
	
	if `"`_ellipse1'"' != "" {
		if `e_cmin' < `c_min' {
			local c_min `e_cmin'
		}
		if `e_cmax' > `c_max' {
			local c_max `e_cmax'
		}
		if `e_qmin' < `q_min' {
			local q_min `e_qmin'
		}
		if `e_qmax' > `q_max' {
			local q_max `e_qmax'
		}
	}
	
	_natscale `c_min' `c_max' 9
	local yy `r(min)'(`r(delta)')`r(max)'
	local ymin = `r(min)'
	local ymax = `r(max)'
	_natscale `q_min' `q_max' 9
	local xx `r(min)'(`r(delta)')`r(max)'
	local xmin = `r(min)'
	local xmax = `r(max)'
	
	if `hasquad' {
		_parse_quad, `quadrants1'
		mata: _getquad()
		local q_min `xmin'
		local q_max `xmax'
		local c_min `ymin'
		local c_max `ymax'

		_natscale `c_min' `c_max' 9
		local yy `r(min)'(`r(delta)')`r(max)'
		local ymin = `r(min)'
		local ymax = `r(max)'
		_natscale `q_min' `q_max' 9
		local xx `r(min)'(`r(delta)')`r(max)'
		local xmin = `r(min)'
		local xmax = `r(max)'
	}
	
	local c_obs = e(b_diff)[1,1]
	local q_obs = e(b_diff)[1,2]
	
	local pos 1
	local ord 0
	
	if `hasicer' {
		local ++pos
		local ++ord
		_parse_icer, `icer1'
		local iceropts `s(iceropts)'
		local prefix `s(prefix)'
		local suffix `s(suffix)'
		local format `s(format)'
		local mlabel `s(mlabel)'
		local icergraph scatteri `c_obs' `q_obs' `"`mlabel'"', pstyle(p1) `iceropts'
		
		local ii = e(b)[1,1] // icer
		local jj : display `format' `ii'
		local jj `jj'
		
		local ICER `prefix'`jj'`suffix'
		if "`e(wtp)'" != "" {
			local name NMB
		}
		else {
			local name ICER
		}
		local ORDER `pos' `"`name' = `ICER'"'
	}
	
	forvalues i=1/`wix' {
		local ++pos
		_parse_wtp `_wtp`i''
		local wtp `s(wtp)'
		local wtpopts `s(wtpopts)'
		local prefix `s(prefix)'
		local suffix `s(suffix)'
		local format `s(format)'
		local wtpgraph function y = `wtp'*x, range(`xmin' `xmax') `wtpopts'
		local ww : display `format' `wtp'
		local ww `ww'
		local ww `prefix'`ww'`suffix'
		local ORDER `ORDER' `pos' "WTP = `ww'"
		local WTPGR `WTPGR' (`wtpgraph')
	}
	
	if `"`_cilines1'"' != "" {
		mata : _checkcis()
		forvalues i = 1/`cix' {
			local pst = mod(`i',15)
			if `pst' == 0 {
				local pst 15
			}
			local opts pstyle(p`pst') lpattern(dash)
			local ++pos
			local ++pos
			_get_ciopts, `_cilines`i''
			local ciopts `s(ciopts)'
			local level `s(level)'
			
			mata : _getcis()
			
			local cigraph1 (function y = `slope1'*x, range(`lrange_x' `urange_x') `opts' `ciopts')
			local cigraph2 (function y = `slope2'*x, range(`lrange_y' `urange_y') `opts' `ciopts')
			
			local cigraph `cigraph' `cigraph1' `cigraph2'
		}
	}
	
	local ORDER order(`ORDER')
	
	local ylabel ylabel(`yy', angle(0) nogrid)
	local xlabel xlabel(`xx', nogrid)
	
	local nr : display %21.0fc `e(N_reps)'
	local nr `nr'
	local note note("Based on `nr' bootstrap replications", span)
	
	if `ord' == 0 {
		local _legend off
	}
	else {
		_parse_legend, `_legend'
		local _legend `s(opts)'
	}
	
	mata : cq2var()
	
	twoway ///
		(scatter c q, `scatter_opts') ///
		(`icergraph') ///
		`WTPGR' ///
		`cigraph' ///
		`ellgraph' `tangraph' ///
		, ///
		title("Cost-effectiveness scatterplot") ///
		`subtitle' ///
		ytitle("Difference in cost", margin(medsmall)) ///
		xtitle("Difference in effect", margin(medsmall)) ///
		`xlabel' xscale(noline) xline(0, lstyle(foreground) lwidth(thin)) ///
		`ylabel' yscale(noline) yline(0, lstyle(foreground) lwidth(thin)) ///
		`note' ///
		`textgr' ///
		legend(`ORDER' `_legend') ///
		`twowayopts'
	
	mata: _cleanup()
end

program _parse_gropts, sclass
	syntax [, LEGend(string) MColor(string) MSymbol(string) *]	
	if `"`msymbol'"' == "" {
		local msymbol oh
	}
	if `"`mcolor'"' == "" {
		local mcolor gs10
	}
	local opts mcolor(`mcolor') msymbol(`msymbol') `options'
	sreturn local opts `opts'
	sreturn local legend `legend'
end

program _parse_legend, sclass
	syntax, [JUSTification(string) SIze(string) Margin(string) *] 
	if `"`justification'"' == "" {
		local justification center
	}
	if `"`size'"' == "" {
		local size small
	}
	if `"`margin'"' == "" {
		local margin "r-1"
	}
	local opts justification(`justification') size(`size') margin(`margin') `options'
	sreturn local opts `opts'
end

program _get_range
	syntax , cmin(real) cmax(real) qmin(real) qmax(real) ///
		[ ///
		XSCale(string asis) YSCale(string asis) ///
		XLABel(string asis) YLABel(string asis) ///
		*]
	
	// __________________________________________ xscale and yscale
	local 0, `xscale'
	syntax [, Range(numlist min=2 max=2) *]
	if "`range'" != "" {
		local xmin : word 1 of `range'
		local xmax : word 2 of `range'
	}
	else {
		local xmin `qmin'
		local xmax `qmax'
	}
	local 0, `yscale'
	syntax [, Range(numlist min=2 max=2) *]
	if "`range'" != "" {
		local ymin : word 1 of `range'
		local ymax : word 2 of `range'
	}
	else {
		local ymin `cmin'
		local ymax `cmax'
	}
	
	if `xmin' < `qmin' {
		local qmin `xmin'
	}
	if `xmax' > `qmax' {
		local qmax `xmax'
	}
		
	if `ymin' < `cmin' {
		local cmin `ymin'
	}
	if `ymax' > `cmax' {
		local cmax `ymax'
	}

	// __________________________________________ xlabel and ylabel
	local 0 `xlabel'
	syntax [anything] [,*]
	foreach el in `anything' {
		capture numlist `"`el'"', sort
		if _rc == 0 {
			local xlist `xlist' `r(numlist)'
		}
	}
	if "`xlist'" != "" {
		local xlist : list uniq xlist
		numlist "`xlist'", sort
		local xlist `r(numlist)'
		local k : list sizeof xlist
		local xmin : word 1 of `xlist'
		local xmax : word `k' of `xlist'
		if "`xmax'" == "" {
			local xmax `xmin'
		}
	}
	
	local 0 `ylabel'
	syntax [anything] [,*]
	foreach el in `anything' {
		capture numlist `"`el'"', sort
		if _rc == 0 {
			local ylist `ylist' `r(numlist)'
		}
	}
	if "`ylist'" != "" {
		local ylist : list uniq ylist
		numlist "`ylist'", sort
		local ylist `r(numlist)'
		local k : list sizeof ylist
		local ymin : word 1 of `ylist'
		local ymax : word `k' of `ylist'
		if "`ymax'" == "" {
			local ymax `ymin'
		}
	}
	
	if `xmin' < `qmin' {
		local qmin `xmin'
	}
	if `xmax' > `qmax' {
		local qmax `xmax'
	}
		
	if `ymin' < `cmin' {
		local cmin `ymin'
	}
	if `ymax' > `cmax' {
		local cmax `ymax'
	}
	
	c_local c_min `cmin'
	c_local c_max `cmax'
	c_local q_min `qmin'
	c_local q_max `qmax'
end

program _parse_ellipse, sclass
	syntax , ix(string) [Level(cilevel) TANgent TANgent1(string asis) ///
		xmin(numlist max=1) xmax(numlist max=1) *]
	_get_gropts, graphopts(`options')
	local pst = mod(`ix',15)
	if `pst' == 0 {
		local pst 15
	}
	local ellopts pstyle(p`pst') `s(graphopts)'
	local level `level'
	mata: _ceaellipse()
	sreturn local ellgraph (`ellgraph')
	sreturn local tangraph (`tangent1') (`tangent2')
	sreturn local xmin `xmin'
	sreturn local xmax `xmax'
	sreturn local ymin `ymin'
	sreturn local ymax `ymax'
end

program _parse_quad, sclass
	syntax [, ROman ARabic OUTer SHOW(numlist max=2 >=0 <=100) ///
		PLACEment(string) SIze(string asis) Color(string asis) *]
	_get_gropts, graphopts(`options')
	opts_exclusive "`roman' `arabic'" quadrant
	local showx : word 1 of `show'
	local showy : word 2 of `show'
	if "`showx'" == "" {
		local showx 0
	}
	if "`showy'" == "" {
		local showy `showx'
	}
	
	local quadopts `s(graphopts)'
	sreturn local quadopts `quadopts'
	sreturn local placement `placement'
	sreturn local size `size'
	sreturn local color `color'
	sreturn local roman `roman'
	sreturn local arabic `arabic'
	sreturn local outer `outer'
	sreturn local showx `showx'
	sreturn local showy `showy'
end
	
program _parse_icer, sclass
	sreturn clear
	syntax [, SUFfix(string asis) PREfix(string asis) Format(string) ///
		MLabel(string asis) MLABPosition(passthru) *]
	_get_gropts, graphopts(`options')
	local iceropts `s(graphopts)'
	if `"`format'"' == "" {
		local format %21.0fc
	}
	sreturn local iceropts `iceropts' `mlabposition'
	sreturn local prefix `"`prefix'"'
	sreturn local suffix `"`suffix'"'
	sreturn local format `format'
	sreturn local mlabel `mlabel'
end

program _parse_wtp, sclass
	sreturn clear
	syntax anything [, SUFfix(string asis) PREfix(string asis) Format(string) *]
	_get_gropts, graphopts(`options')
	local wtpopts `s(graphopts)'
	local k : list sizeof anything
	if `k' > 1 {
		di as err "wtp() invalid; single value required"
		exit 198
	}
	if "`anything'" == "icer" {
		local c_obs = e(b_diff)[1,1]
		local q_obs = e(b_diff)[1,2]
		local wtp = `c_obs' / `q_obs'
	}
	else {
		local 0 , wtp(`anything')
		syntax, wtp(numlist max=1 >0)
	}
	if `"`format'"' == "" {
		local format %21.0fc
	}
	sreturn local wtp `wtp'
	sreturn local wtpopts `wtpopts'
	sreturn local prefix `"`prefix'"'
	sreturn local suffix `"`suffix'"'
	sreturn local format `format'
end

program _get_ciopts, sclass
	syntax [, Level(cilevel) *]
	_get_gropts, graphopts(`options')
	local ciopts `s(graphopts)'
	sreturn local level `level'
	sreturn local ciopts `ciopts'
end
