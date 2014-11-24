module Type.Fragment where

import qualified Data.List as List
import qualified Data.Map as Map

import Type.Type
import AST.Annotation (noneNoDocs)

data Fragment = Fragment
    { typeEnv        :: Map.Map String Type
    , vars           :: [Variable]
    , typeConstraint :: TypeConstraint
    }

emptyFragment = Fragment Map.empty [] (noneNoDocs CTrue)

joinFragment f1 f2 = Fragment
    { typeEnv        = Map.union (typeEnv f1) (typeEnv f2)
    , vars           = vars f1 ++ vars f2
    , typeConstraint = typeConstraint f1 /\ typeConstraint f2
    }

joinFragments = List.foldl' (flip joinFragment) emptyFragment

toScheme fragment =
    Scheme [] (vars fragment) (typeConstraint fragment) (typeEnv fragment)
