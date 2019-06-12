xtgee      gem   tradeopenness_unlogged   fdi_unlogged      portgdp  sap_implementation   gdppercap_logged   democracy , i (  polity) t (  time) robust

xtgee     gdi   tradeopenness_unlogged   fdi_unlogged      portgdp  sap_implementation   gdppercap_logged   democracy , i (  polity) t (  time) robust

ologit      wecon wecon_lag1   tradeopenness_unlogged   fdi_unlogged      portgdp  sap_implementation   gdppercap_logged   democracy if  globz==0 &  year>1981, cluster(  polity) robust

ologit      wecon wecon_lag1   tradeopenness_unlogged   fdi_unlogged      portgdp  sap_implementation   gdppercap_logged   democracy if  globz==1 &  year>1981, cluster(  polity) robust

ologit       wopol wopol_lag1   tradeopenness_unlogged   fdi_unlogged      portgdp  sap_implementation   gdppercap_logged   democracy if  globz==0 &  year>1981, cluster(  polity) robust

ologit       wopol wopol_lag1   tradeopenness_unlogged   fdi_unlogged      portgdp  sap_implementation   gdppercap_logged   democracy if  globz==1 &  year>1981, cluster(  polity) robust

ologit     wosoc wosoc_lag1   tradeopenness_unlogged   fdi_unlogged      portgdp  sap_implementation   gdppercap_logged   democracy if  globz==0 &  year>1981, cluster(  polity) robust

ologit     wosoc wosoc_lag1   tradeopenness_unlogged   fdi_unlogged      portgdp  sap_implementation   gdppercap_logged   democracy if  globz==1 &  year>1981, cluster(  polity) robust


end