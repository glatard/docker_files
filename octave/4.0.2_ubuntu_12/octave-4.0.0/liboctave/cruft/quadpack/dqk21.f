      SUBROUTINE DQK21(F,A,B,RESULT,ABSERR,RESABS,RESASC,IERR)
C***BEGIN PROLOGUE  DQK21
C***DATE WRITTEN   800101   (YYMMDD)
C***REVISION DATE  830518   (YYMMDD)
C***CATEGORY NO.  H2A1A2
C***KEYWORDS  21-POINT GAUSS-KRONROD RULES
C***AUTHOR  PIESSENS,ROBERT,APPL. MATH. & PROGR. DIV. - K.U.LEUVEN
C           DE DONCKER,ELISE,APPL. MATH. & PROGR. DIV. - K.U.LEUVEN
C***PURPOSE  TO COMPUTE I = INTEGRAL OF F OVER (A,B), WITH ERROR
C                           ESTIMATE
C                       J = INTEGRAL OF ABS(F) OVER (A,B)
C***DESCRIPTION
C
C           INTEGRATION RULES
C           STANDARD FORTRAN SUBROUTINE
C           DOUBLE PRECISION VERSION
C
C           PARAMETERS
C            ON ENTRY
C              F      - SUBROUTINE F(X,IERR,RESULT) DEFINING THE INTEGRAND
C                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
C                       DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
C
C              A      - DOUBLE PRECISION
C                       LOWER LIMIT OF INTEGRATION
C
C              B      - DOUBLE PRECISION
C                       UPPER LIMIT OF INTEGRATION
C
C            ON RETURN
C              RESULT - DOUBLE PRECISION
C                       APPROXIMATION TO THE INTEGRAL I
C                       RESULT IS COMPUTED BY APPLYING THE 21-POINT
C                       KRONROD RULE (RESK) OBTAINED BY OPTIMAL ADDITION
C                       OF ABSCISSAE TO THE 10-POINT GAUSS RULE (RESG).
C
C              ABSERR - DOUBLE PRECISION
C                       ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
C                       WHICH SHOULD NOT EXCEED ABS(I-RESULT)
C
C              RESABS - DOUBLE PRECISION
C                       APPROXIMATION TO THE INTEGRAL J
C
C              RESASC - DOUBLE PRECISION
C                       APPROXIMATION TO THE INTEGRAL OF ABS(F-I/(B-A))
C                       OVER (A,B)
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  D1MACH
C***END PROLOGUE  DQK21
C
      DOUBLE PRECISION A,ABSC,ABSERR,B,CENTR,DABS,DHLGTH,DMAX1,DMIN1,
     *  D1MACH,EPMACH,FC,FSUM,FVAL1,FVAL2,FV1,FV2,HLGTH,RESABS,RESASC,
     *  RESG,RESK,RESKH,RESULT,UFLOW,WG,WGK,XGK
      INTEGER J,JTW,JTWM1
      EXTERNAL F
C
      DIMENSION FV1(10),FV2(10),WG(5),WGK(11),XGK(11)
C
C           THE ABSCISSAE AND WEIGHTS ARE GIVEN FOR THE INTERVAL (-1,1).
C           BECAUSE OF SYMMETRY ONLY THE POSITIVE ABSCISSAE AND THEIR
C           CORRESPONDING WEIGHTS ARE GIVEN.
C
C           XGK    - ABSCISSAE OF THE 21-POINT KRONROD RULE
C                    XGK(2), XGK(4), ...  ABSCISSAE OF THE 10-POINT
C                    GAUSS RULE
C                    XGK(1), XGK(3), ...  ABSCISSAE WHICH ARE OPTIMALLY
C                    ADDED TO THE 10-POINT GAUSS RULE
C
C           WGK    - WEIGHTS OF THE 21-POINT KRONROD RULE
C
C           WG     - WEIGHTS OF THE 10-POINT GAUSS RULE
C
C
C GAUSS QUADRATURE WEIGHTS AND KRONRON QUADRATURE ABSCISSAE AND WEIGHTS
C AS EVALUATED WITH 80 DECIMAL DIGIT ARITHMETIC BY L. W. FULLERTON,
C BELL LABS, NOV. 1981.
C
      DATA WG  (  1) / 0.0666713443 0868813759 3568809893 332 D0 /
      DATA WG  (  2) / 0.1494513491 5058059314 5776339657 697 D0 /
      DATA WG  (  3) / 0.2190863625 1598204399 5534934228 163 D0 /
      DATA WG  (  4) / 0.2692667193 0999635509 1226921569 469 D0 /
      DATA WG  (  5) / 0.2955242247 1475287017 3892994651 338 D0 /
C
      DATA XGK (  1) / 0.9956571630 2580808073 5527280689 003 D0 /
      DATA XGK (  2) / 0.9739065285 1717172007 7964012084 452 D0 /
      DATA XGK (  3) / 0.9301574913 5570822600 1207180059 508 D0 /
      DATA XGK (  4) / 0.8650633666 8898451073 2096688423 493 D0 /
      DATA XGK (  5) / 0.7808177265 8641689706 3717578345 042 D0 /
      DATA XGK (  6) / 0.6794095682 9902440623 4327365114 874 D0 /
      DATA XGK (  7) / 0.5627571346 6860468333 9000099272 694 D0 /
      DATA XGK (  8) / 0.4333953941 2924719079 9265943165 784 D0 /
      DATA XGK (  9) / 0.2943928627 0146019813 1126603103 866 D0 /
      DATA XGK ( 10) / 0.1488743389 8163121088 4826001129 720 D0 /
      DATA XGK ( 11) / 0.0000000000 0000000000 0000000000 000 D0 /
