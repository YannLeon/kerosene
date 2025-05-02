extends Node

var fuelAmount=100

func add_fuel(amount:float) :
	fuelAmount = min(100, fuelAmount+amount)
