-----------------------------------------------------------------------------
-- Title      : Test routines for the new functions in numeric_bit
--              for vhdl-200x-ft
-- check of to_string functions
-- check of read and write functions
--  Date: August 18, 2004. testcompile.
--
--  Created for VHDL-200X par, David Bishop (dbishop@vhdl.org)
-----------------------------------------------------------------------------
library vunit_lib;
context vunit_lib.vunit_context;

entity test_bstring is
  generic (
    runner_cfg : string);
end entity test_bstring;

library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

architecture testbench of test_bstring is

  -- purpose: reports an error
  procedure report_error (
    constant errmes   :    STRING;      -- error message
    actual            : in STRING;      -- data from algorithm
    constant expected :    STRING)  is  -- reference data
    variable L : LINE;
  begin  -- function report_error
    assert (actual = expected)
      report "TEST_STRING: " & errmes & CR
      & "Actual   " & actual & " /= "
      & "Expected " & expected
      severity failure;
    return;
  end procedure report_error;
  signal start_readtest, readtest_done : BOOLEAN := false;  -- start reading test
  signal start_stest, stest_done       : BOOLEAN := false;  -- start reading test
begin  -- architecture testbench

  -- purpose: Checks basic string functions
  -- type   : combinational
  -- inputs :
  -- outputs:
  Test_process : process is
    variable checknum              : UNSIGNED (23 downto 0);  -- checknum
    variable checknum1             : UNSIGNED (24 downto 0);  -- checknum
    variable checknum2             : UNSIGNED (25 downto 0);  -- checknum
    variable checknum3             : UNSIGNED (26 downto 0);  -- checknum
    variable checkstr, checkstrx   : STRING (1 to 24);
    variable checkstrb             : STRING (24 downto 1);    -- downto string
    variable checkstr1, checkstrx1 : STRING (1 to 25);
    variable checkstr2, checkstrx2 : STRING (1 to 26);
    variable checkstr3, checkstrx3 : STRING (1 to 27);
    variable checknums             : SIGNED (23 downto 0);    -- signed number
    variable checkst1              : STRING (1 to 1);         -- 1 char
    variable checkst2              : STRING (1 to 2);         -- 2 char
    variable checkst3              : STRING (1 to 3);         -- 3 char
    variable checkstr4             : STRING (1 to 4);         -- 4 char
    variable checkstr5             : STRING (1 to 5);         -- 5 char
    variable checkstr6             : STRING (1 to 6);         -- 6 char
    variable checkstr7             : STRING (1 to 7);         -- 7 char
    variable checkstr8             : STRING (1 to 8);         -- 7 char
    variable checkstr9             : STRING (1 to 9);         -- 7 char
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
      if run("Test to_string") then
        checknum := "000000000000000000000000";
        checkstr := to_string (checknum);
        report_error ("First string test", checkstr,
                      "000000000000000000000000");
        checknum := "000000000000000000000011";
        checkstr := to_string (checknum);
        report_error ("right string test", checkstr,
                      "000000000000000000000011");
        checknum := "011000000000000000000000";
        checkstr := to_string (checknum);
        report_error ("left string test", checkstr,
                      "011000000000000000000000");
        --checknum := "000000000000000000000011";
        --checkstr := justify (to_string (checknum), left, 0);
        --report_error ("string left justify 0", checkstr,
        --              "000000000000000000000011");
        --checknum  := "000000000000000000000011";
        --checkstr1 := justify (to_string (checknum), left, 25);
        --report_error ("string left justify 25", checkstr1,
        --              "000000000000000000000011 ");
        --checknum  := "000000000000000000000011";
        --checkstr1 := justify (to_string (checknum), right, 25);
        --report_error ("string right justify 25", checkstr1,
        --              " 000000000000000000000011");
        --checknum := "000000000000000000000011";
        --checkstr := justify (to_string (checknum), right, 0);
        --report_error ("string right justify 0", checkstr,
        --              "000000000000000000000011");
      elsif run("Test to_ostring") then
        checknum  := "000000000000000000000011";
        checkstr8 := to_ostring (checknum);
        report_error ("First octal test", checkstr8,
                      "00000003");
        checknum  := "111110101100011010001000";
        checkstr8 := to_ostring (checknum);
        report_error ("First octal test", checkstr8,
                      "76543210");
        checknum  := "001010011100101110000111";
        checkstr8 := to_ostring (checknum);
        report_error ("First octal test", checkstr8,
                      "12345607");
      elsif run("Test to_ostring with padding") then
        checknum1 := "0000000000000000000000011";
        checkstr9 := to_ostring (checknum1);
        report_error ("Octal padding test 1", checkstr9,
                      "000000003");
        checknum2 := "11111110101100011010001000";
        checkstr9 := to_ostring (checknum2);
        report_error ("Octal padding test 2", checkstr9,
                      "376543210");
        checknum1 := "1001010011100101110000111";
        checkstr9 := to_ostring (checknum1);
        report_error ("Octal padding test 3", checkstr9,
                      "112345607");
        checknum1 := "0001010011100101110000111";
        checkstr9 := to_ostring (checknum1);
        report_error ("Octal 0 padding test 1", checkstr9,
                      "012345607");
        checknum2 := "00001010011100101110000111";
        checkstr9 := to_ostring (checknum2);
        report_error ("Octal 0 padding test 2", checkstr9,
                      "012345607");
        checknums := "100000000000000000000011";
        checkstr8 := to_ostring (checknums);
        report_error ("Octal signed test", checkstr8,
                      "40000003");
      elsif run("Test to_hstring") then
        checknum  := "000000000000000000000011";
        checkstr6 := to_hstring (checknum);
        report_error ("First hex test", checkstr6,
                      "000003");
        checknum  := "010101000011001000010000";
        checkstr6 := to_hstring (checknum);
        report_error ("First hex number test", checkstr6,
                      "543210");
        checknum  := "101110101001100001110110";
        checkstr6 := to_hstring (checknum);
        report_error ("second hex number test", checkstr6,
                      "BA9876");
        checknum  := "111111101101110010111010";
        checkstr6 := to_hstring (checknum);
        report_error ("3 hex letter test", checkstr6,
                      "FEDCBA");
        checknum  := "001010011100101110000111";
        checkstr6 := to_hstring (checknum);
        report_error ("hex octal test", checkstr6,
                      "29CB87");
        checknum1 := "0000000000000000000000011";
        checkstr7 := to_hstring (checknum1);
        report_error ("Hex padding test 1", checkstr7,
                      "0000003");
        checknum2 := "01000000000000000000000011";
        checkstr7 := to_hstring (checknum2);
        report_error ("Hex padding test 2", checkstr7,
                      "1000003");
        checknum3 := "101000000000000000000000011";
        checkstr7 := to_hstring (checknum3);
        report_error ("Hex padding test 3", checkstr7,
                      "5000003");
        checknum3 := "000000000000000000000000011";
        checkstr7 := to_hstring (checknum3);
        report_error ("Hex padding Z test 1", checkstr7,
                      "0000003");
        checknums := "100000000000000000000011";
        checkstr6 := to_hstring (checknums);
        report_error ("signed hex test", checkstr6,
                      "800003");
      --elsif run("Test to_dstring") then
        --checknum := "000000000000000000000011";
        --checkst1 := to_dstring (checknum);
        --report_error ("First decimal test", checkst1,
        --              "3");
        --checknum := "000000000000000000001111";
        --checkst2 := to_dstring (checknum);
        --report_error ("2 decimal test", checkst2,
        --              "15");
        --checknums := "111111111111111111111111";
        --report_error ("dec signed test", to_dstring (checknums),
        --              "-1");
        --checknums := "111111111111111111110000";
        --report_error ("dec signed test 2", to_dstring (checknums),
        --              "-16");
      elsif run("Test read routines") or
        run("Expected to fail: Test HREAD truncate error 1") or
        run("Expected to fail: Test HREAD truncate error 2") or
        run("Expected to fail: Test OREAD truncate error 1") or
        run("Expected to fail: Test OREAD truncate error 2") or
        run("Expected to fail: Test HREAD truncate error 3") then

        start_readtest <= true;
        wait for 0 ns;
        start_readtest <= false;
        wait until readtest_done;
      end if;
    end loop;

    test_runner_cleanup(runner);
    wait;
  end process Test_process;

  -- purpose: test the read routines
  -- type   : combinational
  -- inputs :
  -- outputs:
  read_test : process is
    constant rstring    : STRING := "110010101011";  -- constant string
    constant rstringh   : STRING := "CAB";           -- constant string
    constant rstringo   : STRING := "6253";          -- constant string
    constant rstringd   : STRING := "3243";          -- constant string
    constant rstringn   : STRING := "-853";          -- constant string
    constant bstring1   : STRING := "";              -- empty string
    constant bstring2   : STRING := "11*111*1111*";  -- illegal characters
    constant bstring3   : STRING := "11 111 1111";   -- space characters
    constant bstring4   : STRING := " 11 ";          -- space padding
    variable checknum   : UNSIGNED (11 downto 0);    -- unsigned
    variable checknums  : SIGNED (11 downto 0);      -- signed
    variable checknums2 : SIGNED (12 downto 0);      -- signed
    variable l          : LINE;                      -- line variable
    variable checkbool  : BOOLEAN;                   -- check boolean
  begin  -- process read_test
    wait until start_readtest;
    if running_test_case = "Test read routines" then
      L        := new STRING'(rstring);
      checknum := (others => '0');
      read (L, checknum);
      report_error ("Error in binary Read",
                    to_string(checknum),
                    "110010101011");
      deallocate (L);
      L        := new STRING'(rstringh);
      checknum := (others => '0');
      hread (L, checknum);
      report_error ("Error in hex read",
                    to_string(checknum),
                    "110010101011");
      deallocate (L);
      L        := new STRING'(rstringo);
      checknum := (others => '0');
      oread (L, checknum);
      report_error ("Error in octal read",
                    to_string(checknum),
                    "110010101011");
      deallocate (L);
      -- Play with some signed values
      checknums2 := (others => '0');
      L          := new STRING'("1001");
      hread (L, checknums2, checkbool);
      assert (not checkbool)
        report "short hread (1001) failed to report error"
        severity failure;
      deallocate (L);
      checknums2 := (others => '0');
      L          := new STRING'("2001");
      hread (L, checknums2, checkbool);
      assert (not checkbool)
        report "short hread (2001) failed to report error"
        severity failure;
      deallocate (L);
      checknums2 := (others => '0');
      L          := new STRING'("3001");
      hread (L, checknums2, checkbool);
      assert (not checkbool)
        report "short hread (3001) failed to report error"
        severity failure;
      deallocate (L);
      checknums2 := (others => '0');
      L          := new STRING'("8001");
      hread (L, checknums2, checkbool);
      assert (not checkbool)
        report "short hread (8001) failed to report error"
        severity failure;
      deallocate (L);

      checknums2 := (others => '0');
      L          := new STRING'("0001");
      hread (L, checknums2, checkbool);
      assert (checkbool) report "short hread(0001) reported error"
        severity failure;
      report_error ("SIGNED hex read w/ bool",
                    to_string (checknums2), "0000000000001");
      deallocate (L);
      checknums2 := (others => '0');
      L          := new STRING'("0001");
      hread (L, checknums2);
      report_error ("SIGNED hex read",
                    to_string (checknums2), "0000000000001");
      deallocate (L);
      checknums2 := (others => '1');
      L          := new STRING'("F001");
      hread (L, checknums2, checkbool);
      assert (checkbool) report "short hread(F001) reported error"
        severity failure;
      report_error ("SIGNED hex -read w/ bool",
                    to_string (checknums2), "1000000000001");
      deallocate (L);
      checknums2 := (others => '0');
      L          := new STRING'("F001");
      hread (L, checknums2);
      report_error ("SIGNED hex -read",
                    to_string (checknums2), "1000000000001");
      deallocate (L);
      checknums2 := (others => '1');
      L          := new STRING'("01007");              -- octal
      oread (L, checknums2);
      report_error ("SIGNED oct read",
                    to_string (checknums2), "0001000000111");
      deallocate (L);
      L := new STRING'("01007");                       -- octal
      oread (L, checknums2, checkbool);
      assert (checkbool) report "short oread(01007) reported error"
        severity failure;
      report_error ("SIGNED oct read w/ bool",
                    to_string (checknums2), "0001000000111");
      deallocate (L);
      L := new STRING'("71007");                       -- octal
      oread (L, checknums2);
      report_error ("SIGNED oct read 71007",
                    to_string (checknums2), "1001000000111");
      deallocate (L);
      L := new STRING'("71007");                       -- octal
      oread (L, checknums2, checkbool);
      assert (checkbool) report "short oread(71007) reported error"
        severity failure;
      report_error ("SIGNED oct read 71007 w/ bool",
                    to_string (checknums2), "1001000000111");
      deallocate (L);
      L := new STRING'("17005");
      oread (L, checknums2, checkbool);
      assert not (checkbool) report "short oread(17005) not reported error"
        severity failure;
      deallocate (L);
      L := new STRING'("23005");
      oread (L, checknums2, checkbool);
      assert not (checkbool) report "short oread(23005) not reported error"
        severity failure;
      deallocate (L);
