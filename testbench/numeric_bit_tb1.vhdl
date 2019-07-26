-- file numeric_bit_tb1.vhd is a simulation testbench for
-- IEEE 1076.3 numeric_bit package.
-- This is the first in a series of testbenches.
--
library vunit_lib;
context vunit_lib.vunit_context;
library ieee;

use ieee.numeric_bit.all;

entity numeric_bit_tb1 is
  generic (
    runner_cfg : string);
end entity numeric_bit_tb1;

architecture t1 of numeric_bit_tb1 is
  signal ANULL: UNSIGNED (0 downto 1);
  signal BNULL: UNSIGNED (0 downto 1);
  signal SANULL: SIGNED (0 downto 1);
  signal SBNULL: SIGNED (0 downto 1);

begin
  process
    -- required A15_38
    variable res4,sgn4: signed(3 downto 0);
    variable sgn6: signed(5 downto 0);
    variable res8: signed(7 downto 0);
    variable sgn10,res10:signed(9 downto 0);
    variable ures4,uns4: unsigned(1 to 4);
    variable uns6: unsigned(2 to 7);
    variable uns8: unsigned(0 to 7);
    variable uns10,ures10:unsigned(1 to 10);


  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
--  ************************************************
--  ************************************************
-- A15_38 tests from Kingsley ::::::
      if run("A_15 tests") then
        for i in 0 to 63 loop
          uns6:=to_unsigned(i,6);
          for j in 0 to 15 loop
            uns4:=to_unsigned(j,4);
            uns10:=uns6*uns4;    -- A.15
            assert to_integer(uns10)=i*j  report "A.15 fails 6x4"
              severity FAILURE;
            assert uns4*uns6=uns10        report "A.15 fails 4x6"
              severity FAILURE;
          end loop;
        end loop;
      elsif run("A_16 tests") then
        for i in -32 to 31 loop
          sgn6:=to_signed(i,6);
          for j in -8 to 7 loop
            sgn4:=to_signed(j,4);
            res10:=sgn6*sgn4;    -- A.16
            assert to_integer(res10)=i*j  report "A.16 fails 6x4"
              severity FAILURE;
            assert sgn4*sgn6=res10        report "A.16 fails 4x6"
              severity FAILURE;
          end loop;
        end loop;
      elsif run("A_17 and A_18 tests") then
        for i in 0 to 15 loop
          uns4:=to_unsigned(i,4);
          assert (i/=8 or uns4="1000") and (i/=9 or uns4="1001")
            and (i/=15 or uns4="1111") and (i/=0 or uns4="0000")
            and (i/=3 or uns4="0011") and (i/=7 or uns4="0111")
            and (to_integer(uns4)=i) severity failure;
          for j in 0 to 15 loop
            -- exaustively test 4x4 case
            uns8:=j*uns4;         -- A.18
            assert to_integer(uns8)=(i*j) report "A.18 fails"
              severity FAILURE;
            uns8:=uns4*j;         -- A.17
            assert to_integer(uns8)=(i*j) report "A.17 fails"
              severity FAILURE;
          end loop;
        -- uns8:=19*uns4;		-- A.18; may note overflow of conversion
        -- assert to_integer(uns8)=(3*i)  report "A.18 fails" severity FAILURE;
        -- uns8:=uns4*21;		-- A.17; may note overflow of conversion
        -- assert to_integer(uns8)=(5*i)  report "A.17 fails" severity FAILURE;
        end loop;
      elsif run("A_19 and A_20 tests") then
        for i in -8 to 7 loop
          sgn4:=to_signed(i,4);
          assert (i/=-8 or sgn4="1000") and (i/=-7 or sgn4="1001")
            and (i/=-1 or sgn4="1111") and (i/=0 or sgn4="0000")
            and (i/=3 or sgn4="0011") and (i/=7 or sgn4="0111")
            and (to_integer(sgn4)=i) severity failure;
          for j in -8 to 7 loop
            -- exaustively test 4x4 case
            res8:=j*sgn4;         -- A.20
            assert to_integer(res8)=(i*j) report "A.20 fails"
              severity FAILURE;
            res8:=sgn4*j;         -- A.19
            assert to_integer(res8)=(i*j) report "A.19 fails"
              severity FAILURE;
          end loop;
        -- res8:=19*sgn4;		-- A.20; may note overflow of conversion
        -- assert to_integer(res8)=(3*i)  report "A.20 fails" severity FAILURE;
        -- res8:=sgn4*21;		-- A.21; may note overflow of conversion
        -- assert to_integer(res8)=(5*i)  report "A.19 fails" severity FAILURE;
        end loop;
      elsif run("A_21, A_23, and A_24 tests") then
        for i in 0 to 1023 loop
          uns10:=to_unsigned(i,10);
          for j in 1 to 15 loop
            uns4:=to_unsigned(j,4);
            ures10:=uns10/uns4;
            assert to_integer(ures10)=i/j report "A.21 fails"
              severity FAILURE;
            ures10:=uns10/j;
            assert to_integer(ures10)=i/j report "A.23 fails"
              severity FAILURE;
            ures10:=i/("000000"&uns4);
            assert to_integer(ures10)=i/j report "A.24 fails"
              severity FAILURE;
          end loop;
        end loop;
        -- These examples test interesting parts of other division algorithms.
        -- They are not particularly targeted to the division algorithm in the
        -- numeric packages.
        -- (These are two examples of the pentium's FDIV bug.)
        assert (to_unsigned(5505001,23)&"0000000000000000")/to_unsigned(294911,19)
          ="100101010101010101001"  -- =(5505001*65536/294911)
          report "A.21 fails ex.1"
          severity FAILURE;
        assert (to_unsigned(4195835,23)&"0000000000000000")/to_unsigned(3145727,22)
          ="10101010101110101"      -- =(4195835*65536/3145727);
          report "A.21 fails ex.2"
          severity FAILURE;
        -- These examples exercise interesting parts of Knuth's Algorithm D, in
        -- Seminumerical Algorithms, section 4.3.2, when B is 256.
        assert (to_unsigned(112893473,28)/to_unsigned(19607,16))=to_unsigned(5757,16)
          report "A.21 fails ex.3"
          severity FAILURE;
        assert (to_unsigned(96419675,28)/to_unsigned(34257,16))=to_unsigned(2814,12)
          report "A.21 fails ex.4"
          severity FAILURE;
        assert (to_unsigned(244699666,28)/to_unsigned(59746,16))=to_unsigned(4095,13)
          report "A.21 fails ex.5"
          severity FAILURE;
      elsif run("A_22, A_25 and A_26 tests") then
        for i in -512 to 511 loop
          sgn10:=to_signed(i,10);
          for j in -8 to 7 loop
            next when j=0;
            sgn4:=to_signed(j,4);
            res10:=sgn10/sgn4;
            -- the exception is because -512 overflows when it is negated.
            assert to_integer(res10)=i/j or (i=-512 and j=-1 and res10=-512)
              report "A.22 fails" severity failure;
            res10:=sgn10/j;
            assert to_integer(res10)=i/j or (i=-512 and j=-1 and res10=-512)
              report "A.25 fails" severity FAILURE;
            res10:=i/resize(sgn4,10);
            assert to_integer(res10)=i/j or (i=-512 and j=-1 and res10=-512)
              report "A.26 fails" severity FAILURE;
          end loop;
        end loop;
        -- (These are two examples of the pentium's FDIV bug.)
        assert (to_signed(5505001,24)&"0000000000000000")/to_signed(294911,20)
          ="0100101010101010101001"  -- =(5505001*65536/294911)
          report "A.22 fails p1" severity FAILURE;
        assert (to_signed(-4195835,24)&"0000000000000000")/to_signed(3145727,23)
          ="11101010101010001011"    -- =(4195835*65536/3145727);
          report "A.22 fails p2" severity FAILURE;
      elsif run("A_27, A_29 and A_30 tests") then
        for i in 0 to 1023 loop
          uns10:=to_unsigned(i,10);
          for j in 1 to 15 loop
            uns4:=to_unsigned(j,4);
            ures4:=uns10 rem uns4;
            assert to_integer(ures4)=i rem j report "A.27 fails" severity FAILURE;
            ures10:=uns10 rem j;
            assert to_integer(ures10)=i rem j report "A.29 fails" severity FAILURE;
            ures10:=i rem ("000000"&uns4);
            assert to_integer(ures10)=i rem j report "A.30 fails" severity FAILURE;
          end loop;
        end loop;
      elsif run("A_28, A_31 and A_32 tests") then
        for i in -512 to 511 loop
          sgn10:=to_signed(i,10);
          for j in -8 to 7 loop
            next when j=0;
            sgn4:=to_signed(j,4);
            res10:=resize((sgn10 rem sgn4),res10'length);
            assert to_integer(res10)=i rem j report "A.28 fails" severity FAILURE;
            res10:=sgn10 rem j;
            assert to_integer(res10)=i rem j report "A.31 fails" severity FAILURE;
            res10:=i rem resize(sgn4,10);
            assert to_integer(res10)=i rem j report "A.32 fails" severity FAILURE;
          end loop;
        end loop;
      elsif run("A_33, A_35 and A_36 tests") then
        for i in 0 to 1023 loop
          uns10:=to_unsigned(i,10);
          for j in 1 to 15 loop
            uns4:=to_unsigned(j,4);
            ures10:=resize((uns10 mod uns4),ures10'length);
            assert to_integer(ures10)=i mod j report "A.33 fails" severity FAILURE;
            ures10:=uns10 mod j;
            assert to_integer(ures10)=i mod j report "A.35 fails" severity FAILURE;
            ures10:=i mod ("000000"&uns4);
            assert to_integer(ures10)=i mod j report "A.36 fails" severity FAILURE;
          end loop;
        end loop;
      elsif run("A_34, A_37 and A_38 tests") then
        for i in -512 to 511 loop
          sgn10:=to_signed(i,10);
          for j in -8 to 7 loop
            next when j=0;
            sgn4:=to_signed(j,4);
            res10:=resize((sgn10 mod sgn4),res10'length);
            assert to_integer(res10)=i mod j report "A.34 fails" severity FAILURE;
            res10:=sgn10 mod j;
            assert to_integer(res10)=i mod j report "A.37 fails" severity FAILURE;
            res10:=i mod resize(sgn4,10);
            assert to_integer(res10)=i mod j report "A.38 fails" severity FAILURE;
          end loop;
        end loop;

--  ************************************************
--  ************************************************
-- C13_24 tests from Bhasker ::::::
      elsif run("BIT_C_13 tests") then
        assert UNSIGNED'("0001") <= UNSIGNED'("0010")
                                    report "Test BIT_C.13.1 failing."
                                    severity FAILURE;
        assert UNSIGNED'("01") <= UNSIGNED'("1010")
                                  report "Test BIT_C.13.2 failing."
                                  severity FAILURE;
        assert UNSIGNED'("000001") <= UNSIGNED'("111")
                                      report "Test BIT_C.13.3 failing."
                                      severity FAILURE;

        assert UNSIGNED'("010") <= UNSIGNED'("010")
                                   report "Test BIT_C.13.5 failing."
                                   severity FAILURE;
        assert UNSIGNED'("00010010") <= UNSIGNED'("10010")
                                        report "Test BIT_C.13.8 failing."
                                        severity FAILURE;
        assert UNSIGNED'("10") <= UNSIGNED'("0010")
                                  report "Test BIT_C.13.9 failing."
                                  severity FAILURE;

        assert not (UNSIGNED'("110001") <= UNSIGNED'("100010"))
          report "Test BIT_C.13.4 failing."
          severity FAILURE;
        assert not(UNSIGNED'("1111") <= UNSIGNED'("0001010"))
          report "Test BIT_C.13.6 test failing."
          severity FAILURE;
        assert not(UNSIGNED'("10001000") <= UNSIGNED'("11"))
          report "Test BIT_C.13.7 test failing."
          severity FAILURE;

        assert not(UNSIGNED'("110") <= UNSIGNED'("011"))
          report "Test BIT_C.13.10 failing."
          severity FAILURE;
        assert not(UNSIGNED'("10010010") <= UNSIGNED'("10010"))
          report "Test BIT_C.13.11 failing."
          severity FAILURE;
      elsif run("Expected to warn: BIT_C_13 warning on null 1") then
        assert not ( UNSIGNED'("110") <= BNULL)
          report "Test BIT_C.13.13 failing."
          severity FAILURE;
      elsif run("Expected to warn: BIT_C_13 warning on null 2") then
        assert not (BNULL <= ANULL)
          report "Test BIT_C.13.14 failing."
          severity FAILURE;
      elsif run("BIT_C_14 tests") then
        assert SIGNED'("0001") <= SIGNED'("0010")
                                  report "Test BIT_C.14.1 failing."
                                  severity FAILURE;
        assert SIGNED'("01") <= SIGNED'("01010")
                                report "Test BIT_C.14.2 failing."
                                severity FAILURE;
        assert SIGNED'("000001") <= SIGNED'("0111")
                                    report "Test BIT_C.14.3 failing."
                                    severity FAILURE;
        assert SIGNED'("111100") <= SIGNED'("11100")
                                    report "Test BIT_C.14.15 failing."
                                    severity FAILURE;
        assert SIGNED'("111100") <= SIGNED'("011100")
                                    report "Test BIT_C.14.16 failing."
                                    severity FAILURE;

        assert SIGNED'("010") <= SIGNED'("010")
                                 report "Test BIT_C.14.5 failing."
                                 severity FAILURE;
        assert SIGNED'("10000010") <= SIGNED'("111110010")
                                      report "Test BIT_C.14.8 failing."
                                      severity FAILURE;
        assert SIGNED'("10") <= SIGNED'("0010")
                                report "Test BIT_C.14.9 failing."
                                severity FAILURE;
        assert SIGNED'("00") <= SIGNED'("0000")
                                report "Test BIT_C.14.17 failing."
                                severity FAILURE;
        assert SIGNED'("11100001100") <= SIGNED'("0000")
                                         report "Test BIT_C.14.18 failing."
                                         severity FAILURE;

        assert not (SIGNED'("110001") <= SIGNED'("100010"))
          report "Test BIT_C.14.4 failing."
          severity FAILURE;
        assert not(SIGNED'("1111") <= SIGNED'("1001010"))
          report "Test BIT_C.14.6 test failing."
          severity FAILURE;
        assert not(SIGNED'("11") <= SIGNED'("10001000"))
          report "Test BIT_C.14.7 test failing."
          severity FAILURE;
        assert not(SIGNED'("0110") <= SIGNED'("10001000"))
          report "Test BIT_C.14.19 test failing."
          severity FAILURE;

        assert not(SIGNED'("010") <= SIGNED'("110"))
          report "Test BIT_C.14.10 failing."
          severity FAILURE;
        assert not(SIGNED'("1001") <= SIGNED'("100100010"))
          report "Test BIT_C.14.11 failing."
          severity FAILURE;
        assert not(SIGNED'("110") <= SIGNED'("10010"))
          report "Test BIT_C.14.12 failing."
          severity FAILURE;
        assert not(SIGNED'("00000110") <= SIGNED'("0000"))
          report "Test BIT_C.14.20 failing."
          severity FAILURE;
      elsif run("Expected to warn: BIT_C_14 tests with warning") then
        assert not (SBNULL <= SANULL)
          report "Test BIT_C.14.14 failing."
          severity FAILURE;
      elsif run("BIT_C_17 tests") then
        assert UNSIGNED'("0001") <= 2
                                    report "Test BIT_C.17.1 failing."
                                    severity FAILURE;
        assert UNSIGNED'("01") <= 10
                                  report "Test BIT_C.17.2 failing."
                                  severity FAILURE;
        assert UNSIGNED'("000001") <= 7
                                      report "Test BIT_C.17.3 failing."
                                      severity FAILURE;

        assert UNSIGNED'("010") <= 2
                                   report "Test BIT_C.17.5 failing."
                                   severity FAILURE;
        assert UNSIGNED'("00010010") <= 18
                                        report "Test BIT_C.17.8 failing."
                                        severity FAILURE;
        assert UNSIGNED'("10") <= 2
                                  report "Test BIT_C.17.9 failing."
                                  severity FAILURE;

        assert not (UNSIGNED'("110001") <= 34)
          report "Test BIT_C.17.4 failing."
          severity FAILURE;
        assert not(UNSIGNED'("1111") <= 10)
          report "Test BIT_C.17.6 test failing."
          severity FAILURE;
        assert not(UNSIGNED'("10001000") <= 3)
          report "Test BIT_C.17.7 test failing."
          severity FAILURE;

        assert not(UNSIGNED'("110") <= 3)
          report "Test BIT_C.17.10 failing."
          severity FAILURE;
        assert not(UNSIGNED'("10010010") <= 18)
          report "Test BIT_C.17.11 failing."
          severity FAILURE;
        assert not(UNSIGNED'("110") <= 2)
          report "Test BIT_C.17.12 failing."
          severity FAILURE;

      elsif run("Expected to warn: BIT_C_17 tests with warning") then
        assert not ( BNULL <= 0)
          report "Test BIT_C.17.14 failing."
          severity FAILURE;
      elsif run("BIT_C_18 tests") then
        assert SIGNED'("0001") <= 2
                                  report "Test BIT_C.18.1 failing."
                                  severity FAILURE;
        assert SIGNED'("01") <= 10
                                report "Test BIT_C.18.2 failing."
                                severity FAILURE;
        assert SIGNED'("100001") <= 7
                                    report "Test BIT_C.18.3 failing."
                                    severity FAILURE;
        assert SIGNED'("111100") <= -4
                                    report "Test BIT_C.18.15 failing."
                                    severity FAILURE;
        assert SIGNED'("111100") <= 28
                                    report "Test BIT_C.18.16 failing."
                                    severity FAILURE;

        assert SIGNED'("010") <= 2
                                 report "Test BIT_C.18.5 failing."
                                 severity FAILURE;
        assert SIGNED'("10") <= 2
                                report "Test BIT_C.18.9 failing."
                                severity FAILURE;
        assert SIGNED'("00") <= 0
                                report "Test BIT_C.18.17 failing."
                                severity FAILURE;
        assert SIGNED'("11100001100") <= -0
                                         report "Test BIT_C.18.18 failing."
                                         severity FAILURE;

        assert not (SIGNED'("110001") <= -30)
          report "Test BIT_C.18.4 failing."
          severity FAILURE;
        assert not(SIGNED'("01111") <= +10)
          report "Test BIT_C.18.6 test failing."
          severity FAILURE;
        assert not(SIGNED'("1100") <= -9)
          report "Test BIT_C.18.7 test failing."
          severity FAILURE;

        assert not(SIGNED'("0110") <= 3)
          report "Test BIT_C.18.10 failing."
          severity FAILURE;
        assert not(SIGNED'("110") <= -15)
          report "Test BIT_C.18.11 failing."
          severity FAILURE;
        assert not(SIGNED'("0110") <= 2)
          report "Test BIT_C.18.12 failing."
          severity FAILURE;
        assert not(SIGNED'("00000110") <= 0)
          report "Test BIT_C.18.20 failing."
          severity FAILURE;

        assert not (SIGNED'("0110") <= 0)
          report "Test BIT_C.18.13 failing."
          severity FAILURE;
        assert not (SIGNED'("110") <= -1000000)
          report "Test BIT_C.18.14 failing."
          severity FAILURE;
      elsif run("BIT_C_15 tests") then
        assert 1 <= UNSIGNED'("0010")
                    report "Test BIT_C.15.1 failing."
                    severity FAILURE;
        assert 1 <= UNSIGNED'("111")
                    report "Test BIT_C.15.3 failing."
                    severity FAILURE;

        assert 2 <= UNSIGNED'("010")
                    report "Test BIT_C.15.5 failing."
                    severity FAILURE;
        assert 18 <= UNSIGNED'("10010")
                     report "Test BIT_C.15.8 failing."
                     severity FAILURE;
        assert 2 <= UNSIGNED'("0010")
                    report "Test BIT_C.15.9 failing."
                    severity FAILURE;

        assert not (49 <= UNSIGNED'("100010"))
          report "Test BIT_C.15.4 failing."
          severity FAILURE;
        assert not(15 <= UNSIGNED'("0001010"))
          report "Test BIT_C.15.6 test failing."
          severity FAILURE;
        assert not(151 <= UNSIGNED'("11"))
          report "Test BIT_C.15.7 test failing."
          severity FAILURE;

        assert not(256 <= UNSIGNED'("10010"))
          report "Test BIT_C.15.11 failing."
          severity FAILURE;
        assert not(6 <= UNSIGNED'("0010"))
          report "Test BIT_C.15.12 failing."
          severity FAILURE;

        assert not (3267 <= UNSIGNED'("111"))
          report "Test BIT_C.15.14 failing."
          severity FAILURE;
      elsif run("Expected to warn: BIT_C_15 tests with warning") then
        assert not (8 <= BNULL)
          report "Test BIT_C.15.13 failing."
          severity FAILURE;
      elsif run("BIT_C_16 tests") then
        assert 1 <= SIGNED'("0010")
                    report "Test BIT_C.16.1 failing."
                    severity FAILURE;
        assert 1 <= SIGNED'("0111")
                    report "Test BIT_C.16.3 failing."
                    severity FAILURE;
        assert -4 <= SIGNED'("11100")
                     report "Test BIT_C.16.15 failing."
                     severity FAILURE;
        assert -4 <= SIGNED'("011100")
                     report "Test BIT_C.16.16 failing."
                     severity FAILURE;

        assert 2 <= SIGNED'("010")
                    report "Test BIT_C.16.5 failing."
                    severity FAILURE;
        assert -14 <= SIGNED'("10010")
                      report "Test BIT_C.16.8 failing."
                      severity FAILURE;
        assert -2 <= SIGNED'("0010")
                     report "Test BIT_C.16.9 failing."
                     severity FAILURE;
        assert 0 <= SIGNED'("0000")
                    report "Test BIT_C.16.17 failing."
                    severity FAILURE;
        assert -2048 <= SIGNED'("0000")
                        report "Test BIT_C.16.18 failing."
                        severity FAILURE;

        assert not (-15 <= SIGNED'("100010"))
          report "Test BIT_C.16.4 failing."
          severity FAILURE;
        assert not(1 <= SIGNED'("10001010"))
          report "Test BIT_C.16.6 test failing."
          severity FAILURE;
        assert not(-1024 <= SIGNED'("1000000111111"))
          report "Test BIT_C.16.19 test failing."
          severity FAILURE;

        assert not(-2 <= SIGNED'("1000011"))
          report "Test BIT_C.16.10 failing."
          severity FAILURE;
        assert not(-63 <= SIGNED'("10000010"))
          report "Test BIT_C.16.11 failing."
          severity FAILURE;
        assert not(0 <= SIGNED'("1000"))
          report "Test BIT_C.16.20 failing."
          severity FAILURE;

        assert not (-6457 <= SIGNED'("100000000000000010"))
          report "Test BIT_C.16.14 failing."
          severity FAILURE;
      elsif run("Expected to warn: BIT_C_16 tests with warning") then
        assert not (-7 <= SBNULL)
          report "Test BIT_C.16.13 failing."
          severity FAILURE;
      elsif run("BIT_C_19 tests") then
        assert UNSIGNED'("1010") >= UNSIGNED'("01")
          report "Test BIT_C.19.2 failing."
          severity FAILURE;

        assert UNSIGNED'("010") >= UNSIGNED'("010")
          report "Test BIT_C.19.5 failing."
          severity FAILURE;
        assert UNSIGNED'("10010") >= UNSIGNED'("00010010")
          report "Test BIT_C.19.8 failing."
          severity FAILURE;

        assert not (UNSIGNED'("100010") >= UNSIGNED'("110001"))
          report "Test BIT_C.19.4 failing."
          severity FAILURE;
        assert not(UNSIGNED'("0001010") >= UNSIGNED'("1111"))
          report "Test BIT_C.19.6 test failing."
          severity FAILURE;
        assert not(UNSIGNED'("11") >= UNSIGNED'("10001000"))
          report "Test BIT_C.19.7 test failing."
          severity FAILURE;

        assert not(UNSIGNED'("011") >= UNSIGNED'("110"))
          report "Test BIT_C.19.10 failing."
          severity FAILURE;
        assert not(UNSIGNED'("10010") >= UNSIGNED'("10010010"))
          report "Test BIT_C.19.11 failing."
          severity FAILURE;
        assert not(UNSIGNED'("0010") >= UNSIGNED'("110"))
          report "Test BIT_C.19.12 failing."
          severity FAILURE;

      elsif run("Expected to warn: BIT_C_19 tests with warning 1") then
        assert not (BNULL >= UNSIGNED'("110"))
          report "Test BIT_C.19.13 failing."
          severity FAILURE;
      elsif run("Expected to warn: BIT_C_19 tests with warning 2") then
        assert not (ANULL >= BNULL)
          report "Test BIT_C.19.14 failing."
          severity FAILURE;
      elsif run("BIT_C_20 tests") then
        assert SIGNED'("0010") >= SIGNED'("0001")
          report "Test BIT_C.20.1 failing."
          severity FAILURE;
        assert SIGNED'("01010") >= SIGNED'("01")
          report "Test BIT_C.20.2 failing."
          severity FAILURE;
        assert SIGNED'("0111") >= SIGNED'("000001")
          report "Test BIT_C.20.3 failing."
          severity FAILURE;
        assert SIGNED'("011100") >= SIGNED'("111100")
          report "Test BIT_C.20.16 failing."
          severity FAILURE;

        assert SIGNED'("010") >= SIGNED'("010")
          report "Test BIT_C.20.5 failing."
          severity FAILURE;
        assert SIGNED'("111110010") >= SIGNED'("10000010")
          report "Test BIT_C.20.8 failing."
          severity FAILURE;
        assert SIGNED'("0010") >= SIGNED'("10")
          report "Test BIT_C.20.9 failing."
          severity FAILURE;
        assert SIGNED'("0000") >= SIGNED'("00")
          report "Test BIT_C.20.17 failing."
          severity FAILURE;
        assert SIGNED'("0000") >= SIGNED'("11100001100")
          report "Test BIT_C.20.18 failing."
          severity FAILURE;

        assert not (SIGNED'("100010") >= SIGNED'("110001"))
          report "Test BIT_C.20.4 failing."
          severity FAILURE;
        assert not(SIGNED'("1001010") >= SIGNED'("1111"))
          report "Test BIT_C.20.6 test failing."
          severity FAILURE;
        assert not(SIGNED'("10001000") >= SIGNED'("11"))
          report "Test BIT_C.20.7 test failing."
          severity FAILURE;

        assert not(SIGNED'("110") >= SIGNED'("010"))
          report "Test BIT_C.20.10 failing."
          severity FAILURE;
        assert not(SIGNED'("100100010") >= SIGNED'("1001"))
          report "Test BIT_C.20.11 failing."
          severity FAILURE;
        assert not(SIGNED'("10010") >= SIGNED'("110"))
          report "Test BIT_C.20.12 failing."
          severity FAILURE;
        assert not(SIGNED'("0000") >= SIGNED'("00000110"))
          report "Test BIT_C.20.20 failing."
          severity FAILURE;

      elsif run("Expected to warn: BIT_C_20 tests with warning 1") then
        assert not (SBNULL >= SIGNED'("110"))
          report "Test BIT_C.20.13 failing."
          severity FAILURE;
      elsif run("Expected to warn: BIT_C_20 tests with warning 2") then
        assert not (SANULL >= SBNULL)
          report "Test BIT_C.20.14 failing."
          severity FAILURE;
      elsif run("BIT_C_21 tests") then
        assert 2 >= UNSIGNED'("0001")
          report "Test BIT_C.21.1 failing."
          severity FAILURE;
        assert 10 >= UNSIGNED'("01")
          report "Test BIT_C.21.2 failing."
          severity FAILURE;
        assert 7 >= UNSIGNED'("000001")
          report "Test BIT_C.21.3 failing."
          severity FAILURE;

        assert 2 >= UNSIGNED'("010")
          report "Test BIT_C.21.5 failing."
          severity FAILURE;
        assert 18 >= UNSIGNED'("00010010")
          report "Test BIT_C.21.8 failing."
          severity FAILURE;

        assert not (34 >= UNSIGNED'("110001"))
          report "Test BIT_C.21.4 failing."
          severity FAILURE;
        assert not(10 >= UNSIGNED'("1111"))
          report "Test BIT_C.21.6 test failing."
          severity FAILURE;
        assert not(3 >= UNSIGNED'("10001000"))
          report "Test BIT_C.21.7 test failing."
          severity FAILURE;

        assert not(3 >= UNSIGNED'("110"))
          report "Test BIT_C.21.10 failing."
          severity FAILURE;
        assert not(18 >= UNSIGNED'("10010010"))
          report "Test BIT_C.21.11 failing."
          severity FAILURE;
        assert not(2 >= UNSIGNED'("110"))
          report "Test BIT_C.21.12 failing."
          severity FAILURE;

        assert (10000 >= UNSIGNED'("110"))
          report "Test BIT_C.21.13 failing."
          severity FAILURE;
      elsif run("Expected to warn: BIT_C_21 tests with warning") then
        assert not ( 0 >= BNULL)
          report "Test BIT_C.21.14 failing."
          severity FAILURE;
      elsif run("BIT_C_22 tests") then
        assert 10 >= SIGNED'("01")
          report "Test BIT_C.22.2 failing."
          severity FAILURE;
        assert 7 >= SIGNED'("100001")
          report "Test BIT_C.22.3 failing."
          severity FAILURE;
        assert -4 >= SIGNED'("111100")
          report "Test BIT_C.22.15 failing."
          severity FAILURE;
        assert 28 >= SIGNED'("111100")
          report "Test BIT_C.22.16 failing."
          severity FAILURE;

        assert 2 >= SIGNED'("010")
          report "Test BIT_C.22.5 failing."
          severity FAILURE;
        assert -14 >= SIGNED'("100010010")
          report "Test BIT_C.22.8 failing."
          severity FAILURE;
        assert 2 >= SIGNED'("10")
          report "Test BIT_C.22.9 failing."
          severity FAILURE;
        assert 0 >= SIGNED'("00")
          report "Test BIT_C.22.17 failing."
          severity FAILURE;
        assert -0 >= SIGNED'("11100001100")
          report "Test BIT_C.22.18 failing."
          severity FAILURE;

        assert not (-30 >= SIGNED'("110001"))
          report "Test BIT_C.22.4 failing."
          severity FAILURE;
        assert not(+10 >= SIGNED'("01111"))
          report "Test BIT_C.22.6 test failing."
          severity FAILURE;
        assert not(-9 >= SIGNED'("1100"))
          report "Test BIT_C.22.7 test failing."
          severity FAILURE;
        assert not(3 >= SIGNED'("010001000"))
          report "Test BIT_C.22.19 test failing."
          severity FAILURE;

        assert not(-15 >= SIGNED'("110"))
          report "Test BIT_C.22.11 failing."
          severity FAILURE;
        assert not(2 >= SIGNED'("0110"))
          report "Test BIT_C.22.12 failing."
          severity FAILURE;
        assert not(0 >= SIGNED'("00000110"))
          report "Test BIT_C.22.20 failing."
          severity FAILURE;

        assert not (0 >= SIGNED'("0110"))
          report "Test BIT_C.22.13 failing."
          severity FAILURE;
        assert not (-1000000 >= SIGNED'("110"))
          report "Test BIT_C.22.14 failing."
          severity FAILURE;
      elsif run("BIT_C_23 tests") then
        assert UNSIGNED'("0010") >= 1
          report "Test BIT_C.23.1 failing."
          severity FAILURE;
        assert UNSIGNED'("1010") >= 1
          report "Test BIT_C.23.2 failing."
          severity FAILURE;
        assert UNSIGNED'("111") >= 1
          report "Test BIT_C.23.3 failing."
          severity FAILURE;

        assert UNSIGNED'("010") >= 2
          report "Test BIT_C.23.5 failing."
          severity FAILURE;
        assert UNSIGNED'("10010") >= 18
          report "Test BIT_C.23.8 failing."
          severity FAILURE;
        assert UNSIGNED'("0010") >= 2
          report "Test BIT_C.23.9 failing."
          severity FAILURE;

        assert not (UNSIGNED'("100010") >= 49)
          report "Test BIT_C.23.4 failing."
          severity FAILURE;
        assert not(UNSIGNED'("0001010") >= 15)
          report "Test BIT_C.23.6 test failing."
          severity FAILURE;
        assert not(UNSIGNED'("11") >= 151)
          report "Test BIT_C.23.7 test failing."
          severity FAILURE;

        assert not(UNSIGNED'("10010") >= 256)
          report "Test BIT_C.23.11 failing."
          severity FAILURE;
        assert not(UNSIGNED'("0010") >= 6)
          report "Test BIT_C.23.12 failing."
          severity FAILURE;

        assert not (UNSIGNED'("111") >= 3267)
          report "Test BIT_C.23.14 failing."
          severity FAILURE;
      elsif run("Expected to warn: BIT_C_23 tests with warning") then
        assert not (BNULL >= 8)
          report "Test BIT_C.23.13 failing."
          severity FAILURE;
      elsif run("BIT_C_24 tests") then
        assert SIGNED'("0010") >= 1
          report "Test BIT_C.24.1 failing."
          severity FAILURE;
        assert SIGNED'("01010") >= 8
          report "Test BIT_C.24.2 failing."
          severity FAILURE;
        assert SIGNED'("0111") >= 1
          report "Test BIT_C.24.3 failing."
          severity FAILURE;
        assert SIGNED'("011100") >= -4
          report "Test BIT_C.24.16 failing."
          severity FAILURE;

        assert SIGNED'("010") >= 2
          report "Test BIT_C.24.5 failing."
          severity FAILURE;
        assert SIGNED'("10010") >= -14
          report "Test BIT_C.24.8 failing."
          severity FAILURE;
        assert SIGNED'("0010") >= -2
          report "Test BIT_C.24.9 failing."
          severity FAILURE;
        assert SIGNED'("0000") >= 0
          report "Test BIT_C.24.17 failing."
          severity FAILURE;
        assert SIGNED'("0000") >= -2048
          report "Test BIT_C.24.18 failing."
          severity FAILURE;

        assert not(SIGNED'("10001010") >= 1)
          report "Test BIT_C.24.6 test failing."
          severity FAILURE;
        assert not(SIGNED'("10011100111") >= -345)
          report "Test BIT_C.24.7 test failing."
          severity FAILURE;
        assert not(SIGNED'("1000000111111") >= -1024)
          report "Test BIT_C.24.19 test failing."
          severity FAILURE;

        assert not(SIGNED'("1000011") >= -2)
          report "Test BIT_C.24.10 failing."
          severity FAILURE;
        assert not(SIGNED'("10000010") >= -63)
          report "Test BIT_C.24.11 failing."
          severity FAILURE;
        assert not(SIGNED'("1000") >= 0)
          report "Test BIT_C.24.20 failing."
          severity FAILURE;

      elsif run("Expected to warn: BIT_C_24 tests with warning") then
        assert not (SBNULL >= -7)
          report "Test BIT_C.24.13 failing."
          severity FAILURE;

--  ************************************************
--  ************************************************
-- r.1, r.2 tests from Bob Flatt ::::::
      elsif run("r_1 tests") then
        assert RESIZE(SIGNED'("0001") , 0)'length = 0
          report "Test r.1.1 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("0001") , 1) = "0"
          report "Test r.1.2 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("0001") , 2) = "01"
          report "Test r.1.3 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("0001") , 3) = "001"
          report "Test r.1.4 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("0001") , 4) = "0001"
          report "Test r.1.5 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("0001") , 5) = "00001"
          report "Test r.1.6 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("0001") , 6) = "000001"
          report "Test r.1.7 failing."
          severity FAILURE;

        assert RESIZE(SIGNED'("1001") , 1) = "1"
          report "Test r.1.8 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("1001") , 2) = "11"
          report "Test r.1.9 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("1001") , 3) = "101"
          report "Test r.1.10 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("1001") , 4) = "1001"
          report "Test r.1.11 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("1001") , 5) = "11001"
          report "Test r.1.12 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("1001") , 6) = "111001"
          report "Test r.1.13 failing."
          severity FAILURE;

        assert RESIZE(SIGNED'("0101") , 1) = "0"
          report "Test r.1.14 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("0101") , 2) = "01"
          report "Test r.1.15 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("0101") , 3) = "001"
          report "Test r.1.16 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("0101") , 4) = "0101"
          report "Test r.1.17 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("0101") , 5) = "00101"
          report "Test r.1.18 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("0101") , 6) = "000101"
          report "Test r.1.19 failing."
          severity FAILURE;

        assert RESIZE(SANULL , 0)'length = 0
          report "Test r.1.20 failing."
          severity FAILURE;
        assert RESIZE(SANULL , 1) = "0"
          report "Test r.1.21 failing."
          severity FAILURE;
        assert RESIZE(SANULL , 2) = "00"
          report "Test r.1.22 failing."
          severity FAILURE;

        assert RESIZE(SIGNED'("0") , 0)'length = 0
          report "Test r.1.23 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("0") , 1) = "0"
          report "Test r.1.24 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("0") , 2) = "00"
          report "Test r.1.25 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("1") , 1) = "1"
          report "Test r.1.26 failing."
          severity FAILURE;
        assert RESIZE(SIGNED'("1") , 2) = "11"
          report "Test r.1.27 failing."
          severity FAILURE;
      elsif run("r_2 tests") then
        assert RESIZE(UNSIGNED'("0001") , 0)'length = 0
          report "Test r.2.1 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("0001") , 1) = "1"
          report "Test r.2.2 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("0001") , 2) = "01"
          report "Test r.2.3 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("0001") , 3) = "001"
          report "Test r.2.4 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("0001") , 4) = "0001"
          report "Test r.2.5 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("0001") , 5) = "00001"
          report "Test r.2.6 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("0001") , 6) = "000001"
          report "Test r.2.7 failing."
          severity FAILURE;

        assert RESIZE(UNSIGNED'("1001") , 1) = "1"
          report "Test r.2.8 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("1001") , 2) = "01"
          report "Test r.2.9 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("1001") , 3) = "001"
          report "Test r.2.10 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("1001") , 4) = "1001"
          report "Test r.2.11 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("1001") , 5) = "01001"
          report "Test r.2.12 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("1001") , 6) = "001001"
          report "Test r.2.13 failing."
          severity FAILURE;

        assert RESIZE(UNSIGNED'("0101") , 1) = "1"
          report "Test r.2.14 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("0101") , 2) = "01"
          report "Test r.2.15 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("0101") , 3) = "101"
          report "Test r.2.16 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("0101") , 4) = "0101"
          report "Test r.2.17 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("0101") , 5) = "00101"
          report "Test r.2.18 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("0101") , 6) = "000101"
          report "Test r.2.19 failing."
          severity FAILURE;

        assert RESIZE(ANULL , 0)'length = 0
          report "Test r.2.20 failing."
          severity FAILURE;
        assert RESIZE(ANULL , 1) = "0"
          report "Test r.2.21 failing."
          severity FAILURE;
        assert RESIZE(ANULL , 2) = "00"
          report "Test r.2.22 failing."
          severity FAILURE;

        assert RESIZE(UNSIGNED'("0") , 0)'length = 0
          report "Test r.2.23 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("0") , 1) = "0"
          report "Test r.2.24 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("0") , 2) = "00"
          report "Test r.2.25 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("1") , 1) = "1"
          report "Test r.2.26 failing."
          severity FAILURE;
        assert RESIZE(UNSIGNED'("1") , 2) = "01"
          report "Test r.2.27 failing."
          severity FAILURE;
      end if;
    end loop;

    test_runner_cleanup(runner);
    wait;
  end process;
end architecture t1;