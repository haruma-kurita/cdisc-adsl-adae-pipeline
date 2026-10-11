/*******************************************************************************
Program Name: 01_adsl.sas
Author:       Haruma Kurita
Date:         11 OCT2026
Purpose:      Derive Analysis Data Subject Level (ADSL) using DATA steps
Inputs:       sdtm.ae, sdtm.dm, sdtm.ds, sdtm.ex
Outputs:      adam.adsl

Modification History:
Date        Author          Description
----------- --------------- ----------------------------------------------------
11OCT2026   Haruma Kurita   Initial creation.
*******************************************************************************/

/* Establish macro variables for dynamic directory paths */
%let sdtm_path = C:\Users\kuric\Desktop\cdisc-adsl-adae-pipeline\sdtm;
%let adam_path = C:\Users\kuric\Desktop\cdisc-adsl-adae-pipeline\adam;

/* Assign standard libraries for source and target data */
libname sdtm "&sdtm_path.";
libname adam "&adam_path.";

/*******************************************************************************
  SECTION 1: Data Creation from SDTM.DM
*******************************************************************************/

data ADSL01;
	length AGEGR1 $ 20;
	set sdtm.dm;

/*	AGEGR1 Derivation*/
	if AGE < 65 then AGEGR1 = '<65';
	else if 65 <= AGE <= 80 then AGEGR1 = '65-80';
	else if AGE > 80 then AGEGR1 = '>80';

/*	Planned and Actual Treatments*/
	TRT01P = ARM;
	TRT01A = ACTARM;

	KEEP USUBJID AGE AGEGR1 SEX RACE TRT01P TRT01A;
run;

/*******************************************************************************
  SECTION 2: Data Creation from SDTM.EX
*******************************************************************************/

proc sort data=sdtm.ex out=sorted_ex;
	by USUBJID;
run;

data ADSL02;
	set sorted_ex;


proc print data=sdtm.ex (obs=20);
	var exstdtc exendtc;
run;











