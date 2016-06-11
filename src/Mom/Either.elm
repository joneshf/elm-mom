module Mom.Either exposing (..)

{-|
@docs Either
@docs left, right, run
-}

import Mom exposing (..)

{-|
A computation that may fail with additional information about the failure.
-}
type alias Either a b =
  Mom (Result a b) b

{-|
Run the computation extracting the value to `Result a b`.
-}
run : Either a b -> Result a b
run =
  with Ok

{-|
A failed computation.
-}
left : a -> Either a b
left a =
  Mom (\_ -> Err a)

{-|
A successful computation.
-}
right : b -> Either a b
right =
  pure
