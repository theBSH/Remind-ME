extends Control

# Variables for UI elements and functionality
var bg
var bg_anim
var textbox : LineEdit
var textbox2 : LineEdit
var button_flag : bool = false
var timer : Timer
var main_button : Button

# Variables for managing paths and interpreter
var DIR
var interperter_path
var script_path

func _ready():
	# Initialize UI elements and paths
	bg = $ColorRect
	bg_anim = $ColorRect/AnimationPlayer
	textbox = $text/HBoxContainer/LineEdit
	textbox2 = $start/VBoxContainer/HBoxContainer/LineEdit_min
	timer = $Timer
	main_button = $start/VBoxContainer/Button
	var os_name = OS.get_name()
	
	if !OS.has_feature("standalone"):
		if os_name == "Linux":
			
			# Set paths for non-standalone mode
			interperter_path = ProjectSettings.globalize_path("res://PythonDeps/venv/bin/python3.11")
			script_path = ProjectSettings.globalize_path("res://PythonDeps/notify.py")
		elif  os_name == "Windows":
			interperter_path = ProjectSettings.globalize_path("res://PythonDeps/venvw/Scripts/python.exe")
			script_path = ProjectSettings.globalize_path("res://PythonDeps/notify.py")
	else:
		if os_name == "Linux":
			
			# Set paths for standalone mode
			DIR = OS.get_executable_path().get_base_dir()
			interperter_path = DIR.path_join("PythonDeps/venv/bin/python3.11")
			script_path = DIR.path_join("PythonDeps/notify.py")
		elif  os_name == "Window":
			DIR = OS.get_executable_path().get_base_dir()
			interperter_path = DIR.path_join("PythonDeps/venvw/Scripts/python.exe")
			script_path = DIR.path_join("PythonDeps/notify.py")

# Function to handle DARK MODE button toggling
func _on_theme_button_toggled(toggled_on):
	if toggled_on:
		# Dark theme
		bg_anim.play("Dark")
		textbox.add_theme_color_override("selection_color",Color(0.8,0.8,0.8,1))
		textbox2.add_theme_color_override("selection_color",Color(0.8,0.8,0.8,1))
	else:
		# Light theme
		bg_anim.play("Light")
		textbox.add_theme_color_override("selection_color",Color(0.133,0.133,0.133,1))
		textbox2.add_theme_color_override("selection_color",Color(0.133,0.133,0.133,1))

# Function to handle language button selection
func _on_lang_button_item_selected(index):
	if index == 0:
		# Set English locale
		TranslationServer.set_locale("en")
	elif index == 1:
		# Set Farsi locale
		TranslationServer.set_locale("fa")

# Function to handle main button press
func _on_button_pressed():
	if button_flag:
		# Stop timer and update button text
		timer.stop()
		main_button.text = "START"
		button_flag = false
	else:
		# Start timer with specified duration
		var time = float(textbox2.text)
		if time != 0 || 0.0:
			var secs = time * 60
			timer.wait_time = secs
			timer.start()
			main_button.text = "STOP"
			button_flag = true
		else:
			print("Enter a valid number")

# Function to handle timer timeout
func _on_timer_timeout():
	# Create a process to run the specified Python script
	var process = OS.create_process(interperter_path, [script_path, textbox.text])

