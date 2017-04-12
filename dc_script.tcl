lappend search_path aes_core/trunk/rtl/verilog

define_design_lib WORK -path ./work

analyze -f verilog [list aes_cipher_top.v aes_key_expand_128.v aes_rcon.v aes_sbox.v timescale.v] 
elaborate aes_cipher_top 
link
write hier f ddc output unmapped/aes.ddc
read_ddc unmapped/aes.ddc
create_clock -period 10 clk
set_clock_latency 0.4 [get_clocks clk]
set_clock_uncertainty  0.05  [get_port clk]
set_clock_transition 0.1 [get_clocks clk]
check_design
check_timing
report_timing_requirements
current_design
compile_ultra

report_design > reports/design.txt
report_clock > reports/clock.txt
report_clock -skew > reports/clockskew.txt
report_constraint > reports/constraint.txt
report_qor > reports/qor.txt
report_area > reports/area.txt
report_power > reports/power.txt
report_cell > reports/cell.txt
report_path_group > reports/path_group.txt

write_sdc work/aes.sdc
write -hier -f verilog -output work/aes.v
write -hier -f ddc -output work/aes.ddc

