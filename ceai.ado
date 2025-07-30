*! version 1.0.0  21jul2025
program ceai, rclass
	version 17
	syntax [, noHEADer noTABLE *]
	
	_get_diopts diopts est, `options'
	
	ceai_estimate, `est'
	ceai_display, `diopts' `header' `table'
	return add
end

program ceai_estimate, rclass
	syntax , ///
		COSTDiff(numlist max=1) 		/// 
		EFFDiff(numlist max=1) 			/// 
		n0(numlist integer max=1 >0) 	/// number of controls
		[ 								///
		n1(numlist integer max=1 >0) 	/// number treated
		costse(numlist max=1 >=0)		/// 
		effse(numlist max=1 >=0)		/// 
		rho(numlist max=1)	 			/// 
		COVariance(string)				///
		wtp(numlist integer) 			/// nmb
		Level(cilevel) 					///
		POST							///
		* ]

	if `"`covariance'"' == "" {
		if "`costse'" == "" & "`effse'" == "" & "`rho'" == "" {
			di as err "you must specify costse(), effse(), and rho()"
			exit 198
		}
	}
	
	if "`n1'" == "" {
		local n1 `n0'
	}
	local N = `n0' + `n1'
	
	local hasse = "`costse'"
	
	tempname c q t_q WTP VarC VarQ CovCQ CovQC nmb SEnmb tval acc p ll ul
	tempname se0 se1 corr
	
	scalar `c' = `costdiff'
	scalar `q' = `effdiff'

	if `"`covariance'"' == "" {
		scalar `VarC' = (`costse')^2
		scalar `VarQ' = (`effse')^2
		scalar `CovCQ' = (`rho')*(`costse')*(`effse')
		scalar `t_q' = `effdiff'/`effse'
		scalar `se0' = `costse'
		scalar `se1' = `effse'
		scalar `corr' = `rho'
	}
	else {
		confirm matrix `covariance'
		scalar `CovCQ' = `covariance'[1,2]
		scalar `CovQC' = `covariance'[2,1]
		if `CovCQ' != `CovQC' {
			di as err "matrix {bf:`covariance} not symmetric"
			exit 198
		}
		scalar `VarC' = `covariance'[1,1]
		scalar `VarQ' = `covariance'[2,2]
		scalar `t_q' = `effdiff'/sqrt(`VarQ')
		scalar `se0' = sqrt(`VarC')
		scalar `se1' = sqrt(`VarQ')
		scalar `corr' = `CovCQ' / (`se0'*`se1')
	}
	
	tempname ICER VICER b V
	
	scalar `ICER' = `c'/`q'
	scalar `VICER' = (`ICER')^2 * ///
		( ///
			`VarC'/`costdiff'^2 + `VarQ'/`effdiff'^2 ///
			- 2*`CovCQ'/(`costdiff'*`effdiff') ///
		)
	
	return scalar rho = `corr'	
	return scalar effse = `se1'
	return scalar costse = `se0'
	return scalar costdiff = `c'
	return scalar effdiff = `q'
		
	return scalar df_r = `N'-2
	return scalar n1 = `n1'
	return scalar n0 = `n0'
	return scalar N = `N'
	
	return scalar icer = `ICER'
	
	return local cmd = "ceai"
	return local cmdline = "ceai `0'"
	return hidden local vce = "delta"

	tempname b V
	mat `b' = J(1,1,`ICER')
	mat colnames `b' = v1
	mat `V' = J(1,1,`VICER')
	mat rownames `V' = v1
	mat colnames `V' = v1
	return matrix V = `V'
	return matrix b = `b'
	
end
