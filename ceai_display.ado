*! version 1.0.0  07jul2015 
program ceai_display, rclass
	version 18
	syntax [, ///
		noHEADer 		///
		noTABLE 		///
		*]

//di as err `"0 in cea_display is: `0'"'

// di as err "return list in ceai_display"
// ret list

	if "`header'" == "" {
		di as text "Cost effectiveness analysis"
		di as text "Number of obs      : " as res `r(N)'
		di as text "Number of controls : " as res `r(n0)'
		di as text "Number treated     : " as res `r(n1)'
	}
	
	nobreak {
		tempname hold
		_estimates hold `hold', nullok
		postrtoe
		if "`table'" == "" {
			_coef_table, `options'
		}
		local corr = `e(rho)'
		local se2 = `e(effse)'
		local se1 = `e(costse)'
		local cost = `e(costdiff)'
		local eff = `e(effdiff)'
		local N = `e(N)'
		local n0 = `e(n0)'
		local n1 = `e(n1)'
		local icer = `e(icer)'
		local cmdline `e(cmdline)'
		tempname b V
		mat `b' = e(b)
		mat `V' = e(V)
		_estimates unhold `hold'
	}
	
	return clear
	
	return scalar rho = `corr'
	return scalar effse = `se2'
	return scalar costse = `se1'
	return scalar costdiff = `cost'
	return scalar effdiff = `eff'
		
	return scalar df_r = `N'-2
	return scalar n1 = `n1'
	return scalar n0 = `n0'
	return scalar N = `N'
	
	return scalar icer = `icer'
	
	return local cmd = "ceai"
	return local cmdline = "`cmdline'"
	return hidden local vce = "delta"
	
	return matrix V = `V'
	return matrix b = `b'
	
// 	return add
end
