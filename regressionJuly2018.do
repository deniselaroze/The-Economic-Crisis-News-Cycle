
cd "/Users/inakisagarzazu/Dropbox/OxfordProject/"

cd "\Users\Denise Laroze P\Dropbox\CESS-Santiago\archive\OxfordProject"
cd "\Users\Profesor\Dropbox\CESS-Santiago\archive\OxfordProject"

use "BCCAP_long_Rs.dta", clear

// data management

egen mean_saw_growth = mean(saw_growth_), by(id)
egen mean_saw_inflation = mean(saw_inflation_), by(id)
egen mean_saw_unemp = mean(saw_unemp_), by(id)


label var saw_unemp_ "Saw unempl"
label  var saw_growth_ "Saw growth" 
label  var age "Age"
label  var female "Female"
label  var LR_Self_ "L-R self-placement"
label  var yearsE "Education (category)"

label var union_1 "Union member"    
label var pronat_ "Prosp. Nat. Econ."
label var retper_ "Prosp. Pers. Econ."
label var proper_ "Prosp. Pers. Econ."


// wave models

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_    if wave==2

est store C2

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_    if wave==3

est store C3

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_    if wave==4

est store C4

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_    if wave==5

est store C5


ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_    if wave==6

est store C6

esttab C* using tables/individ_waves.tex, stats(N ll) se booktabs nonumbers title(Ordered logit model of retrospective evaluations of the economy  on having watched economic news \label{tbl:waves}) ///
	label mtitles("May 2009" " Oct 2009" "Jan 2010" "May 2010" " Jun 2010") replace
estimates clear
	
/// wave models for growth news compliers


ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_    if wave==2 &  (mean_saw_growth==1 | mean_saw_growth==0)

est store cc2

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_    if wave==3 &  (mean_saw_growth==1 | mean_saw_growth==0)

est store cc3

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_    if wave==4 &  (mean_saw_growth==1 | mean_saw_growth==0)

est store cc4

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_    if wave==5 &  (mean_saw_growth==1 | mean_saw_growth==0)

est store cc5


ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_    if wave==6 &  (mean_saw_growth==1 | mean_saw_growth==0)

est store cc6

esttab cc* using tables/individ_waves_con_growth.tex, stats(N ll) se booktabs nonumbers title(Ordered logit model of retrospective evaluations of the economy  on having watched economic news by people people who were consistent growth news watchers/non-watchers \label{tbl:wavesConGrowth}) ///
	label mtitles("May 2009" " Oct 2009" "Jan 2010" "May 2010" " Jun 2010") replace

estimates clear

	/// wave models for unemployment news compliers


ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_    if wave==2 &  (mean_saw_unemp==1 |mean_saw_unemp==0)

est store cc2

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_   if wave==3 &  (mean_saw_unemp==1 |mean_saw_unemp==0)

est store cc3

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_   if wave==4 &  (mean_saw_unemp==1 |mean_saw_unemp==0)

est store cc4

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_   if wave==5 &  (mean_saw_unemp==1 |mean_saw_unemp==0)

est store cc5


ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_     if wave==6 &  (mean_saw_growth==1 | mean_saw_growth==0)

est store cc6

esttab cc* using tables/individ_waves_con_unemp.tex, stats(N ll) se booktabs nonumbers title(Ordered logit model of retrospective evaluations of the economy  on having watched economic news by people people who were consistent unemployment news watchers/non-watchers \label{tbl:wavesConUnemp}) ///
	label mtitles("May 2009" " Oct 2009" "Jan 2010" "May 2010" " Jun 2010") replace

	
estimates clear	
	

// wave models other controls

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_  union_1 i.pronat_ i.retper_ i.proper_   if wave==2

est store C2

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_   union_1 i.pronat_ i.retper_ i.proper_  if wave==3

est store C3

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_   union_1 i.pronat_ i.retper_ i.proper_  if wave==4

est store C4

ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_   union_1 i.pronat_ i.retper_ i.proper_  if wave==5

est store C5


ologit retnat_ saw_unemp_ saw_growth_ age i.i.yearsE female LR_Self_  union_1  if wave==6

est store C6

esttab C* using tables/individ_waves_control.tex, stats(N ll) se booktabs nonumbers title(Ordered logit model of retrospective evaluations of the economy  on having watched economic news \label{tbl:wavesControl}) ///
	label mtitles("May 2009" " Oct 2009" "Jan 2010" "May 2010" " Jun 2010") replace
