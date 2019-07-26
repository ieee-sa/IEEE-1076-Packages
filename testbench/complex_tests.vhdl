-- -----------------------------------------------------------------
-- 
-- Copyright 2019 IEEE P1076 WG Authors
-- 
-- See the LICENSE file distributed with this work for copyright and
-- licensing information and the AUTHORS file.
-- 
-- This file to you under the Apache License, Version 2.0 (the "License").
-- You may obtain a copy of the License at
-- 
--     http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
-- implied.  See the License for the specific language governing
-- permissions and limitations under the License.
--
--
-- Title:       Testbench for Standard VHDL MATH_COMPLEX Package (PAR 1076.2)
--
-- Developers:  Members of the VHDL Mathematical Packages Working Group
--              Code was written by Charles Swart (cswart@analogy.com)
--              Data was supplied by many people.
--
-- Purpose:     An aid to check implementations of the IEEE MATH_COMPLEX
--              package, Standard 1076.2.
--
-- Library:     This  can be compiled into any convient library.
--
-- Limitation:  Only values in the minimum required range may be tested
--              to keep this test portable.
--              That range is -1.0E38 to +1.0E38 inclusive.
--
-- Notes:
--
--              This file consists of an entity REAL_TESTS and a single
--              architecture, ARCH. It references packages MATH_REAL,
--              MATH_COMPLEX and TEXTIO.
--
--              To run this set of tests, choose an appropriate value for
--              the constant FULL_RESULTS, compile and simulate for
--              about 100 ns.
--
--              Each process begins with a WAIT for a unique time interval.
--              The purpose of this is to impose an order of evaluation
--              on the tests to ease data comparisons between different
--              implementations.
--
--              The data was optained from a number of sources and is not
--              guaranteed to be accurate. Many results are highly sensitive
--              to the character to real conversion, which is inherently
--              inaccurate in the last few places.
--
--              Also, the tests are not comprehensive. In fact, mamy of
--              the complex tests are very simple, just verifying basic
--              functionality. Most of them compute results using simpler
--              complex or real valued functions. Independently derived
--              data points would probably be preferable.
--
--              The tests report the absolute and relative differences
--              between the computed and expected results.
--
--              Suggestions, improvements and additional test points
--              are welcome.
--
-- -------------------------------------------------------------------------
-- Modification history:
-- -------------------------------------------------------------------------
--      Version: | Mod. date:  | Modified by:
--      v0.2     | 05/03/96    | pre-release version
-- Modified for VHDL-2006 05/25/06 David Bishop (dbishop@vhdl.org)
-------------------------------------------------------------
library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.math_real.all;
use ieee.math_complex.all;
use std.textio.all;
entity COMPLEX_TESTS is
  generic (
    runner_cfg : string;
    FULL_RESULTS : BOOLEAN := false);   -- verbose output
end entity COMPLEX_TESTS;
architecture ARCH of COMPLEX_TESTS is

  type REALX_VECTOR is array(POSITIVE range <>) of REAL;
  type INT_VECTOR is array(POSITIVE range <>) of INTEGER;
  type COMPLEX_VECTOR is array(POSITIVE range <>) of COMPLEX;
  type COMPLEX_POLAR_VECTOR is array(POSITIVE range <>) of COMPLEX_POLAR;
