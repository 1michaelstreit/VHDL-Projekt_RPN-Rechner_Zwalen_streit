# -------------------------------------------------------------------------------
# -- Filename 		: pmod.tcl
# -- Title    		: PMOD Wiring 
# -- Author   		: Patrick Zwahlen
# -- Date     		: 07.01.2020
# -- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
# -------------------------------------------------------------------------------
# You have to replace <ENTITY_PORT_NAME_xxx> with the name of the PMOD I/O port
# of your top entity
set_location_assignment PIN_F2 -to kp_column[3]
set_location_assignment PIN_E3 -to kp_column[2]
set_location_assignment PIN_C2 -to kp_column[1]
set_location_assignment PIN_B2 -to kp_column[0]
set_location_assignment PIN_F1 -to kp_row[3]
set_location_assignment PIN_E4 -to kp_row[2]
set_location_assignment PIN_C1 -to kp_row[1]
set_location_assignment PIN_B1 -to kp_row[0]

