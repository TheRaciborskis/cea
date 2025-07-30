*! version 1.0.0  21jul2025
program _cea_check_tvar_levels, sclass
	version 18
	syntax anything, tvar(varname)
	capture numlist "`anything'", min(2)
	if _rc {
		di as err "`tvar' has too few values, two or more levels required"
		exit 122		
	}
	capture numlist "`anything'", range(>=0)
	if _rc {
		di as err "`tvar' may not contain negative values"
		exit 452
	}
	capture numlist "`anything'", integer sort
	if _rc {
		di as err "`tvar' may not contain noninteger elements"
		exit 452
	}
	local control: word 1 of `r(numlist)'
	local treated: word 2 of `r(numlist)'
	sreturn local control `control'
	sreturn local treated `treated'
	sreturn local tlevels `r(numlist)'
end
