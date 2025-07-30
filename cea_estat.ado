*! version 1.0.0  21jul2025
program cea_estat, rclass
	version 18
	
	if "`e(cmd)'" != "cea" {
		error 301
	}
	
	gettoken sub rest : 0, parse(" ,")
	local len = length("`sub'")
	
	if `"`sub'"' == substr("fieller",1,max(1,`len')) {
		if "`e(wtp)'" != "" {
			di as err "command {bf:estat fieller} is not supported after NMB estimation with {bf:cea}"
			exit 321
		}
		cea_estat_fieller `rest'
	}
	else if `"`sub'"' == substr("summarize",1,max(2,`len')) {
		cea_estat_summarize `rest'
	}
	else if `"`sub'"' == substr("means",1,max(4,`len')) {
		cea_estat_means `rest'
	}
	else if `"`sub'"' == substr("bootstrap",1,max(4,`len')) {
		_bs_display `rest'
	}
	else {
		di as error `"`sub' unknown subcommand"'
		exit 198
	}
	return add
end

program cea_estat_bootstrap, rclass
	estat bootstrap `0'
end

program cea_estat_summarize, eclass
	syntax [varlist(numeric fv default=none)] [,*]

	tempname b b0 V V0
	
	mat `b0' = e(b)
	mat `V0' = e(V)
		
	if `e(aeq_ok)' {
		mat `b' = /*e(b),*/ e(b1), e(b2)
		mata: _getV("`V'")
		mat `V' = `V'[2...,2...]
		local names : colnames `b'
		mat rownames `V' = `names'
		mat colnames `V' = `names'
					
		local tlevels `e(tlevels)'
		local control = e(control)
		local tlevnoc : list tlevels - control
		
		forvalues i=1/`=e(k_levels)-1' {
			local nm : word `i' of `names'
			local lev : word `i' of `tlevnoc'
			gettoken r var: nm, parse(".")
			local names : subinstr local names "`r'" "`lev'" 
		}
		local names : subinstr local names "r`control'" "`control'" 

		local names : subinstr local names "`e(control)'b.`e(tvar)'" "`e(control)'.`e(tvar)'", all

		// pre-pend treatment variable
		mat `b' = J(1,2,1),`b'
		local names _treat:`e(control)'.`e(tvar)' _treat:`e(treated)'.`e(tvar)' `names'
		mat colnames `b' = `names'
		mat `V' = J(2,colsof(`V'),1) \ `V'
		mat `V' = J(rowsof(`V'),2,1) , `V'
		
		// pre-pend cost and effect variables
		mat `b' = J(1,2,1),`b'
		local names _cost:`e(costvar)' _effect:`e(effvar)' `names'
		
		mat colnames `b' = `names'
		mat `V' = J(2,colsof(`V'),1) \ `V'
		mat `V' = J(rowsof(`V'),2,1) , `V'
		
		mat colnames `b' = `names'
		mat colnames `V' = `names'
		mat rownames `V' = `names'
	}
	else {
		mat `b' = e(b_diff)
		mat `V' = e(V_diff)
		local names : coleq `b'
		
		// apppend treatment variable
		mat `b' = `b', J(1,2,1)
		local names `names' _treat:`e(control)'.`e(tvar)' _treat:`e(treated)'.`e(tvar)'
		mat colnames `b' = `names'
		mat `V' =  `V' \ J(2,colsof(`V'),1)
		mat `V' = `V', J(rowsof(`V'),2,1)
		
		mat colnames `b' = `names'
		mat colnames `V' = `names'
		mat rownames `V' = `names'
	}
	local depvar `e(depvar)'
	nobreak {
		qui ereturn repost b=`b' V=`V', rename resize
		ereturn local depvar
		estat_default summarize `varlist', `options'
		ereturn repost b=`b0' V=`V0', rename resize
		ereturn local depvar `depvar'
	}
end

program cea_estat_means, rclass
	syntax [, ///
		Level(cilevel)		///
		CFORMAT(string) 	///
		EFORMAT(string)		///
		noFVLABel 			///
	]
	
	_get_format `cformat'
	local cfmt `s(fmt)'
	_get_format `eformat'
	local efmt `s(fmt)'
	
	mat bc = e(b_means)
	mat vc = e(V_means)
	
	qui _coef_table, bmat(bc) vmat(vc) level(`level') nopvalues `fvlabel'
	mat table = r(table)
	
	local depvar "Means"
	local treat `e(tvar)'
	local cost `e(costvar)'
	local effect `e(effvar)'
	
	local treated = e(treated)
	local control = e(control)
	
	local lbl : value label `treat'
	if "`lbl'" != "" & "`fvlabel'" == "" {
		local treated : label `lbl' `treated'
		local control : label `lbl' `control'
	}
	
	local tr `treated'
	local tr_len = udstrlen(`"`treated'"')
	if `tr_len' > 27 {
		local tr = usubstr(`"`treated'"',1,25)
		local tr `tr'..
		local tr_len 27
	}
	
	local co `control'
	local co_len = udstrlen(`"`control'"')
	if `co_len' > 27 {
		local co = usubstr(`"`control'"',1,25)
		local co `co'..
		local co_len 27
	}
	
	local eq1 c.`cost'@`treat'
	local eq2 c.`effect'@`treat'
	
	local eq1_len = udstrlen("`eq1'")
	if `eq1_len' > 29 { // `cost'@`treat'
		local w1 = udstrlen("`cost'")
		local w2 = udstrlen("`treat'")
		if `w1' > 13 & `w2' > 13 {
			local abr1 13
			local abr2 13
		}
		else if `w1' > 13 & `w2' <= 13 {
			local abr1 = 13 + (13-`w2'-0)
			local abr2 13
		}
		else if `w1' <= 13 & `w2' > 13 {
			local abr1 13
			local abr2 = 13 + (13-`w1'-0)
		}
		local var1 = abbrev("`cost'",`abr1')
		local var2 = abbrev("`treat'",`abr2')
		local eq1 c.`var1'@`var2'
		local eq1_len = udstrlen("`eq1'")
	}
	
	local eq2_len = udstrlen("`eq2'")
	if `eq2_len' > 29 { // `effect'@`treat'
		local w1 = udstrlen("`effect'")
		local w2 = udstrlen("`treat'")
		if `w1' > 13 & `w2' > 13 {
			local abr1 13
			local abr2 13
		}
		else if `w1' > 13 & `w2' <= 13 {
			local abr1 = 13 + (13-`w2'-0)
			local abr2 13
		}
		else if `w1' <= 13 & `w2' > 13 {
			local abr1 13
			local abr2 = 13 + (13-`w1'-0)
		}
		local var1 = abbrev("`effect'",`abr1')
		local var2 = abbrev("`treat'",`abr2')
		local eq2 c.`var1'@`var2'
		local eq2_len = udstrlen("`eq2'")
	}
	
	local maxlen = max(`tr_len',`co_len',`eq1_len',`eq2_len')
	local maxeq = max(`eq1_len',`eq2_len')
	local maxli = max(`tr_len',`co_len')
	
	local space1 {space 1}
	local space2 {space 2}
	
	if `maxlen' >= 29 {
		local fmtti %28s
		local fmteq %29s
		local fmtli %27s
		local space0 {space 0}
		local h `maxlen'
	}
	else if `maxli' > `maxeq' {
		local mm = `maxlen'+1
		local fmtti %`mm's
		local fmteq %`mm's
		local fmtli %`maxli's
		local space0 {space 1}
		local h = `maxlen'+2
	}
	else {
		local fmtti %`maxlen's
		local fmteq %`maxlen's
		local mm = `maxlen'-1
		local fmtli %`mm's
		local space0 {space 1}
		local h = `maxlen'+1
	}
	
	local dv : display `fmtti' "`depvar'"
	local tr : display `fmtli' "`tr'"
	local co : display `fmtli' "`co'"
	local eq1 : display `fmteq' "`eq1'"
	local eq2 : display `fmteq' "`eq2'"
	
	di as txt "{hline `h'}{c TT}{hline 48}"
	di as txt "`dv'`space1'{c |} Coefficient  Std. err.     [`level'% conf. interval]"
	di as txt "{hline `h'}{c +}{hline 48}"
	di as txt "`eq1'`space0'{c |}"
	
	local b : display `cfmt' table["b",1]
	local se : display `cfmt' table["se",1]
	local ll : display `cfmt' table["ll",1]
	local ul : display `cfmt' table["ul",1]
	di as txt "`co'`space2'{c |}" as res "  `b'  `se'     `ll'   `ul'"
		
	local b : display `cfmt' table["b",2]
	local se : display `cfmt' table["se",2]
	local ll : display `cfmt' table["ll",2]
	local ul : display `cfmt' table["ul",2]
	di as txt "`tr'`space2'{c |}" as res "  `b'  `se'     `ll'   `ul'"
	
	di as txt "{hline `h'}{c +}{hline 48}"
	di as txt "`eq2'`space0'{c |}"
	
	local b : display `efmt' table["b",3]
	local se : display `efmt' table["se",3]
	local ll : display `efmt' table["ll",3]
	local ul : display `efmt' table["ul",3]
	di as txt "`co'`space2'{c |}" as res "  `b'  `se'     `ll'   `ul'"
	
	local b : display `efmt' table["b",4]
	local se : display `efmt' table["se",4]
	local ll : display `efmt' table["ll",4]
	local ul : display `efmt' table["ul",4]
	di as txt "`tr'`space2'{c |}" as res "  `b'  `se'     `ll'   `ul'"
	
	di as txt "{hline `h'}{c BT}{hline 48}"
	
	return add
	return scalar level = `level'	

end

program cea_estat_fieller, rclass

	if "`e(vce)'" == "bootstrap" {
		di as err "{bf:estat fieller} not allowed after bootstrapped estimates"
		exit 198
	}
	
	syntax [, Level(cilevel) *]
	
	_get_diopts diopts rest, `options' 
	local diopts `diopts' level(`level')
	
	if "`e(vce)'" == "delta" {
		mata : estat_ci_fieller()
	}
	else {
		mata: estat_ci_pc()
	}
	
	local ttl `r(ttl)'
	local depvar `e(depvar)'
	local treat `e(tvar)'
	local coef = e(b)[1,1]
	local se = sqrt(e(V)[1,1])
	local t = r(t_crit)
	local p = .
	local ll = r(ll)
	local ul = r(ul)
	
	tempname ci
	mat `ci' = `ll' \ `ul'
	_coef_table, cimatrix(`ci') cititle(`ttl') `diopts' nopvalues
	
	capture return scalar df = `e(df_b)'
	return scalar t_crit = `t'
	return scalar ul = `ul'
	return scalar ll = `ll'
	return scalar se = `se'
	return scalar icer = `coef'
	return add
	return scalar level = `level'

end
