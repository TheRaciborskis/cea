*! version 1.0.0  21jul2025
program cea_mean, eclass
	version 18
	syntax varlist (min=2 max=2 numeric) [if] [in], ///
		TREATment(passthru)			///
		[							///
		CONtrol(passthru)			///
		TLEVel(passthru)			///
		WTP(numlist max=1 >=0)		///
		DIFFerences					///
		VCE(passthru)				///
		Reps(numlist max=1 >0)		///
		Level(cilevel) 				///
		]
	
	local 0_orig `0'
	
	gettoken costvar effvar : varlist
	local effvar `effvar'
	
	marksample touse
	local if if `touse'
	_cea_parse_tvar `if', `treatment' `control' `tlevel'
	local treatment `s(treatment)'
	local control `s(control)'
	local treated `s(treated)'
	local k_levels `s(k_levels)'
	
	local if `if' & inlist(`treatment',`treated',`control')	
	
	_vce_parse, opt(delta) : , `vce'
	local vcetype `r(vce)'
	
	tempname b_means V_means
	qui mean `costvar' `effvar' `if', over(`treatment')
	local df = `e(df_r)' - 1
	mat `b_means' = e(b)
	mat `V_means' = e(V)
	
	local c `control'
	local t `treated'
	
	qui nlcom (C:_b[c.`costvar'@`t'.`treatment']-_b[c.`costvar'@`c'bn.`treatment']) ///
		(Q:_b[c.`effvar'@`t'.`treatment']-_b[c.`effvar'@`c'bn.`treatment'])
	
	tempname b_diff V_diff b_cost b_eff
	mat `b_diff' = r(b)
	mat `V_diff' = r(V)
	scalar `b_cost' = r(b)[1,1]
	scalar `b_eff' = r(b)[1,2]
	
	local names `costvar':diff `effvar':diff
	mat colnames `b_diff'= `names'
	mat colnames `V_diff' = `names'
	mat rownames `V_diff' = `names'
	
	if "`wtp'" != "" {
		local depvar NMB
		qui nlcom ///
			(nmb:(`wtp'*(_b[c.`effvar'@`t'.`treatment']- _b[c.`effvar'@`c'bn.`treatment']) ///
			-(_b[c.`costvar'@`t'.`treatment']-_b[c.`costvar'@`c'bn.`treatment']))), post ///
			df(`df')
	}
	else {
		local depvar ICER
		qui nlcom ///
			(ratio: (_b[c.`costvar'@`t'.`treatment']-_b[c.`costvar'@`c'bn.`treatment']) ///
			/ (_b[c.`effvar'@`t'.`treatment']-_b[c.`effvar'@`c'bn.`treatment'])), ///
			post ///
			df(`df')
	}
	
	qui count `if' & `treatment' == `control'
	local n0 = `r(N)'
	qui count `if' & `treatment' == `treated'
	local n1 = `r(N)'
	ereturn scalar n0 = `n0'
	ereturn scalar n1 = `n1'
	
	tempname b
	matrix `b' = e(b)
	local names `depvar':r`treated'vs`control'.`treatment'
	mat colnames `b' = `names'
	
	local icer = `b'[1,1]
	
	ereturn repost b = `b', rename
	
	ereturn scalar icer = `b_cost'/`b_eff'
	capture ereturn scalar wtp = `wtp'
	ereturn scalar k_levels = `k_levels'
	ereturn scalar treated = `treated'
	ereturn scalar control = `control'
	ereturn hidden scalar C = `b_cost'
	ereturn hidden scalar Q = `b_eff'
	ereturn scalar df_r = `df'
	capture ereturn scalar df_b = `reps'
	
	if "`vce'" == "delta" {
		ereturn hidden scalar N_reps = 1
	}
	
 	ereturn hidden matrix b_diff = `b_diff', copy
	ereturn hidden matrix V_diff = `V_diff'
	ereturn hidden matrix b_means = `b_means'
	ereturn hidden matrix V_means = `V_means'
	ereturn hidden scalar aeq_ok = 0
	
	ereturn local predict
	ereturn local tlevels "`AllTLevs'"
	ereturn local tlevels `control' `treated'
	ereturn local tvar "`treatment'"
	ereturn local effvar "`effvar'"
	ereturn local costvar "`costvar'"
	ereturn local cmd "cea"
	ereturn local cmdline "cea `0_orig'"
	ereturn local title "Cost effectiveness analysis"
	ereturn hidden local depvar "`depvar'"
	ereturn hidden local cmodel "arithmetic mean"
	ereturn hidden local emodel "arithmetic mean"
	ereturn local vce `vcetype'
	ereturn local vcetype = proper("`vcetype'")
	ereturn local estat_cmd "cea_estat"
	
	mata: _b2cq("`b_diff'")

end
