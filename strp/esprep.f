      SUBROUTINE ESPREP (ISER,PNONE,PMECH,PBURN)
      IMPLICIT NONE
C----------
C STRP $Id$
C----------
C     PREDICT DEFAULT SITE PREP PROBABILITIES.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ESPARM.F77'
C
C
      INCLUDE 'ESCOMN.F77'
C
C
      INCLUDE 'PLOT.F77'
C
      REAL PBURN,PMECH,PNONE
      INTEGER ISER
      INTEGER IDANUW
C
C
COMMONS
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      IDANUW = ISER
C
C     PROB(NO SITE PREP)
C
      PNONE = 0.75
C
C     PROB(MECH SITE PREP)
C
      PMECH = 0.20
C
C     PROB(BURN SITE PREP)
C
      PBURN = 0.05
      RETURN
      END