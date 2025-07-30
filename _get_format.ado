*! version 1.0.0  21jul2025
program _get_format, sclass
	version 18
	syntax [anything(name=format)]
	
	// c(cformat) -- coefficients, std. errors, and confidence limits
	// max format width is 9
	// figure out display format; all we care is the number of digits after
	// the decimal point and what the decimal point is
	
	if "`c(cformat)'" != "" {
		local fmt `c(format)'
	}
	
	if "`format'" != "" {
		local check : display `cformat' 0
		local fmt `format'
	}
	
	if "`fmt'" == "" {
		local fmt %9.0g
	}
	
	else {
		// allowed: %xx[.|,]yy{g|f|e}[c]
		local dot "."
		local dp = strpos("`fmt'",".")
		if `dp' == 0 {
			local dp = strpos("`fmt'",",")
			local dot ","
		}
		local _fmt = substr("`fmt'",`dp',.)
		local ++dp
		local fmt = substr("`fmt'",`dp',.)
		
		local fmt : subinstr local fmt "f" "", count(local f)
		local fmt : subinstr local fmt "g" "", count(local g)
		local fmt : subinstr local fmt "e" "", count(local e)
		local fmt : subinstr local fmt "c" "", count(local c)
		
		local fmt %9`_fmt'
	}
	
	sreturn local fmt `fmt'
end
