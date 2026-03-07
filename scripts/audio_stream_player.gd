extends AudioStreamPlayer

const TRACKS = {
	"bgm_galaxy":  {"path": "res://audio/space fantasy.mp3", "offset": -10},
	"bgm_odyssey": {"path": "res://audio/prologue.mp3",       "offset": 0},
	"main_theme":  {"path": "res://audio/g2w4.mp3",          "offset": -10},
	"bgm_earth":   {"path": "res://audio/earth.mp3",         "offset": 0},
	"bgm_mercury": {"path": "res://audio/mercury.mp3",       "offset": 20},
	"bgm_venus":   {"path": "res://audio/venus.mp3",         "offset": 20},
	"bgm_mars":    {"path": "res://audio/mars.mp3",          "offset": 0},
	"bgm_jupiter": {"path": "res://audio/jupiter.mp3",       "offset": 0},
	"bgm_saturn":  {"path": "res://audio/saturn.mp3",        "offset": 0},
	"bgm_uranus":  {"path": "res://audio/uranus.mp3",        "offset": 0},
	"bgm_neptune": {"path": "res://audio/neptune.mp3",       "offset": 0},
	"bgm_loop":    {"path": "res://audio/looping.mp3",       "offset": 0},
	"bgm_intro":   {"path": "res://audio/intro.mp3",         "offset": 0}
}

var playback_positions: Dictionary = {}
var current_track_path: String = ""
var locked_by_loop: bool = false
var is_playing_planet: bool = false
var fade_duration: float = 1.0
var active_tween: Tween

func _ready() -> void:
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus, Global.music_volume_db)
	AudioServer.set_bus_mute(music_bus, Global.music_muted)
	
	for signal_name in TRACKS.keys():
		if Global.has_signal(signal_name):
			Global.connect(signal_name, _on_play_requested.bind(signal_name))

func _process(_delta: float) -> void:
	if Global.play_bgm != playing:
		if Global.play_bgm:
			play(playback_positions.get(current_track_path, 0.0))
		else:
			stop()

func _on_play_requested(track_key: String) -> void:
	var planets = ["bgm_earth", "bgm_mercury", "bgm_venus", "bgm_mars", "bgm_jupiter", "bgm_saturn", "bgm_uranus", "bgm_neptune"]
	var is_planet = track_key in planets
	var is_loop = (track_key == "bgm_loop")
	var is_main = (track_key == "main_theme")

	if locked_by_loop and not is_planet:
		return 

	if is_playing_planet and not (is_planet or is_loop or is_main):
		return

	if is_loop:
		locked_by_loop = true
		is_playing_planet = false
	elif is_planet:
		locked_by_loop = false
		is_playing_planet = true
	else:
		locked_by_loop = false
		is_playing_planet = false
	
	var data = TRACKS[track_key]
	var target_db = Global.music_volume_db + data.get("offset", 0)
	
	_switch_and_play(data["path"], target_db)

func _switch_and_play(new_path: String, target_db: float) -> void:
	if current_track_path == new_path:
		if not playing:
			play()
		return

	if active_tween:
		active_tween.kill()

	if stream:
		playback_positions[current_track_path] = get_playback_position()

	active_tween = create_tween()
	
	if playing:
		active_tween.tween_property(self, "volume_db", -80.0, fade_duration).set_trans(Tween.TRANS_SINE)
	
	active_tween.tween_callback(func():
		current_track_path = new_path
		stream = load(new_path)
		play(playback_positions.get(new_path, 0.0))
	)
	
	active_tween.tween_property(self, "volume_db", target_db, fade_duration).set_trans(Tween.TRANS_SINE)