C
      DATA WGK (  1) / 0.0116946388 6737187427 8064396062 192 D0 /
      DATA WGK (  2) / 0.0325581623 0796472747 8818972459 390 D0 /
      DATA WGK (  3) / 0.0547558965 7435199603 1381300244 580 D0 /
      DATA WGK (  4) / 0.0750396748 1091995276 7043140916 190 D0 /
      DATA WGK (  5) / 0.0931254545 8369760553 5065465083 366 D0 /
      DATA WGK (  6) / 0.1093871588 0229764189 9210590325 805 D0 /
      DATA WGK (  7) / 0.1234919762 6206585107 7958109831 074 D0 /
      DATA WGK (  8) / 0.1347092173 1147332592 8054001771 707 D0 /
      DATA WGK (  9) / 0.1427759385 7706008079 7094273138 717 D0 /
      DATA WGK ( 10) / 0.1477391049 0133849137 4841515972 068 D0 /
      DATA WGK ( 11) / 0.1494455540 0291690566 4936468389 821 D0 /
C
C
C           LIST OF MAJOR VARIABLES
C           -----------------------
C
C           CENTR  - MID POINT OF THE INTERVAL
C           HLGTH  - HALF-LENGTH OF THE INTERVAL
C           ABSC   - ABSCISSA
C           FVAL*  - FUNCTION VALUE
C           RESG   - RESULT OF THE 10-POINT GAUSS FORMULA
C           RESK   - RESULT OF THE 21-POINT KRONROD FORMULA
C           RESKH  - APPROXIMATION TO THE MEAN VALUE OF F OVER (A,B),
C                    I.E. TO I/(B-A)
C
C
C           MACHINE DEPENDENT CONSTANTS
C           ---------------------------
C
C           EPMACH IS THE LARGEST RELATIVE SPACING.
C           UFLOW IS THE SMALLEST POSITIVE MAGNITUDE.
C
C***FIRST EXECUTABLE STATEMENT  DQK21
      EPMACH = D1MACH(4)
      UFLOW = D1MACH(1)
C
      CENTR = 0.5D+00*(A+B)
      HLGTH = 0.5D+00*(B-A)
      DHLGTH = DABS(HLGTH)
C
C           COMPUTE THE 21-POINT KRONROD APPROXIMATION TO
C           THE INTEGRAL, AND ESTIMATE THE ABSOLUTE ERROR.
C
      RESG = 0.0D+00
      IERR = 0
      CALL F(CENTR,IERR,FC)
      IF (IERR .LT. 0) RETURN
      RESK = WGK(11)*FC
      RESABS = DABS(RESK)
      DO 10 J=1,5
        JTW = 2*J
        ABSC = HLGTH*XGK(JTW)
        CALL F(CENTR-ABSC,IERR,FVAL1)
        IF (IERR .LT. 0) RETURN
        CALL F(CENTR+ABSC,IERR,FVAL2)
        IF (IERR .LT. 0) RETURN
        FV1(JTW) = FVAL1
        FV2(JTW) = FVAL2
        FSUM = FVAL1+FVAL2
        RESG = RESG+WG(J)*FSUM
        RESK = RESK+WGK(JTW)*FSUM
        RESABS = RESABS+WGK(JTW)*(DABS(FVAL1)+DABS(FVAL2))
   10 CONTINUE
      DO 15 J = 1,5
        JTWM1 = 2*J-1
        ABSC = HLGTH*XGK(JTWM1)
        CALL F(CENTR-ABSC,IERR,FVAL1)
        IF (IERR .LT. 0) RETURN
        CALL F(CENTR+ABSC,IERR,FVAL2)
        IF (IERR .LT. 0) RETURN
        FV1(JTWM1) = FVAL1
        FV2(JTWM1) = FVAL2
        FSUM = FVAL1+FVAL2
        RESK = RESK+WGK(JTWM1)*FSUM
        RESABS = RESABS+WGK(JTWM1)*(DABS(FVAL1)+DABS(FVAL2))
   15 CONTINUE
      RESKH = RESK*0.5D+00
      RESASC = WGK(11)*DABS(FC-RESKH)
      DO 20 J=1,10
        RESASC = RESASC+WGK(J)*(DABS(FV1(J)-RESKH)+DABS(FV2(J)-RESKH))
   20 CONTINUE
      RESULT = RESK*HLGTH
      RESABS = RESABS*DHLGTH
      RESASC = RESASC*DHLGTH
      ABSERR = DABS((RESK-RESG)*HLGTH)
      IF(RESASC.NE.0.0D+00.AND.ABSERR.NE.0.0D+00)
     *  ABSERR = RESASC*DMIN1(0.1D+01,(0.2D+03*ABSERR/RESASC)**1.5D+00)
      IF(RESABS.GT.UFLOW/(0.5D+02*EPMACH)) ABSERR = DMAX1
     *  ((EPMACH*0.5D+02)*RESABS,ABSERR)
      RETURN
      END
