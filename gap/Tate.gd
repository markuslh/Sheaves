#############################################################################
##
##  Tate.gd                     Sheaves package              Mohamed Barakat
##
##  Copyright 2008-2010, Mohamed Barakat, University of Kaiserslautern
##
##  Declarations of procedures for the pair of adjoint Tate functors.
##
#############################################################################

####################################
#
# global functions and operations:
#
####################################

# basic operations:

DeclareOperation( "TateResolution",
        [ IsSheafOfRings, IsInt, IsInt ] );

DeclareOperation( "TateResolution",
        [ IsSheafOfModules, IsInt, IsInt ] );

DeclareOperation( "TateResolution",
        [ IsScheme, IsInt, IsInt ] );

