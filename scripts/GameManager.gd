extends Node

enum ZONE {EPIPELAGIC, MESOPELAGIC, BATHYPELAGIC, ABYSSOPELAGIC, HADAL}
enum ZONE_DURATION {EPIPELAGIC=2, MESOPELAGIC=4, BATHYPELAGIC=3, ABYSSOPELAGIC=3, HADAL=2}
enum DEATH_REASON {AIR, PRESSURE, MELTDOWN}

signal zone_reached(zona)
signal tutorial_start()
signal add_air_depletion(value)
signal game_over(why)
signal pressure_dir()

var zone_now = ZONE.EPIPELAGIC :
	set(value):
		zone_now = value
		print(zone_now)
