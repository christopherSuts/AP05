LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY AdaptiveTrafficLight IS
    PORT (
        clk : IN STD_LOGIC;

        traffic_sensor : IN STD_LOGIC;
        elderly_cross_button : IN STD_LOGIC;

        road_vertical : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
        road_horizontal : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := "000"
        -- green_duration : out STD_LOGIC_VECTOR(7 downto 0);
        -- yellow_duration : out STD_LOGIC_VECTOR(7 downto 0);
        -- red_duration : out STD_LOGIC_VECTOR(7 downto 0)
    );
END AdaptiveTrafficLight;

ARCHITECTURE Behavioral OF AdaptiveTrafficLight IS
    TYPE State_Type IS (INIT, TL_VERTICAL, TL_HORIZONTAL, TRANSITION);
    SIGNAL state : State_Type := INIT;
    SIGNAL traffic_density : STD_LOGIC;

    SIGNAL green_timer_vertical, red_timer_horizontal : INTEGER := 10; -- TOLONG KEMBALIKAN JADI 20
    SIGNAL red_timer_vertical, green_timer_horizontal : INTEGER := 10; -- TOLONG KEMBALIKAN JADI 20
    SIGNAL yellow_timer_vertical, yellow_timer_horizontal : INTEGER := 5;
    SIGNAL initial_road_vertical : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";

    CONSTANT YELLOW_BASE_DURATION : INTEGER := 5; --lampu kuning
    CONSTANT GREEN_RED_BASE_DURATION : INTEGER := 10; -- tolong kembalikan jadi 20 nanti
    CONSTANT GREEN_RED_BASE_DURATION_ELDERLY : INTEGER := 15; -- tolong kembalikan jadi 30 nanti
    SIGNAL road_vertical_temp : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100"; 

BEGIN
    -- -- handle condition for the initiation execution
    -- red_timer_vertical <= GREEN_RED_BASE_DURATION;
    -- green_timer_vertical <= GREEN_RED_BASE_DURATION;
    -- yellow_timer_vertical <= YELLOW_BASE_DURATION;

    -- red_timer_horizontal <= GREEN_RED_BASE_DURATION;
    -- green_timer_horizontal <= GREEN_RED_BASE_DURATION;
    -- yellow_timer_horizontal <= YELLOW_BASE_DURATION;

    PROCESS (clk, elderly_cross_button)
        VARIABLE reset : STD_LOGIC := '0';
    BEGIN
        IF reset = '1' THEN
            traffic_density <= '0';

            red_timer_vertical <= GREEN_RED_BASE_DURATION;
            green_timer_vertical <= GREEN_RED_BASE_DURATION;

            red_timer_horizontal <= GREEN_RED_BASE_DURATION;
            green_timer_horizontal <= GREEN_RED_BASE_DURATION;
            reset := '0';

        ELSIF rising_edge(clk) THEN
            CASE state IS
                WHEN INIT =>
                    State <= TL_vertical;

                WHEN TL_vertical =>
                    -- Condition : The vertical traffic light will be red, whether the horizontal traffic light will be green.
                    initial_road_vertical <= "100"; -- merah (sign only)
                    road_vertical <= "100"; -- merah
                    road_horizontal <= "001"; -- hijau

                    IF (elderly_cross_button = '1') THEN
                        red_timer_vertical <= red_timer_vertical + 10;
                        green_timer_horizontal <= green_timer_horizontal + 10;

                        FOR i IN 1 TO GREEN_RED_BASE_DURATION_ELDERLY LOOP
                            red_timer_vertical <= red_timer_vertical - 1;
                            green_timer_horizontal <= green_timer_horizontal - 1;

                            IF (red_timer_vertical = 0 AND green_timer_horizontal = 0) THEN
                                state <= TRANSITION;
                            END IF;
                        END LOOP;
                    ELSE
                        FOR i IN 1 TO GREEN_RED_BASE_DURATION LOOP
                            red_timer_vertical <= red_timer_vertical - 1;
                            green_timer_horizontal <= green_timer_horizontal - 1;

                            IF (red_timer_vertical = 0 AND green_timer_horizontal = 0) THEN
                                state <= TRANSITION;
                            END IF;
                        END LOOP;
                    END IF;

                    --TRANSITION = state for yellow
                WHEN TRANSITION =>
                    road_vertical <= "010";
                    road_horizontal <= "010";

                    FOR i IN 1 TO YELLOW_BASE_DURATION LOOP
                        yellow_timer_vertical <= yellow_timer_vertical - 1;
                        yellow_timer_horizontal <= yellow_timer_horizontal - 1;

                        IF (yellow_timer_vertical = 0 AND yellow_timer_horizontal = 0) THEN
                            IF (initial_road_vertical = "100") THEN
                                road_vertical <= "001";
                                road_horizontal <= "100";
                                reset := '1';
                                state <= TL_horizontal;
                            ELSE
                                road_vertical <= "100";
                                road_horizontal <= "001";
                                reset := '1';
                                state <= TL_vertical;
                            END IF;
                        END IF;
                    END LOOP;

                WHEN TL_horizontal =>
                    -- Condition : The horizontal traffic light will be red, whether the vertical traffic light will be green.
                    initial_road_vertical <= "001";
                    road_vertical <= "001";
                    road_horizontal <= "100";

                    IF (elderly_cross_button = '1') THEN
                        green_timer_vertical <= green_timer_vertical + 10;
                        red_timer_horizontal <= red_timer_horizontal + 10;

                        FOR i IN 1 TO GREEN_RED_BASE_DURATION_ELDERLY LOOP
                            green_timer_vertical <= green_timer_vertical - 1;
                            red_timer_horizontal <= red_timer_horizontal - 1;
                            IF (green_timer_vertical = 0 AND red_timer_horizontal = 0) THEN
                                state <= TRANSITION;
                            END IF;
                        END LOOP;
                    ELSE
                        FOR i IN 1 TO GREEN_RED_BASE_DURATION LOOP
                            green_timer_vertical <= green_timer_vertical - 1;
                            red_timer_horizontal <= red_timer_horizontal - 1;

                            IF (red_timer_horizontal = 0 AND green_timer_vertical = 0) THEN
                                state <= TRANSITION;
                            END IF;
                        END LOOP;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;
END Behavioral;