--  constant FULL_RESULTS : BOOLEAN := false;  -- TRUE for full results, FALSE for summary

  signal start_CMPLX1, start_COMPLEX_TO_POLAR1, start_POLAR_TO_COMPLEX1, start_ABS1, start_ABS2, start_ARG1,
    start_ARG2, start_MINUS1, start_MINUS2, start_CONJ1, start_CONJ2, start_SQRT1, start_SQRT2, start_EXP1,
    start_EXP2, start_LOG1, start_LOG_2, start_LOG3, start_LOG4, start_LOG5, start_LOG6, start_LOG7, start_LOG8,
    start_SIN1, start_SIN2, start_COS1, start_COS2, start_SINH1, start_SINH2, start_COSH1, start_COSH2, start_PLUS1,
    start_PLUS2, start_PLUS3, start_PLUS4, start_PLUS5, start_PLUS6, start_MINUS3, start_MINUS4, start_MINUS5,
    start_MINUS6, start_MINUS7, start_MINUS8, start_MULT1, start_MULT2, start_MULT3, start_MULT4, start_MULT5,
    start_MULT6, start_DIV1, start_DIV2, start_DIV3, start_DIV4, start_DIV5, start_DIV6,
    start_TEST_GET_PRINCIPAL_VALUE, start_TEST_EQUAL, start_TEST_NOT_EQUAL : boolean := false;

  signal done_CMPLX1, done_COMPLEX_TO_POLAR1, done_POLAR_TO_COMPLEX1, done_ABS1, done_ABS2, done_ARG1,
    done_ARG2, done_MINUS1, done_MINUS2, done_CONJ1, done_CONJ2, done_SQRT1, done_SQRT2, done_EXP1,
    done_EXP2, done_LOG1, done_LOG_2, done_LOG3, done_LOG4, done_LOG5, done_LOG6, done_LOG7, done_LOG8,
    done_SIN1, done_SIN2, done_COS1, done_COS2, done_SINH1, done_SINH2, done_COSH1, done_COSH2, done_PLUS1,
    done_PLUS2, done_PLUS3, done_PLUS4, done_PLUS5, done_PLUS6, done_MINUS3, done_MINUS4, done_MINUS5,
    done_MINUS6, done_MINUS7, done_MINUS8, done_MULT1, done_MULT2, done_MULT3, done_MULT4, done_MULT5,
    done_MULT6, done_DIV1, done_DIV2, done_DIV3, done_DIV4, done_DIV5, done_DIV6,
    done_TEST_GET_PRINCIPAL_VALUE, done_TEST_EQUAL, done_TEST_NOT_EQUAL : boolean := false;

  function ABSOLUTE_ERROR(EXPECTED : COMPLEX; RESULT : COMPLEX) return REAL is

  begin
    return abs (EXPECTED-RESULT);

  end ABSOLUTE_ERROR;

  function ABSOLUTE_ERROR(EXPECTED : REAL; RESULT : REAL) return REAL is

  begin
    return abs (EXPECTED-RESULT);

  end ABSOLUTE_ERROR;

  function ABSOLUTE_ERROR(EXPECTED : COMPLEX_POLAR; RESULT : COMPLEX_POLAR)
    return REAL is

  begin
    return abs (EXPECTED-RESULT);

  end ABSOLUTE_ERROR;

  function RELATIVE_ERROR(EXPECTED : COMPLEX; RESULT : COMPLEX) return REAL is

  begin
    if (RESULT.RE /= 0.0 or RESULT.IM /= 0.0) then
      return abs ((EXPECTED-RESULT)/RESULT);
    else
      return abs (EXPECTED-RESULT);
    end if;

  end RELATIVE_ERROR;

  function RELATIVE_ERROR(EXPECTED : REAL; RESULT : REAL) return REAL is

  begin
    if (RESULT /= 0.0) then
      return abs ((EXPECTED-RESULT)/RESULT);
    else
      return abs (EXPECTED-RESULT);
    end if;

  end RELATIVE_ERROR;

  function RELATIVE_ERROR(EXPECTED : COMPLEX_POLAR; RESULT : COMPLEX_POLAR)
    return REAL is

  begin
    if (RESULT.MAG /= 0.0) then
      return abs ((EXPECTED-RESULT)/RESULT);
    else
      return abs (EXPECTED-RESULT);
    end if;

  end RELATIVE_ERROR;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING; ARG1 : COMPLEX_VECTOR;
                          RESULTS         : COMPLEX_VECTOR;
                          CORRECT_ANSWERS : COMPLEX_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is
    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable REQUIRED_ACCURACY : real := 1.0e-8;
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --Write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'(" argument"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --Write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG1(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG1(I).IM);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).IM);
        WRITE(OUTLINE, STRING'(") "));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, RESULTS(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, RESULTS(I).IM);
        WRITE(OUTLINE, STRING'(")"));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update relative_error
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

    check_relation(WORST_RELATIVE_ACCURACY <= REQUIRED_ACCURACY, result("for " & FUNC_NAME));

  end PRINT_RESULTS;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING; ARG1 : COMPLEX_VECTOR;
                          ARG2            : COMPLEX_VECTOR;
                          RESULTS         : COMPLEX_VECTOR;
                          CORRECT_ANSWERS : COMPLEX_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is

    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable REQUIRED_ACCURACY : real := 1.0e-8;
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --Write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'(" argument1"), left, 25);
      WRITE(OUTLINE, STRING'(" argument2"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --Write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG1(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG1(I).IM);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG2(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG2(I).IM);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).IM);
        WRITE(OUTLINE, STRING'(") "));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, RESULTS(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, RESULTS(I).IM);
        WRITE(OUTLINE, STRING'(")"));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update relative_error
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

    check_relation(WORST_RELATIVE_ACCURACY <= REQUIRED_ACCURACY, result("for " & FUNC_NAME));

  end PRINT_RESULTS;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING;
                          ARG1            : REALX_VECTOR;
                          ARG2            : REALX_VECTOR;
                          RESULTS         : COMPLEX_VECTOR;
                          CORRECT_ANSWERS : COMPLEX_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is
    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable REQUIRED_ACCURACY : real := 1.0e-8;
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --Write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'(" argument1"), left, 25);
      WRITE(OUTLINE, STRING'(" argument2"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --Write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG1(I));
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG2(I));
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).IM);
        WRITE(OUTLINE, STRING'(") "));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, RESULTS(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, RESULTS(I).IM);
        WRITE(OUTLINE, STRING'(")"));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update RELATIVE_ERROR
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

    check_relation(WORST_RELATIVE_ACCURACY <= REQUIRED_ACCURACY, result("for " & FUNC_NAME));

  end PRINT_RESULTS;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING; ARG1 : COMPLEX_VECTOR;
                          RESULTS         : REALX_VECTOR;
                          CORRECT_ANSWERS : REALX_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is
    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable REQUIRED_ACCURACY : real := 1.0e-8;
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --Write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'(" argument"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --Write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG1(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG1(I).IM);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, CORRECT_ANSWERS(I));
        WRITE(OUTLINE, STRING'(") "));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, RESULTS(I));
        WRITE(OUTLINE, STRING'(")"));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update RELATIVE_ERROR
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

    check_relation(WORST_RELATIVE_ACCURACY <= REQUIRED_ACCURACY, result("for " & FUNC_NAME));

  end PRINT_RESULTS;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING; ARG1 : REALX_VECTOR;
                          ARG2            : COMPLEX_VECTOR;
                          RESULTS         : COMPLEX_VECTOR;
                          CORRECT_ANSWERS : COMPLEX_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is
    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable REQUIRED_ACCURACY : real := 1.0e-8;
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --Write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'(" argument1"), left, 25);
      WRITE(OUTLINE, STRING'(" argument2"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --Write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG1(I));
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG2(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG2(I).IM);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).IM);
        WRITE(OUTLINE, STRING'(") "));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, RESULTS(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, RESULTS(I).IM);
        WRITE(OUTLINE, STRING'(")"));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update RELATIVE_ERROR
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

    check_relation(WORST_RELATIVE_ACCURACY <= REQUIRED_ACCURACY, result("for " & FUNC_NAME));

  end PRINT_RESULTS;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING; ARG1 : COMPLEX_VECTOR;
                          ARG2            : REALX_VECTOR;
                          RESULTS         : COMPLEX_VECTOR;
                          CORRECT_ANSWERS : COMPLEX_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is
    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable REQUIRED_ACCURACY : real := 1.0e-8;
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --Write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'(" argument1"), left, 25);
      WRITE(OUTLINE, STRING'(" argument2"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --Write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG1(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG1(I).IM);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG2(I));
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).IM);
        WRITE(OUTLINE, STRING'(") "));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, RESULTS(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, RESULTS(I).IM);
        WRITE(OUTLINE, STRING'(")"));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update RELATIVE_ERROR
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

    check_relation(WORST_RELATIVE_ACCURACY <= REQUIRED_ACCURACY, result("for " & FUNC_NAME));

  end PRINT_RESULTS;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING; ARG1 : COMPLEX_VECTOR;
                          RESULTS         : COMPLEX_POLAR_VECTOR;
                          CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is
    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable REQUIRED_ACCURACY : real := 2.0e-8;
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --Write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'(" argument"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --Write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG1(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG1(I).IM);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).ARG);
        WRITE(OUTLINE, STRING'(") "));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, RESULTS(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, RESULTS(I).ARG);
        WRITE(OUTLINE, STRING'(")"));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update RELATIVE_ERROR
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

    check_relation(WORST_RELATIVE_ACCURACY <= REQUIRED_ACCURACY, result("for " & FUNC_NAME));

  end PRINT_RESULTS;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING; ARG1 : COMPLEX_POLAR_VECTOR;
                          RESULTS         : COMPLEX_VECTOR;
                          CORRECT_ANSWERS : COMPLEX_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is
    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable REQUIRED_ACCURACY : real := 1.0e-8;
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --Write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'(" argument"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --Write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG1(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG1(I).ARG);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).IM);
        WRITE(OUTLINE, STRING'(") "));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, RESULTS(I).RE);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, RESULTS(I).IM);
        WRITE(OUTLINE, STRING'(")"));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update RELATIVE_ERROR
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

    check_relation(WORST_RELATIVE_ACCURACY <= REQUIRED_ACCURACY, result("for " & FUNC_NAME));

  end PRINT_RESULTS;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING; ARG1 : COMPLEX_POLAR_VECTOR;
                          RESULTS         : REALX_VECTOR;
                          CORRECT_ANSWERS : REALX_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is
    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable REQUIRED_ACCURACY : real := 1.0e-8;
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --Write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'(" argument"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --Write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG1(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG1(I).ARG);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, CORRECT_ANSWERS(I));
        WRITE(OUTLINE, STRING'(") "));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, RESULTS(I));
        WRITE(OUTLINE, STRING'(")"));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update RELATIVE_ERROR
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

    check_relation(WORST_RELATIVE_ACCURACY <= REQUIRED_ACCURACY, result("for " & FUNC_NAME));

  end PRINT_RESULTS;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING; ARG1 : COMPLEX_POLAR_VECTOR;
                          RESULTS         : COMPLEX_POLAR_VECTOR;
                          CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is
    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable REQUIRED_ACCURACY : real := 8.0e-7;
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --Write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'(" argument"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --Write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG1(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG1(I).ARG);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).ARG);
        WRITE(OUTLINE, STRING'(") "));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, RESULTS(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, RESULTS(I).ARG);
        WRITE(OUTLINE, STRING'(")"));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update RELATIVE_ERROR
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

    check_relation(WORST_RELATIVE_ACCURACY <= REQUIRED_ACCURACY, result("for " & FUNC_NAME));

  end PRINT_RESULTS;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING; ARG1 : COMPLEX_POLAR_VECTOR;
                          ARG2            : COMPLEX_POLAR_VECTOR;
                          RESULTS         : COMPLEX_POLAR_VECTOR;
                          CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is
    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable REQUIRED_ACCURACY : real := 2.0e-8;
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --Write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'(" argument1"), left, 25);
      WRITE(OUTLINE, STRING'(" argument2"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --Write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG1(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG1(I).ARG);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG2(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG2(I).ARG);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).ARG);
        WRITE(OUTLINE, STRING'(") "));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, RESULTS(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, RESULTS(I).ARG);
        WRITE(OUTLINE, STRING'(")"));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update RELATIVE_ERROR
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

    check_relation(WORST_RELATIVE_ACCURACY <= REQUIRED_ACCURACY, result("for " & FUNC_NAME));

  end PRINT_RESULTS;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING; ARG1 : REALX_VECTOR;
                          ARG2            : COMPLEX_POLAR_VECTOR;
                          RESULTS         : COMPLEX_POLAR_VECTOR;
                          CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is
    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable REQUIRED_ACCURACY : real := 2.0e-8;
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --Write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'(" argument1"), left, 25);
      WRITE(OUTLINE, STRING'(" argument2"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --Write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG1(I));
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG2(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG2(I).ARG);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).ARG);
        WRITE(OUTLINE, STRING'(") "));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, RESULTS(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, RESULTS(I).ARG);
        WRITE(OUTLINE, STRING'(")"));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update RELATIVE_ERROR
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

    check_relation(WORST_RELATIVE_ACCURACY <= REQUIRED_ACCURACY, result("for " & FUNC_NAME));

  end PRINT_RESULTS;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING; ARG1 : COMPLEX_POLAR_VECTOR;
                          ARG2            : REALX_VECTOR;
                          RESULTS         : COMPLEX_POLAR_VECTOR;
                          CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is
    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --Write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'(" argument1"), left, 25);
      WRITE(OUTLINE, STRING'(" argument2"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --Write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG1(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, ARG1(I).ARG);
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, ARG2(I));
        WRITE(OUTLINE, STRING'(") "));
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, CORRECT_ANSWERS(I).ARG);
        WRITE(OUTLINE, STRING'(") "));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, STRING'("("));
        WRITE(OUTLINE, RESULTS(I).MAG);
        WRITE(OUTLINE, STRING'(","));
        WRITE(OUTLINE, RESULTS(I).ARG);
        WRITE(OUTLINE, STRING'(")"));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update RELATIVE_ERROR
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

  end PRINT_RESULTS;

  procedure PRINT_RESULTS(FUNC_NAME       : STRING; ARG1 : REALX_VECTOR;
                          RESULTS         : REALX_VECTOR;
                          CORRECT_ANSWERS : REALX_VECTOR;
                          ABS_ERROR       : REALX_VECTOR;
                          REL_ERROR       : REALX_VECTOR;
                          FULL_RESULTS    : BOOLEAN) is
    variable WORST_ABSOLUTE_ACCURACY : REAL := ABS_ERROR(1);
    variable WORST_RELATIVE_ACCURACY : REAL := REL_ERROR(1);
    variable REQUIRED_ACCURACY : real := 1.0e-8;
    variable OUTLINE                 : LINE;

  begin
    if(FULL_RESULTS) then

      --write out header
      WRITE(OUTLINE, FUNC_NAME, left, 10);
      WRITE(OUTLINE, STRING'("argument"), left, 25);
      WRITE(OUTLINE, STRING'("correct"), left, 50);
      WRITELINE(OUTPUT, OUTLINE);
      WRITE(OUTLINE, STRING'("result"), left, 50);
      WRITE(OUTLINE, STRING'("absolute error"), left, 25);
      WRITE(OUTLINE, STRING'("relative error"), left, 25);
      WRITELINE(OUTPUT, OUTLINE);

      --write out each value
      for I in 1 to ARG1'length loop
        WRITE(OUTLINE, STRING'("          "));
        WRITE(OUTLINE, ARG1(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, CORRECT_ANSWERS(I));
        WRITELINE(OUTPUT, OUTLINE);
        WRITE(OUTLINE, RESULTS(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, ABS_ERROR(I));
        WRITE(OUTLINE, STRING'(" "));
        WRITE(OUTLINE, REL_ERROR(I));
        WRITELINE(OUTPUT, OUTLINE);
      end loop;

    end if;

    --Update absolute_error
    for I in 1 to ABS_ERROR'length loop
      if ABS_ERROR(I) > WORST_ABSOLUTE_ACCURACY then
        WORST_ABSOLUTE_ACCURACY := ABS_ERROR(I);
      end if;
    end loop;

    --Update relative_error
    for I in 1 to REL_ERROR'length loop
      if REL_ERROR(I) > WORST_RELATIVE_ACCURACY then
        WORST_RELATIVE_ACCURACY := REL_ERROR(I);
      end if;
    end loop;

    check_relation(WORST_RELATIVE_ACCURACY <= REQUIRED_ACCURACY, result("for " & FUNC_NAME));

  end PRINT_RESULTS;
begin
  test_runner : process is
  begin
    test_runner_setup(runner, runner_cfg);
    enable_pass_msg;
    while test_suite loop
      if run("Test CMPLX1") then
        start_CMPLX1 <= true;
        wait until done_CMPLX1;
      elsif run("Test COMPLEX_TO_POLAR1") then
        start_COMPLEX_TO_POLAR1 <= true;
        wait until done_COMPLEX_TO_POLAR1;
      elsif run("Test POLAR_TO_COMPLEX1") then
        start_POLAR_TO_COMPLEX1 <= true;
        wait until done_POLAR_TO_COMPLEX1;
      elsif run("Test ABS1") then
        start_ABS1 <= true;
        wait until done_ABS1;
      elsif run("Test ABS2") then
        start_ABS2 <= true;
        wait until done_ABS2;
      elsif run("Test ARG1") then
        start_ARG1 <= true;
        wait until done_ARG1;
      elsif run("Test ARG2") then
        start_ARG2 <= true;
        wait until done_ARG2;
      elsif run("Test MINUS1") then
        start_MINUS1 <= true;
        wait until done_MINUS1;
      elsif run("Test MINUS2") then
        start_MINUS2 <= true;
        wait until done_MINUS2;
      elsif run("Test CONJ1") then
        start_CONJ1 <= true;
        wait until done_CONJ1;
      elsif run("Test CONJ2") then
        start_CONJ2 <= true;
        wait until done_CONJ2;
      elsif run("Test SQRT1") then
        start_SQRT1 <= true;
        wait until done_SQRT1;
      elsif run("Test SQRT2") then
        start_SQRT2 <= true;
        wait until done_SQRT2;
      elsif run("Test EXP1") then
        start_EXP1 <= true;
        wait until done_EXP1;
      elsif run("Test EXP2") then
        start_EXP2 <= true;
        wait until done_EXP2;
      elsif run("Test LOG1") then
        start_LOG1 <= true;
        wait until done_LOG1;
      elsif run("Test LOG_2") then
        start_LOG_2 <= true;
        wait until done_LOG_2;
      elsif run("Test LOG3") then
        start_LOG3 <= true;
        wait until done_LOG3;
      elsif run("Test LOG4") then
        start_LOG4 <= true;
        wait until done_LOG4;
      elsif run("Test LOG5") then
        start_LOG5 <= true;
        wait until done_LOG5;
      elsif run("Test LOG6") then
        start_LOG6 <= true;
        wait until done_LOG6;
      elsif run("Test LOG7") then
        start_LOG7 <= true;
        wait until done_LOG7;
      elsif run("Test LOG8") then
        start_LOG8 <= true;
        wait until done_LOG8;
      elsif run("Test SIN1") then
        start_SIN1 <= true;
        wait until done_SIN1;
      elsif run("Test SIN2") then
        start_SIN2 <= true;
        wait until done_SIN2;
      elsif run("Test COS1") then
        start_COS1 <= true;
        wait until done_COS1;
      elsif run("Test COS2") then
        start_COS2 <= true;
        wait until done_COS2;
      elsif run("Test SINH1") then
        start_SINH1 <= true;
        wait until done_SINH1;
      elsif run("Test SINH2") then
        start_SINH2 <= true;
        wait until done_SINH2;
      elsif run("Test COSH1") then
        start_COSH1 <= true;
        wait until done_COSH1;
      elsif run("Test COSH2") then
        start_COSH2 <= true;
        wait until done_COSH2;
      elsif run("Test PLUS1") then
        start_PLUS1 <= true;
        wait until done_PLUS1;
      elsif run("Test PLUS2") then
        start_PLUS2 <= true;
        wait until done_PLUS2;
      elsif run("Test PLUS3") then
        start_PLUS3 <= true;
        wait until done_PLUS3;
      elsif run("Test PLUS4") then
        start_PLUS4 <= true;
        wait until done_PLUS4;
      elsif run("Test PLUS5") then
        start_PLUS5 <= true;
        wait until done_PLUS5;
      elsif run("Test PLUS6") then
        start_PLUS6 <= true;
        wait until done_PLUS6;
      elsif run("Test MINUS3") then
        start_MINUS3 <= true;
        wait until done_MINUS3;
      elsif run("Test MINUS4") then
        start_MINUS4 <= true;
        wait until done_MINUS4;
      elsif run("Test MINUS5") then
        start_MINUS5 <= true;
        wait until done_MINUS5;
      elsif run("Test MINUS6") then
        start_MINUS6 <= true;
        wait until done_MINUS6;
      elsif run("Test MINUS7") then
        start_MINUS7 <= true;
        wait until done_MINUS7;
      elsif run("Test MINUS8") then
        start_MINUS8 <= true;
        wait until done_MINUS8;
      elsif run("Test MULT1") then
        start_MULT1 <= true;
        wait until done_MULT1;
      elsif run("Test MULT2") then
        start_MULT2 <= true;
        wait until done_MULT2;
      elsif run("Test MULT3") then
        start_MULT3 <= true;
        wait until done_MULT3;
      elsif run("Test MULT4") then
        start_MULT4 <= true;
        wait until done_MULT4;
      elsif run("Test MULT5") then
        start_MULT5 <= true;
        wait until done_MULT5;
      elsif run("Test MULT6") then
        start_MULT6 <= true;
        wait until done_MULT6;
      elsif run("Test DIV1") then
        start_DIV1 <= true;
        wait until done_DIV1;
      elsif run("Test DIV2") then
        start_DIV2 <= true;
        wait until done_DIV2;
      elsif run("Test DIV3") then
        start_DIV3 <= true;
        wait until done_DIV3;
      elsif run("Test DIV4") then
        start_DIV4 <= true;
        wait until done_DIV4;
      elsif run("Test DIV5") then
        start_DIV5 <= true;
        wait until done_DIV5;
      elsif run("Test DIV6") then
        start_DIV6 <= true;
        wait until done_DIV6;
      elsif run("Test GET_PRINCIPAL_VALUE") then
        start_TEST_GET_PRINCIPAL_VALUE <= true;
        wait until done_TEST_GET_PRINCIPAL_VALUE;
      elsif run("Test EQUAL") then
        start_TEST_EQUAL <= true;
        wait until done_TEST_EQUAL;
      elsif run("Test NOT_EQUAL") then
        start_TEST_NOT_EQUAL <= true;
        wait until done_TEST_NOT_EQUAL;
      end if;
    end loop;

    test_runner_cleanup(runner);
  end process test_runner;

--Test CMPLX[REAL,REAL] return COMPLEX
  CMPLX1 : process
    constant ARG1 : REALX_VECTOR := (

      (MATH_E),
      (COS(1.0)),
      (1.0),
      (-1.0),
      (0.0),

      (1.0),
      (1.0),
      (-1.0),
      (0.0),
      (MATH_PI),

      (-1.0)
      );

    constant ARG2 : REALX_VECTOR(1 to ARG1'length) := (

      (MATH_E),
      (SIN(1.0)),
      (-1.0),
      (1.0),
      (1.0),

      (1.0),
      (0.0),
      (-1.0),
      (-1.0),
      (-MATH_PI),

      (0.0)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (MATH_E, MATH_E),
      (COS(1.0), SIN(1.0)),
      (1.0, -1.0),
      (-1.0, 1.0),
      (0.0, 1.0),

      (1.0, 1.0),
      (1.0, 0.0),
      (-1.0, -1.0),
      (0.0, -1.0),
      (MATH_PI, -MATH_PI),

      (-1.0, 0.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_CMPLX1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := CMPLX(ARG1(I), ARG2(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("CMPLX[REAL,REAL]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_CMPLX1 <= true;
    wait;

  end process CMPLX1;

--Test COMPLEX_TO_POLAR[COMPLEX] return COMPLEX_POLAR
  COMPLEX_TO_POLAR1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.0, 0.0),
      (0.0, 1.0),
      (-1.0, 0.0),
      (0.0, -1.0),

      (1.0, 1.0),
      (-1.0, 1.0),
      (1.0, -1.0),
      (-1.0, -1.0),
      (-MATH_PI, 0.0),

      (MATH_PI, MATH_PI),
      (0.0, -5.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.0, 0.0),
      (1.0, MATH_PI_OVER_2),
      (1.0, MATH_PI),
      (1.0, -MATH_PI_OVER_2),

      (MATH_SQRT_2, MATH_PI/4.0),
      (MATH_SQRT_2, 3.0*MATH_PI/4.0),
      (MATH_SQRT_2, -MATH_PI/4.0),
      (MATH_SQRT_2, -3.0*MATH_PI/4.0),
      (MATH_PI, MATH_PI),

      (MATH_PI*MATH_SQRT_2, MATH_PI/4.0),
      (5.0, -MATH_PI_OVER_2)

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_COMPLEX_TO_POLAR1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := COMPLEX_TO_POLAR(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("COMPLEX_TO_POLAR", ARG1, RESULTS,
                  CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_COMPLEX_TO_POLAR1 <= true;
    wait;

  end process COMPLEX_TO_POLAR1;

--Test POLAR_TO_COMPLEX[COMPLEX_POLAR] return COMPLEX
  POLAR_TO_COMPLEX1 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.0, 0.0),
      (1.0, MATH_PI_OVER_2),
      (1.0, MATH_PI),
      (1.0, -MATH_PI_OVER_2),

      (MATH_SQRT_2, MATH_PI/4.0),
      (MATH_SQRT_2, 3.0*MATH_PI/4.0),
      (MATH_SQRT_2, -MATH_PI/4.0),
      (MATH_SQRT_2, -3.0*MATH_PI/4.0),
      (MATH_PI, MATH_PI),

      (MATH_PI*MATH_SQRT_2, MATH_PI/4.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.0, 0.0),
      (0.0, 1.0),
      (-1.0, 0.0),
      (0.0, -1.0),

      (1.0, 1.0),
      (-1.0, 1.0),
      (1.0, -1.0),
      (-1.0, -1.0),
      (-MATH_PI, 0.0),

      (MATH_PI, MATH_PI)

      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_POLAR_TO_COMPLEX1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := POLAR_TO_COMPLEX(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("POLAR_TO_COMPLEX", ARG1, RESULTS,
                  CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_POLAR_TO_COMPLEX1 <= true;
    wait;

  end process POLAR_TO_COMPLEX1;

--Test ABS[COMPLEX] return REAL
  ABS1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (3.0, 4.0),
      (-3.0, 4.0),
      (3.0, -4.0),
      (-3.0, -4.0),
      (4.0, 3.0),

      (-5.0, -12.0),
      (7500.0, 10000.0),
      (999999.0, 2000.0),
      (3990000.0, 400000.0)


      );

    constant CORRECT_ANSWERS : REALX_VECTOR(1 to ARG1'length) := (

      5.0,
      5.0,
      5.0,
      5.0,
      5.0,

      13.0,
      12500.0,
      1000001.0,
      4010000.0
      );

    variable RESULTS   : REALX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_ABS1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := abs(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("ABS[COMPLEX]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_ABS1 <= true;
    wait;

  end process ABS1;

--Test ABS[COMPLEX_POLAR] return REAL
  ABS2 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.0, 0.0),
      (1.0, MATH_PI_OVER_2),
      (1.0, MATH_PI),
      (1.0, -MATH_PI_OVER_2),

      (MATH_SQRT_2, MATH_PI/4.0),
      (MATH_SQRT_2, 3.0*MATH_PI/4.0),
      (MATH_SQRT_2, -MATH_PI/4.0),
      (MATH_SQRT_2, -3.0*MATH_PI/4.0),
      (MATH_PI, MATH_PI),

      (MATH_PI*MATH_SQRT_2, MATH_PI/4.0)

      );

    constant CORRECT_ANSWERS : REALX_VECTOR(1 to ARG1'length) := (

      0.00000000000000E+00,
      1.0,
      1.0,
      1.0,
      1.0,

      MATH_SQRT_2,
      MATH_SQRT_2,
      MATH_SQRT_2,
      MATH_SQRT_2,
      MATH_PI,

      MATH_PI*MATH_SQRT_2

      );

    variable RESULTS   : REALX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_ABS2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := abs(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("ABS[COMPLEX_POLAR]", ARG1, RESULTS,
                  CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_ABS2 <= true;
    wait;

  end process ABS2;

--Test ARG[COMPLEX] return REAL
  ARG1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (1.0, 1.0),
      (1.0, -1.0),
      (-1.0, 1.0),
      (-1.0, -1.0),
      (1.0, 0.0),

      (-1.0, 0.0),
      (0.0, 1.0),
      (0.0, -1.0),
      (1.0, SQRT(3.0)),
      (0.0, 0.0)

      );

    constant CORRECT_ANSWERS : REALX_VECTOR(1 to ARG1'length) := (

      MATH_PI_OVER_2/2.0,
      -MATH_PI_OVER_2/2.0,
      MATH_PI_OVER_2/2.0+MATH_PI_OVER_2,
      -MATH_PI_OVER_2/2.0-MATH_PI_OVER_2,
      0.0,

      MATH_PI,
      MATH_PI_OVER_2,
      -MATH_PI_OVER_2,
      MATH_PI/3.0,
      0.0
      );

    variable RESULTS   : REALX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_ARG1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("ARG[COMPLEX]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_ARG1 <= true;
    wait;

  end process ARG1;

--Test ARG[COMPLEX_POLAR] return REAL
  ARG2 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.0, 0.0),
      (1.0, MATH_PI_OVER_2),
      (1.0, MATH_PI),
      (1.0, -MATH_PI_OVER_2),

      (MATH_SQRT_2, MATH_PI/4.0),
      (MATH_SQRT_2, 3.0*MATH_PI/4.0),
      (MATH_SQRT_2, -MATH_PI/4.0),
      (MATH_SQRT_2, -3.0*MATH_PI/4.0),
      (MATH_PI, MATH_PI),

      (MATH_PI*MATH_SQRT_2, MATH_PI/4.0)

      );

    constant CORRECT_ANSWERS : REALX_VECTOR(1 to ARG1'length) := (

      0.00000000000000E+00,
      0.0,
      MATH_PI_OVER_2,
      MATH_PI,
      -MATH_PI_OVER_2,

      MATH_PI/4.0,
      3.0*MATH_PI/4.0,
      -MATH_PI/4.0,
      -3.0*MATH_PI/4.0,
      MATH_PI,

      MATH_PI/4.0

      );

    variable RESULTS   : REALX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_ARG2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("ARG[COMPLEX_POLAR]", ARG1, RESULTS,
                  CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_ARG2 <= true;
    wait;

  end process ARG2;

--Test -[COMPLEX] return COMPLEX
  MINUS1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, 1.00000000000000E+00),
      (1.00000000000000E+00, 0.00000000000000E+00),
      (1.00000000000000E+00, 1.00000000000000E+00),
      (1.00000000000000E+00, -1.00000000000000E+00),
      (-1.00000000000000E+00, 1.00000000000000E+00),
      (-1.00000000000000E+00, -1.00000000000000E+00),
      (5.23598775598299E-01, 7.85398163397448E-01)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, -1.00000000000000E+00),
      (-1.00000000000000E+00, 0.00000000000000E+00),
      (-1.00000000000000E+00, -1.00000000000000E+00),
      (-1.00000000000000E+00, 1.00000000000000E+00),
      (1.00000000000000E+00, -1.00000000000000E+00),
      (1.00000000000000E+00, 1.00000000000000E+00),
      (-5.23598775598299E-01, -7.85398163397448E-01)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_MINUS1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := -(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("-[COMPLEX] ", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MINUS1 <= true;
    wait;

  end process MINUS1;

--Test -[COMPLEX_POLAR] return COMPLEX_POLAR
  MINUS2 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.0, 0.0),
      (1.0, MATH_PI_OVER_2),
      (1.0, MATH_PI),
      (1.0, -MATH_PI_OVER_2),

      (MATH_SQRT_2, MATH_PI/4.0),
      (MATH_SQRT_2, 3.0*MATH_PI/4.0),
      (MATH_SQRT_2, -MATH_PI/4.0),
      (MATH_SQRT_2, -3.0*MATH_PI/4.0),
      (MATH_PI, MATH_PI),

      (MATH_PI*MATH_SQRT_2, MATH_PI/4.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.0),
      (1.0, MATH_PI),
      (1.0, -MATH_PI_OVER_2),
      (1.0, 0.0),
      (1.0, MATH_PI_OVER_2),

      (MATH_SQRT_2, -3.0*MATH_PI/4.0),
      (MATH_SQRT_2, -MATH_PI/4.0),
      (MATH_SQRT_2, 3.0*MATH_PI/4.0),
      (MATH_SQRT_2, MATH_PI/4.0),
      (MATH_PI, 0.0),

      (MATH_PI*MATH_SQRT_2, -3.0*MATH_PI/4.0)

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_MINUS2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := -(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("-[COMPLEX_POLAR]", ARG1, RESULTS,
                  CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MINUS2 <= true;
    wait;

  end process MINUS2;

--Test CONJ[COMPLEX] return COMPLEX
  CONJ1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, 1.00000000000000E+00),
      (1.00000000000000E+00, 0.00000000000000E+00),
      (1.00000000000000E+00, 1.00000000000000E+00),
      (1.00000000000000E+00, -1.00000000000000E+00),
      (-1.00000000000000E+00, 1.00000000000000E+00),
      (-1.00000000000000E+00, -1.00000000000000E+00),
      (5.23598775598299E-01, 7.85398163397448E-01)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, -1.00000000000000E+00),
      (1.00000000000000E+00, 0.00000000000000E+00),
      (1.00000000000000E+00, -1.00000000000000E+00),
      (1.00000000000000E+00, 1.00000000000000E+00),
      (-1.00000000000000E+00, -1.00000000000000E+00),
      (-1.00000000000000E+00, 1.00000000000000E+00),
      (5.23598775598299E-01, -7.85398163397448E-01)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_CONJ1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := CONJ(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("CONJ[COMPLEX]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_CONJ1 <= true;
    wait;

  end process CONJ1;

--Test CONJ[COMPLEX_POLAR] return COMPLEX_POLAR
  CONJ2 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.0, 0.0),
      (1.0, MATH_PI_OVER_2),
      (1.0, MATH_PI),
      (1.0, -MATH_PI_OVER_2),

      (MATH_SQRT_2, MATH_PI/4.0),
      (MATH_SQRT_2, 3.0*MATH_PI/4.0),
      (MATH_SQRT_2, -MATH_PI/4.0),
      (MATH_SQRT_2, -3.0*MATH_PI/4.0),
      (MATH_PI, MATH_PI),

      (MATH_PI*MATH_SQRT_2, MATH_PI/4.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.0, 0.0),
      (1.0, -MATH_PI_OVER_2),
      (1.0, MATH_PI),
      (1.0, MATH_PI_OVER_2),

      (MATH_SQRT_2, -MATH_PI/4.0),
      (MATH_SQRT_2, -3.0*MATH_PI/4.0),
      (MATH_SQRT_2, MATH_PI/4.0),
      (MATH_SQRT_2, 3.0*MATH_PI/4.0),
      (MATH_PI, MATH_PI),

      (MATH_PI*MATH_SQRT_2, -MATH_PI/4.0)

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_CONJ2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := CONJ(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("CONJ[COMPLEX_POLAR]", ARG1, RESULTS,
                  CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_CONJ2 <= true;
    wait;

  end process CONJ2;

--Test SQRT[COMPLEX] return COMPLEX
  SQRT1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, 1.00000000000000E+00),
      (1.00000000000000E+00, 0.00000000000000E+00),
      (-1.00000000000000E+00, 0.0),
      (0.0, -1.00000000000000E+00),
      (-4.0, 0.0)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (MATH_SQRT_2/2.0, MATH_SQRT_2/2.0),
      (1.00000000000000E+00, 0.00000000000000E+00),
      (0.0, 1.0),
      (MATH_SQRT_2/2.0, -MATH_SQRT_2/2.0),
      (0.0, 2.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_SQRT1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := SQRT(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("SQRT[COMPLEX]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_SQRT1 <= true;
    wait;

  end process SQRT1;

--Test SQRT[COMPLEX_POLAR] return COMPLEX_POLAR
  SQRT2 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.0, 0.0),
      (1.0, MATH_PI_OVER_2),
      (1.0, MATH_PI),
      (1.0, -MATH_PI_OVER_2),

      (4.0, MATH_PI/4.0),
      (4.0, 3.0*MATH_PI/4.0),
      (4.0, -MATH_PI/4.0),
      (4.0, -3.0*MATH_PI/4.0),
      (9.0, MATH_PI),

      (1.0E10, MATH_PI/4.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.0, 0.0),
      (1.0, MATH_PI_OVER_4),
      (1.0, MATH_PI_OVER_2),
      (1.0, -MATH_PI_OVER_4),

      (2.0, MATH_PI/8.0),
      (2.0, 3.0*MATH_PI/8.0),
      (2.0, -MATH_PI/8.0),
      (2.0, -3.0*MATH_PI/8.0),
      (3.0, MATH_PI_OVER_2),

      (1.0E05, MATH_PI/8.0)

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_SQRT2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := SQRT(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("SQRT[COMPLEX_POLAR]", ARG1, RESULTS,
                  CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_SQRT2 <= true;
    wait;

  end process SQRT2;

--Test EXP[COMPLEX] return COMPLEX
  EXP1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, 1.00000000000000E+00),
      (-1.00000000000000E+00, 0.0),
      (0.0, -1.00000000000000E+00),

      (0.0, MATH_PI)

      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (1.00000000000000E+00, 0.00000000000000E+00),
      (MATH_E, 0.0),
      (COS(1.0), SIN(1.0)),
      (MATH_1_OVER_E, 0.0),
      (COS(1.0), -SIN(1.0)),

      (-1.0, 0.0)

      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_EXP1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := EXP(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("EXP[COMPLEX]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_EXP1 <= true;
    wait;

  end process EXP1;

--Test EXP[COMPLEX_POLAR] return COMPLEX_POLAR
  EXP2 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (0.0, 0.0),
      (1.0, 0.0),
      (1.0, MATH_PI_OVER_2),
      (1.0, MATH_PI),
      (1.0, -MATH_PI_OVER_2),

      (MATH_PI, MATH_PI_OVER_2),
      COMPLEX_TO_POLAR(COMPLEX'(31.0*MATH_PI_OVER_2, -31.0*MATH_PI_OVER_2)),
      COMPLEX_TO_POLAR(COMPLEX'(31.0*MATH_PI_OVER_2, 31.0*MATH_PI_OVER_2))

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      (1.0, 0.0),
      (MATH_E, 0.0),
      (1.0, 1.0),
      (MATH_1_OVER_E, 0.0),
      (1.0, -1.0),

      (1.0, MATH_PI),
      (exp(31.0*MATH_PI_OVER_2), MATH_PI_OVER_2),
      (exp(31.0*MATH_PI_OVER_2), -MATH_PI_OVER_2)

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_EXP2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := EXP(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("EXP[COMPLEX_POLAR]", ARG1, RESULTS,
                  CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_EXP2 <= true;
    wait;

  end process EXP2;

--Test LOG[COMPLEX] return COMPLEX
  LOG1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (1.00000000000000E+00, 0.00000000000000E+00),
      (-1.00000000000000E+00, 0.00000000000000E+00),
      (MATH_E, 0.0),
      (COS(1.0), SIN(1.0)),
      (MATH_1_OVER_E, 0.0),
      (COS(1.0), -SIN(1.0)),
      (0.0, 1.0),
      (0.0, -1.0),
      (-1.0, 0.0)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, MATH_PI),
      (1.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, 1.00000000000000E+00),
      (-1.00000000000000E+00, 0.0),
      (0.0, -1.00000000000000E+00),
      (0.0, MATH_PI_OVER_2),
      (0.0, -MATH_PI_OVER_2),
      (0.0, MATH_PI)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_LOG1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := LOG(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("LOG[COMPLEX]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_LOG1 <= true;
    wait;

  end process LOG1;


--Test LOG2[COMPLEX] return COMPLEX
  LOG_2 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (1.00000000000000E+00, 0.00000000000000E+00),
      (2.00000000000000E+00, 0.00000000000000E+00),
      (4.0, 0.0),
      (0.5, 0.0)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.00000000000000E+00, 0.0),
      (2.00000000000000E+00, 0.00000000000000E+00),
      (-1.00000000000000E+00, 0.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_LOG_2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := LOG2(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("LOG2[COMPLEX]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_LOG_2 <= true;
    wait;

  end process LOG_2;


--Test LOG10[COMPLEX] return COMPLEX
  LOG3 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (1.00000000000000E+00, 0.00000000000000E+00),
      (10.00000000000000E+00, 0.00000000000000E+00),
      (100.0, 0.0),
      (0.1, 0.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.00000000000000E+00, 0.0),
      (2.00000000000000E+00, 0.00000000000000E+00),
      (-1.00000000000000E+00, 0.0)

      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_LOG3;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := LOG10(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("LOG10[COMPLEX]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_LOG3 <= true;
    wait;

  end process LOG3;


--Test LOG[COMPLEX_POLAR] return COMPLEX_POLAR
  LOG4 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (1.0, 0.0),
      (1.0, MATH_PI),
      (1.0, MATH_PI_OVER_2),
      (1.0, -MATH_PI_OVER_2),
      (MATH_E, 0.0),
      (2.0, 3.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      (0.0, 0.0),
      (MATH_PI, MATH_PI_OVER_2),
      (MATH_PI_OVER_2, MATH_PI_OVER_2),
      (MATH_PI_OVER_2, -MATH_PI_OVER_2),
      (1.0, 0.0),
      COMPLEX_TO_POLAR(LOG(POLAR_TO_COMPLEX(COMPLEX_POLAR'(2.0, 3.0))))

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_LOG4;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := LOG(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("LOG[COMPLEX_POLAR]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_LOG4 <= true;
    wait;

  end process LOG4;


--Test LOG2[COMPLEX_POLAR] return COMPLEX_POLAR
  LOG5 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (1.0, 0.0),
      (2.0, 0.0),
      (4.0, 0.0),
      (0.5, 0.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      (0.0, 0.0),
      (1.0, 0.0),
      (2.0, 0.0),
      (1.0, MATH_PI)

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_LOG5;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := LOG2(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("LOG2[COMPLEX_POLAR]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_LOG5 <= true;
    wait;

  end process LOG5;


--Test LOG10[COMPLEX_POLAR] return COMPLEX_POLAR
  LOG6 : process

    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (1.0, 0.0),
      (10.0, 0.0),
      (100.0, 0.0),
      (0.1, 0.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      (0.0, 0.0),
      (1.0, 0.0),
      (2.0, 0.0),
      (1.0, MATH_PI)

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_LOG6;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := LOG10(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("LOG10[COMPLEX_POLAR]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_LOG6 <= true;
    wait;

  end process LOG6;


--Test LOG[COMPLEX,REAL] return COMPLEX
  LOG7 : process

    constant ARG1 : COMPLEX_VECTOR := (

      (1.00000000000000E+00, 0.00000000000000E+00),
      (MATH_E, 0.0),
      (2.0, 0.0),
      (-1.0, 0.0)
      );

    constant ARG2 : REALX_VECTOR := (

      3.0,
      MATH_E,
      2.0,
      MATH_E

      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.0, 0.0),
      (1.0, 0.0),
      (0.0, MATH_PI)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_LOG7;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := LOG(ARG1(I), ARG2(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("LOG[COMPLEX,REAL]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_LOG7 <= true;
    wait;

  end process LOG7;


--Test LOG[COMPLEX_POLAR,REAL] return COMPLEX_POLAR
  LOG8 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (1.0, 0.0),
      (MATH_E, 0.0),
      (49.0, 0.0),
      (25.0, 2.5)

      );

    constant ARG2 : REALX_VECTOR(1 to ARG1'length) := (

      5.0,
      MATH_E,
      7.0,
      13.0

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      (0.0, 0.0),
      (1.0, 0.0),
      (2.0, 0.0),
      COMPLEX_TO_POLAR(LOG(POLAR_TO_COMPLEX(COMPLEX_POLAR'(25.0, 2.5)), 13.0))

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_LOG8;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := LOG(ARG1(I), ARG2(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("LOG[COMPLEX_POLAR,REAL]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_LOG8 <= true;
    wait;

  end process LOG8;

--Test SIN[COMPLEX] return COMPLEX
  SIN1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (MATH_PI, 0.0),
      (MATH_PI_OVER_2, MATH_PI_OVER_4),
      (1.0, 2.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, 0.00000000000000E+00),
      (sin(MATH_PI_OVER_2)*cosh(MATH_PI_OVER_4), cos(MATH_PI_OVER_2)*sinh(MATH_PI_OVER_4)),
      (sin(1.0)*cosh(2.0), cos(1.0)*sinh(2.0))

      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_SIN1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := SIN(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("SIN[COMPLEX]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_SIN1 <= true;
    wait;

  end process SIN1;

--Test SIN[COMPLEX_POLAR] return COMPLEX_POLAR
  SIN2 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (MATH_PI, 0.0),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 2.0))

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, 0.00000000000000E+00),
      COMPLEX_TO_POLAR(SIN(COMPLEX'(1.0, 2.0)))

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin

    wait until start_SIN2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := SIN(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("SIN[COMPLEX_POLAR]", ARG1, RESULTS,
                  CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_SIN2 <= true;
    wait;

  end process SIN2;

--Test COS[COMPLEX] return COMPLEX
  COS1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (MATH_PI_OVER_2, 0.0),
      (-MATH_PI_OVER_2, 0.0),
      (MATH_PI, 0.0),
      (MATH_PI_OVER_2, MATH_PI_OVER_4),
      (1.0, 2.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, 0.00000000000000E+00),
      (cos(MATH_PI)*cosh(0.0), -sin(MATH_PI)*sinh(0.0)),
      (cos(MATH_PI_OVER_2)*cosh(MATH_PI_OVER_4), -sin(MATH_PI_OVER_2)*sinh(MATH_PI_OVER_4)),
      (cos(1.0)*cosh(2.0), -sin(1.0)*sinh(2.0))

      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_COS1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := COS(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("COS[COMPLEX]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_COS1 <= true;
    wait;

  end process COS1;

--Test COS[COMPLEX_POLAR] return COMPLEX_POLAR
  COS2 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (MATH_PI_OVER_2, 0.00000000000000E+00),
      (MATH_PI_OVER_2, MATH_PI),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 2.0))

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, 0.00000000000000E+00),
      COMPLEX_TO_POLAR(COS(COMPLEX'(1.0, 2.0)))

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_COS2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := COS(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("COS[COMPLEX_POLAR]", ARG1, RESULTS,
                  CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_COS2 <= true;
    wait;

  end process COS2;

--Test SINH[COMPLEX] return COMPLEX
  SINH1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.0, MATH_PI),
      (0.0, MATH_PI_OVER_2),
      (0.0, -MATH_PI_OVER_2),
      (MATH_PI_OVER_2, MATH_PI_OVER_4),
      (1.0, 2.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.0, 1.0),
      (0.0, -1.0),
      (sinh(MATH_PI_OVER_2)*cos(MATH_PI_OVER_4), cosh(MATH_PI_OVER_2)*sin(MATH_PI_OVER_4)),
      (sinh(1.0)*cos(2.0), cosh(1.0)*sin(2.0))

      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_SINH1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := SINH(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("SINH[COMPLEX]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_SINH1 <= true;
    wait;

  end process SINH1;

--Test SINH[COMPLEX_POLAR] return COMPLEX_POLAR
  SINH2 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (MATH_PI, MATH_PI_OVER_2),
      (MATH_PI_OVER_2, MATH_PI_OVER_2),
      (MATH_PI_OVER_2, -MATH_PI_OVER_2),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 2.0))

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, 0.00000000000000E+00),
      (1.0, MATH_PI_OVER_2),
      (1.0, -MATH_PI_OVER_2),
      COMPLEX_TO_POLAR(SINH(COMPLEX'(1.0, 2.0)))


      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_SINH2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := SINH(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("SINH[COMPLEX_POLAR]", ARG1, RESULTS,
                  CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_SINH2 <= true;
    wait;

  end process SINH2;

--Test COSH[COMPLEX] return COMPLEX
  COSH1 : process

    constant ARG1 : COMPLEX_VECTOR := (

      (0.0, 0.0),
      (0.0, MATH_PI),
      (0.0, MATH_PI_OVER_2),
      (0.0, -MATH_PI_OVER_2),
      (1.0, 2.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (1.00000000000000E+00, 0.00000000000000E+00),
      (-1.00000000000000E+00, 0.0),
      (0.00000000000000E+00, 0.00000000000000E+00),
      (0.00000000000000E+00, 0.00000000000000E+00),
      (cosh(1.0)*cos(2.0), sinh(1.0)*sin(2.0))

      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin

    wait until start_COSH1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := COSH(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("COSH[COMPLEX]", ARG1, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_COSH1 <= true;
    wait;

  end process COSH1;

--Test COSH[COMPLEX_POLAR] return COMPLEX_POLAR
  COSH2 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (0.0, 0.0),
      (MATH_PI, MATH_PI_OVER_2),
      (MATH_PI_OVER_2, MATH_PI_OVER_2),
      (MATH_PI_OVER_2, -MATH_PI_OVER_2),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 2.0))

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      (1.00000000000000E+00, 0.00000000000000E+00),
      (1.00000000000000E+00, MATH_PI),
      (0.0, 0.0),
      (0.0, 0.0),
      COMPLEX_TO_POLAR(COSH(COMPLEX'(1.0, 2.0)))

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin

    wait until start_COSH2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := COSH(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("COSH[COMPLEX_POLAR]", ARG1, RESULTS,
                  CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_COSH2 <= true;
    wait;

  end process COSH2;

--Test +[COMPLEX,COMPLEX] return COMPLEX
  PLUS1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (COS(1.0), SIN(1.0)),
      (1.0, 0.0),
      (-1.0, 0.0),
      (0.0, 0.0),

      (0.0, 1.0),
      (1.0, 1.0),
      (-1.0, 1.0),
      (0.0, -1.0),
      (1.0, -1.0),
      (-1.0, -1.0)
      );

    constant ARG2 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (SIN(1.0), COS(1.0)),
      (-1.0, 1.0),
      (1.0, 1.0),
      (1.0, -1.0),
      (1.0, 0.0),
      (0.0, -1.0),
      (-1.0, -1.0),
      (-1.0, 0.0),
      (0.0, 1.0),
      (0.0, 0.0)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (2.0*MATH_E, 2.0*MATH_E),
      (COS(1.0)+SIN(1.0), COS(1.0)+SIN(1.0)),
      (0.0, 1.0),
      (0.0, 1.0),
      (1.0, -1.0),
      (1.0, 1.0),
      (1.0, 0.0),
      (-2.0, 0.0),
      (-1.0, -1.0),
      (1.0, 0.0),
      (-1.0, -1.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_PLUS1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)+ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("+[COMPLEX,COMPLEX]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_PLUS1 <= true;
    wait;

  end process PLUS1;

--Test +[REAL,COMPLEX] return COMPLEX
  PLUS2 : process
    constant ARG1 : REALX_VECTOR := (

      MATH_E,
      COS(1.0),
      1.0,
      -1.0,
      0.0,

      0.0,
      1.0,
      -1.0,
      0.0,
      1.0,

      -1.0
      );

    constant ARG2 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (SIN(1.0), COS(1.0)),
      (-1.0, 1.0),
      (1.0, 1.0),
      (1.0, -1.0),

      (1.0, 0.0),
      (0.0, -1.0),
      (-1.0, -1.0),
      (-1.0, 0.0),
      (0.0, 1.0),

      (0.0, 0.0)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (2.0*MATH_E, MATH_E),
      (COS(1.0)+SIN(1.0), COS(1.0)),
      (0.0, 1.0),
      (0.0, 1.0),
      (1.0, -1.0),

      (1.0, 0.0),
      (1.0, -1.0),
      (-2.0, -1.0),
      (-1.0, 0.0),
      (1.0, 1.0),

      (-1.0, 0.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_PLUS2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)+ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("+[REAL,COMPLEX]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS,
                  ABS_ERROR, REL_ERROR, FULL_RESULTS);

    done_PLUS2 <= true;
    wait;

  end process PLUS2;

--Test +[COMPLEX,REAL] return COMPLEXP
  PLUS3 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (COS(1.0), SIN(1.0)),
      (1.0, 0.0),
      (-1.0, 0.0),
      (0.0, 0.0),

      (0.0, 1.0),
      (1.0, 1.0),
      (-1.0, 1.0),
      (0.0, -1.0),
      (1.0, -1.0),

      (-1.0, -1.0)
      );

    constant ARG2 : REALX_VECTOR := (

      MATH_E,
      SIN(1.0),
      -1.0,
      1.0,
      1.0,

      1.0,
      0.0,
      -1.0,
      -1.0,
      0.0,

      0.0
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (2.0*MATH_E, MATH_E),
      (COS(1.0)+SIN(1.0), SIN(1.0)),
      (0.0, 0.0),
      (0.0, 0.0),
      (1.0, 0.0),

      (1.0, 1.0),
      (1.0, 1.0),
      (-2.0, 1.0),
      (-1.0, -1.0),
      (1.0, -1.0),

      (-1.0, -1.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_PLUS3;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)+ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("+[COMPLEX,REAL]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_PLUS3 <= true;
    wait;

  end process PLUS3;

--Test +[COMPLEX_POLAR,COMPLEX_POLAR] return COMPLEX_POLAR
  PLUS4 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0), SIN(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      (1.0, 7.0*MATH_PI/8.0),
      (1.0, 5.0*MATH_PI/8.0)

      );

    constant ARG2 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(SIN(1.0), COS(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),
      (1.0, -5.0*MATH_PI/8.0),
      (1.0, -7.0*MATH_PI/8.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      COMPLEX_TO_POLAR(COMPLEX'(2.0*MATH_E, 2.0*MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0)+SIN(1.0), COS(1.0)+SIN(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-2.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      (MATH_SQRT_2, -7.0*MATH_PI/8.0),
      (MATH_SQRT_2, 7.0*MATH_PI/8.0)

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin

    wait until start_PLUS4;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)+ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("+[COMPLEX_POLAR,COMPLEX_POLAR]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_PLUS4 <= true;
    wait;

  end process PLUS4;

--Test +[REAL,COMPLEX_POLAR] return COMPLEX_POLAR
  PLUS5 : process
    constant ARG1 : REALX_VECTOR := (

      MATH_E,
      COS(1.0),
      1.0,
      -1.0,
      0.0,

      0.0,
      1.0,
      -1.0,
      0.0,
      1.0,

      -1.0
      );

    constant ARG2 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(SIN(1.0), COS(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0))

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      COMPLEX_TO_POLAR(COMPLEX'(2.0*MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0)+SIN(1.0), COS(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-2.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0))

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin

    wait until start_PLUS5;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)+ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("+[REAL,COMPLEX_POLAR]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS,
                  ABS_ERROR, REL_ERROR, FULL_RESULTS);

    done_PLUS5 <= true;
    wait;

  end process PLUS5;

--Test +[COMPLEX_POLAR,REAL] return COMPLEX_POLAR
  PLUS6 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0), SIN(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0))

      );

    constant ARG2 : REALX_VECTOR := (

      MATH_E,
      SIN(1.0),
      -1.0,
      1.0,
      1.0,

      1.0,
      0.0,
      -1.0,
      -1.0,
      0.0,

      0.0
      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      COMPLEX_TO_POLAR(COMPLEX'(2.0*MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0)+SIN(1.0), SIN(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-2.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0))

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin

    wait until start_PLUS6;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)+ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("+[COMPLEX_POLAR,REAL]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_PLUS6 <= true;
    wait;

  end process PLUS6;

--Test -[COMPLEX,COMPLEX] return COMPLEX
  MINUS3 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (COS(1.0), SIN(1.0)),
      (1.0, 0.0),
      (-1.0, 0.0),
      (0.0, 0.0),

      (0.0, 1.0),
      (1.0, 1.0),
      (-1.0, 1.0),
      (0.0, -1.0),
      (1.0, -1.0),

      (-1.0, -1.0)
      );

    constant ARG2 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (SIN(1.0), COS(1.0)),
      (-1.0, 1.0),
      (1.0, 1.0),
      (1.0, -1.0),

      (1.0, 0.0),
      (0.0, -1.0),
      (-1.0, -1.0),
      (-1.0, 0.0),
      (0.0, 1.0),

      (0.0, 0.0)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.0, 0.0),
      (COS(1.0)-SIN(1.0), SIN(1.0)-COS(1.0)),
      (2.0, -1.0),
      (-2.0, -1.0),
      (-1.0, 1.0),

      (-1.0, 1.0),
      (1.0, 2.0),
      (0.0, 2.0),
      (1.0, -1.0),
      (1.0, -2.0),

      (-1.0, -1.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_MINUS3;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)-ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("-[COMPLEX,COMPLEX]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MINUS3 <= true;
    wait;

  end process MINUS3;

--Test -[REAL,COMPLEX] return COMPLEX
  MINUS4 : process
    constant ARG1 : REALX_VECTOR := (

      MATH_E,
      COS(1.0),
      1.0,
      -1.0,
      0.0,

      0.0,
      1.0,
      -1.0,
      0.0,
      1.0,

      -1.0
      );

    constant ARG2 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (SIN(1.0), COS(1.0)),
      (-1.0, 1.0),
      (1.0, 1.0),
      (1.0, -1.0),

      (1.0, 0.0),
      (0.0, -1.0),
      (-1.0, -1.0),
      (-1.0, 0.0),
      (0.0, 1.0),

      (0.0, 0.0)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.0, -MATH_E),
      (COS(1.0)-SIN(1.0), -COS(1.0)),
      (2.0, -1.0),
      (-2.0, -1.0),
      (-1.0, 1.0),

      (-1.0, 0.0),
      (1.0, 1.0),
      (0.0, 1.0),
      (1.0, 0.0),
      (1.0, -1.0),

      (-1.0, 0.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin

    wait until start_MINUS4;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)-ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("-[REAL,COMPLEX]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MINUS4 <= true;
    wait;

  end process MINUS4;

--Test -[COMPLEX,REAL] return COMPLEX
  MINUS5 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (COS(1.0), SIN(1.0)),
      (1.0, 0.0),
      (-1.0, 0.0),
      (0.0, 0.0),

      (0.0, 1.0),
      (1.0, 1.0),
      (-1.0, 1.0),
      (0.0, -1.0),
      (1.0, -1.0),

      (-1.0, -1.0)
      );

    constant ARG2 : REALX_VECTOR := (

      MATH_E,
      SIN(1.0),
      -1.0,
      1.0,
      1.0,

      1.0,
      0.0,
      -1.0,
      -1.0,
      0.0,

      0.0
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.0, MATH_E),
      (COS(1.0)-SIN(1.0), SIN(1.0)),
      (2.0, 0.0),
      (-2.0, 0.0),
      (-1.0, 0.0),

      (-1.0, 1.0),
      (1.0, 1.0),
      (0.0, 1.0),
      (1.0, -1.0),
      (1.0, -1.0),

      (-1.0, -1.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_MINUS5;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)-ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("-[COMPLEX,REAL]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MINUS5 <= true;
    wait;

  end process MINUS5;

--Test -[COMPLEX_POLAR,COMPLEX_POLAR] return COMPLEX_POLAR
  MINUS6 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0), SIN(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      (1.0, 7.0*MATH_PI/8.0),
      (1.0, 5.0*MATH_PI/8.0)


      );

    constant ARG2 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(SIN(1.0), COS(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),
      (1.0, 3.0*MATH_PI/8.0),
      (1.0, MATH_PI/8.0)

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0)-SIN(1.0), SIN(1.0)-COS(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(2.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-2.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 2.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 2.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -2.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      (MATH_SQRT_2, -7.0*MATH_PI/8.0),
      (MATH_SQRT_2, 7.0*MATH_PI/8.0)

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_MINUS6;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)-ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("-[COMPLEX_POLAR,COMPLEX_POLAR]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MINUS6 <= true;
    wait;

  end process MINUS6;

--Test -[REAL,COMPLEX_POLAR] return COMPLEX_POLAR
  MINUS7 : process
    constant ARG1 : REALX_VECTOR := (

      MATH_E,
      COS(1.0),
      1.0,
      -1.0,
      0.0,

      0.0,
      1.0,
      -1.0,
      0.0,
      1.0,

      -1.0
      );

    constant ARG2 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(SIN(1.0), COS(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0))
      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      COMPLEX_TO_POLAR(COMPLEX'(0.0, -MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0)-SIN(1.0), -COS(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(2.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-2.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0))
      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin

    wait until start_MINUS7;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)-ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("-[REAL,COMPLEX_POLAR]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MINUS7 <= true;
    wait;

  end process MINUS7;

--Test -[COMPLEX_POLAR,REAL] return COMPLEX_POLAR
  MINUS8 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0), SIN(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0))

      );

    constant ARG2 : REALX_VECTOR := (

      MATH_E,
      SIN(1.0),
      -1.0,
      1.0,
      1.0,

      1.0,
      0.0,
      -1.0,
      -1.0,
      0.0,

      0.0
      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      COMPLEX_TO_POLAR(COMPLEX'(0.0, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0)-SIN(1.0), SIN(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(2.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-2.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0))

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin

    wait until start_MINUS8;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)-ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("-[COMPLEX_POLAR,REAL]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MINUS8 <= true;
    wait;

  end process MINUS8;

--Test *[COMPLEX,COMPLEX] return COMPLEX
  MULT1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (COS(1.0), SIN(1.0)),
      (1.0, 0.0),
      (-1.0, 0.0),
      (0.0, 0.0),

      (0.0, 1.0),
      (1.0, 1.0),
      (-1.0, 1.0),
      (0.0, -1.0),
      (1.0, -1.0),

      (-1.0, -1.0)
      );

    constant ARG2 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (SIN(1.0), COS(1.0)),
      (-1.0, 1.0),
      (1.0, 1.0),
      (1.0, -1.0),

      (1.0, 0.0),
      (0.0, -1.0),
      (-1.0, -1.0),
      (-1.0, 0.0),
      (0.0, 1.0),

      (0.0, 0.0)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (0.0, MATH_E*MATH_E+MATH_E*MATH_E),
      (0.0, 1.0),
      (-1.0, 1.0),
      (-1.0, -1.0),
      (0.0, 0.0),

      (0.0, 1.0),
      (1.0, -1.0),
      (2.0, 0.0),
      (0.0, 1.0),
      (1.0, 1.0),

      (0.0, 0.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_MULT1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)*ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("*[COMPLEX,COMPLEX]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MULT1 <= true;
    wait;

  end process MULT1;

--Test *[REAL,COMPLEX] return COMPLEX
  MULT2 : process
    constant ARG1 : REALX_VECTOR := (

      MATH_E,
      COS(1.0),
      1.0,
      -1.0,
      0.0,

      MATH_PI,
      MATH_PI,
      -1.0,
      4.0,
      1.0,

      -1.0
      );

    constant ARG2 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (SIN(1.0), COS(1.0)),
      (-1.0, 1.0),
      (1.0, 1.0),
      (1.0, -1.0),

      (1.0, 0.0),
      (0.0, -1.0),
      (-1.0, -1.0),
      (-1.0, 1.0),
      (0.0, 1.0),

      (0.0, 0.0)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (MATH_E*MATH_E, MATH_E*MATH_E),
      (COS(1.0)*SIN(1.0), COS(1.0)*COS(1.0)),
      (-1.0, 1.0),
      (-1.0, -1.0),
      (0.0, 0.0),

      (MATH_PI, 0.0),
      (0.0, -MATH_PI),
      (1.0, 1.0),
      (-4.0, 4.0),
      (0.0, 1.0),

      (0.0, 0.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_MULT2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)*ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("*[REAL,COMPLEX]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MULT2 <= true;
    wait;

  end process MULT2;

--Test *[COMPLEX,REAL] return COMPLEX
  MULT3 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (COS(1.0), SIN(1.0)),
      (1.0, 0.0),
      (-1.0, 0.0),
      (0.0, 0.0),

      (0.0, 1.0),
      (2.0, 2.0),
      (-5.0, 5.0),
      (0.0, -1.0),
      (1.0, -1.0),

      (-10.0, -10.0)
      );

    constant ARG2 : REALX_VECTOR := (

      MATH_E,
      SIN(1.0),
      -1.0,
      1.0,
      1.0,

      2.0,
      3.0,
      -4.0,
      -1.0,
      0.0,

      20.0
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (MATH_E*MATH_E, MATH_E*MATH_E),
      (COS(1.0)*SIN(1.0), SIN(1.0)*SIN(1.0)),
      (-1.0, 0.0),
      (-1.0, 0.0),
      (0.0, 0.0),

      (0.0, 2.0),
      (6.0, 6.0),
      (20.0, -20.0),
      (0.0, 1.0),
      (0.0, 0.0),

      (-200.0, -200.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_MULT3;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)*ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("*[COMPLEX,REAL]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MULT3 <= true;
    wait;

  end process MULT3;

--Test *[COMPLEX_POLAR,COMPLEX_POLAR] return COMPLEX_POLAR
  MULT4 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0), SIN(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      (3.0, 3.0*MATH_PI_OVER_4),
      (3.0, -3.0*MATH_PI_OVER_4)

      );

    constant ARG2 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(SIN(1.0), COS(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),
      (2.0, MATH_PI_OVER_2),
      (2.0, -MATH_PI_OVER_2)

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      COMPLEX_TO_POLAR(COMPLEX'(0.0, MATH_E*MATH_E+MATH_E*MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(2.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),
      (6.0, -3.0*MATH_PI_OVER_4),
      (6.0, 3.0*MATH_PI_OVER_4)

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_MULT4;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)*ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("*[COMPLEX_POLAR,COMPLEX_POLAR]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MULT4 <= true;
    wait;

  end process MULT4;

--Test *[REAL,COMPLEX_POLAR] return COMPLEX_POLAR
  MULT5 : process
    constant ARG1 : REALX_VECTOR := (

      MATH_E,
      COS(1.0),
      1.0,
      -1.0,
      0.0,

      MATH_PI,
      MATH_PI,
      -1.0,
      4.0,
      1.0,

      -1.0
      );

    constant ARG2 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(SIN(1.0), COS(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0))

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E*MATH_E, MATH_E*MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0)*SIN(1.0), COS(1.0)*COS(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(MATH_PI, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -MATH_PI)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-4.0, 4.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0))

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_MULT5;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)*ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("*[REAL,COMPLEX_POLAR]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MULT5 <= true;
    wait;

  end process MULT5;

--Test *[COMPLEX_POLAR,REAL] return COMPLEX_POLAR
  MULT6 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0), SIN(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(2.0, 2.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-5.0, 5.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-10.0, -10.0))

      );

    constant ARG2 : REALX_VECTOR := (

      MATH_E,
      SIN(1.0),
      -1.0,
      1.0,
      1.0,

      2.0,
      3.0,
      -4.0,
      -1.0,
      0.0,

      20.0
      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E*MATH_E, MATH_E*MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0)*SIN(1.0), SIN(1.0)*SIN(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 2.0)),
      COMPLEX_TO_POLAR(COMPLEX'(6.0, 6.0)),
      COMPLEX_TO_POLAR(COMPLEX'(20.0, -20.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(-200.0, -200.0))
      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_MULT6;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)*ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("*[COMPLEX_POLAR,REAL]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_MULT6 <= true;
    wait;

  end process MULT6;


--Test /[COMPLEX,COMPLEX] return COMPLEX
  DIV1 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (COS(1.0), SIN(1.0)),
      (1.0, 0.0),
      (-1.0, 0.0),
      (0.0, 0.0),

      (0.0, 1.0),
      (1.0, 1.0),
      (-1.0, 1.0),
      (0.0, -1.0),
      (1.0, -1.0),

      (10.0, 7.0)
      );

    constant ARG2 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (SIN(1.0), -COS(1.0)),
      (-1.0, 1.0),
      (1.0, 1.0),
      (1.0, -1.0),

      (1.0, 0.0),
      (0.0, -1.0),
      (-1.0, -1.0),
      (-1.0, 0.0),
      (0.0, 1.0),

      (0.0, 5.0)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (1.0, 0.0),
      (0.0, 1.0),
      (-0.5, -0.5),
      (-0.5, 0.5),
      (0.0, 0.0),

      (0.0, 1.0),
      (-1.0, 1.0),
      (0.0, -1.0),
      (0.0, 1.0),
      (-1.0, -1.0),

      (1.4, -2.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_DIV1;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)/ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("/[COMPLEX,COMPLEX]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_DIV1 <= true;
    wait;

  end process DIV1;


--Test /[REAL,COMPLEX] return COMPLEX
  DIV2 : process
    constant ARG1 : REALX_VECTOR := (

      MATH_E,
      COS(1.0),
      1.0,
      -1.0,
      0.0,

      0.0,
      1.0,
      -1.0,
      5.0,
      1.0,

      10.0
      );

    constant ARG2 : COMPLEX_VECTOR := (

      (MATH_E, 0.0),
      (SIN(1.0), -COS(1.0)),
      (-1.0, 1.0),
      (1.0, 1.0),
      (1.0, -1.0),

      (1.0, 0.0),
      (0.0, -1.0),
      (-1.0, -1.0),
      (-1.0, 0.0),
      (0.0, -1.0),

      (0.0, 5.0)
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (1.0, 0.0),
      (COS(1.0)*SIN(1.0), COS(1.0)*COS(1.0)),
      (-0.5, -0.5),
      (-0.5, 0.5),
      (0.0, 0.0),

      (0.0, 0.0),
      (0.0, 1.0),
      (0.5, -0.5),
      (-5.0, 0.0),
      (0.0, 1.0),

      (0.0, -2.0)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_DIV2;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)/ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("/[REAL,COMPLEX]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_DIV2 <= true;
    wait;

  end process DIV2;

--Test /[COMPLEX,REAL] return COMPLEX
  DIV3 : process
    constant ARG1 : COMPLEX_VECTOR := (

      (MATH_E, MATH_E),
      (COS(1.0), SIN(1.0)),
      (1.0, -1.0),
      (-1.0, 0.0),
      (0.0, 0.0),

      (0.0, 1.0),
      (10.0, 10.0),
      (-1.0, 1.0),
      (0.0, -1.0),
      (1.0, -1.0),

      (10.0, 7.0)
      );

    constant ARG2 : REALX_VECTOR(1 to ARG1'length) := (

      MATH_E,
      SIN(1.0),
      -1.0,
      2.0,
      1.0,

      2.0,
      -5.0,
      -1.0,
      -1.0,
      10.0,

      5.0
      );

    constant CORRECT_ANSWERS : COMPLEX_VECTOR(1 to ARG1'length) := (

      (1.0, 1.0),
      (COS(1.0)/SIN(1.0), 1.0),
      (-1.0, 1.0),
      (-0.5, 0.0),
      (0.0, 0.0),

      (0.0, 0.5),
      (-2.0, -2.0),
      (1.0, -1.0),
      (0.0, 1.0),
      (0.1, -0.1),

      (2.0, 1.4)
      );

    variable RESULTS   : COMPLEX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin

    wait until start_DIV3;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)/ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("/[COMPLEX,REAL]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_DIV3 <= true;
    wait;

  end process DIV3;

--Test /[COMPLEX_POLAR,COMPLEX_POLAR] return COMPLEX_POLAR
  DIV4 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0), SIN(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(10.0, 7.0)),
      (3.0, -3.0*MATH_PI_OVER_4),
      (3.0, 3.0*MATH_PI_OVER_4)

      );

    constant ARG2 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(SIN(1.0), -COS(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 5.0)),
      (2.0, 2.0*MATH_PI_OVER_4),
      (2.0, -2.0*MATH_PI_OVER_4)

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-0.5, -0.5)),
      COMPLEX_TO_POLAR(COMPLEX'(-0.5, 0.5)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(1.4, -2.0)),
      (1.5, 3.0*MATH_PI_OVER_4),
      (1.5, -3.0*MATH_PI_OVER_4)

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_DIV4;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)/ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("/[COMPLEX_POLAR,COMPLEX_POLAR]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_DIV4 <= true;
    wait;

  end process DIV4;


--Test /[REAL,COMPLEX_POLAR] return COMPLEX_POLAR
  DIV5 : process
    constant ARG1 : REALX_VECTOR := (

      MATH_E,
      COS(1.0),
      1.0,
      -1.0,
      0.0,

      0.0,
      1.0,
      -1.0,
      5.0,
      1.0,

      10.0
      );

    constant ARG2 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(SIN(1.0), -COS(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 5.0))

      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0)*SIN(1.0), COS(1.0)*COS(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(-0.5, -0.5)),
      COMPLEX_TO_POLAR(COMPLEX'(-0.5, 0.5)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.5, -0.5)),
      COMPLEX_TO_POLAR(COMPLEX'(-5.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, -2.0))

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin
    wait until start_DIV5;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)/ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("/[REAL,COMPLEX_POLAR]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_DIV5 <= true;
    wait;

  end process DIV5;

--Test /[COMPLEX,REAL] return COMPLEX
  DIV6 : process
    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      COMPLEX_TO_POLAR(COMPLEX'(MATH_E, MATH_E)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0), SIN(1.0))),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(10.0, 10.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),

      COMPLEX_TO_POLAR(COMPLEX'(10.0, 7.0))

      );

    constant ARG2 : REALX_VECTOR(1 to ARG1'length) := (

      MATH_E,
      SIN(1.0),
      -1.0,
      2.0,
      1.0,

      2.0,
      -5.0,
      -1.0,
      -1.0,
      10.0,

      5.0
      );

    constant CORRECT_ANSWERS : COMPLEX_POLAR_VECTOR(1 to ARG1'length) := (

      COMPLEX_TO_POLAR(COMPLEX'(1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(COS(1.0)/SIN(1.0), 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-1.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(-0.5, 0.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.0)),

      COMPLEX_TO_POLAR(COMPLEX'(0.0, 0.5)),
      COMPLEX_TO_POLAR(COMPLEX'(-2.0, -2.0)),
      COMPLEX_TO_POLAR(COMPLEX'(1.0, -1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.0, 1.0)),
      COMPLEX_TO_POLAR(COMPLEX'(0.1, -0.1)),

      COMPLEX_TO_POLAR(COMPLEX'(2.0, 1.4))

      );

    variable RESULTS   : COMPLEX_POLAR_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin

    wait until start_DIV6;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I)/ARG2(I);
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("/[COMPLEX_POLAR,REAL]", ARG1, ARG2, RESULTS, CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_DIV6 <= true;
    wait;

  end process DIV6;

--Test GET_PRINCIPAL_VALUE[REAL] return REAL
  TEST_GET_PRINCIPAL_VALUE : process
    constant ARG1 : REALX_VECTOR := (

      13.0*MATH_PI_OVER_4+0.025,
      13.0*MATH_PI_OVER_4-0.025,

      3.0*MATH_PI+0.025,
      3.0*MATH_PI-0.025,
      11.0*MATH_PI_OVER_4+0.025,
      11.0*MATH_PI_OVER_4-0.025,
      5.0*MATH_PI_OVER_2+0.025,
      5.0*MATH_PI_OVER_2-0.025,
      9.0*MATH_PI_OVER_4+0.025,
      9.0*MATH_PI_OVER_4-0.025,
      2.0*MATH_PI+0.025,
      2.0*MATH_PI-0.025,
      7.0*MATH_PI_OVER_4+0.025,
      7.0*MATH_PI_OVER_4-0.025,
      3.0*MATH_PI_OVER_2+0.025,
      3.0*MATH_PI_OVER_2-0.025,
      5.0*MATH_PI_OVER_4+0.025,
      5.0*MATH_PI_OVER_4-0.025,

      MATH_PI+0.025,
      MATH_PI-0.025,
      3.0*MATH_PI_OVER_4+0.025,
      3.0*MATH_PI_OVER_4-0.025,
      MATH_PI_OVER_2+0.025,
      MATH_PI_OVER_2-0.025,
      MATH_PI_OVER_4+0.025,
      MATH_PI_OVER_4-0.025,
      0.0+0.025,
      0.0,
      0.0-0.025,
      -MATH_PI_OVER_4+0.025,
      -MATH_PI_OVER_4-0.025,
      -MATH_PI_OVER_2+0.025,
      -MATH_PI_OVER_2-0.025,
      -3.0*MATH_PI_OVER_4+0.025,
      -3.0*MATH_PI_OVER_4-0.025,

      -MATH_PI+0.025,
      -MATH_PI,
      -MATH_PI-0.025,
      -5.0*MATH_PI_OVER_4+0.025,
      -5.0*MATH_PI_OVER_4-0.025,
      -3.0*MATH_PI_OVER_2+0.025,
      -3.0*MATH_PI_OVER_2-0.025,
      -7.0*MATH_PI_OVER_4+0.025,
      -7.0*MATH_PI_OVER_4-0.025,
      -2.0*MATH_PI+0.025,
      -2.0*MATH_PI-0.025,
      -9.0*MATH_PI_OVER_4+0.025,
      -9.0*MATH_PI_OVER_4-0.025,
      -5.0*MATH_PI_OVER_2+0.025,
      -5.0*MATH_PI_OVER_2-0.025,
      -11.0*MATH_PI_OVER_4+0.025,
      -11.0*MATH_PI_OVER_4-0.025,

      -3.0*MATH_PI+0.025,
      -3.0*MATH_PI-0.025,
      -13.0*MATH_PI_OVER_4+0.025,
      -13.0*MATH_PI_OVER_4-0.025

      );


    constant CORRECT_ANSWERS : REALX_VECTOR(1 to ARG1'length) := (

      -3.0*MATH_PI_OVER_4+0.025,
      -3.0*MATH_PI_OVER_4-0.025,

      -MATH_PI+0.025,
      MATH_PI-0.025,
      3.0*MATH_PI_OVER_4+0.025,
      3.0*MATH_PI_OVER_4-0.025,
      MATH_PI_OVER_2+0.025,
      MATH_PI_OVER_2-0.025,
      MATH_PI_OVER_4+0.025,
      MATH_PI_OVER_4-0.025,
      0.0+0.025,
      0.0-0.025,
      -MATH_PI_OVER_4+0.025,
      -MATH_PI_OVER_4-0.025,
      -MATH_PI_OVER_2+0.025,
      -MATH_PI_OVER_2-0.025,
      -3.0*MATH_PI_OVER_4+0.025,
      -3.0*MATH_PI_OVER_4-0.025,

      -MATH_PI+0.025,
      MATH_PI-0.025,
      3.0*MATH_PI_OVER_4+0.025,
      3.0*MATH_PI_OVER_4-0.025,
      MATH_PI_OVER_2+0.025,
      MATH_PI_OVER_2-0.025,
      MATH_PI_OVER_4+0.025,
      MATH_PI_OVER_4-0.025,
      0.0+0.025,
      0.0,
      0.0-0.025,
      -MATH_PI_OVER_4+0.025,
      -MATH_PI_OVER_4-0.025,
      -MATH_PI_OVER_2+0.025,
      -MATH_PI_OVER_2-0.025,
      -3.0*MATH_PI_OVER_4+0.025,
      -3.0*MATH_PI_OVER_4-0.025,

      -MATH_PI+0.025,
      MATH_PI,
      MATH_PI-0.025,
      3.0*MATH_PI_OVER_4+0.025,
      3.0*MATH_PI_OVER_4-0.025,
      MATH_PI_OVER_2+0.025,
      MATH_PI_OVER_2-0.025,
      MATH_PI_OVER_4+0.025,
      MATH_PI_OVER_4-0.025,
      0.0+0.025,
      0.0-0.025,
      -MATH_PI_OVER_4+0.025,
      -MATH_PI_OVER_4-0.025,
      -MATH_PI_OVER_2+0.025,
      -MATH_PI_OVER_2-0.025,
      -3.0*MATH_PI_OVER_4+0.025,
      -3.0*MATH_PI_OVER_4-0.025,

      -MATH_PI+0.025,
      MATH_PI-0.025,
      3.0*MATH_PI_OVER_4+0.025,
      3.0*MATH_PI_OVER_4-0.025

      );

    variable RESULTS   : REALX_VECTOR(1 to ARG1'length);
    variable REL_ERROR : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR : REALX_VECTOR(1 to ARG1'length);

  begin

    wait until start_TEST_GET_PRINCIPAL_VALUE;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := GET_PRINCIPAL_VALUE(ARG1(I));
    end loop;

--      Compute absolute error

    for I in 1 to ARG1'length loop
      ABS_ERROR(I) := ABSOLUTE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Compute relative error

    for I in 1 to ARG1'length loop
      REL_ERROR(I) := RELATIVE_ERROR(CORRECT_ANSWERS(I), RESULTS(I));
    end loop;

--      Print results

    PRINT_RESULTS("GET_PRINCIPAL_VALUE", ARG1, RESULTS,
                  CORRECT_ANSWERS, ABS_ERROR,
                  REL_ERROR, FULL_RESULTS);

    done_TEST_GET_PRINCIPAL_VALUE <= true;
    wait;

  end process TEST_GET_PRINCIPAL_VALUE;


--Test =[COMPLEX_POLAR,COMPLEX_POLAR] return BOOLEAN
  TEST_EQUAL : process

    type booleanx_vector is array(POSITIVE range <>) of BOOLEAN;

    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (1.0, MATH_PI),
      (1.0, MATH_PI),
      (500.0, MATH_PI_OVER_2),
      (500.0, -MATH_PI_OVER_2),

      (1.0, 1.0),
      (1.0, -1.0),
      (1.0, 1.0),
      (1.0, -1.0),

      (0.0, 0.0),
      (0.0, 1.0),
      (0.0, 1.6),
      (0.0, MATH_PI)

      );


    constant ARG2 : COMPLEX_POLAR_VECTOR := (

      (1.0, MATH_PI),
      (1.0, -MATH_PI_OVER_4),
      (500.0, MATH_PI_OVER_2),
      (500.0, MATH_PI_OVER_2),

      (1.0, 1.0),
      (1.0, 1.0),
      (1.0, -1.0),
      (1.0, -1.0),

      (0.0, MATH_PI_OVER_2),
      (0.0, MATH_PI),
      (0.0, -MATH_PI_OVER_2),
      (0.0, 3.0)

      );

    constant CORRECT_ANSWERS : BOOLEANX_VECTOR(1 to ARG1'length) := (

      true,
      false,
      true,
      false,

      true,
      false,
      false,
      true,

      true,
      true,
      true,
      true
      );

    variable RESULTS    : BOOLEANX_VECTOR(1 to ARG1'length);
    variable REL_ERROR  : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR  : REALX_VECTOR(1 to ARG1'length);
    variable FAIL_COUNT : INTEGER := 0;
    variable OUTLINE    : LINE;

  begin

    wait until start_TEST_EQUAL;

--      Compute results

    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I) /= ARG2(I);
    end loop;

--      Compute number of failing cases

    for I in 1 to ARG1'length loop

      if(RESULTS(I) = CORRECT_ANSWERS(I))
      then
        FAIL_COUNT := FAIL_COUNT+1;
      end if;

    end loop;

    check_equal(FAIL_COUNT, 0, result("for FAIL_COUNT"));

    done_TEST_EQUAL <= true;
    wait;

  end process TEST_EQUAL;

--Test /=[COMPLEX_POLAR,COMPLEX_POLAR] return BOOLEAN
  TEST_NOT_EQUAL : process

    type booleanx_vector is array(POSITIVE range <>) of BOOLEAN;

    constant ARG1 : COMPLEX_POLAR_VECTOR := (

      (1.0, MATH_PI),
      (1.0, MATH_PI),
      (500.0, MATH_PI_OVER_2),
      (500.0, -MATH_PI_OVER_2),

      (1.0, 1.0),
      (1.0, -1.0),
      (1.0, 1.0),
      (1.0, -1.0),

      (0.0, 0.0),
      (0.0, 1.0),
      (0.0, 1.6),
      (0.0, MATH_PI)

      );


    constant ARG2 : COMPLEX_POLAR_VECTOR := (

      (1.0, MATH_PI),
      (1.0, -MATH_PI_OVER_4),
      (500.0, MATH_PI_OVER_2),
      (500.0, MATH_PI_OVER_2),

      (1.0, 1.0),
      (1.0, 1.0),
      (1.0, -1.0),
      (1.0, -1.0),

      (0.0, MATH_PI_OVER_2),
      (0.0, MATH_PI),
      (0.0, -MATH_PI_OVER_2),
      (0.0, 3.0)

      );

    constant CORRECT_ANSWERS : BOOLEANX_VECTOR(1 to ARG1'length) := (

      false,
      true,
      false,
      true,

      false,
      true,
      true,
      false,

      false,
      false,
      false,
      false

      );

    variable RESULTS    : BOOLEANX_VECTOR(1 to ARG1'length);
    variable REL_ERROR  : REALX_VECTOR(1 to ARG1'length);
    variable ABS_ERROR  : REALX_VECTOR(1 to ARG1'length);
    variable FAIL_COUNT : INTEGER := 0;
    variable OUTLINE    : LINE;
  begin

    wait until start_TEST_NOT_EQUAL;

--      Compute results
    for I in 1 to ARG1'length loop
      RESULTS(I) := ARG1(I) /= ARG2(I);
    end loop;

--      Compute number of failing cases

    for I in 1 to ARG1'length loop

      if(RESULTS(I) /= CORRECT_ANSWERS(I))
      then
        FAIL_COUNT := FAIL_COUNT+1;
      end if;
    end loop;

    check_equal(FAIL_COUNT, 0, result("for FAIL_COUNT"));

    done_TEST_NOT_EQUAL <= true;
    wait;
  end process TEST_NOT_EQUAL;

end architecture ARCH;
