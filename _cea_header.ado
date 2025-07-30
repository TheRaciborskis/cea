*! version 1.0.0  21jul2025
program _cea_header
	local ttl `e(title)'
	if `"`ttl'"' == "" {
		local ttl Cost effectiveness analysis
	}
	di as text "`ttl'"
	__cea_header
end

program __cea_header
	local n : display %22.0fc `e(N)'
	local n `n'
	local len = length("Number of obs      = `n'")
	local col = 78 - `len' + 1
	
	local n0 : display %22.0fc `e(n0)'
	local n0 `n0'
	local len1 = length("`n0'")
	local col1 = 78 - `len1' + 1
	
	local n1 : display %22.0fc `e(n1)'
	local n1 `n1'
	local len2 = length("`n1'")
	local col2 = 78 - `len2' + 1
	
	di as text "Cost model   : " as res "`e(cmodel)'" ///
		_col(`col') as text "Number of obs      = " as res "`n'"
	di as text "Effect model : " as res "`e(emodel)'" ///
		_col(`col') as text "Number of controls = " _col(`col1') as res "`n0'"
	di as text ///
		_col(`col') as text "Number treated     = " _col(`col2') as res "`n1'"
end