--    L := new string'(rstringd);
--    checknum := (others => '0');
--    dread (L, checknum);
--    report_error ("Error in decimal read",
--                  to_string(checknum),
--                  "110010101011");
--    deallocate (L);
      L := new STRING'(rstring);
      read (L, checknums);
      report_error ("Error in binary Read",
                    to_string(checknums),
                    "110010101011");
      deallocate (L);
      checknums := (others => '0');
      L         := new STRING'(rstringh);
      hread (L, checknums);
      report_error ("Error in hex read",
                    to_string(checknums),
                    "110010101011");
      deallocate (L);
      checknums := (others => '0');
      L         := new STRING'(rstringo);
      oread (L, checknums);
      report_error ("Error in octal read",
                    to_string(checknums),
                    "110010101011");
      deallocate (L);

--    L := new string'(rstringd);
--    dread (L, checknums2);
--    report_error ("Error in decimal read",
--                  to_string(checknums2),
--                  "0110010101011");

--    deallocate (L);
--    checknums := (others => '0');
--    L := new string'(rstringn);
--    dread (L, checknums);
--    report_error ("Error in negative decimal read",
--                  to_string(checknums),
--                  "110010101011");
      -- read with boolean checks
      L        := new STRING'(rstring);
      checknum := (others => '0');
      read (L, checknum, checkbool);
      assert (checkbool) report "TEST_STRING: Read reported error condition"
        severity failure;
      report_error ("Error in binary Read",
                    to_string(checknum),
                    "110010101011");
      deallocate (L);
      checknum := (others => '0');
      L        := new STRING'(rstringh);
      hread (L, checknum, checkbool);
      assert (checkbool) report "TEST_STRING: Read reported error condition"
        severity failure;
      report_error ("Error in hex read",
                    to_string(checknum),
                    "110010101011");
      deallocate (L);
      checknum := (others => '0');
      L        := new STRING'(rstringo);
      oread (L, checknum, checkbool);
      assert (checkbool) report "TEST_STRING: Read reported error condition"
        severity failure;
      report_error ("Error in unsigned octal read",
                    to_string(checknum),
                    "110010101011");
      deallocate (L);
