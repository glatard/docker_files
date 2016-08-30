*DECK DACOSH
      DOUBLE PRECISION FUNCTION DACOSH (X)
C***BEGIN PROLOGUE  DACOSH
C***PURPOSE  Compute the arc hyperbolic cosine.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C4C
C***TYPE      DOUBLE PRECISION (ACOSH-S, DACOSH-D, CACOSH-C)
C***KEYWORDS  ACOSH, ARC HYPERBOLIC COSINE, ELEMENTARY FUNCTIONS, FNLIB,
C             INVERSE HYPERBOLIC COSINE
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C DACOSH(X) calculates the double precision arc hyperbolic cosine for
C double precision argument X.  The result is returned on the
C positive branch.
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  D1MACH, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   770601  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C***END PROLOGUE  DACOSH
      DOUBLE PRECISION X, DLN2, XMAX,  D1MACH
      SAVE DLN2, XMAX
      DATA DLN2 / 0.6931471805 5994530941 7232121458 18 D0 /
      DATA XMAX / 0.D0 /
C***FIRST EXECUTABLE STATEMENT  DACOSH
      IF (XMAX.EQ.0.D0) XMAX = 1.0D0/SQRT(D1MACH(3))
C
      IF (X .LT. 1.D0) CALL XERMSG ('SLATEC', 'DACOSH',
     +   'X LESS THAN 1', 1, 2)
C
      IF (X.LT.XMAX) DACOSH = LOG (X+SQRT(X*X-1.0D0))
      IF (X.GE.XMAX) DACOSH = DLN2 + LOG(X)
C
      RETURN
      END
