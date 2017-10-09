onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate {/linear_pipeline/intf[0]/status}
add wave -noupdate {/linear_pipeline/intf[0]/req}
add wave -noupdate {/linear_pipeline/intf[0]/ack}
add wave -noupdate {/linear_pipeline/intf[0]/data}
add wave -noupdate {/linear_pipeline/intf[1]/status}
add wave -noupdate {/linear_pipeline/intf[1]/req}
add wave -noupdate {/linear_pipeline/intf[1]/ack}
add wave -noupdate {/linear_pipeline/intf[1]/data}
add wave -noupdate {/linear_pipeline/intf[2]/status}
add wave -noupdate {/linear_pipeline/intf[2]/req}
add wave -noupdate {/linear_pipeline/intf[2]/ack}
add wave -noupdate {/linear_pipeline/intf[2]/data}
add wave -noupdate {/linear_pipeline/intf[3]/status}
add wave -noupdate {/linear_pipeline/intf[3]/req}
add wave -noupdate {/linear_pipeline/intf[3]/ack}
add wave -noupdate {/linear_pipeline/intf[3]/data}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
configure wave -namecolwidth 246
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits fs
update
WaveRestoreZoom {0 fs} {836 fs}