--    checknum := (others => '0');
--    L := new string'(rstringd);
--    dread (L, checknum, checkbool);
--    assert (checkbool) report "TEST_STRING: Read reported error condition"
--      severity failure;
--    report_error ("Error in decimal read",
--                  to_string(checknum),
--                  "110010101011");
--    deallocate (L);
      checknums := (others => '0');
      L         := new STRING'(rstring);
      read (L, checknums, checkbool);
      assert (checkbool) report "TEST_STRING: Read reported error condition"
        severity failure;
      report_error ("Error in binary Read",
                    to_string(checknums),
                    "110010101011");
      deallocate (L);
      checknums := (others => '0');
      L         := new STRING'(rstringh);
      hread (L, checknums, checkbool);
      assert (checkbool) report "TEST_STRING: Read reported error condition"
        severity failure;
      report_error ("Error in hex read",
                    to_string(checknums),
                    "110010101011");
      deallocate (L);
      checknums := (others => '0');
      L         := new STRING'(rstringo);
      oread (L, checknums, checkbool);
      assert (checkbool) report "TEST_STRING: Read reported error condition"
        severity failure;
      report_error ("Error in signed octal read",
                    to_string(checknums),
                    "110010101011");
--    deallocate (L);
--    checknums2 := (others => '0');
--    L := new string'(rstringd);
--    dread (L, checknums2, checkbool);
--    assert (checkbool) report "TEST_STRING: Read reported error condition"
--      severity failure;
--    report_error ("Error in decimal read",
--                  to_string(checknums2),
--                  "0110010101011");

