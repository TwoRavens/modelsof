****2nd Table in Appendix 1****
ologit cenvio cinc polclt triggr powdis dem gravty grv_adv, cluster(crisno)
ologit cenvio cinc polclt cincXpolclt triggr powdis dem gravty grv_adv, cluster(crisno)
ologit sevvio cinc polclt triggr powdis dem gravty grv_adv, cluster(crisno)
ologit sevvio cinc polclt cincXpolclt triggr powdis dem gravty grv_adv, cluster(crisno)

****3rd and 4th Tables in Appendix 1****
ologit cenvio cinc polclt cincXpolclt triggr powdis dem gravty grv_adv, cluster(crisno)
prvalue, x(cinc=0.139 polclt=0 cincXpolclt=0 triggr=9 dem=0 gravty=3 grv_adv=0) rest(mean) save
prvalue, x(cinc=0.139 polclt=1 cincXpolclt=0.139 triggr=9 dem=0 gravty=3 grv_adv=0) rest(mean) diff

logit rspdelay powdis dem gravty grv_adv triggr cinc polclt, cluster(crisno)
logit rspdelay powdis dem gravty grv_adv triggr cinc polclt  cincXpolclt, cluster(crisno)
