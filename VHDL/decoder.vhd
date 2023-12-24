LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY decoder IS
    PORT (
        input_num : IN INTEGER RANGE 0 TO 59;
        seg1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        seg2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END decoder;

ARCHITECTURE Behavioral OF decoder IS
    SIGNAL temp_num : INTEGER RANGE 0 TO 59 := 0;
    SIGNAL digit1, digit2 : INTEGER RANGE 0 TO 9 := 0;
    SIGNAL seg1_out, seg2_out : STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN
    PROCESS (input_num)
    BEGIN
        temp_num <= input_num;
    END PROCESS;

    digit1 <= temp_num / 10;
    digit2 <= temp_num MOD 10;

    PROCESS (digit1, digit2)
    BEGIN
        CASE digit1 IS
            WHEN 0 => seg1_out <= "0000001"; -- Corresponding segments for digit 0
            WHEN 1 => seg1_out <= "1001111"; -- Corresponding segments for digit 1
            WHEN 2 => seg1_out <= "0010010"; -- Corresponding segments for digit 2
            WHEN 3 => seg1_out <= "0000110"; -- Corresponding segments for digit 3
            WHEN 4 => seg1_out <= "1001100"; -- Corresponding segments for digit 4
            WHEN 5 => seg1_out <= "0100100"; -- Corresponding segments for digit 5
            WHEN 6 => seg1_out <= "0100000"; -- Corresponding segments for digit 6
            WHEN 7 => seg1_out <= "0001111"; -- Corresponding segments for digit 7
            WHEN 8 => seg1_out <= "0000000"; -- Corresponding segments for digit 8
            WHEN 9 => seg1_out <= "0000100"; -- Corresponding segments for digit 9
            WHEN OTHERS => seg1_out <= "1111111"; -- All segments off for other values
        END CASE;

        CASE digit2 IS
            WHEN 0 => seg2_out <= "0000001"; -- Corresponding segments for digit 0
            WHEN 1 => seg2_out <= "1001111"; -- Corresponding segments for digit 1
            WHEN 2 => seg2_out <= "0010010"; -- Corresponding segments for digit 2
            WHEN 3 => seg2_out <= "0000110"; -- Corresponding segments for digit 3
            WHEN 4 => seg2_out <= "1001100"; -- Corresponding segments for digit 4
            WHEN 5 => seg2_out <= "0100100"; -- Corresponding segments for digit 5
            WHEN 6 => seg2_out <= "0100000"; -- Corresponding segments for digit 6
            WHEN 7 => seg2_out <= "0001111"; -- Corresponding segments for digit 7
            WHEN 8 => seg2_out <= "0000000"; -- Corresponding segments for digit 8
            WHEN 9 => seg2_out <= "0000100"; -- Corresponding segments for digit 9
            WHEN OTHERS => seg2_out <= "1111111"; -- All segments off for other values
        END CASE;
    END PROCESS;

    seg1 <= seg1_out;
    seg2 <= seg2_out;
END Behavioral;