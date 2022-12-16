if [file exists "work"] {vdel -all}
vlib work


# Comment out either the SystemVerilog or VHDL DUT.
# There can be only one!

#VHDL DUT
vcom -f dut.f

# SystemVerilog DUT
# vlog ../misc/tinyalu.sv

vlog -f tb.f
vopt top -o top_optimized  +acc +cover=sbfec+tinyalu(rtl).

# RADNOM TEST start
#vsim top_optimized -coverage +UVM_TESTNAME=random_test
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
#run -all
#coverage exclude -src ../../tinyalu_dut/single_cycle_add_and_xor.vhd -line 49 -code s
#coverage exclude -src ../../tinyalu_dut/single_cycle_add_and_xor.vhd -scope /top/DUT/add_and_xor -line 49 -code b
#coverage save random_test.ucdb
# RANDOM TEST stop

# ADD TEST start
#vsim top_optimized -coverage +UVM_TESTNAME=add_test
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
#run -all
#coverage exclude -src ../../tinyalu_dut/single_cycle_add_and_xor.vhd -line 49 -code s
#coverage exclude -src ../../tinyalu_dut/single_cycle_add_and_xor.vhd -scope /top/DUT/add_and_xor -line 49 -code b
#coverage save add_test.ucdb
# ADD TEST stop

# FUN TEST start
vsim top_optimized -coverage +UVM_TESTNAME=fun_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage exclude -src ../../tinyalu_dut/single_cycle_add_and_xor.vhd -line 49 -code s
coverage exclude -src ../../tinyalu_dut/single_cycle_add_and_xor.vhd -scope /top/DUT/add_and_xor -line 49 -code b
coverage save fun_test.ucdb
# FUN TEST stop

vcover merge  tinyalu.ucdb random_test.ucdb add_test.ucdb fun_test.ucdb
vcover report tinyalu.ucdb -cvg -details
quit
