regress  MIDduration demdumA demdumB territory contiguity allied caprat_init hegemon 
eststo model1

regress  MIDduration demdumA demdumB territory contiguity allied caprat_init hegemon contigdem
eststo model2

regress  MIDduration demdumA demdumB territory contiguity allied caprat_init hegemon powerdem
eststo model3

regress  MIDduration demdumA demdumB territory contiguity allied caprat_init hegemon powerdem contigdem
eststo model4

*esttab model1 model2 model3 model4 using "durationrep.tex", b(3) se(3)
