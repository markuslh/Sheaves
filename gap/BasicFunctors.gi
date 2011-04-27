#############################################################################
##
##  BasicFunctors.gi                                         Sheaves package
##
##  Copyright 2011,      Mohamed Barakat, University of Kaiserslautern
##                       Markus Lange-Hegermann, RWTH Aachen
##
#############################################################################

####################################
#
# install global functions/variables:
#
####################################

##
## Cokernel
##

##
InstallGlobalFunction( _Functor_Cokernel_OnCoherentSheafOnProj, ### defines: Cokernel(Epi)
  function( phi )
    local psi, coker_psi, nat, epi, coker, gen_iso, img_emb, emb;
    
    if HasCokernelEpi( phi ) then
      return Range( CokernelEpi( phi ) );
    fi;
    
    psi := TruncatedModuleOfGlobalSections( phi );
    
    coker_psi := Cokernel( psi );
    
    nat := NaturalMapToModuleOfGlobalSections( coker_psi );
    Assert( 1, IsMonomorphism( nat ) );
    SetIsMonomorphism( nat, true );
    
    epi := SheafMorphism( PreCompose( CokernelEpi( psi ), nat ), Range( phi ), "create" );
    
    ## set the attribute CokernelEpi (specific for Cokernel):
    SetCokernelEpi( phi, epi );
    
    coker := Range( epi );

#     todo:
#     ## the generalized inverse of the natural epimorphism
#     ## (cf. [Bar, Cor. 4.8])
#     gen_iso := SheafMorphism( GeneralizedInverse( CokernelEpi( psi ) ), coker, Range( phi ) );
#     
#     ## set the morphism aid map
#     SetMorphismAid( gen_iso, phi );
#     
#     ## set the generalized inverse of the natural epimorphism
#     SetGeneralizedInverse( epi, gen_iso );
#     
#     ## we cannot check this assertion, since
#     ## checking it would cause an infinite loop
#     SetIsGeneralizedIsomorphism( gen_iso, true );
    
    #=====# end of the core procedure #=====#
    
    ## abelian category: [HS, Prop. II.9.6]
    if HasImageObjectEmb( phi ) then
        img_emb := ImageObjectEmb( phi );
        SetKernelEmb( epi, img_emb );
        if not HasCokernelEpi( img_emb ) then
            SetCokernelEpi( img_emb, epi );
        fi;
    elif HasIsMonomorphism( phi ) and IsMonomorphism( phi ) then
        SetKernelEmb( epi, phi );
    fi;
    
#     todo
#     ## this is in general NOT a morphism,
#     ## BUT it is one modulo the image of phi in T, and then even a monomorphism:
#     ## this is enough for us since we will always view it this way (cf. [BR08, 3.1.1,(2), 3.1.2] )
#     emb := SheafMorphism( NaturalGeneralizedEmbedding( TruncatedModuleOfGlobalSections( coker ) ), coker, Range( phi ) );
#     SetMorphismAid( emb, phi );
#     
#     ## we cannot check this assertion, since
#     ## checking it would cause an infinite loop
#     SetIsGeneralizedIsomorphism( emb, true );
#     
#     ## save the natural embedding in the cokernel (thanks GAP):
#     coker!.NaturalGeneralizedEmbedding := emb;
    
    return coker;
    
end );

##  <#GAPDoc Label="functor_Cokernel:code">
##      <Listing Type="Code"><![CDATA[
InstallValue( functor_Cokernel_ForCoherentSheafOnProj,
        CreateHomalgFunctor(
                [ "name", "Cokernel" ],
                [ "category", HOMALG_SHEAVES_PROJ.category ],
                [ "operation", "Cokernel" ],
                [ "natural_transformation", "CokernelEpi" ],
                [ "special", true ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant" ],
                        [ IsMorphismOfCoherentSheavesOnProjRep,
                          [ IsHomalgChainMorphism, IsImageSquare ] ] ] ],
                [ "OnObjects", _Functor_Cokernel_OnCoherentSheafOnProj ]
                )
        );
##  ]]></Listing>
##  <#/GAPDoc>

functor_Cokernel_ForCoherentSheafOnProj!.ContainerForWeakPointersOnComputedBasicMorphisms :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

##
InstallFunctor( functor_Cokernel_ForCoherentSheafOnProj );

##
## ImageObject
##

InstallGlobalFunction( _Functor_ImageObject_OnCoherentSheafOnProj,  ### defines: ImageObject(Emb)
  function( phi )
    local emb, img, coker_epi, img_submodule;
    
    if HasImageObjectEmb( phi ) then
        return Source( ImageObjectEmb( phi ) );
    fi;
    
    emb := SheafMorphism( ImageObjectEmb( UnderlyingGradedMap( phi ) ), "create", Range( phi ) );
    
    ## set the attribute ImageObjectEmb (specific for ImageObject):
    ## (since ImageObjectEmb is listed below as a natural transformation
    ##  for the functor ImageObject, a method will be automatically installed
    ##  by InstallFunctor to fetch it by first invoking the main operation ImageObject)
    SetImageObjectEmb( phi, emb );
    
    if HasIsEpimorphism( phi ) and IsEpimorphism( phi ) then
        SetIsIsomorphism( emb, true );
    else
        SetIsMonomorphism( emb, true );
    fi;

    ## get the image module from its embedding
    img := Source( emb );
    
    #=====# end of the core procedure #=====#
    
    ## abelian category: [HS, Prop. II.9.6]
    if HasCokernelEpi( phi ) then
        coker_epi := CokernelEpi( phi );
        SetCokernelEpi( emb, coker_epi );
        if not HasKernelEmb( coker_epi ) then
            SetKernelEmb( coker_epi, emb );
        fi;
    fi;
    
    ## at last define the image submodule
    img_submodule := ImageSubobject( phi );
    
    SetUnderlyingSubobject( img, img_submodule );
    SetEmbeddingInSuperObject( img_submodule, emb );
    
    ## save the natural embedding in the image (thanks GAP):
    img!.NaturalGeneralizedEmbedding := emb;
    
    if HasTruncatedModuleOfGlobalSections( phi ) then
        SetTruncatedModuleOfGlobalSections( emb, UnderlyingGradedMap( emb ) );
        SetTruncatedModuleOfGlobalSections( img_submodule, UnderlyingGradedModule( img_submodule ) );
        SetTruncatedModuleOfGlobalSections( img, UnderlyingGradedModule( img ) );
    fi;
    
    return img;
    
end );

##  <#GAPDoc Label="functor_ImageObject:code">
##      <Listing Type="Code"><![CDATA[
InstallValue( functor_ImageObject_ForCoherentSheafOnProj,
        CreateHomalgFunctor(
                [ "name", "ImageObject" ],
                [ "category", HOMALG_SHEAVES_PROJ.category ],
                [ "operation", "ImageObject" ],
                [ "natural_transformation", "ImageObjectEmb" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant" ],
                        [ IsMorphismOfCoherentSheavesOnProjRep ] ] ],
                [ "OnObjects", _Functor_ImageObject_OnCoherentSheafOnProj ]
                )
        );
##  ]]></Listing>
##  <#/GAPDoc>

functor_ImageObject_ForCoherentSheafOnProj!.ContainerForWeakPointersOnComputedBasicMorphisms :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctorOnObjects( functor_ImageObject_ForCoherentSheafOnProj );