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

/*AGEGR1 Derivation*/
	if AGE < 65 then AGEGR1 = '<65';
	else if 65 <= AGE <= 80 then AGEGR1 = '65-80';
	else if AGE > 80 then AGEGR1 = '>80';

/*Planned and Actual Treatments*/
	TRT01P = ARM;
	TRT01A = ACTARM;

/*Intent-To-Treat Population Flag*/
	if upcase(ARM) not in ('SCREEN FAILURE', 'NOT ASSIGNED') then ITTFL = 'Y';

/*Variables to keep*/
	KEEP USUBJID AGE AGEGR1 SEX RACE TRT01P TRT01A ITTFL;
run;

/*******************************************************************************
  SECTION 2: Data Creation from SDTM.EX
*******************************************************************************/

proc sort data=sdtm.ex out=sorted_ex;
	by USUBJID EXSTDTC;
run;

data ADSL02;
	set sorted_ex;
	by USUBJID EXSTDTC;
	retain TRTSDT SAFFL;

/*Date of First Exposure to Treatment*/
	if first.USUBJID then do;
		TRTSDT = input(EXSTDTC, yymmdd10.);
		SAFFL = '';
	end;

/*Safety Population Flag*/
	if EXSTDTC ^= '' then SAFFL = 'Y';

/*Date of Last Exposure, Duration, and Output*/
	if last.USUBJID then do;
		TRTEDT = input(EXENDTC, yymmdd10.);
		
		/*Duration of Treatment*/
		if nmiss(TRTSDT, TRTEDT) = 0 then do;
			TRTDUR = TRTEDT - TRTSDT + 1;
		end;
		
		output;
	end;
	
	format TRTSDT TRTEDT yymmdd10.;
	keep USUBJID TRTSDT TRTEDT TRTDUR SAFFL;
run;

/*******************************************************************************
  SECTION 3: Data Creation from SDTM.DS
*******************************************************************************/

proc sort data=sdtm.ds out=sorted_ds;
	by USUBJID;
run;

data ADSL03;
	set sorted_ds;
	by USUBJID;
	retain COMPLFL;

/*Reset flag for each new patient*/
	if first.USUBJID then do;
		COMPLFL = '';
	end;

/*Check for completion*/
	if upcase(DSDECOD) = 'COMPLETED' then COMPLFL = 'Y';

/*Output last row for patient*/
	if last.USUBJID then do;
		output;
	end;

	keep USUBJID COMPLFL;
run;

/*******************************************************************************
  SECTION 4: Merging to Create ADSL
*******************************************************************************/

proc sort data=ADSL01;
	by USUBJID;
run;

proc sort data=ADSL02;
	by USUBJID;
run;

proc sort data=ADSL03;
	by USUBJID;
run;


data ADSL;
	merge ADSL01 (in=a) ADSL02 (in=b) ADSL03 (in=c);
	by USUBJID;
	if a;
run;



