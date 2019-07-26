-------------------------------------------------------------------------------
-- Test vector for the VHDL-200x-FT std_logic_1164 package
-- This is a test of the reduce functions in std_logic_1164
-- Last Modified: $Date: 2007-09-11 15:31:23-04 $
-- RCS ID: $Id: test_reduce.vhdl,v 1.2 2007-09-11 15:31:23-04 l435385 Exp $
--
--  Created for VHDL-200X par, David Bishop (dbishop@vhdl.org)
-------------------------------------------------------------------------------
library vunit_lib;
context vunit_lib.vunit_context;

entity test_reduce is
  generic (
    runner_cfg : string);
end entity test_reduce;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

architecture test of test_reduce is
  signal start_nulltest, nulltest_done : BOOLEAN := false;  -- null test
begin

  verify : process is
    variable bv  : BIT_VECTOR(0 to 3);
    variable sulv : STD_ULOGIC_VECTOR(0 to 3);
    variable slv : STD_LOGIC_VECTOR(0 to 3);
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
      if run("Test reduce functions on non-null arrays") then
        for bv_val in 0 to 15 loop
          bv  := BIT_VECTOR (to_unsigned (bv_val, bv'length));  -- call from numeric_bit
          sulv := to_sulv(bv);
          slv := to_slv(bv);

          assert to_bit(and (sulv)) = (bv(0) and bv(1) and bv(2) and bv(3))
            report "error in and reduce std_ulogic_vector" severity failure;
          assert to_bit(and (slv)) = (bv(0) and bv(1) and bv(2) and bv(3))
            report "error in and reduce std_logic_vector" severity failure;

          assert to_bit(nand (sulv)) = not (bv(0) and bv(1) and bv(2) and bv(3))
            report "error in nand reduce std_ulogic_vector" severity failure;
          assert to_bit(nand (slv)) = not (bv(0) and bv(1) and bv(2) and bv(3))
            report "error in nand reduce std_logic_vector" severity failure;

          assert to_bit(or (sulv)) = (bv(0) or bv(1) or bv(2) or bv(3))
            report "error in or reduce std_ulogic_vector" severity failure;
          assert to_bit(or (slv)) = (bv(0) or bv(1) or bv(2) or bv(3))
            report "error in or reduce std_logic_vector" severity failure;

          assert to_bit(nor (sulv)) = not (bv(0) or bv(1) or bv(2) or bv(3))
            report "error in nor reduce std_ulogic_vector" severity failure;
          assert to_bit(nor (slv)) = not (bv(0) or bv(1) or bv(2) or bv(3))
            report "error in nor reduce std_logic_vector" severity failure;

          assert to_bit(xor (sulv)) = (bv(0) xor bv(1) xor bv(2) xor bv(3))
            report "error in xor reduce std_ulogic_vector" severity failure;
          assert to_bit(xor (slv)) = (bv(0) xor bv(1) xor bv(2) xor bv(3))
            report "error in xor reduce std_logic_vector" severity failure;

          assert to_bit(xnor (sulv)) = not (bv(0) xor bv(1) xor bv(2) xor bv(3))
            report "error in xnor reduce std_ulogic_vector" severity failure;
          assert to_bit(xnor (slv)) = not (bv(0) xor bv(1) xor bv(2) xor bv(3))
            report "error in xnor reduce std_logic_vector" severity failure;

          wait for 1 ns;
        end loop;
      elsif run("Test reduce functions on null arrays") then
        start_nulltest <= true;
        wait until nulltest_done;
      end if;
    end loop;

    test_runner_cleanup(runner);
    wait;
  end process verify;

  -- purpose: test null arrays
  nulltest : process is
    variable SNULL  : STD_LOGIC_VECTOR (0 downto 2)  := (others => '0');  -- NULL
    variable SUNULL : STD_ULOGIC_VECTOR (0 downto 2) := (others => '0');
  begin
    wait until start_nulltest;
    assert (and (SNULL) = '1') report "and reduce (SNULL) /= 1"
      severity failure;
    assert (nand (SNULL) = '0') report "nand reduce (SNULL) /= 0"
      severity failure;
    assert (or (SNULL) = '0') report "or reduce (SNULL) /= 0"
      severity failure;
    assert (nor (SNULL) = '1') report "nor reduce (SNULL) /= 1"
      severity failure;
    assert (xor (SNULL) = '0') report "xor reduce (SNULL) /= 0"
      severity failure;
    assert (xnor (SNULL) = '1') report "xnor reduce (SNULL) /= 1"
      severity failure;
    -- std_ulogic_vector
    assert (and (SUNULL) = '1') report "and reduce (SUNULL) /= 1"
      severity failure;
    assert (nand (SUNULL) = '0') report "nand reduce (SUNULL) /= 0"
      severity failure;
    assert (or (SUNULL) = '0') report "or reduce (SUNULL) /= 0"
      severity failure;
    assert (nor (SUNULL) = '1') report "nor reduce (SUNULL) /= 1"
      severity failure;
    assert (xor (SUNULL) = '0') report "xor reduce (SUNULL) /= 0"
      severity failure;
    assert (xnor (SUNULL) = '1') report "xnor reduce (SUNULL) /= 1"
      severity failure;

    nulltest_done <= true;
    wait;
  end process nulltest;

end architecture test;
