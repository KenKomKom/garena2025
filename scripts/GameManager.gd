extends Node

enum ZONE {EPIPELAGIC, MESOPELAGIC, BATHYPELAGIC, ABYSSOPELAGIC, HADAL}

signal zone_reached(zona)
signal tutorial_start()
signal tank_minus()
signal tank_plus()

var zone_now
