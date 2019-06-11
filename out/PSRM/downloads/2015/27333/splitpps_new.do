* To call up the model, issue this command:
*	ml model lf splitpps (duration: duration = x1 x2 ...) (logit: censor = x1 x2 ...) /shape
*
*	To maximize the function, issue the "ml max" command. For more difficult models, use "ml max, difficult". 
*	For better starting values, issue "ml search" after calling up the model and before maximizing it. 




program define splitpps_ll_anc1
	args lnf theta1 theta2 theta 
	tempvar p s d l 
	quietly gen double `l'=exp(-`theta1')
	quietly gen double `d'=exp(`theta2')/(1+exp(`theta2'))
	*quietly gen double `theta' = `theta3' + `theta4'*be + `theta5'*ge + `theta6'*fr

        quietly gen double `s'=1- `d' +`d'*(1/(1+(`l'*$ML_y1)^(1/`theta')))
	quietly gen double `p'=ln(`d')-ln(`theta')+((1/`theta')-1)*ln($ML_y1)+(1/`theta')*ln(`l')-2*ln(1+(`l'*$ML_y1)^(1/`theta'))

	quietly replace `lnf'=$ML_y2*(`p')+(1-$ML_y2)*ln(`s')
end



program define splitpps_ll_anc
	args lnf theta1 theta2 theta3 theta4 theta5 theta6
	tempvar p s d l theta
	quietly gen double `l'=exp(-`theta1')
	quietly gen double `d'=exp(`theta2')/(1+exp(`theta2'))
	quietly gen double `theta' = `theta3' + `theta4'*be + `theta5'*ge + `theta6'*fr

        quietly gen double `s'=1- `d' +`d'*(1/(1+(`l'*$ML_y1)^(1/`theta')))
	quietly gen double `p'=ln(`d')-ln(`theta')+((1/`theta')-1)*ln($ML_y1)+(1/`theta')*ln(`l')-2*ln(1+(`l'*$ML_y1)^(1/`theta'))

	quietly replace `lnf'=$ML_y2*(`p')+(1-$ML_y2)*ln(`s')
end



program define splitpps_ll
	args lnf theta1 theta2 theta3 
	tempvar p s d l 
	quietly gen double `l'=exp(-`theta1')
	quietly gen double `d'=exp(`theta2')/(1+exp(`theta2'))

        quietly gen double `s'=1- `d' +`d'*(1/(1+(`l'*$ML_y1)^(1/`theta3')))
	quietly gen double `p'=ln(`d')-ln(`theta3')+((1/`theta3')-1)*ln($ML_y1)+(1/`theta3')*ln(`l')-2*ln(1+(`l'*$ML_y1)^(1/`theta3'))

	quietly replace `lnf'=$ML_y2*(`p')+(1-$ML_y2)*ln(`s')
end



program define splitpps_exp
	args lnf theta1 theta2
	tempvar p s d l 
	quietly gen double `l'=exp(-`theta1')
	quietly gen double `d'=exp(`theta2')/(1+exp(`theta2'))

	quietly gen double `s'=1- `d' +`d'*( exp((-1)*`l') )
	quietly gen double `p' = ln(`d') + ln(`l') - `l'

	quietly replace `lnf'=$ML_y2*(`p')+(1-$ML_y2)*ln(`s')
end


program define splitpps_weib
	args lnf theta1 theta2 theta3 
	tempvar p s d l 
	quietly gen double `l'=exp(-`theta1')
	quietly gen double `d'=exp(`theta2')/(1+exp(`theta2'))

	quietly gen double `s' = 1- `d' + `d'*( exp( ((-1)*`l'*$ML_y1)^(1/`theta3') ))
	quietly gen double `p' = ln(`d') - ln(`theta3') + ((1/`theta3')-1)*ln($ML_y1) + (1/`theta3')*ln(`l') - (`l'*$ML_y1)^(1/`theta3')

	quietly replace `lnf'=$ML_y2*(`p')+(1-$ML_y2)*ln(`s')
end




program define splitpps_gom_anc
	args lnf theta1 theta2 theta3 theta4 theta5 theta6
	tempvar p s d l theta
	quietly gen double `l'=exp(`theta1')
	quietly gen double `d'=exp(`theta2')/(1+exp(`theta2'))
	quietly gen double `theta' = `theta3' + `theta4'*be + `theta5'*ge + `theta6'*fr

        quietly gen double `s'=1- `d' +`d'*( exp( -(1/`theta')*exp(`l')*(exp(`theta'*$ML_y1)-1) ))
	quietly gen double `p'=ln(`d') + exp(`l')*exp(`theta'*$ML_y1)*(1-(1/`theta')) + (1/`theta')*exp(`l')

	quietly replace `lnf'=$ML_y2*(`p')+(1-$ML_y2)*ln(`s')
end





