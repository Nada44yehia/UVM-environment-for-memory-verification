vlib work
vlog -f src_files.list +define+SIM  +cover -covercells
vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all
add wave /top/in1/*
coverage save top.ucdb 

run -all

# Generate coverage report in transcript
coverage report -details