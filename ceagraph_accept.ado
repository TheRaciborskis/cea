*! version 1.0.0  21jul2025
program ceagraph_accept, rclass
	version 18
	syntax,	[ ///
		wtp(string asis) ///
		FIEller ///
		FIEller1(string asis) ///
		Level(cilevel) ///
		*]

	local rclass = "`r(cmd)'" == "ceai"
	local eclass = "`e(cmd)'" == "cea"

	local mylevel = `level'
	
	if `rclass' {
		if `eclass' {
			di as txt "(using results from {bf:ceai})"
		}
	}
	else {
		if `eclass' == 0 {
			error 301
		}
	}
	
	if `rclass' {
		tempname hold
		_estimates hold `hold', nullok
		postrtoe
		tempname b_diff V_diff
		mat `b_diff' = `e(costdiff)',`e(effdiff)'
		local names cost:diff effect:diff
		mat colnames `b_diff' = `names'
		mata: st_matrix("e(b_diff)",st_matrix("`b_diff'"))
		mat `V_diff' = J(2,2,0)
		mat `V_diff'[1,1] = `e(costse)'^2
		mat `V_diff'[2,2] = `e(effse)'^2
		mat `V_diff'[1,2] = `e(costse)'*`e(effse)'*`e(rho)'
		mat `V_diff'[2,1] = `V_diff'[1,2]
		mat rownames `V_diff' = `names'
		mat colnames `V_diff' = `names'
		mata: st_matrix("e(V_diff)",st_matrix("`V_diff'"))
	}
	
	if `e(icer)' < 0 {
		di as txt "({bf:ceagraph accept} not available with estimated ICER < 0)"
		exit
	}
	
	if "`e(vce)'" == "bootstrap" {
		if "`fieller'" != "" {
			di as err "{bf:fieller} is not allowed after bootstrapped estimates"
			exit 198
		}
		if "`fieller1'" != "" {
			di as err "{bf:fieller()} is not allowed after bootstrapped estimates"
			exit 198
		}
	}
	
	local sort = strmatch(`"`0'"',"* sort(*")
	if `sort' {
		di as err "option {bf:sort()} not allowed"
		exit 198
	}
	
	_parse_fieller, `fieller1' `fieller'
	local level `s(level)'
	local hasdropln `s(hasdropln)'
	local hasciln `s(hasciln)'
	local hasllciln `s(hasllciln)'
	local hasulciln `s(hasulciln)'
	local droplnopts `s(droplnopts)'
	local cilnopts `s(cilnopts)'
	local llcilnopts `s(llcilnopts)'
	local ulcilnopts `s(ulcilnopts)'
	local fieopts `s(fieopts)'
	local hasfie `s(hasfie)'
	if "`e(vce)'" == "bootstrap" {
		local df = e(df_b)
	}
	else {
		local df = e(df_r)
	}
	
	tempname c q t_q ICER WTP VarC VarQ CovCQ nmb SEnmb tval acc p ll ul
	scalar `c' = e(b_diff)[1,1]
	scalar `q' = e(b_diff)[1,2]
	scalar `ICER' = e(b)[1,1]
	scalar `VarC' = e(V_diff)[1,1]
	scalar `VarQ' = e(V_diff)[2,2]
	scalar `CovCQ' = e(V_diff)[1,2]
	
	tempname pval tcrit t2 sc2 sq2 sq_sc A B C 
	
	if `"`droplnopts'"' == "" {
		local drdef lpattern(solid)
	}
	if `"`clnopts'"' == "" {
		local cidef lstyle(p1) lpattern(dash) lcolor(gray)
	}
	
	if `hasfie' {	
		scalar `pval' = (1-(`level'/100))/2
		scalar `tcrit' = invttail(`df',`pval')
		scalar `t2' = (`tcrit')^2
		scalar `A' = `t2'*`VarQ' - (`q')^2
		scalar `B' = 2*`q'*`c' - 2*`t2'*`CovCQ'
		scalar `C' = `t2'*`VarC' - (`c')^2
		
		mata: fieller_ci("`C'","`B'","`A'","`ll'","`ul'")
		
		local maxx = scalar(`ul')
		
		local llwtp = round(scalar(`ll'))
		local ulwtp = round(scalar(`ul'))
		
		return scalar ul = scalar(`ul')
		return scalar ll = scalar(`ll')
		
		local y1 = `pval'
		local y2 = 1 - `pval'

		if `hasciln' & `hasllciln' {
			_check_line_opts, `cidef' `fieopts' `cilnopts' `llcilnopts'
			local lnopts `s(lnopts)'
			local LLCILINE yline(`y1', `lnopts')
		}
		if `hasdropln' {
			if scalar(`ll') >= 0 {
				local DROPLINE1 (pci 0 `llwtp' `y1' `llwtp', ///
					pstyle(p1) `drdef' `fieopts' `droplnopts')
				local xlab `llwtp'			
			}
		}
		if `hasciln' & `hasulciln' {
			_check_line_opts, `cidef' `fieopts' `cilnopts' `ulcilnopts'
			local lnopts `s(lnopts)'
			local ULCILINE yline(`y2', `lnopts')
		}
		if `hasdropln' {
			local DROPLINE2 (pci 0 `ulwtp' `y2' `ulwtp', ///
				pstyle(p1) `drdef' `fieopts' `droplnopts')
			local xlab `xlab' `ulwtp'
		}
		
		local sub "with `level'% Fieller confidence limits"
		local subtitle subtitle("`sub'")
	}

	// add level() to wtp
	gettoken wtp rest : wtp, parse(",")
	local rest `rest'
	local rest ,`rest'
	local rest : subinstr local rest ",," ","
	local wtp `wtp' `rest' level(`mylevel')
	
	_parse_wtp `wtp'
	local wtp `s(wtp)'
	local wtpopts `s(wtpopts)'
	local wtpplnopts `s(plnopts)'
	local wtpdroplnopts `s(droplnopts)'
	local wtphasdropln `s(hasdropln)'
	local wtphaspln `s(haspln)'
	local haswtp `s(haswtp)'	
	local haswtpciln `s(hasciln)'
	local wtpcilnopts `s(cilnopts)'
	local wtpcivals `s(civals)'
	local wtp_icer `s(wtp_icer)'
	local wtp_ll `s(wtp_ll)'
	local wtp_ul `s(wtp_ul)'
	local wtp_vals `s(wtp_vals)'
	
	_get_gropts, graphopts(`options') gettwoway
	local twowayopts `s(twowayopts)'
	local gropts `s(graphopts)'
	
	local 0 , `gropts'
	syntax [, Connect(string) PSTYle(string) LSTYle(string) *]
	if "`connect'" == "" & "`e(vce)'" == "bootstrap" {
		local connect J
	}
	if "`pstyle'" == "" {
		local pstyle p1
	}
	if "`lstyle'" == "" {
		local lstyle p1
	}
	local gropts `options' connect(`connect') pstyle(`pstyle') lstyle(`lstyle')
	
	local se = sqrt(e(V)[1,1])
	local p1 = (100-`mylevel')/200
	local p2 = 1 - `p1'
		
	foreach w in 0 `wtp' {
		scalar `nmb' = (`w')*(`q')-`c'
		scalar `SEnmb' = ///
			 sqrt((`VarC'+((`w')^2*`VarQ')) - (2*`w'*`CovCQ'))
		// cumulative t distribution
		scalar `tval' = `nmb'/`SEnmb'
		if "`e(vce)'" == "bootstrap" {
			_get_p_value `w'
			scalar `acc' = `s(pvalue)'			
		}
		else {
			scalar `acc' = t(`e(df_r)',`tval')
		}
		scalar `p' = 2*ttail(`df',abs(`nmb'/`SEnmb'))
		
		mat `WTP' = (nullmat(`WTP') \ ///
			`ICER', `w', `nmb', `SEnmb' , `acc', `tval', `p')
	}
	mat colnames `WTP' = "icer" "wtp" "nmb" "se_nmb" "acc" "tval" "p"
	
	if `haswtp' {
		if "`e(vce)'" == "bootstrap" {
			local max = e(C_max)/e(Q_max)
		}
		else {
 			local max = e(icer) * 1.75
		}
		_natscale 0 `max' 3
		local xmax `r(max)'
		local zero 0
		local xmin 0
		if "`wtp_ll'" != "" {
			local zero
			local xmin `wtp_ll'
		}
		local one 1
		if "`wtp_ul'" != "" {
			local one
			local xmax `wtp_ul'
		}
		if "`wtp_icer'`wtp_ll'`wtp_ul'" == "" & "`wtp_vals'" == "" {
			local ymid 0.5
		}
		local XLABS `xmin' `wtp_icer' `xmax'
		local YLABS `zero' `ymid' `one'
	}
	else {
		local YLABS 0 .25 .5 .75 1
	}
	
	local minx 0
	// find the maximum value of wtp at 99.9% level for the x-axis
	local t2 = (invttail(`df',0.999))^2
	scalar `A' = `t2'*`VarQ' - (`q')^2
	scalar `B' = 2*`q'*`c' - 2*`t2'*`CovCQ'
	scalar `C' = `t2'*`VarC' - (`c')^2
	mata: fieller_ci("`C'","`B'","`A'","`ll'","`ul'")
	local maxx = scalar(`ul')
	
	local gq = scalar(`q')
	local gc = scalar(`c')
	local gvc = scalar(`VarC')
	local gvq = scalar(`VarQ')
	local gccq = scalar(`CovCQ')
	
	// wtp lines
	local pciopts lstyle(p1) lpattern(dash) lcolor(%50)
	local k = rowsof(`WTP')
	// starting from row 2 because row 1 is at wtp = 0 we added above
	forvalues i = 2/`k' {
		local y = `WTP'[`i',"acc"]
		local x = `WTP'[`i',"wtp"]
		if (`wtphaspln') {
			local WTPGRAPH `WTPGRAPH' ///
			(pci `y' 0 `y' `x', pstyle(p1) `pciopts' `wtpopts' `wtpplnopts')
		}
		if (`wtphasdropln') {
			local WTPGRAPH `WTPGRAPH' ///
			(pci `y' `x' 0 `x', pstyle(p1) `pciopts' `wtpopts' `wtpdroplnopts')
		}
		if (`wtphasdropln' | `wtphaspln') {
			local y : display %5.3f `y'
		}
		local xlabs `xlabs' `x'
		local ylabs `ylabs' `y'
	}
	
	local XLABS `XLABS' `xlabs'
	local YLABS `YLABS' `ylabs'
	
	local XLABS : list uniq XLABS
	local YLABS : list uniq YLABS

	local xlabel xlabel(`XLABS', format(%10.0fc))
	local ylabel ylabel(`YLABS')
	
	// wtp cilines
	if "`wtpcivals'" != "" {
		local ops lstyle(p1) lpattern(dash) lcolor(%50)
		local ll = (100-`mylevel')/200
		local ul = 1 - `ll'
		gettoken v1 v2 : wtpcivals
		local CIGRAPH ///
			(pci `ll' 0 `ll' `v1', `ops' `wtpcilnopts') ///
			(pci `ll' `v1' 0 `v1', `ops' `wtpcilnopts') ///
			(pci `ul' 0 `ul' `v2', `ops' `wtpcilnopts') ///
			(pci `ul' `v2' 0 `v2', `ops' `wtpcilnopts')
		if `wtphaspln' {
			local yminor `yminor' `ul' `ll'
		}
	}
	
	if "`e(vce)'" == "bootstrap" {
		tempname tf
		frame create `tf'
		frame change `tf'
		mata: _get_accept()
		local ACCEPT (`ACCEPT', `gropts')
		local bb : display %21.0fc `e(N_reps)'
		local bb `bb'
		local note note("Based on `bb' bootstrap replications")
		
	}
	else {
		local ACCEPT ///
			(function y=ttail(`df',abs(((x*`gq')-`gc') / ///
				(sqrt((`gvc'+((x)^2*`gvq')) - (2*x*`gccq'))))), ///
				range(`minx' `e(icer)') `gropts' ///
			) ///
			(function y=t(`df',abs(((x*`gq')-`gc') / ///
				(sqrt((`gvc'+((x)^2*`gvq')) - (2*x*`gccq'))))), ///
				range(`e(icer)' `maxx') `gropts' ///
			)
	}
	
	twoway `ACCEPT' ///
			`DROPLINE1' `DROPLINE2' ///
			`WTPGRAPH' `CIGRAPH' ///
			, ///
		`LLCILINE' `ULCILINE' ///
		title("Cost-effectiveness acceptability curve") ///
		`subtitle' ///
		xtitle("Willingness to pay", margin(medsmall)) ///
		ytitle("Proportion acceptable", margin(medsmall)) ///
		legend(off) ///
		`xlabel' ///
		ylabel(,angle(0)) `ylabel' `ymlabel' ///
		`note' ///
		`twowayopts'
	
	return matrix table = `WTP'
	return scalar icer = scalar(`ICER')
	return local wtp `wtp'
	return scalar df = `df'
	return scalar Q_se = sqrt(e(V_diff)[2,2])
	return scalar Q = scalar(`q')
	return scalar C_se = sqrt(e(V_diff)[1,1])
	return scalar C = scalar(`c')
	
	return local xvalues `XLABS'
	return local yvalues `YLABS'
	return local xlabel `xlabel'
	return local ylabel `ylabel'
	
	if `rclass' {
		_estimates unhold `hold'
	}
	
end

program _parse_wtp, sclass
	syntax [anything] [, ///
		noDROPlines ///
		DROPlines1(string asis) ///
		noPlines ///
		Plines1(string asis) ///
		Level(cilevel) ///
		*]
	
	local haswtp = "`anything'" != ""
	
	local anything : subinstr local anything "icer" "", word count(local has_icer)
	local anything : subinstr local anything "ll" "", word count(local has_ll)
	local anything : subinstr local anything "ul" "", word count(local has_ul)
	local anything : subinstr local anything "ci" "", word count(local has_ci)
	
	local wtp_vals `anything'
	local has_vals = "`wtp_vals'" != ""
	if `has_vals' {
		capture numlist "`wtp_vals'", range(>=0)
		if _rc {
			di as err "invalid wtp({bf:`wtp_vals'})"
			exit 198
		}
		local wtp_vals `r(numlist)'
	}
	
	if `has_icer' {
		local wtp_icer `e(icer)'
	}
	if "`e(vce)'" == "bootstrap" {
		local p1 = (100-`level')/200
		local p2 = 1 - `p1'
	
		if `has_ll' | `has_ci' {
			_get_bs_value `p1'
			local wtp_ll = `s(value)'
		}
		if `has_ul' | `has_ci' {
			_get_bs_value `p2'
			local wtp_ul = `s(value)'
		}
	}
	else {
		qui _coef_table, level(`level')
		if `has_ll' | `has_ci' {
			local wtp_ll = r(table)["ll",1]
		}
		if `has_ul' | `has_ci' {
			local wtp_ul = r(table)["ul",1]
		}
	}
	
	_get_gropts, graphopts(`options')
	local wtpopts `s(graphopts)'
	
	local hasdropln = (`"`droplines'`droplines1'"' == "" | `"`droplines1'"' != "") & `haswtp'
	local haspln = (`"`plines'`plines1'"' == "" | `"`plines1'"' != "") & `haswtp'
	local hasciln = `"`cilines'`cilines1'"' != "" //& `haswtp'
	
	if `hasdropln' {
		_get_gropts, graphopts(`droplines1')
		local droplnopts `s(graphopts)'
	}
	
	if `haspln' {
		_get_gropts, graphopts(`plines1')
		local plnopts `s(graphopts)'
	}
	
	if `hasciln' {
		_get_gropts, graphopts(`cilines1')
		local cilnopts `s(graphopts)'
		local ll = e(ci_percentile)[1,1]
		local ul = e(ci_percentile)[2,1]
	}
	
	local wtp `wtp_icer' `wtp_ll' `wtp_ul' `wtp_vals'
	
	sreturn clear
	
	sreturn local wtp `wtp'
	sreturn local wtpopts `wtpopts'
	
	sreturn local hasdropln `hasdropln'
	sreturn local droplnopts `droplnopts'
	
	sreturn local haspln `haspln'
	sreturn local plnopts `plnopts'
	
	sreturn local hasciln `hasciln'
	sreturn local cilnopts `cilnopts'
	sreturn local civals `ll' `ul'
	
	sreturn local wtp_icer `wtp_icer'
	sreturn local wtp_ll `wtp_ll'
	sreturn local wtp_ul `wtp_ul'
	sreturn local wtp_vals `wtp_vals'

	sreturn local haswtp `haswtp'
end

program _parse_fieller, sclass
	syntax [,*]
	
	if `"`options'"' == "" {
		sreturn clear
		sreturn local hasfie 0
		exit
	}
	
	syntax [, ///
		Level(cilevel) ///
		noDROPlines ///
		DROPlines1(string asis) ///
		noCIlines ///
		CIlines1(string asis) ///
		noLLCIline ///
		LLCIline1(string asis) ///
		noULCIline ///
		ULCIline1(string asis) ///
		FIEller ///
		*]

	if "`level'" == "" {
		local level 95
	}
	
	_get_gropts, graphopts(`options')
	local fieopts `s(graphopts)'
	
	local hasdropln = "`droplines'" == ""
	local hasciln = "`cilines'" == ""
	local hasllciln = "`llciline'" == "" & `hasciln'
	local hasulciln = "`ulciline'" == "" & `hasciln'
	if `hasllciln' == 0 & `hasulciln' == 0 {
		local hasciln 0
	}
	
	if `hasdropln' {
		_get_gropts, graphopts(`droplines1')
		local droplnopts `s(graphopts)'
	}
	
	if `hasciln' {
		_get_gropts, graphopts(`cilines1')
		local cilnopts `s(graphopts)'
	}
	
	if `hasllciln' {
		_get_gropts, graphopts(`llciline1')
		local llcilnopts `s(graphopts)'
	}
	
	if "`ulcilines'" == "" {
		_get_gropts, graphopts(`ulciline1')
		local ulcilnopts `s(graphopts)'
	}
	
	local hasfie = `hasdropln' | `hasciln' | `hasllciln' | `hasulciln'
	
	sreturn clear
	
	sreturn local level `level'
	sreturn local fieopts `fieopts'
	
	sreturn local hasdropln `hasdropln'
	sreturn local hasciln `hasciln'
	sreturn local hasllciln `hasllciln'
	sreturn local hasulciln `hasulciln'
	
	sreturn local droplnopts `droplnopts'
	sreturn local cilnopts `cilnopts'
	sreturn local llcilnopts `llcilnopts'
	sreturn local ulcilnopts `ulcilnopts'
	
	sreturn local hasfie `hasfie'
end

program _check_line_opts, sclass
	sreturn clear
	syntax , [ ///
		AXis(passthru) /// ignored
		STYle(passthru) ///
		noEXtend ///
		LSTYle(passthru) ///
		LPattern(passthru) ///
		LWidth(passthru) ///
		LAlign(passthru) ///
		LColor(passthru) ///
		*]
	
	local _style `style'
	local _extend `extend'
	local _lstyle `lstyle'
	local _lpattern `lpattern'
	local _lwidth `lwidth'
	local _lalign `lalign'
	local _lcolor `lcolor'
	
	local ix 256
	while `"`options'"' != "" & `ix' {
		local --ix
		local 0 , `options'
		syntax , [ ///
			AXis(string) ///
			STYle(passthru) ///
			noEXtend ///
			LSTYle(passthru) ///
			LPattern(passthru) ///
			LWidth(passthru) ///
			LAlign(passthru) ///
			LColor(passthru) ///
			*]
		
		local _style `style' `_style'
		local _extend `extend' `_extend'
		local _lstyle `lstyle' `_lstyle'
		local _lpattern `lpattern' `_lpattern'
		local _lwidth `lwidth' `_lwidth'
		local _lalign `lalign' `_lalign'
		local _lcolor `lcolor' `_lcolor'
	
		local options `options'
	}
	
	local _style : word 1 of `_style'
	local _extend : word 1 of `_extend'
	local _lstyle : word 1 of `_lstyle'
	local _lpattern : word 1 of `_lpattern'
	local _lwidth : word 1 of `_lwidth'
	local _lalign : word 1 of `_lalign'
	local _lcolor : word 1 of `_lcolor'
	
	local opts ///
		`_style' `_extend' `_lstyle' `_lpattern' `_lwidth' `_lalign' `_lcolor'
	sreturn local lnopts `opts'
end

program _get_p_value, sclass
	args wtp_value
	mata: _get_p_value(`wtp_value')
	sreturn local pvalue `pval'
end

program _get_bs_value, sclass
	args pvalue
	mata: _get_bs_value(`pvalue')
	sreturn local value `bsvalue'
end

exit
