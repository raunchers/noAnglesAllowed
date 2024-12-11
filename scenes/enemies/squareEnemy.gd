extends CharacterBody2D

signal damage_to_player

# Enemy health
var enemy_health = 150
# Enemy defult speed
var speed = 200
# Default damage amount
var enemy_attack_damage = 10
# References the player node
var player = null
# Frequency of attacks
var damage_time_interval = 0.5
# Timer for continous damage, when touching the player
var damage_timer = null

func _ready():
	
	# Find the player node in the player group
	player = get_tree().get_first_node_in_group("player")
	
	# If the player node was not found
	if !player:
		push_error("Player not found in the scene!")
	
	# Set up the timer for continuous damage
	damage_timer = Timer.new()
	add_child(damage_timer)
	# Causes the repeat attack
	damage_timer.set_one_shot(false)
	damage_timer.set_wait_time(damage_time_interval)
	damage_timer.connect("timeout", Callable(self, "_on_damage_timer_timeout"))
	# Set autostart to off
	damage_timer.set_autostart(false)

func _on_damage_detection_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("damage_to_player", enemy_attack_damage)
		damage_timer.start()

func _on_damage_detection_body_exited(body):
	if body.is_in_group("player"):
		# player_contact = false
		# Stop the timer when the player exits
		damage_timer.stop()
		# Clear any pending signals
		if damage_timer.time_left > 0:
			damage_timer.stop()

func _on_damage_timer_timeout():
	if $damageDetection.overlaps_body(player):
			emit_signal("damage_to_player", enemy_attack_damage)
#	if player_contact:
#		emit_signal("damage_to_player", enemy_attack_damage)
#		if $DamageDetection.overlaps_body(player):
#			emit_signal("damage_to_player", enemy_attack_damage)

func _physics_process(delta):
	
	# Do nothing if the player node was not found
	if !player:
		return
	
	# Calc the direction towards the player
	var direction = (player.global_position - global_position).normalized()
	
	# Move towards the player
	velocity = direction * speed
	
	# Flip the sprite based on the horizontal direction
	if direction.x < 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
	
	move_and_slide()
