{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- Standard input
import           Protolude hiding (interact)
import qualified Turtle as T
import           Data.ByteString hiding (singleton)
import           Text.Parser.Token
import           Text.Trifecta

--
import           Data.Fold
import           Data.Fold.L
import           Data.IntSet

difficulty = T.switch "hard" 'd' "diffuculty level"

easy :: ByteString -> ByteString
easy i = show $ easySolution <$> parseByteString easyParser mempty i

hard :: ByteString -> ByteString
hard i = show $ hardSolution <$> parseByteString hardParser mempty i

main = do
    isHard <- T.options "Advent of Code 2018" difficulty
    if isHard then
        interact hard
    else
        interact easy

--------------------------------------------------------------------

easyParser = many (token integer)
easySolution = sum

hardParser :: Parser [Int]
hardParser = (fmap . fmap) fromIntegral easyParser

hardSolution' :: Either Int (Int, IntSet) -> [Int] -> Either Int (Int, IntSet)
hardSolution' t0 i = case run i (solutionFold t0) of
                      Left result -> Left result
                      Right s -> hardSolution' (Right s) i

hardSolution = hardSolution' (Right (0, mempty))

shortCircuit :: (Int, IntSet) -> Either Int (Int, IntSet)
shortCircuit (value, set)
    | value `member` set = Left value
    | otherwise          = Right (value, insert value set)


stepF :: Either Int (Int, IntSet) -> Int -> Either Int (Int, IntSet)
stepF s v = do
    (acc, set) <- s
    shortCircuit (acc + v, set)

solutionFold = L identity stepF 
