gen     optmethod_str=""
replace optmethod_str="DER1-QN1"  if optmethod==1
replace optmethod_str="DER2-QN2"  if optmethod==5
replace optmethod_str="DER3-CGR"  if optmethod==4
replace optmethod_str="DER4-SOL"  if optmethod==3

replace optmethod_str="DER5-KN1"  if optmethod==11
replace optmethod_str="DER6-KN2"  if optmethod==13
replace optmethod_str="DER7-KN3"  if optmethod==12
replace optmethod_str="DER8-KN4"  if optmethod==14
replace optmethod_str="DER9-KN5"  if optmethod==15

replace optmethod_str="DIR1-SIM"  if optmethod==2
replace optmethod_str="DIR2-MAD"  if optmethod==8
replace optmethod_str="DIR3-GPS"  if optmethod==9

replace optmethod_str="STO1-SIA"  if optmethod==7
replace optmethod_str="STO2-GAL"  if optmethod==10
replace optmethod_str="STO3-SIG"  if optmethod==16

replace optmethod_str=trim(upper(optmethod_str))

*EOF
