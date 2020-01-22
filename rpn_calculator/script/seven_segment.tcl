# -------------------------------------------------------------------------------
# -- Filename 		: seven_segment.tcl
# -- Title    		: Seven Segment Wiring 
# -- Author   		: Patrick Zwahlen
# -- Date     		: 07.01.2020
# -- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
# -------------------------------------------------------------------------------
# You have to replace <ENTITY_PORT_NAME_xxx> with the name of the Output port
# of your top entity

set_location_assignment PIN_T3 -to segment1[0]
set_location_assignment PIN_R6 -to segment1[1]
set_location_assignment PIN_R5 -to segment1[2]
set_location_assignment PIN_P7 -to segment1[3]
set_location_assignment PIN_N8 -to segment1[4]
set_location_assignment PIN_N7 -to segment1[5]
set_location_assignment PIN_P8 -to segment1[6]
set_location_assignment PIN_P6 -to segment1[7]

set_location_assignment PIN_R10 -to segment2[0]
set_location_assignment PIN_T9  -to segment2[1]
set_location_assignment PIN_R9  -to segment2[2]
set_location_assignment PIN_R8  -to segment2[3]
set_location_assignment PIN_T7  -to segment2[4]
set_location_assignment PIN_R7  -to segment2[5]
set_location_assignment PIN_T4  -to segment2[6]
set_location_assignment PIN_T8  -to segment2[7]

set_location_assignment PIN_U9  -to segment3[0]
set_location_assignment PIN_W8  -to segment3[1]
set_location_assignment PIN_V8  -to segment3[2]
set_location_assignment PIN_Y4  -to segment3[3]
set_location_assignment PIN_T11 -to segment3[4]
set_location_assignment PIN_R11 -to segment3[5]
set_location_assignment PIN_T10 -to segment3[6]
set_location_assignment PIN_W7  -to segment3[7]

set_location_assignment PIN_U11 -to segment4[0]
set_location_assignment PIN_G18 -to segment4[1]
set_location_assignment PIN_M8  -to segment4[2]
set_location_assignment PIN_L6  -to segment4[3]
set_location_assignment PIN_W10 -to segment4[4]
set_location_assignment PIN_U10 -to segment4[5]
set_location_assignment PIN_V9  -to segment4[6]
set_location_assignment PIN_L7  -to segment4[7]
