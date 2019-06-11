*********************

* Maps replication

*********************

clear

insheet using Paramilitary_August_16.csv

summ

keep if ano==2003

sort id
sort radm2

keep ano radm2 id priogrid_gid xcoord ycoord radm1 codmpio depto municipio auc d_coca h_coca_mayor3 h_coca_menor3 h_coca p_coca_mayor3 p_coca_menor3 p_coca_total dcoca dcult baja_auc homi_auc terro_auc terror_count drugs tribut_2_log_sq tribut_2

destring auc, replace force
destring d_coca, replace force
destring dcult, replace force
destring h_coca_mayor3, replace force
destring h_coca_menor3, replace force
destring h_coca, replace force
destring p_coca_mayor3, replace force
destring p_coca_menor3, replace force
destring p_coca_total, replace force
destring baja_auc, replace force
destring homi_auc, replace force
destring terro_auc, replace force
destring terror_count, replace force
destring drugs, replace force
destring tribut_2_log_sq, replace force
destring tribut_2, replace force
destring radm1, replace force
destring id, replace force

*** Choco map ***

keep if radm1==13

generate merge=.
replace merge=469 if radm2=="ACANDI"
replace merge=470 if radm2=="ALTO BAUDO (PIE DE PATO)"
replace merge=471 if radm2=="BAGADO"
replace merge=472 if radm2=="BAHIA SOLANO (CIUDAD MUTI"
replace merge=473 if radm2=="BAJO BAUDO (PIZARRO)"
replace merge=474 if radm2=="BOJAYA (BELLA VISTA)"
replace merge=475 if radm2=="CONDOTO"
replace merge=478 if radm2=="LITORAL DEL SAN JUAN"
replace merge=479 if radm2=="ISTMINA"
replace merge=480 if radm2=="JURADO"
replace merge=481 if radm2=="LLORO"
replace merge=482 if radm2=="NOVITA"
replace merge=483 if radm2=="NUQUI"
replace merge=484 if radm2=="QUIBDO"
replace merge=485 if radm2=="RIOSUCIO"
replace merge=486 if radm2=="SAN JOSE DEL PALMAR"
replace merge=487 if radm2=="SIPI"
replace merge=488 if radm2=="TADO"
replace merge=489 if radm2=="UNGUIA"
	 
outsheet using choco.csv, comma

***

clear

insheet using Paramilitary_August_16.csv

summ

keep if ano==2003

sort id
sort radm2

keep ano radm2 id priogrid_gid xcoord ycoord radm1 codmpio depto municipio auc d_coca h_coca_mayor3 h_coca_menor3 h_coca p_coca_mayor3 p_coca_menor3 p_coca_total dcoca dcult baja_auc homi_auc terro_auc terror_count drugs tribut_2_log_sq tribut_2

destring auc, replace force
destring d_coca, replace force
destring dcult, replace force
destring h_coca_mayor3, replace force
destring h_coca_menor3, replace force
destring h_coca, replace force
destring p_coca_mayor3, replace force
destring p_coca_menor3, replace force
destring p_coca_total, replace force
destring baja_auc, replace force
destring homi_auc, replace force
destring terro_auc, replace force
destring terror_count, replace force
destring drugs, replace force
destring tribut_2_log_sq, replace force
destring tribut_2, replace force
destring radm1, replace force
destring id, replace force

*** Valle map ***

keep if radm1==31

generate merge=.
replace merge=1012 if radm2=="ALCALA"
replace merge=1013 if radm2=="ANDALUCIA"
replace merge=1014 if radm2=="ANSERMANUEVO"
replace merge=1017 if radm2=="BUENAVENTURA"
replace merge=1018 if radm2=="BUGALAGRANDE"
replace merge=1019 if radm2=="CAICEDONIA"
replace merge=1020 if radm2=="CALIMA  (DARIEN)"
replace merge=1022 if radm2=="CARTAGO"
replace merge=1023 if radm2=="DAGUA"
replace merge=1024 if radm2=="EL AGUILA"
replace merge=1025 if radm2=="EL CAIRO"
replace merge=1026 if radm2=="EL CERRITO"
replace merge=1027 if radm2=="EL DOVIO"
replace merge=1028 if radm2=="FLORIDA"
replace merge=1029 if radm2=="GINEBRA"
replace merge=1030 if radm2=="GUACARI"
replace merge=1032 if radm2=="JAMUNDI"
replace merge=1033 if radm2=="LA CUMBRE"
replace merge=1036 if radm2=="OBANDO"
replace merge=1037 if radm2=="PALMIRA"
replace merge=1038 if radm2=="PRADERA"
replace merge=1039 if radm2=="RESTREPO"
replace merge=1040 if radm2=="RIOFRIO"
replace merge=1041 if radm2=="ROLDANILLO"
replace merge=1044 if radm2=="SEVILLA"
replace merge=1045 if radm2=="TORO"
replace merge=1046 if radm2=="TRUJILLO"
replace merge=1047 if radm2=="TULUA"
replace merge=1048 if radm2=="ULLOA"
replace merge=1049 if radm2=="VERSALLES"
replace merge=1051 if radm2=="YOTOCO"
replace merge=1052 if radm2=="YUMBO"
replace merge=1053 if radm2=="ZARZAL"

