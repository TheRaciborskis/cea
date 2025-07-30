*! version 1.0.0  21jul2025
program _cea_parse_tvar, sclass
	version 18
	syntax [if] [in], ///
		TREATment(varname numeric)	///
		[							///	
		CONtrol(string) 			///
		TLEVel(string) 				///
		]
	
	qui levelsof `treatment' `if', local(levels)
	local k_levels = `r(r)'
	_cea_check_tvar_levels `levels', tvar(`treatment')
	local _control = `s(control)'
	local _treated = `s(treated)'
		
	// user-specified control group
	local _ctrl `control'
	if `"`control'"' != "" {
		capture confirm number `control'
		if _rc {
			local lbl : value label `treatment'
			capture local control = `"`control'"':`lbl'
			if inlist(`"`control'"',"",".") {
				di as err `"value label dereference {bf:"`_ctrl'":`treatment'} not found"'
				exit 198
			}
		}
		local found : list levels & control
		if "`found'" == "" {
			di as err `"invalid control({bf:`control'})"'
			exit 198
		}
	}
	
	// user-specified treatment group
	local _tlev `tlevel'
	if `"`tlevel'"' != "" {
		capture confirm number `tlevel'
		if _rc {
			local lbl : value label `treatment'
			capture local tlevel = `"`tlevel'"':`lbl'
			if `"`control'"' == "" {
				di as err `"value label dereference {bf:"`_tlev'":`treatment'} not found"'
				exit 198
			}
		}
		local found : list levels & tlevel
		if "`found'" == "" {
			di as err `"invalid tlevel({bf:`tlevel'})"'
			exit 198
		}
	}
	
	if "`control'" == "" {
		if "`tlevel'" != "" {
			qui levelsof `treatment' if `treatment' != `tlevel', clean local(vv)
			local control : word 1 of `vv'
		}
		else {
			local control `_control'
		}
	}
	if "`tlevel'" == "" {
		if "`control'" != "" {
			qui levelsof `treatment' if `treatment' != `control', clean local(vv)
			local tlevel : word 1 of `vv'
		}
		else {
			local tlevel `_treated'
		}
	}
	
	if `control' == `tlevel' {
		di as err "control() and tlevel() may not specify the same treatment level"
		exit 198
	}
	
	sreturn local treatment `treatment'
	sreturn local control `control'
	sreturn local treated `tlevel'
	sreturn local k_levels 2
		
end
