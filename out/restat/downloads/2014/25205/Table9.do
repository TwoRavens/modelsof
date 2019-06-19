clear

set memory 70m,

insheet using "...\DW_unemployment_inflationb.txt", clear tab,

/*Main variables include:
an year
taux_br average wage increases negotiated at the industry-level
taux_gen average wage increases negotiated at the firm-level
taux_diff_ ouv	average wage increases negotiated at the firm-level (blue collar)
taux_diff_emp average wage increases negotiated at the firm-level (white collar)
taux_diff_cad average wage increases negotiated at the firm-level (managers)
taux_gen_diff average wage increases negotiated at the firm-level (other)
chomage	Unemployment rate
IPC_moy	 Inflation rate
l1_chom	lag1 of U rate
l2_chom	lag2 of U rate
l1_ipc_moy lag1 of inflation
l2_ipc_moy lag2 of inflation	
smic	NMW increase
dw	wage increase in France
l1_dw	lag of general wage increase
l2_dw	lag2 of general wage increase
l1_mw	lag of NMW
l2_mw lag2 of NMW*/

generate diff_chom=0
replace diff_chom=chomage-l1_chom


/*Table 9 a firm-level ********************/
reg taux_gen ipc_moy l1_ipc_moy 
reg taux_diff_ouv ipc_moy l1_ipc_moy 
reg taux_diff_emp ipc_moy l1_ipc_moy 
reg taux_diff_cad ipc_moy l1_ipc_moy 

/*TAble 9 b industry-level************/


reg taux_br smic chomage 
reg taux_br ipc_moy chomage
reg taux_br dw chomage 

