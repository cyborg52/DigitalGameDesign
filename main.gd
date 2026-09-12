extends Node

@export var mob_scene: PackedScene
@export var coin_scene: PackedScene
var score

func game_over() -> void:
	$MobTimer.stop()
	$CoinTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("coins", "queue_free")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 6, PI / 6)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$CoinTimer.start()


func collect() -> void:
	score += 1
	$HUD.update_score(score)


func _on_coin_timer_timeout() -> void:
	var coin = coin_scene.instantiate()
	coin.position = Vector2 (randf_range(110, 570),randf_range(110, 738))
	add_child(coin)
	