--    deallocate (L);
--    checknums := (others => '0');
--    L := new string'(rstringn);
--    dread (L, checknums, checkbool);
--    assert (checkbool) report "TEST_STRING: Read reported error condition"
--      severity failure;
--    report_error ("Error in negative decimal read",
--                  to_string(checknums),
--                  "110010101011");

      deallocate (L);
      L        := null;
      checknum := "110010101011";
      write (L, checknum);
      report_error ("Error in unsigned write",
                    L.all,
                    "110010101011");
      deallocate (L);
      L        := null;
      checknum := "110010101011";
      hwrite (L, checknum);
      report_error ("Error in unsigned hwrite",
                    L.all,
                    rstringh);
      deallocate (L);
      L        := null;
      checknum := "110010101011";
      owrite (L, checknum);
      report_error ("Error in unsigned owrite",
                    L.all,
                    rstringo);
      deallocate (L);
--    L := null;
--    checknum := "110010101011";
--    dwrite ( L, checknum );
--    report_error ("Error in unsigned dwrite",
--                  L.all,
--                  rstringd);

      L         := null;
      checknums := "110010101011";
      write (L, checknums);
      report_error ("Error in signed write",
                    L.all,
                    "110010101011");
      deallocate (L);
      L         := null;
      checknums := "110010101011";
      hwrite (L, checknums);
      report_error ("Error in signed hwrite",
                    L.all,
                    rstringh);
      deallocate (L);
      L         := null;
      checknums := "110010101011";
      owrite (L, checknums);
      report_error ("Error in signed owrite",
                    L.all,
                    rstringo);
      deallocate (L);
