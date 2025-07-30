*! version 1.0.0  21jul2025
program cea_eq2, eclass
	version 18
	syntax anything [if] [in], 		///
		TREATment(passthru)			///
		[							///
		CONtrol(passthru)			///
		TLEVel(passthru)			///
		WTP(numlist max=1 >=0)		///
		VCE(passthru)				///
		Reps(numlist max=1 >0)		///
		bootcall					///
		NOIsily						///  not documented
		]
	
	local 0_orig `0'
	
	_parse expand eq opt : 0
	
	__parse_eq `eq_1'
	local costvar `s(depvar)'
	local costx `s(indepvars)'
	local opts1 `s(opts)'
	local cmd1 `s(cmd)'
	
	__parse_eq `eq_2'
	local effvar `s(depvar)'
	local effx `s(indepvars)'
	local opts2 `s(opts)'
	local cmd2 `s(cmd)'
	
	marksample touse
	markout `touse' `costx' `effx'
	local if if `touse'
	
	_cea_parse_tvar `if', `treatment' `control' `tlevel'
	local treatment `s(treatment)'
	local control `s(control)'
	local treated `s(treated)'
	local k_levels `s(k_levels)'
	
	qui replace `touse' = 0 if !inlist(`treatment',`treated',`control')
	
	_vce_parse, opt(delta) : , `vce'
	local vcetype = proper("`r(vce)'")
	
	tempname b_means V_means
	qui mean `costvar' `effvar' `if', over(`treatment')
 	local df = `e(df_r)' - 1
	mat `b_means' = e(b)
	mat `V_means' = e(V)
		
	tempname b b_diff V_diff b_cost b_eff
	
	local c `control'
	local t `treated'
	
	qui `noisily' `cmd1' `costvar' ib`c'.`treatment' `costx' `if', `opts1'
	
	tempname b1 V1
	mat `b1' = e(b)
	mat `V1' = e(V)
	local k_eq1 `e(k_eq)'
	if "`k_eq1'" == "" {
		local k_eq1 1
	}
	local coleq1 : coleq `b1'
	local coleq1 : subinstr local coleq1 "_" "`e(depvar)'", word all
	mat coleq `b1' = `coleq1'
	
	qui margins rb`c'.`treatment', contrast post
	scalar `b_cost' = e(b)[1,1]
	mat `V_diff' = e(V)
	
	qui `noisily' `cmd2' `effvar' ib`c'.`treatment' `effx' `if', `opts2'
	
	tempname b2 V2
	mat `b2' = e(b)
	mat `V2' = e(V)
	local k_eq2 `e(k_eq)'
	if "`k_eq2'" == "" {
		local k_eq2 1
	}
	local coleq2 : coleq `b2'
	local coleq2 : subinstr local coleq2 "_" "`e(depvar)'", word all
	mat coleq `b2' = `coleq2'
	
	local rank = `e(rank)'
	qui margins rb`c'.`treatment', contrast post
	scalar `b_eff' = e(b)[1,1]
	mat `V_diff' = `V_diff', e(V)
	
	mat `b_diff' = `b_cost', `b_eff'
	mat `V_diff' = diag(`V_diff')
	
	local n = `e(N)'
	
	local names `costvar':diff `effvar':diff
	mat colnames `b_diff'= `names'
	mat colnames `V_diff' = `names'
	mat rownames `V_diff' = `names'
		
	if "`wtp'" != "" {
        mat `b' = (`wtp'*`b_eff') - (`b_cost')
		local depvar NMB
	}
	else {
        mat `b' = `b_cost'/`b_eff'
		local depvar ICER
	}
	
	local names r`treated'vs`control'.`treatment'
	mat colnames `b' = `names'
	
	tempname V
	mat `V' = 1	// temporary, will be replaced by bootstrap
	mat colnames `V' = `names'
	mat rownames `V' = `names'

	qui count `if' & `treatment' == `control'
	local n0 = `r(N)'
	qui count `if' & `treatment' == `treated'
	local n1 = `r(N)'
	
	local icer = `b'[1,1]
	
	ereturn clear
	ereturn post `b' `V', depname(`depvar') esample(`touse') obs(`n') dof(`df')
	
	ereturn scalar n0 = `n0'
	ereturn scalar n1 = `n1'
	
	ereturn scalar icer = `b_cost'/`b_eff'
	capture ereturn scalar wtp = `wtp'
	ereturn scalar k_levels = `k_levels'
	ereturn scalar treated = `treated'
	ereturn scalar control = `control'
	ereturn hidden scalar C = `b_cost'
	ereturn hidden scalar Q = `b_eff'
	ereturn hidden scalar aeq_ok = 1
	capture ereturn scalar df_b = `reps'

	if "`vce'" == "delta" {
		ereturn hidden scalar N_reps = 1
	}
	
 	ereturn hidden matrix b_diff = `b_diff', copy
	ereturn hidden matrix V_diff = `V_diff'
	ereturn hidden matrix b_means = `b_means'
	ereturn hidden matrix V_means = `V_means'
	
	ereturn hidden matrix b1 = `b1'
	ereturn hidden matrix V1 = `V1'
	ereturn hidden scalar k_eq1 = `k_eq1'
	ereturn hidden matrix b2 = `b2'
	ereturn hidden matrix V2 = `V2'
	ereturn hidden scalar k_eq2 = `k_eq2'
	
	ereturn local predict
	ereturn local tlevels `control' `treated'
	ereturn local tvar "`treatment'"
	ereturn local effvar "`effvar'"
	ereturn local costvar "`costvar'"
	ereturn local cmd "cea"
	ereturn local cmdline "cea `0_orig'"
	ereturn local title "Cost effectiveness analysis"
	ereturn hidden local depvar "`depvar'"
	ereturn hidden local cmodel "`cmd1'"
	ereturn hidden local emodel "`cmd2'"
	ereturn local vce `vce'
	ereturn local vcetype `vcetype'
	ereturn local estat_cmd "cea_estat"
		
	mata: _b2cq("`b_diff'")

end

program __parse_eq, sclass
	syntax anything [,*]
	
	gettoken cmd anything : anything
	
	__check_cmd, `cmd'
	local cmd `s(cmd)'
	
	local 0 `anything', `options'
	syntax varlist(numeric) [,*]
	
	gettoken depvar indepvars : varlist
	
	sreturn local depvar `depvar'
	sreturn local indepvars `indepvars'
	sreturn local cmd `cmd'
	sreturn local opts `options'
end

program __check_cmd, sclass
	syntax [,*]
	local cmd `options'
	local 0 , `options'
	//syntax [, REGress glm logit probit]
	sreturn local cmd `cmd'
end
