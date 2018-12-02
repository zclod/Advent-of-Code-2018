{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- Standard input
import           Protolude hiding (interact)
import qualified Turtle as T
import qualified Data.ByteString as B
import           Text.Parser.Token
import           Text.Parser.Char
import           Text.Trifecta

--
import           Data.Fold
import           Data.Fold.L

difficulty = T.switch "hard" 'd' "diffuculty level"

easy :: ByteString -> ByteString
easy i = show $ easySolution <$> parseByteString easyParser mempty i

hard :: ByteString -> ByteString
hard i = show $ hardSolution <$> parseByteString hardParser mempty i

main = do
    isHard <- T.options "Advent of Code 2018" difficulty
    if isHard then
        B.interact hard
    else
        B.interact easy

--------------------------------------------------------------------

easyParser = many (token (many letter))
easySolution i = (\x y -> x*y) <$> (run i easyF)

easyStep :: Int -> Int -> [Char] -> Int
easyStep repetitionN acc str = if isFound
                                  then acc + 1
                                  else acc

    where
        filterlist = (\x -> (==x)) <$> str
        charRepetitions = filter <$> filterlist <*> [str]
        charNs = length <$> charRepetitions
        isFound = repetitionN `elem` charNs

threeLetters = L identity (easyStep 3) 0
twoLetters = L identity (easyStep 3) 0

easyF = (,) <$> twoLetters <*> threeLetters


hardParser = undefined
hardSolution = undefined