--    L := null;
--    checknums := "110010101011";
--    dwrite ( L, checknums );
--    report_error ("Error in signed dwrite",
--                  L.all,
--                  rstringn);

      -- Verify read error conditions
      -- read with boolean checks
      L        := new STRING'(bstring1);
      checknum := (others => '0');
      read (L, checknum, checkbool);
      assert (not checkbool) report "TEST_STRING: Read unreported error condition"
        severity failure;
      deallocate (L);
      L        := new STRING'(bstring1);
      checknum := (others => '0');
      hread (L, checknum, checkbool);
      assert (not checkbool) report "TEST_STRING: hRead unreported error condition"
        severity failure;
      deallocate (L);
      L        := new STRING'(bstring1);
      checknum := (others => '0');
      oread (L, checknum, checkbool);
      assert (not checkbool) report "TEST_STRING: oRead unreported error condition"
        severity failure;
      deallocate (L);
--    L := new string'(bstring1);
--    checknum := (others => '0');
--    dread (L, checknum, checkbool);
--    assert (not checkbool) report "TEST_STRING: dRead unreported error condition"
--      severity failure;
--    deallocate (L);
      L         := new STRING'(bstring1);
      checknums := (others => '0');
      read (L, checknums, checkbool);
      assert (not checkbool) report "TEST_STRING: Read unreported error condition"
        severity failure;
      deallocate (L);
      L         := new STRING'(bstring1);
      checknums := (others => '0');
      hread (L, checknums, checkbool);
      assert (not checkbool) report "TEST_STRING: hRead unreported error condition"
        severity failure;
      deallocate (L);
      L         := new STRING'(bstring1);
      checknums := (others => '0');
      oread (L, checknums, checkbool);
      assert (not checkbool) report "TEST_STRING: oRead unreported error condition"
        severity failure;
      deallocate (L);
--    L := new string'(bstring1);
--    checknums := (others => '0');
--    dread (L, checknums, checkbool);
--    assert (not checkbool) report "TEST_STRING: dRead unreported error condition"
--      severity failure;
--    deallocate (L);


      L        := new STRING'(bstring2);
      checknum := (others => '0');
      read (L, checknum, checkbool);
      assert (not checkbool) report "TEST_STRING: Read2 unreported error condition"
        severity failure;
      deallocate (L);
      L        := new STRING'(bstring2);
      checknum := (others => '0');
      hread (L, checknum, checkbool);
      assert (not checkbool) report "TEST_STRING: hRead2 unreported error condition"
        severity failure;
      deallocate (L);
      L        := new STRING'(bstring2);
      checknum := (others => '0');
      oread (L, checknum, checkbool);
      assert (not checkbool) report "TEST_STRING: oRead2 unreported error condition"
        severity failure;
