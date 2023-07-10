transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {Fsm.vo}

vlog -vlog01compat -work work +incdir+C:/Users/Bharadwaj/OneDrive/Documents/FSM {C:/Users/Bharadwaj/OneDrive/Documents/FSM/test_bench.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L altera_lnsim_ver -L cyclonev_ver -L lpm_ver -L sgate_ver -L cyclonev_hssi_ver -L altera_mf_ver -L cyclonev_pcie_hip_ver -L gate_work -L work -voptargs="+acc"  test_bench

add wave *
view structure
view signals
run -all
