restart
add_force clk {1 0ns} {0 5ns} -repeat_every 10ns
add_force btns {0000 0ns 0100 20ns 0001 32ns 0000 200ns 0010 201ns}
add_force swtchs {00000000 0ns 00000001 30ns}
run 200ns