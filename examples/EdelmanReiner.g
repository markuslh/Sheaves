## Edelman-Reiner's counterexample to a conjecture of Orlik
## it is not free but locally free on Proj

A := Tuples( [ 0, 1 ], 4 );

LoadPackage( "Sheaves" );

Q := HomalgFieldOfRationalsInDefaultCAS( );
QQ := GradedRing( Q );

LoadPackage( "D-Modules" );

D := Divisor( A, QQ );

Assert( 0, not IsFree( D ) );
Assert( 0, IsLocallyFree( D ) );

R := HomalgRing( D );
R0 := LocalizeAtZero( R );

D0 := R0 * D;

m := DerMinusLogMap( D0 );
der := DerMinusLog( D0 );
f := DefiningPolynomialOverWeylAlgebra( D0 );
Der := DerMinusLogInWeylAlgebra( D0 );
