class_name Stats
extends Node

@export var stats : Array[Stat] = []

"""
change the value of a stat by its name
If the stat does not exist, it will print an error message.
"""
func change_stat_value(stat_name: String, value: int) -> void:
  for stat in stats:
    if stat.name == stat_name:
      stat.value = clamp(stat.value + value, stat.min_value, stat.max_value)
      return
  print("Stat not found: ", stat_name)