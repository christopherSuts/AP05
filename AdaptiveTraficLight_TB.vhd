LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY AdaptiveTrafficLight_TB IS
END AdaptiveTrafficLight_TB;

ARCHITECTURE behavior OF AdaptiveTrafficLight_TB IS
    SIGNAL clk : STD_LOGIC := '0'; -- Clock signal
    SIGNAL traffic_sensor_vertical_one, traffic_sensor_vertical_two,
    traffic_sensor_horizontal_one, traffic_sensor_horizontal_two : STD_LOGIC := '0';
    SIGNAL elderly_cross_button : STD_LOGIC := '0';
    SIGNAL road_vertical, road_horizontal : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL display_vertical_one, display_vertical_two,
    display_horizontal_one, display_horizontal_two : STD_LOGIC_VECTOR(6 DOWNTO 0);
    -- Add other signals as needed for testing

    -- Component instantiation
    COMPONENT AdaptiveTrafficLight
        PORT (
            clk : IN STD_LOGIC;
            traffic_sensor_vertical_one, traffic_sensor_vertical_two,
            traffic_sensor_horizontal_one, traffic_sensor_horizontal_two : IN STD_LOGIC;
            elderly_cross_button : IN STD_LOGIC;
            road_vertical : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            road_horizontal : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            display_vertical_one, display_vertical_two,
            display_horizontal_one, display_horizontal_two : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    IMPURE FUNCTION randomize_signal RETURN STD_LOGIC IS
        VARIABLE r : real;
        VARIABLE random_int : INTEGER;
        VARIABLE seed1, seed2 : INTEGER := 999;
    BEGIN
        uniform(seed1, seed2, r);
        random_int := INTEGER(round(r * real(1 - 0 + 1) + real(0) - 0.5));
        IF random_int = 0 THEN
            RETURN '0';
        ELSE
            RETURN '1';
        END IF;
    END FUNCTION;

BEGIN
    -- Instantiate the DUT (Device Under Test)
    UUT : AdaptiveTrafficLight PORT MAP(
        clk => clk,
        traffic_sensor_vertical_one => traffic_sensor_vertical_one,
        traffic_sensor_vertical_two => traffic_sensor_vertical_two,
        traffic_sensor_horizontal_one => traffic_sensor_horizontal_one,
        traffic_sensor_horizontal_two => traffic_sensor_horizontal_two,
        elderly_cross_button => elderly_cross_button,
        road_vertical => road_vertical,
        road_horizontal => road_horizontal,
        display_vertical_one => display_vertical_one,
        display_vertical_two => display_vertical_two,
        display_horizontal_one => display_horizontal_one,
        display_horizontal_two => display_horizontal_two
    );

    -- Clock process to simulate real-time behavior
    CLK_PROCESS : PROCESS
    BEGIN
        WHILE (TRUE) LOOP
            clk <= '0';
            WAIT FOR 500 MS; -- Adjust this value to simulate real-time behavior
            clk <= '1';
            WAIT FOR 500 MS; -- Adjust this value to simulate real-time behavior
        END LOOP;
        WAIT;
    END PROCESS CLK_PROCESS;

    STIMULUS_PROCESS : PROCESS
    BEGIN

        LOOP
            -- Randomize input signals
            traffic_sensor_vertical_one <= randomize_signal;
            traffic_sensor_vertical_two <= randomize_signal;
            traffic_sensor_horizontal_one <= randomize_signal;
            traffic_sensor_horizontal_two <= randomize_signal;
            elderly_cross_button <= randomize_signal;

            -- Wait for another 10 seconds before changing inputs again
            WAIT FOR 5 SEC;
        END LOOP;
    END PROCESS STIMULUS_PROCESS;

END behavior;