estimates clear
	

	
/// Wave models for unemployment only

ologit retnat_ saw_unemp_  age i.i.yearsE female LR_Self_    if wave==2

est store C2

ologit retnat_ saw_unemp_  age i.i.yearsE female LR_Self_    if wave==3

est store C3

ologit retnat_ saw_unemp_  age i.i.yearsE female LR_Self_    if wave==4

est store C4

ologit retnat_ saw_unemp_  age i.i.yearsE female LR_Self_    if wave==5

est store C5


ologit retnat_ saw_unemp_  age i.i.yearsE female LR_Self_    if wave==6

est store C6

esttab C* using tables/individ_waves_unemp.tex, stats(N ll) se booktabs nonumbers title(Ordered logit model of retrospective evaluations of the economy  on having watched unemployment news \label{tbl:wavesUnemp}) ///
	label mtitles("May 2009" " Oct 2009" "Jan 2010" "May 2010" " Jun 2010") replace
estimates clear


/// wave models for growth only


ologit retnat_  saw_growth_ age i.i.yearsE female LR_Self_    if wave==2

est store C2

ologit retnat_  saw_growth_ age i.i.yearsE female LR_Self_    if wave==3

est store C3

ologit retnat_  saw_growth_ age i.i.yearsE female LR_Self_    if wave==4

est store C4

ologit retnat_  saw_growth_ age i.i.yearsE female LR_Self_    if wave==5

est store C5


ologit retnat_  saw_growth_ age i.i.yearsE female LR_Self_    if wave==6

est store C6

esttab C* using tables/individ_waves_growth.tex, stats(N ll) se booktabs nonumbers title( Ordered logit model of retrospective evaluations of the economy  on having watched growth/decline news  \label{tbl:wavesGrowth}) ///
	label mtitles("May 2009" " Oct 2009" "Jan 2010" "May 2010" " Jun 2010") replace
estimates clear	
	
	
	
	
	
//// other wave models	
	
	

ologit retnat_ age i.i.yearsE female LR_Self_  unemp_was_    if wave==2 & saw_unemp_==1

est store D2

ologit retnat_ age i.i.yearsE female LR_Self_  unemp_was_   if wave==3 & saw_unemp_==1

est store D3

ologit retnat_ age i.yearsE female LR_Self_  unemp_was_   if wave==4 & saw_unemp_==1

est store D4

ologit retnat_ age i.yearsE female LR_Self_  unemp_was_  if wave==5 & saw_unemp_==1

est store D5


ologit retnat_ age i.yearsE female LR_Self_  unemp_was_   if wave==6 & saw_unemp_==1

est store D6

est table D* , star(0.05 0.1 0.01) stats(N ll)




ologit retnat_ age i.yearsE female LR_Self_  growth_was_    if wave==2 & saw_growth_==1

est store E2

ologit retnat_ age i.yearsE female LR_Self_  growth_was_   if wave==3 & saw_growth_==1

est store E3

ologit retnat_ age i.yearsE female LR_Self_  growth_was_   if wave==4 & saw_growth_==1

est store E4

ologit retnat_ age i.yearsE female LR_Self_  growth_was_  if wave==5 & saw_growth_==1

est store E5


ologit retnat_ age i.yearsE female LR_Self_  growth_was_   if wave==6 & saw_growth_==1

est store E6

est table E* , star(0.05 0.1 0.01) stats(N ll)




ologit retnat_ age i.yearsE female LR_Self_  growth_was_ unemp_was_   if wave==2 & saw_growth_==1 & saw_unemp_==1

est store F2

ologit retnat_ age i.yearsE female LR_Self_  growth_was_  unemp_was_ if wave==3 & saw_growth_==1 & saw_unemp_==1

est store F3

ologit retnat_ age i.yearsE female LR_Self_  growth_was_ unemp_was_  if wave==4 & saw_growth_==1 & saw_unemp_==1

est store F4

ologit retnat_ age i.yearsE female LR_Self_  growth_was_ unemp_was_ if wave==5 & saw_growth_==1 & saw_unemp_==1

est store F5


ologit retnat_ age i.yearsE female LR_Self_  growth_was_  unemp_was_ if wave==6 & saw_growth_==1 & saw_unemp_==1

est store F6

est table F* , star(0.05 0.1 0.01) stats(N ll)


