module Mom.Always exposing (Always, always, run)

{-|
@docs Always
@docs always, run
-}

import Mom exposing (..)

{-|
A computation that never changes its value.
-}
type alias Always a b =
  Mom a b

{-|
Remove the value the computation.
-}
run : Always a b -> a
run (Mom k) =
  let
    spin = spin
  in
    k spin

{-|
A value that never changes in the computation.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
always : a -> Always a b
always x =
  Mom (\_ -> x)
