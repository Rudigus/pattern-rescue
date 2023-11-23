class_name PatternManager
extends Node

signal game_lost
signal game_won
signal should_replay
signal should_spawn_helper(color)
signal helper_should_jump(color)

enum PatternColor {RED, BLUE, GREEN, YELLOW}

var color_pattern: Array[PatternColor] = []
var pattern_attempt: Array[PatternColor] = []
var is_on_replay = false
var helped_colors: Array[PatternColor] = []

# Game starts after one shot timer ends
func _on_timer_timeout():
	next_round()

func next_round():
	increment()
	replay()

func increment():
	var pattern_colors = PatternColor.values()
	pattern_colors.shuffle()
	var random_color = pattern_colors[0]
	color_pattern.append(random_color)

func replay():
	is_on_replay = true
	await get_tree().create_timer(2).timeout
	should_replay.emit()

func replay_finished():
	is_on_replay = false

func check():
	var last_element_index = pattern_attempt.size() - 1
	# Successful
	if pattern_attempt[last_element_index] == color_pattern[last_element_index]:
		if last_element_index + 1 < color_pattern.size():
			var next_color = color_pattern[last_element_index + 1]
			if next_color in helped_colors:
				helper_should_jump.emit(next_color)
		if pattern_attempt.size() == color_pattern.size():
			if pattern_attempt.size() % 2 == 0:
				add_helper()
				if helped_colors.size() == 4:
					game_won.emit()
			next_round()
			pattern_attempt = []
	else:
		game_lost.emit()

func add_helper():
	var pattern_colors = PatternColor.values()
	for color in helped_colors:
		pattern_colors.erase(color)
	pattern_colors.shuffle()
	var random_color = pattern_colors[0]
	helped_colors.append(random_color)
	should_spawn_helper.emit(random_color)

func handle_press(color):
	if is_on_replay:
		return
	var pattern_color: PatternColor
	match color:
		"red":
			pattern_color = PatternColor.RED
		"blue":
			pattern_color = PatternColor.BLUE
		"green":
			pattern_color = PatternColor.GREEN
		"yellow":
			pattern_color = PatternColor.YELLOW
	pattern_attempt.append(pattern_color)
	check()
