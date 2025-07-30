*! 1.0.0  21jul2025
program ceagraph
	version 18
	
	gettoken sub rest : 0
	gettoken sub c : sub, parse(",")
	local rest `c' `rest'
	
	local len = length(`"`sub'"')
	if `len' == 0 {
		di as err "no subcommand specified"
		exit 198
	}
	
	if `"`sub'"' == substr("accept",1,max(3,`len')) {
		if `"`e(cmd)'"' != "cea" & `"`r(cmd)'"' != "ceai" {
			error 301
		}
	}
	else {
		if "`e(cmd)'"' != "cea" {
			error 301
		}
	}
	
	if `"`sub'"' == substr("accept",1,max(3,`len')) {
		ceagraph_accept `rest'
	}
	else if `"`sub'"' == substr("scatter",1,max(2,`len')) {
		ceagraph_scatter `rest'
	}
	else if `"`sub'"' == "voi" {
		di as err "not implemented yet"
		exit 198
	}
	else {
		di as error `"`sub' invalid subcommand"'
		exit 198
	}

end
