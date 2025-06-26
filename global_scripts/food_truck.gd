extends Node

# Stores the data for the currently selected ingredient sprite
var current_selection : Sprite2D

# Toggles when bell is rang - triggers counting of the toppings
var pizza_ready : bool = false

# Stores the toppings on the pizza here when the bell is rang
var pizza_toppings : Array

# Stores the order of the current customer as a String
var current_order : String
