module Mom.Option exposing (..)

{-|
@docs Option
@docs none, run, some
-}

import Mom exposing (..)

{-|
A computation that may fail with no information about the failure.
-}
type alias Option a =
  Mom (Maybe a) a

{-|
Run the computation extracting the value to `Maybe a`.
-}
run : Option a -> Maybe a
run =
  with Just

{-|
A failed computation.
-}
none : Option a
none =
  Mom (\_ -> Nothing)

{-|
A successful computation.
-}
some : a -> Option a
some =
  pure
