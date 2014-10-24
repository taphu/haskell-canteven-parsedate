module SumAll.TestParseDate ( tests ) where

import SumAll.ParseDate (parseDate)
import Distribution.TestSuite (Test(..), TestInstance(..), Progress(..), Result(..))

tests :: IO [Test]
tests = return [Group "timezone tests for ISO8601 format" True [testZulu, testFourDigitTZ, test8601StyleTz],
                Group "Twitter format tests" True [testTwitterBasic, testTwitterWithTZ],
                Group "fractional second tests" True [testFracSecond],
                Group "epoch time tests" True [testEpochTime]]

testZulu = Test $ defaultTest {
  run = return $ Finished $ tryParse "2014-10-01T21:13:00Z",
  name = "parsing with Zulu suffix (\"Z\")"
  }

testFourDigitTZ = Test $ defaultTest {
  run = return $ Finished $ tryParse "2014-10-01T21:13:00+0400",
  name = "parsing with RFC822-style four-digit tz (\"+0400\")"
  }

test8601StyleTz = Test $ defaultTest {
  run = return $ Finished $ tryParse "2014-10-01T21:13:00+04:00",
  name = "parsing with ISO8601-style hh:mm tz (\"+04:00\")"
  }

testFracSecond = Test $ defaultTest {
  run = return $ Finished $ tryParse "2014-10-01T21:13:00.000Z",
  name = "parsing fractional seconds"
  }

testTwitterBasic = Test $ defaultTest {
  run = return $ Finished $ tryParse "Fri Aug 21 21:48:25 +0000 2009",
  name = "parsing Twitter's basic format"
  }

testTwitterWithTZ = Test $ defaultTest {
  run = return $ Finished $ tryParse "Fri Aug 21 21:48:25 -0200 2009",
  name = "parsing Twitter with a tz"
  }
  
testEpochTime = Test $ defaultTest {
  run = return $ Finished $ tryParse "1414180021",
  name = "parsing epoch time"
  }

defaultTest = TestInstance {
  run = return $ Finished $ Pass,
  name = "",
  tags = [],
  options = [],
  setOption = \_ _ -> Right defaultTest  -- FIXME
  }

tryParse :: String -> Result
tryParse s = case parseDate s of
  Just t -> Pass
  Nothing -> Fail $ "couldn't parse " ++ s
