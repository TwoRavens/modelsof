*******defining schooling variable
gen inuniv = inmuniv + infuniv
gen inhigh = inmhigh + infhigh
gen insec = inmsec + infsec
gen inprim = inmprim + infprim

gen outuniv = outmuniv + outfuniv
gen outhigh = outmhigh + outfhigh
gen outsec = outmsec + outfsec
gen outprim = outmprim + outfprim

gen inunivshare = inuniv/infte
gen inhighshare = inhigh/infte
gen insecshare = insec/infte
gen inprimshare = inprim/infte

gen outunivshare = outuniv/outfte
gen outhighshare = outhigh/outfte
gen outsecshare = outsec/outfte
gen outprimshare = outprim/outfte

bysort mark : egen totin = sum(infte)
bysort mark : egen totout = sum(outfte)
bysort mark : egen totinuniv = sum(inuniv)
bysort mark : egen totinhigh = sum(inhigh)
bysort mark : egen totinsec = sum(insec)
bysort mark : egen totinprim = sum(inprim)

bysort mark : egen totoutuniv = sum(outuniv)
bysort mark : egen totouthigh = sum(outhigh)
bysort mark : egen totoutsec = sum(outsec)
bysort mark : egen totoutprim = sum(outprim)

gen totinunivshare = totinuniv / totin
gen totinhighshare = totinhigh / totin
gen totinsecshare = totinsec / totin
gen totinprimshare = totinprim / totin

gen totoutunivshare = totoutuniv / totout
gen totouthighshare = totouthigh / totout
gen totoutsecshare = totoutsec / totout
gen totoutprimshare = totoutprim / totout

gen totinschooledshare = (totinhigh + totinuniv )/ totin
gen totoutschooledshare = (totouthigh + totoutuniv) / totout