outsheet using valle.csv, comma

***

clear

insheet using Paramilitary_August_16.csv

summ

keep if ano==2003

sort id
sort radm2

keep ano radm2 id priogrid_gid xcoord ycoord radm1 codmpio depto municipio auc d_coca h_coca_mayor3 h_coca_menor3 h_coca p_coca_mayor3 p_coca_menor3 p_coca_total dcoca dcult baja_auc homi_auc terro_auc terror_count drugs tribut_2_log_sq tribut_2

destring auc, replace force
destring d_coca, replace force
destring dcult, replace force
destring h_coca_mayor3, replace force
destring h_coca_menor3, replace force
destring h_coca, replace force
destring p_coca_mayor3, replace force
destring p_coca_menor3, replace force
destring p_coca_total, replace force
destring baja_auc, replace force
destring homi_auc, replace force
destring terro_auc, replace force
destring terror_count, replace force
destring drugs, replace force
destring tribut_2_log_sq, replace force
destring tribut_2, replace force
destring radm1, replace force
destring id, replace force

*** Santander map ***

keep if radm1==28

generate merge=.
replace merge=855 if radm2=="AGUADA"
replace merge=857 if radm2=="ARATOCA"
replace merge=859 if radm2=="BARICHARA"
replace merge=860 if radm2=="BARRANCABERMEJA"
replace merge=863 if radm2=="BUCARAMANGA"
replace merge=865 if radm2=="CALIFORNIA"
replace merge=866 if radm2=="CAPITANEJO"
replace merge=867 if radm2=="CARCASI"
replace merge=868 if radm2=="CEPITA"
replace merge=869 if radm2=="CERRITO"
replace merge=870 if radm2=="CHARALA"
replace merge=871 if radm2=="CHARTA"
replace merge=872 if radm2=="CHIMA"
replace merge=873 if radm2=="CHIPATA"
replace merge=874 if radm2=="CIMITARRA"
replace merge=876 if radm2=="CONFINES"
replace merge=877 if radm2=="CONTRATACION"
replace merge=878 if radm2=="COROMORO"
replace merge=879 if radm2=="CURITI"
replace merge=880 if radm2=="EL CARMEN"
replace merge=881 if radm2=="EL GUACAMAYO"
replace merge=882 if radm2=="EL PE?ON"
replace merge=883 if radm2=="EL PLAYON"
replace merge=884 if radm2=="ENCINO"
replace merge=885 if radm2=="ENCISO"
replace merge=886 if radm2=="FLORIAN"
replace merge=887 if radm2=="FLORIDABLANCA"
replace merge=890 if radm2=="GALAN"
replace merge=888 if radm2=="GAMBITA"
replace merge=891 if radm2=="GIRON"
replace merge=892 if radm2=="GUACA"
replace merge=894 if radm2=="GUAPOTA"
replace merge=895 if radm2=="GUAVATA"
replace merge=889 if radm2=="GUEPSA"
replace merge=896 if radm2=="HATO"
replace merge=897 if radm2=="JESUS MARIA"
replace merge=898 if radm2=="JORDAN"
replace merge=899 if radm2=="LA BELLEZA"
replace merge=901 if radm2=="LANDAZURI"
replace merge=902 if radm2=="LEBRIJA"
replace merge=903 if radm2=="LOS SANTOS"
replace merge=905 if radm2=="MACARAVITA"
replace merge=904 if radm2=="MALAGA"
replace merge=906 if radm2=="MATANZA"
replace merge=907 if radm2=="MOGOTES"
replace merge=908 if radm2=="MOLAGAVITA"
replace merge=909 if radm2=="OCAMONTE"
replace merge=910 if radm2=="OIBAS"
replace merge=911 if radm2=="ONZAGA"
replace merge=913 if radm2=="PALMAR"
replace merge=914 if radm2=="PALMAS DEL SOCORRO"
replace merge=912 if radm2=="PARAMO"
replace merge=915 if radm2=="PIEDECUESTA"
replace merge=916 if radm2=="PINCHOTE"
replace merge=917 if radm2=="PUENTE NACIONAL"
replace merge=918 if radm2=="PUERTO PARRA"
replace merge=919 if radm2=="PUERTO WILCHES"
replace merge=921 if radm2=="SABANA DE TORRES"
replace merge=923 if radm2=="SAN BENITO"
replace merge=924 if radm2=="SAN GIL"
replace merge=925 if radm2=="SAN JOAQUIN"
replace merge=926 if radm2=="SAN JOSE MIRANDA"
replace merge=928 if radm2=="SAN VICENTE DE CHUCURI"
replace merge=930 if radm2=="SANTA HELENA DE OPON"
replace merge=931 if radm2=="SIMACOTA"
replace merge=932 if radm2=="SOCORRO"
replace merge=933 if radm2=="SUAITA"
replace merge=935 if radm2=="SURATA"
replace merge=936 if radm2=="TONA"
replace merge=938 if radm2=="VALLE DE  SAN JOSE"
replace merge=937 if radm2=="VELEZ"
replace merge=939 if radm2=="VETAS"
replace merge=941 if radm2=="ZAPATOCA"

outsheet using santander.csv, comma
