      SUBROUTINE SITERANGE(IWHO,IS,SILOW,SIHIGH)
      IMPLICIT NONE
C----------
C UT $Id$
C----------
C
C SUBROUTINE TO RETURN THE SITE INDEX RANGE FOR A SPECIES.
C
C THIS SUBROUTINE IS CALLED FROM **SITSET** AND **REGENT**.  
C----------
C  SPECIES ORDER:
C  1=WB,  2=LM,  3=DF,  4=WF,  5=BS,  6=AS,  7=LP,  8=ES,  9=AF, 10=PP,
C 11=PI, 12=WJ, 13=GO, 14=PM, 15=RM, 16=UJ, 17=GB, 18=NC, 19=FC, 20=MC,
C 21=BI, 22=BE, 23=OS, 24=OH
C
C VARIANT EXPANSION:
C GO AND OH USE OA (OAK SP.) EQUATIONS FROM UT
C PM USES PI (COMMON PINYON) EQUATIONS FROM UT
C RM AND UJ USE WJ (WESTERN JUNIPER) EQUATIONS FROM UT
C GB USES BC (BRISTLECONE PINE) EQUATIONS FROM CR
C NC, FC, AND BE USE NC (NARROWLEAF COTTONWOOD) EQUATIONS FROM CR
C MC USES MC (CURL-LEAF MTN-MAHOGANY) EQUATIONS FROM SO
C BI USES BM (BIGLEAF MAPLE) EQUATIONS FROM SO
C OS USES OT (OTHER SP.) EQUATIONS FROM UT
C
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
COMMONS
C----------
      REAL SITELO(MAXSP),SITEHI(MAXSP),SLO(MAXSP),SHI(MAXSP)
      REAL SILOW, SIHIGH
      INTEGER IS,IWHO
C----------
C  DEFINITION OF VARIABLES:
C----------
C      IS -- FVS SPECIES INDEX NUMBER
C    IWHO -- 1 IF CALLED FROM SUBROUTINE **SITSET**
C            2 IF CALLED FROM SUBROUTINE **REGENT**
C  SITEHI -- UPPER SITE INDEX VALUE FOR SUBROUTINE **SITSET**
C  SITELO -- LOWER SITE INDEX VALUE FOR SUBROUTINE **SITEST**
C     SHI -- UPPER SITE INDEX VALUE FOR SUBROUTINE **REGENT**
C     SLO -- LOWER SITE INDEX VALUE FOR SUBROUTINE **REGENT**
C----------
C  DATA STATEMENTS:
C----------
C  SITE INDEX RANGE VALUES USED IN SUBROUTINE **SITSET**.
C  THESE VALUES SHOULD BE BASED ON THE BASE-AGE OF THE SITE CURVE
C  BEING USED FOR THAT SPECIES.
C
C  WHEN CHANGING THESE VALUES, ALSO CHANGE THE CORRESPONDING VALUES IN
C  ARRAYS SLO AND SHI, ADJUSTING VALUES FOR WB, LM, WF, BS, LP, ES, AF,
C  PP, AND OS AS DIRECTED.
C----------
      DATA SITELO/
     &  20.,  20.,  30.,  40.,  40.,  30.,  40.,  40.,  50.,  40.,
     &   5.,   5.,   5.,   5.,   5.,   5.,  20.,  30.,  30.,   5.,
     &   5.,  15.,  20.,   5./
C
      DATA SITEHI/
     &  50.,  50.,  70.,  80.,  90.,  70.,  85., 100.,  90.,  80.,
     &  20.,  15.,  20.,  20.,  15.,  15.,  60., 120.,  90.,  15.,
     &  30.,  40.,  50.,  20./
C----------
C  SITE INDEX RANGE VALUES USED IN SUBROUTINE **REGENT**.
C  VALUES HERE FOR WB, LM, WF, BS, LP, ES, AF, PP, AND OS ARE ADJUSTED
C  TO A 50-YEAR AGE BASIS EQUIVALENT TO THE BASE-AGE BASIS VALUES THAT
C  APPEAR IN ARRAYS SITELO AND SITEHI.
C----------
      DATA SLO/
     &  15.,  15.,  30.,  20.,  20.,  30.,  27.,  20.,  27.,  23.,
     &   5.,   5.,   5.,   5.,   5.,   5.,  20.,  30.,  30.,   5.,
     &   5.,  15.,  15.,   5./
C
      DATA SHI/
     &  32.,  32.,  70.,  50.,  58.,  70.,  53.,  65.,  58.,  50.,
     &  20.,  15.,  20.,  20.,  15.,  15.,  60., 120.,  90.,  15.,
     &  30.,  40.,  32.,  20./
C----------
      SELECT CASE (IWHO)
C
C  CALLED FROM SUBROUTINE **SITSET**
C
        CASE (1)
          SILOW = SITELO(IS)
          SIHIGH = SITEHI(IS)
C
C  CALLED FROM SUBROUTINE **REGENT**
C
        CASE (2)
          SILOW = SLO(IS)
          SIHIGH = SHI(IS)
C
C  SPACE FOR ADDITIONAL CALLS
C
        CASE DEFAULT
          SILOW = 0.
          SIHIGH = 999.
C
      END SELECT
C
      RETURN
      END