module Mom exposing (..)

{-|
@docs Mom
@docs (#>), (*>), (<#>), (<$), (<$>), (<*), (<*>), (<=<), (=<<), (>=>), (>>=)
@docs ap, bind, callCC, forever, join, map, pure, run, unless, when, with
-}

{-|
Generalizes most computational effects.

Based on ideas from http://blog.sigfpe.com/2008/12/mother-of-all-monads.html and http://fplab.bitbucket.org/posts/2007-12-09-continuations-and-classic.html
-}
type Mom r a
  = Mom ((a -> r) -> r)

{-|
Extracts the computational effects to the elm level.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
run : Mom r a -> (a -> r) -> r
run (Mom k) =
  k

{-|
Flipped version of `run`

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
with : (a -> r) -> Mom r a -> r
with =
  flip run

{-|
Transforms values of a computational effect by the given function.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
map : (a -> b) -> Mom r a -> Mom r b
map f (Mom k) =
  Mom (\h -> k (\a -> h (f a)))

{-|
An operator alias for `map`.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
(<$>) : (a -> b) -> Mom r a -> Mom r b
(<$>) =
  map

{-|
Replaces values of a computational effect by the given function.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
(<$) : b -> Mom r a -> Mom r b
(<$) b =
  map (\_ -> b)

{-|
Flipped version of `(<$>)`.
Pun with "dollar" and "pound".

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
(<#>) : Mom r a -> (a -> b) -> Mom r b
(<#>) =
  flip map

{-|
Flipped version of `(<$)`.
Pun with "dollar" and "pound".

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
(#>) : Mom r a -> b -> Mom r b
(#>) =
  flip (<$)

{-|
Transforms values of a computational effect by the given function in the computational effect.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
ap : Mom r (a -> b) -> Mom r a -> Mom r b
ap (Mom k) (Mom h) =
  Mom (\j -> k (\f -> h (\a -> j (f a))))

{-|
An operator alias for `ap`.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
(<*>) : Mom r (a -> b) -> Mom r a -> Mom r b
(<*>) =
  ap

{-|
Executes both computational effects ignoring the value of the second.
-}
(<*) : Mom r a -> Mom r b -> Mom r a
(<*) k h =
  always <$> k <*> h

{-|
Executes both computational effects ignoring the value of the first.
-}
(*>) : Mom r a -> Mom r b -> Mom r b
(*>) =
  flip (<*)

{-|
Embeds a pure value into an effectful computation.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
pure : a -> Mom r a
pure a =
  Mom (\f -> f a)

{-|
Substitues a value in an effectful computation.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
bind : (a -> Mom r b) -> Mom r a -> Mom r b
bind f (Mom k) =
  Mom (\h -> k (\a -> run (f a) h))

{-|
Removes a layer of computational effects.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
join : Mom r (Mom r a) -> Mom r a
join =
  bind (\x -> x)

{-|
An operator alias for `bind`.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
(=<<) : (a -> Mom r b) -> Mom r a -> Mom r b
(=<<) =
  bind

{-|
Flipped version of `(=<<)`.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
(>>=) : Mom r a -> (a -> Mom r b) -> Mom r b
(>>=) =
  flip bind

{-|
Sequences two computational effect substitutions.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
(>=>) : (a -> Mom r b) -> (b -> Mom r c) -> a -> Mom r c
(>=>) f g a =
  f a >>= g

{-|
Flipped version of `(>=>)`.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
(<=<) : (b -> Mom r c) -> (a -> Mom r b) -> a -> Mom r c
(<=<) =
  flip (>=>)

{-|
Control flow primitive for effectful computations.

Due to parametricity, this documentation is worthless,
as there is exactly one implementation of this function.
-}
callCC : ((a -> Mom r b) -> Mom r a) -> Mom r a
callCC f =
  Mom (\k -> run (f (\a -> Mom (\_ -> k a))) k)

{-|
Executes the effectful computation only when the `Bool` is true.
-}
when : Bool -> Mom r () -> Mom r ()
when b general =
  if b then
    general
  else
    pure ()

{-|
Executes the effectful computation only when the `Bool` is false.
-}
unless : Bool -> Mom r () -> Mom r ()
unless b =
  when (not b)

{-|
Executes the effectful computation forever.
-}
forever : Mom r a -> Mom r b
forever general =
  general *> forever general
