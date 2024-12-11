extends CharacterBody2D

# Pixels / sec
var speed = 300;
# Player default health
var player_health = 100

#signal hit(damage)

func _physics_process(delta):
	
	# Reset veolcity to 0
	velocity = Vector2.ZERO
	
	# Get directional input
	var input_direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	
	# If there is any movement
	if input_direction.length() > 0:
		# Normalize the direction and apply speed
		# This will stop the player from moving faster by applying 2 movement inputs at once
		velocity = input_direction.normalized() * speed
	else:
		# Set velocity to 0 when there is no directional input
		velocity = Vector2.ZERO
	
	# Flip the sprite
	if velocity.x != 0:
		$Sprite2D.flip_h = velocity.x < 0
	
	# Apply the velocity to the player
	move_and_slide()

# Function for when the player is damaged
#func _on_hit(damage):
#	player_health -= damage
#	print("Player health: ", player_health)

func take_damage(damage):
	player_health -= damage
	print("Remaining HP: ", player_health)
	# Temporary place holder for player death.
	if player_health <= 0:
		player_health = 0
		set_physics_process(false)

func _on_square_enemy_damage_to_player(damage):
	#player_health -= damage
	take_damage(damage)
