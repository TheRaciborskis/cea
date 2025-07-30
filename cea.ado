*! version 1.0.0  21jul2025
program cea, eclass
	version 18
	local vv : di "version " string(_caller()) ", missing:"

	syntax [anything] [if] [in] [, bootcall vce(string) noBOOTstrap *]
	
	_parse expand eq opt : 0
	
	if `eq_n' > 2 {
		di as err "too many equations specified"
		exit 198
	}
	
	if replay() {
		if `"`e(cmd)'"' != "cea" {
			error 301
		}
		if _by() {
			error 190
		}
		cea_display `0'
		exit
	}
	
	mata: _initcea()
	
	local boot_ok 1
	if `eq_n' == 1 {
		local first : word 1 of `0'
		capture which `first'
		if _rc == 0 {
			local boot_ok 0
		}
	}
	
	if /*`eq_n' == 2 &*/ `"`bootstrap'"' == "" & `boot_ok' {
		if `"`bootcall'"' == "" {
			if `"`vce'"' == "" {
				local vce bootstrap
			}
			else {
				gettoken vcetype vcerest : vce , parse(", ")
				local lsub = length(`"`vcetype'"')
				if `eq_n' == 1 {
					if `"`vcetype'"' != substr("bootstrap", 1, max(4,`lsub')) ///
						& `"`vcetype'"' != "delta" {
						di as error `"vcetype {bf:`vcetype'} not allowed"'
						exit 198
					}
				}
				else {
					if `"`vcetype'"' != substr("bootstrap", 1, max(4,`lsub')) {
						di as error `"vcetype {bf:`vcetype'} not allowed"'
						exit 198
					}
				}
			}
			
			_get_reps `vce'
			local reps `s(reps)'
			local vce vce(`s(vce)')			
		}
	}
	
	local 0 `anything' `if' `in', `options' `vce' //`reps'
	`vv' cap noi _vce_parserun cea, noeqlist : `0' bootcall
	if "`s(exit)'" != "" | `r(rc)' {
		mata: _fincea()
		local 0 : list clean 0
		ereturn local cmdline `"cea `0'"'
		exit
	}		
	
	`vv' Estimate `0'
	
	mata: _fincea()
	
	ereturn local cmdline `"cea `0'"'
end

program Estimate, eclass
	version 18
	local vv : di "version " string(_caller()) ", missing:"
	
	_parse expand eq opt : 0
	
	if `eq_n' == 1 {
		local first : word 1 of `0'
		capture which `first'
		if _rc == 0 {
			gettoken cmd 0 : 0
			syntax [anything(everything)] [, noTABLE noHEADer *]				
			_get_diopts diopts options, `options'
			local diopts `diopts' `table' `header'
			cea_eq1 `anything', `options' cmd(`cmd')
		}
		else {
			syntax anything(everything) [, DIFFerences noTABLE noHEADer *]	
			_get_diopts diopts options, `options'
			local diopts `diopts' `differences' `table' `header'
			cea_mean `anything', `options' `differences'
		}
	}
	else if `eq_n' == 2 {
		syntax anything(everything) [, DIFFerences noTABLE noHEADer *]
		_get_diopts diopts options, `options'
		local diopts `diopts' `differences' `table' `header'
		cea_eq2 `anything', `options' `differences'
	}
	else {
		di as err "too many equations specified"
		exit 198
	}

	cea_display, `diopts'
end

program _get_reps, sclass
	syntax anything [, Reps(numlist max=1 >0) *]	
	if "`anything'" == "delta" {
		sreturn local vce `anything'
		exit
	}
	if "`reps'" == "" {
		local reps $CEA_BOOTSTRAP_REPS
		if "`reps'" == "" {
			local reps 50
		}
	}
	sreturn local vce `anything', `options' reps(`reps')
	sreturn local reps reps(`reps')
end
