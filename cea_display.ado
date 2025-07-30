*! version 1.0.0  21jul2025
program cea_display
	version 18
	syntax [, ///
		noHEADer 		///
		noTABLE 		///
		DIFFerences 	///
		AEQuations		///
		*]

	opts_exclusive "`differences' `aequations'"
	
	if "`aequations'" != "" & `e(aeq_ok)' == 0 {
		di as txt "option {bf:aequations} ignored"
		local aequations
	}
	
	_get_diopts diopts rest, `options'
	local diopts `diopts'
	
	if `"`rest'"' != "" {
		di as err `"option {bf:`rest'} not allowed"'
		exit 198
	}
	
	display
	
	if "`coeflegend'" == "coeflegend" {
		_coef_table, coeflegend `header' `table'
		exit
	}
	
	if "`header'" == "" {
		_cea_header
	}
	
	if "`table'" == "" {
		if "`differences'" != "" {
			tempname b_diff V V_diff
			mat `b_diff' = e(b), e(b_diff)
			mat `V' = e(V), J(1, 2, .)
			mat `V_diff' = J(2, 1, .) , e(V_diff)
			mat `V_diff' = `V' \ `V_diff'
			_coef_table, bmatrix(`b_diff') vmatrix(`V_diff') neq(3) `diopts'
		}
		else if "`aequations'" != "" {
			tempname b V
			mat `b' = e(b), e(b1), e(b2)
			local stripe : colfullnames `b'
			tempname V
			mata: _getV("`V'")
			mat rownames `V' = `stripe'
			mat colnames `V' = `stripe'
			local k = 1 + `e(k_eq1)' + `e(k_eq2)'		
			_coef_table, bmatrix(`b') vmatrix(`V') neq(`k') `diopts'
		}
		else {
			_coef_table, `diopts'
		}
	}	
end
