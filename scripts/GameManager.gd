extends Node

enum ZONE {EPIPELAGIC, MESOPELAGIC, BATHYPELAGIC, ABYSSOPELAGIC, HADAL}
enum ZONE_DURATION {EPIPELAGIC=2, MESOPELAGIC=3, BATHYPELAGIC=3, ABYSSOPELAGIC=3, HADAL=3}
enum DEATH_REASON {AIR, PRESSURE, MELTDOWN}

var next_level

signal zone_reached(zona)
signal tutorial_start()
signal add_air_depletion(value)
signal game_over(why)
signal add_pressure_value()
signal start_meltdown()
signal meltdown_done()
signal lights_switch(nyala)

var zone_now = ZONE.EPIPELAGIC :
	set(value):
		zone_now = value
		print(zone_now)
