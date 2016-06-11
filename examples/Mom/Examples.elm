module Mom.Examples exposing (..)

import Mom exposing (..)
import Mom.Either as ME exposing (..)
import Mom.Identity as MI exposing (..)
import Mom.Option as MO exposing (..)

ex1 : Mom a Int
ex1 =
  pure 1 >>= \a ->
  pure 10 >>= \b ->
  pure (a + b)

test1 : String
test1 =
  Mom.run ex1 toString

ex2 : Mom a Int
ex2 =
  pure 1 >>= \a ->
  Mom (\fred -> fred 10) >>= \b ->
  pure (a + b)

test2 : String
test2 =
  Mom.run ex2 toString

ex3 : Mom String Int
ex3 =
  pure 1 >>= \a ->
  Mom (\fred -> "escape") >>= \b ->
  pure (a + b)

test3 : String
test3 =
  Mom.run ex3 toString

ex4 : Mom appendable Int
ex4 =
  pure 1 >>= \a ->
  Mom (\fred -> fred 10 ++ fred 20) >>= \b ->
  pure (a + b)

test4 : String
test4 =
  Mom.run ex4 toString

ex6 : Mom appendable Int
ex6 =
  pure 1 >>= \a ->
  Mom (\fred -> fred 10 ++ fred 20) >>= \b ->
  pure (a + b)

test6 : List Int
test6 =
  Mom.run ex6 (\x -> [x])

ex7 : Mom (List a) Int
ex7 =
  pure 1 >>= \a ->
  Mom (\fred -> List.concat [fred 10, fred 20]) >>= \b ->
  pure (a + b)

test7 : List Int
test7 =
  Mom.run ex7 (\x -> [x])

ex8 : Mom (List a) Int
ex8 =
  pure 1 >>= \a ->
  Mom (\fred -> List.concatMap fred [10, 20]) >>= \b ->
  pure (a + b)

test8 : List Int
test8 =
  Mom.run ex8 (\x -> [x])

ex9 : Mom a Int
ex9 =
  (+) <$> pure 3 <*> pure 4

test9 : List Int
test9 =
  Mom.run ex9 (\x -> [x])

nums1 : Mom a Int
nums1 =
  pure 1 *> pure 2 *> pure 3

nums2 : Mom a Int
nums2 =
  pure 4 *> pure 5 *> pure 6

ex10 : Mom a Int
ex10 =
  (+) <$> nums1 <*> nums2

test10 : List Int
test10 =
  Mom.run ex10 (\x -> [x])

idEx1 : Identity Int
idEx1 =
  ex1

idTest1 : Int
idTest1 =
  MI.run idEx1

optionEx1 : Option Int
optionEx1 =
  some 3 >>= \x ->
  some 4 >>= \y ->
  pure (x + y)

optionTest1 : Maybe Int
optionTest1 =
  MO.run optionEx1

optionEx2 : Option Int
optionEx2 =
  some 3 >>= \x ->
  none >>= \y ->
  pure (x + y)

optionTest2 : Maybe Int
optionTest2 =
  MO.run optionEx2

genericSeven : Mom a Int
genericSeven =
  pure 3 >>= \x ->
  pure 4 >>= \y ->
  pure (x + y)

optionSeven : Option Int
optionSeven =
  genericSeven

length : List a -> Mom b Int
length xs =
  pure (List.length xs)

double : Int -> Mom a Int
double n =
  pure (n * 2)

doubleLength : Mom a Int
doubleLength =
  length ['1', '2', '3'] >>= double

eitherEx1 : Either String Int
eitherEx1 =
  right 3 >>= \x ->
  right 4 >>= \y ->
  pure (x + y)

eitherTest1 : Result String Int
eitherTest1 =
  ME.run eitherEx1

eitherEx2 : Either String Int
eitherEx2 =
  right 3 >>= \x ->
  left "wat" >>= \y ->
  pure (x + y)

eitherTest2 : Result String Int
eitherTest2 =
  ME.run eitherEx2
