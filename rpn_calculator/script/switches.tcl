# -------------------------------------------------------------------------------
# -- Filename 		: switches.tcl
# -- Title    		: Switch Wiring 
# -- Author   		: Patrick Zwahlen
# -- Date     		: 07.01.2020
# -- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
# -------------------------------------------------------------------------------
# You have to replace <ENTITY_PORT_NAME_xxx> with the name of the Output port
# of your top entity
set_location_assignment PIN_B11  -to button[0]
set_location_assignment PIN_A11  -to button[1]
set_location_assignment PIN_B12  -to button[2]
set_location_assignment PIN_A12  -to button[3]
set_location_assignment PIN_G22  -to button[4]
set_location_assignment PIN_AA11 -to reset
set_location_assignment PIN_AB11 -to button[6]