--    deallocate (L);
--    L := new string'(bstring2);
--    checknum := (others => '0');
--    dread (L, checknum, checkbool);     -- Will read "11" from this string
--    assert (checkbool) report "TEST_STRING: dRead2 reported error condition"
--      severity failure;
--    report_error ("Error in bad decmial Read",
--                  to_string(checknum),
--                  "000000001011");
      deallocate (L);
      L         := new STRING'(bstring2);
      checknums := (others => '0');
      read (L, checknums, checkbool);
      assert (not checkbool) report "TEST_STRING: Read2 unreported error condition"
        severity failure;
      deallocate (L);
      L         := new STRING'(bstring2);
      checknums := (others => '0');
      hread (L, checknums, checkbool);
      assert (not checkbool) report "TEST_STRING: hRead2 unreported error condition"
        severity failure;
      deallocate (L);
      L         := new STRING'(bstring2);
      checknums := (others => '0');
      oread (L, checknums, checkbool);
      assert (not checkbool) report "TEST_STRING: oRead2 unreported error condition"
        severity failure;
      deallocate (L);
--    L := new string'(bstring2);
--    checknums := (others => '0');
--    dread (L, checknums, checkbool);     -- Will read "11" from this string
--    assert (checkbool) report "TEST_STRING: dRead2 reported error condition"
--      severity failure;
--    report_error ("Error in bad decmial Read",
--                  to_string(checknums),
--                  "000000001011");
--    deallocate (L);

      L        := new STRING'(bstring3);
      checknum := (others => '0');
      read (L, checknum, checkbool);
      assert (not checkbool) report "TEST_STRING: Read3 unreported error condition"
        severity failure;
      deallocate (L);
      L        := new STRING'(bstring3);
      checknum := (others => '0');
      hread (L, checknum, checkbool);
      assert (not checkbool) report "TEST_STRING: hRead3 unreported error condition"
        severity failure;
      deallocate (L);
      L        := new STRING'(bstring3);
      checknum := (others => '0');
      oread (L, checknum, checkbool);
      assert (not checkbool) report "TEST_STRING: oRead3 unreported error condition"
        severity failure;
--    deallocate (L);
--    L := new string'(bstring3);
--    checknum := (others => '0');
--    dread (L, checknum, checkbool);     -- Will read "11" from this string
--    assert (checkbool) report "TEST_STRING: dRead3 reported error condition"
--      severity failure;
      deallocate (L);
      L         := new STRING'(bstring3);
      checknums := (others => '0');
      read (L, checknums, checkbool);
      assert (not checkbool) report "TEST_STRING: Read3 unreported error condition"
        severity failure;
      deallocate (L);
      L         := new STRING'(bstring3);
      checknums := (others => '0');
      hread (L, checknums, checkbool);
      assert (not checkbool) report "TEST_STRING: hRead3 unreported error condition"
        severity failure;
      deallocate (L);
      L         := new STRING'(bstring3);
      checknums := (others => '0');
      oread (L, checknums, checkbool);
      assert (not checkbool) report "TEST_STRING: oRead3 unreported error condition"
        severity failure;
      deallocate (L);
--    L := new string'(bstring3);
--    checknums := (others => '0');
--    dread (L, checknums, checkbool);     -- Will read "11" from this string
--    assert (checkbool) report "TEST_STRING: dRead3 reported error condition"
--      severity failure;
--    report_error ("Error in bad decmial Read",
--                  to_string(checknums),
--                  "000000001011");
--    deallocate (L);
    elsif running_test_case = "Expected to fail: Test HREAD truncate error 1" then
      checknums2 := (others => '1');
      L          := new STRING'("8001");
      hread (L, checknums2);
      deallocate (L);
    elsif running_test_case = "Expected to fail: Test HREAD truncate error 2" then
      checknums2 := (others => '1');
      L          := new STRING'("2001");
      hread (L, checknums2);
      deallocate (L);
    elsif running_test_case = "Expected to fail: Test OREAD truncate error 1" then
      L := new STRING'("17005");
      oread (L, checknums2);
      deallocate (L);
    elsif running_test_case = "Expected to fail: Test OREAD truncate error 2" then
      L := new STRING'("23005");
      oread (L, checknums2);
      deallocate (L);
    elsif running_test_case = "Expected to fail: Test HREAD truncate error 3" then
      checknums2 := (others => '0');
      L          := new STRING'("8001");
      hread (L, checknums2);
      report_error ("SIGNED hex read overflow",
                    to_string (checknums2), "0000000000000");
      deallocate (L);
    end if;

    readtest_done <= true;
    wait for 0 ns;
    readtest_done <= false;
  end process read_test;
end architecture testbench;
