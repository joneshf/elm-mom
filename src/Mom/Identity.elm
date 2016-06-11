module Mom.Identity exposing (..)

{-|
@docs Identity
@docs identity, run
-}

import Mom exposing (..)

{-|
A computation with no effects.
-}
type alias Identity a =
  Mom a a

{-|
Remove the value the computation.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
run : Identity a -> a
run =
  with (\x -> x)

{-|
Alias for `pure`.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
identity : a -> Identity a
identity =
  \x -> Mom (\f -> f x)
