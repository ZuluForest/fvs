      subroutine DBSECSUM(STDID,beginAnalYear, endTime, pretend,
     &      costUndisc,revUndisc, costDisc, revDisc, npv, irr,
     &      irrCalculated,bcRatio, bcRatioCalculated, rrr,
     &      rrrCalculated,sev, sevCalculated, forestValue,
     &      forestValueCalculated,reprodValue, reprodValueCalculated,
     &      ft3Volume, bfVolume,discountRate, sevInput, sevInputUsed)

C $Id: dbsecsum.f 1968 2017-06-07 17:10:14Z lancedavid $

      IMPLICIT NONE

      include 'DBSCOM.F77'

      character(len=*), parameter :: tableName = 'FVS_EconSummary'

      character(len=26)   :: STDID
      character(len=*)    :: pretend
      character(len=2000) :: SQLStmtStr

      integer, parameter :: zero = 0
      integer :: beginAnalYear, endTime, status,
     &           ft3Volume, bfVolume, iRet

      logical :: sevCalculated, rrrCalculated,
     &           forestValueCalculated, reprodValueCalculated,
     &           irrCalculated, bcRatioCalculated, sevInputUsed

      real :: costUndisc, revUndisc, costDisc, revDisc, npv, irr,
     &        bcRatio, rrr, sev, forestValue, reprodValue, 
     &        discountRate, sevInput
      real*8 :: costUndisc8,revUndisc8,costDisc8,revDisc8,npv8,irr8,
     &        bcRatio8, rrr8, sev8, forestValue8, reprodValue8, 
     &        discountRate8, sevInput8

      integer fsql3_bind_double,fsql3_finalize,fsql3_errmsg,
     >  fsql3_bind_int,fsql3_bind_text,fsql3_exec,fsql3_tableexists,
     >  fsql3_prepare,fsql3_step
     
      if (IDBSECON == 0) return
      
!    Make sure we have an up-to-date case ID.
      call DBSCASE(1)

!     Ensure that the FVS_EconSummary table exists in the DB.
      iRet = fsql3_tableexists(IoutDBref,"FVS_EconSummary"//CHAR(0))
      IF(iRet.EQ.0) THEN
         SQLStmtStr = 'CREATE TABLE FVS_EconSummary ('
     &          // 'CaseID char(36), '
     &          // 'StandID char(26), '
     &          // 'Year int null, '
     &          // 'Period int null, '
     &          // 'Pretend_Harvest char(3) null, '
     &          // 'Undiscounted_Cost real null, '
     &          // 'Undiscounted_Revenue real null, '
     &          // 'Discounted_Cost real null, '
     &          // 'Discounted_Revenue real null, '
     &          // 'PNV real null, '
     &          // 'IRR real null, '
     &          // 'BC_Ratio real null, '
     &          // 'RRR real null, '
     &          // 'SEV real null, '
     &          // 'Value_of_Forest real null, '
     &          // 'Value_of_Trees real null, '
     &          // 'Mrch_Cubic_Volume int null, '
     &          // 'Mrch_BoardFoot_Volume int null, '
     &          // 'Discount_Rate real null, '
     &          // 'Given_SEV real null);' // CHAR(0)
        iRet = fsql3_exec(IoutDBref,SQLStmtStr)
        IF (iRet .NE. 0) THEN
          IDBSECON = 0
          RETURN
        ENDIF
      ENDIF

      write(SQLStmtStr, *) 'INSERT INTO ',
     &   'FVS_EconSummary (CaseID, StandID, Year, Period,',
     &   'Pretend_Harvest, Undiscounted_Cost, Undiscounted_Revenue,',
     &   'Discounted_Cost, Discounted_Revenue, PNV, IRR, BC_Ratio,',
     &   'RRR, SEV, Value_of_Forest, Value_of_Trees,',
     &   'Mrch_Cubic_Volume, Mrch_BoardFoot_Volume, Discount_Rate,',
     &   'Given_SEV)','VALUES (''',CASEID,''',''',TRIM(STDID),
     &   ''',?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);' // CHAR(0)
      iRet = fsql3_prepare(IoutDBref,SQLStmtStr)
      IF (iRet .NE. 0) THEN
        iRet = fsql3_errmsg(SQLStmtStr, 200)
        PRINT *,"dbsecsum prepare error: ",TRIM(SQLStmtStr)
        IDBSECON = 0
        RETURN
      endif
      costUndisc8    = costUndisc 
      revUndisc8     = revUndisc 
      costDisc8      = costDisc 
      revDisc8       = revDisc 
      npv8           = npv 
      irr8           = irr
      bcRatio8       = bcRatio 
      rrr8           = rrr 
      sev8           = sev 
      forestValue8   = forestValue 
      reprodValue8   = reprodValue 
      discountRate8  = discountRate
      sevInput8      = sevInput

      iRet = fsql3_bind_int(IoutDBref,1, beginAnalYear)
      iRet = fsql3_bind_int(IoutDBref,2, endTime)
      iRet = fsql3_bind_text(IoutDBref,3, pretend, 3)
      if (costUndisc >= 0) 
     >  iRet = fsql3_bind_double(IoutDBref,4, costUndisc8)
      if (revUndisc >= 0) 
     >  iRet = fsql3_bind_double(IoutDBref,5, revUndisc8)
      if (costDisc >= 0) 
     >  iRet = fsql3_bind_double(IoutDBref,6, costDisc8)
      if (revDisc >= 0) 
     >  iRet = fsql3_bind_double(IoutDBref,7, revDisc8)
      iRet = fsql3_bind_double(IoutDBref,8, npv8)
      if (irrCalculated) 
     >  iRet = fsql3_bind_double(IoutDBref,9, irr8)
      if (bcRatioCalculated) 
     >  iRet = fsql3_bind_double(IoutDBref,10, bcRatio8)
      if (rrrCalculated) 
     >  iRet = fsql3_bind_double(IoutDBref,11, rrr8)
      if (sevCalculated) 
     >  iRet = fsql3_bind_double(IoutDBref,12, sev8)
      if (forestValueCalculated) 
     >  iRet = fsql3_bind_double(IoutDBref,13, forestValue8)
      if (reprodValueCalculated) 
     >   iRet = fsql3_bind_double(IoutDBref,14, reprodValue8)
      iRet = fsql3_bind_int(IoutDBref,15, ft3Volume)
      iRet = fsql3_bind_int(IoutDBref,16, bfVolume)
      iRet = fsql3_bind_double(IoutDBref,17, discountRate8)
      if (sevInputUsed) 
     >  iRet = fsql3_bind_double(IoutDBref,18, sevInput8)

      iRet = fsql3_step(IoutDBref)
      iRet = fsql3_finalize(IoutDBref)
      IF (iRet>0) THEN
        iRet = fsql3_errmsg(SQLStmtStr, 200)
        PRINT *,"dbsecsum finalize error: ",TRIM(SQLStmtStr)
        IDBSECON = 0
      endif
      return
      
      entry getDbsEconStatus(status)
         if(IDBSECON == 0) then
            status = 0   !DB-FVS output not requested
         else if(IDBSECON == 1) then
            status = 1   ! Write to summary output to DB.
         else
            status = 2   ! Write to summary and harvest output to DB.
         end if
      return
      end