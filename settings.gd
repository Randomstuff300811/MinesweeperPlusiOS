extends PopupPanel

signal language_changed

var l_click_to_open = "Left-click to open, right-click to flag"
var r_click_to_open = "Right-click to open, left-click to flag"
var click = "Flag a tile on click"
var click_release = "Flag a tile on click then release"
var seconds = " seconds"
var l_click = "Left-click"
var r_click = "Right-click"
var lr_click = "Left+Right-click"
var ThreeByThreeG = "3 by 3 Guarantee"
var OneG = "1 tile Guaranteed"
var NoG = "No Guarantee"
var it = "ITERATIVE"
var rec = "RECURSIVE"
var none = "None"
var few = "Few"
var some = "Some"
var many = "Many"


func _ready() -> void :
    translate(Main.db["language"])
    $Menu / VolumeSettings / MasterVolumeSlider.value = Main.db["master_volume"]
    $Menu / VolumeSettings / MusicVolumeSlider.value = Main.db["music_volume"]
    $Menu / VolumeSettings / SFXVolumeSlider.value = Main.db["sfx_volume"]
    if (Main.db["chording"] == false): $Menu / GameplaySettings / ChordingLabel / ChordingButton / OffOn.frame = 0
    else: $Menu / GameplaySettings / ChordingLabel / ChordingButton / OffOn.frame = 1
    if (Main.db["auto_sonar"] == false): $Menu / GameplaySettings / AutoSonarLabel / AutoSonarButton / OffOn.frame = 0
    else: $Menu / GameplaySettings / AutoSonarLabel / AutoSonarButton / OffOn.frame = 1
    $Menu / ControlSettings / ReverseLabel / ReverseButton / OffOn.frame = Main.db["play_style"]
    if (Main.db["play_style"] == 0): $Menu / ControlSettings / ReverseLabel / Label.text = l_click_to_open
    else: $Menu / ControlSettings / ReverseLabel / Label.text = r_click_to_open
    $Menu / ControlSettings / HoldLabel / HoldTimeSlider.value = Main.db["hold_time"]
    if (Main.db["hold_to_flag"] == false): $Menu / ControlSettings / HoldLabel / HoldButton / OffOn.frame = 0
    else:
        $Menu / ControlSettings / HoldLabel / HoldButton / OffOn.frame = 1
        $Menu / ControlSettings / HoldLabel / HoldTimeSlider.visible = true
    update_chord_text()
    update_safe_text()
    if (Main.db["legacy_time"]) == false: $Menu / GameplaySettings / LegacyLabel / LegacyButton / OffOn.frame = 0
    else: $Menu / GameplaySettings / LegacyLabel / LegacyButton / OffOn.frame = 1
    if (Main.db["legacy_10_speed"]) == false: $Menu / GameplaySettings / LegacyLabel2 / Legacy2Button / OffOn.frame = 0
    else: $Menu / GameplaySettings / LegacyLabel2 / Legacy2Button / OffOn.frame = 1
    $Menu / OtherSettings / ExplodingLabel / ExplodingButton / OffOn.frame = Main.db["exploding_mines"]
    update_spread_text()
    update_decor_text()
    if (Main.db["classic"] == 1): $Menu / OtherSettings / ClassicGrid / ClassicButton / OffOn.frame = 0
    else: $Menu / OtherSettings / ClassicGrid / ClassicButton / OffOn.frame = 1
    if (Main.db["mouse_drag"]): $Menu / ControlSettings / MouseDragLabel / MouseButton / OffOn.frame = 1
    else: $Menu / ControlSettings / MouseDragLabel / MouseButton / OffOn.frame = 0
    if (Main.db["flag_click"]):
        $Menu / ControlSettings / FlagClickLabel / FlagButton / OffOn.frame = 1
        $Menu / ControlSettings / FlagClickLabel / Label.text = click
    else:
        $Menu / ControlSettings / FlagClickLabel / FlagButton / OffOn.frame = 0
        $Menu / ControlSettings / FlagClickLabel / Label.text = click_release
    if (Main.db["instant_zero_spread"]): $Menu / GameplaySettings / InstantLabel / InstantButton / OffOn.frame = 1
    else: $Menu / GameplaySettings / InstantLabel / InstantButton / OffOn.frame = 0
    if (Main.db["instant_boat_travel"]): $Menu / OtherSettings / InstantBoatLabel / InstantBoatButton / OffOn.frame = 1
    else: $Menu / OtherSettings / InstantBoatLabel / InstantBoatButton / OffOn.frame = 0
    if (Main.db["instant_boat_travel"]): $Menu / OtherSettings / InstantBoatLabel / InstantBoatButton / OffOn.frame = 1
    else: $Menu / OtherSettings / InstantBoatLabel / InstantBoatButton / OffOn.frame = 0
    if (Main.db["screen_shake"]): $Menu / OtherSettings / ScreenShake / ShakeButton / OffOn.frame = 1
    else: $Menu / OtherSettings / ScreenShake / ShakeButton / OffOn.frame = 0
    if (Main.db["flashing_lights"]): $Menu / OtherSettings / FlashingLights / FlashButton / OffOn.frame = 1
    else: $Menu / OtherSettings / FlashingLights / FlashButton / OffOn.frame = 0
    if (Main.db["graphics_quality"]): $Menu / OtherSettings / GraphicsLabel / GraphicsButton / OffOn.frame = 1
    else: $Menu / OtherSettings / GraphicsLabel / GraphicsButton / OffOn.frame = 0



func _process(_delta: float) -> void :
    pass


func _on_windowed_button_pressed() -> void :
    DisplayServer.window_set_mode(0)
    Main.db["window_mode"] = 0


func _on_fullscreen_button_pressed() -> void :
    DisplayServer.window_set_mode(3)
    Main.db["window_mode"] = 3

func _on_enabled_button_pressed() -> void :
    get_tree().root.content_scale_mode = 2
    Main.db["window_stretch"] = 2


func _on_disabled_button_pressed() -> void :
    get_tree().root.content_scale_mode = 0
    Main.db["window_stretch"] = 0


func _on_keep_button_pressed() -> void :
    get_tree().root.content_scale_aspect = 1
    Main.db["window_aspect"] = 1


func _on_ignore_button_pressed() -> void :
    get_tree().root.content_scale_aspect = 0
    Main.db["window_aspect"] = 0


func _on_fraction_button_pressed() -> void :
    get_tree().root.content_scale_stretch = 0
    Main.db["window_scale"] = 0


func _on_integer_button_pressed() -> void :
    get_tree().root.content_scale_stretch = 1
    Main.db["window_scale"] = 1


func _on_master_volume_slider_value_changed(value: float) -> void :
    get_tree().call_group("music", "set_volume_linear", value * Main.db["music_volume"])
    get_tree().call_group("sfx", "set_volume_linear", value * Main.db["sfx_volume"])
    $Menu / VolumeSettings / MasterVolumeSlider / VolumeLabel.text = var_to_str(snapped(value * 100, 1))
    Main.db["master_volume"] = value


func _on_music_volume_slider_value_changed(value: float) -> void :
    get_tree().call_group("music", "set_volume_linear", value * Main.db["master_volume"])
    $Menu / VolumeSettings / MusicVolumeSlider / VolumeLabel.text = var_to_str(snapped(value * 100, 1))
    Main.db["music_volume"] = value


func _on_sfx_volume_slider_value_changed(value: float) -> void :
    get_tree().call_group("sfx", "set_volume_linear", value * Main.db["master_volume"])
    $Menu / VolumeSettings / SFXVolumeSlider / VolumeLabel.text = var_to_str(snapped(value * 100, 1))
    Main.db["sfx_volume"] = value


func _on_chording_button_pressed() -> void :
    $Menu / GameplaySettings / ChordingLabel / ChordingButton / OffOn.frame = ($Menu / GameplaySettings / ChordingLabel / ChordingButton / OffOn.frame + 1) % 2
    Main.db["chording"] = !Main.db["chording"]

func _on_auto_sonar_button_pressed() -> void :
    $Menu / GameplaySettings / AutoSonarLabel / AutoSonarButton / OffOn.frame = ($Menu / GameplaySettings / AutoSonarLabel / AutoSonarButton / OffOn.frame + 1) % 2
    Main.db["auto_sonar"] = !Main.db["auto_sonar"]

func _on_reverse_button_pressed() -> void :
    $Menu / ControlSettings / ReverseLabel / ReverseButton / OffOn.frame = ($Menu / ControlSettings / ReverseLabel / ReverseButton / OffOn.frame + 1) % 2
    Main.db["play_style"] = $Menu / ControlSettings / ReverseLabel / ReverseButton / OffOn.frame
    if (Main.db["play_style"] == 0): $Menu / ControlSettings / ReverseLabel / Label.text = l_click_to_open
    else: $Menu / ControlSettings / ReverseLabel / Label.text = r_click_to_open


func _on_hold_button_pressed() -> void :
    $Menu / ControlSettings / HoldLabel / HoldButton / OffOn.frame = ($Menu / ControlSettings / HoldLabel / HoldButton / OffOn.frame + 1) % 2
    if ($Menu / ControlSettings / HoldLabel / HoldButton / OffOn.frame == 0): Main.db["hold_to_flag"] = false
    else: Main.db["hold_to_flag"] = true
    $Menu / ControlSettings / HoldLabel / HoldTimeSlider.visible = Main.db["hold_to_flag"]


func _on_hold_time_slider_value_changed(value: float) -> void :
    $Menu / ControlSettings / HoldLabel / HoldTimeSlider / SecondsLabel.text = var_to_str(value) + seconds
    Main.db["hold_time"] = value


func _on_left_button_pressed() -> void :
    Main.db["chord_button"] -= 1
    if Main.db["chord_button"] == -1: Main.db["chord_button"] = 2
    update_chord_text()


func _on_right_button_pressed() -> void :
    Main.db["chord_button"] += 1
    Main.db["chord_button"] = Main.db["chord_button"] %3
    update_chord_text()

func update_chord_text() -> void :
    if (Main.db["chord_button"] == 0): $Menu / ControlSettings / ChordLabel / Label.text = l_click
    elif (Main.db["chord_button"] == 1): $Menu / ControlSettings / ChordLabel / Label.text = r_click
    else: $Menu / ControlSettings / ChordLabel / Label.text = lr_click


func _on_safe_left_button_pressed() -> void :
    Main.db["safe_first_click"] -= 1
    if Main.db["safe_first_click"] == -1: Main.db["safe_first_click"] = 2
    update_safe_text()

func _on_safe_right_button_pressed() -> void :
    Main.db["safe_first_click"] += 1
    Main.db["safe_first_click"] = Main.db["safe_first_click"] %3
    update_safe_text()

func update_safe_text() -> void :
    if (Main.db["safe_first_click"] == 0): $Menu / GameplaySettings / FirstClickLabel / Label.text = ThreeByThreeG
    elif (Main.db["safe_first_click"] == 1): $Menu / GameplaySettings / FirstClickLabel / Label.text = OneG
    else: $Menu / GameplaySettings / FirstClickLabel / Label.text = NoG


func _on_legacy_button_pressed() -> void :
    $Menu / GameplaySettings / LegacyLabel / LegacyButton / OffOn.frame = ($Menu / GameplaySettings / LegacyLabel / LegacyButton / OffOn.frame + 1) % 2
    Main.db["legacy_time"] = !Main.db["legacy_time"]

func _on_legacy_2_button_pressed() -> void :
    $Menu / GameplaySettings / LegacyLabel2 / Legacy2Button / OffOn.frame = ($Menu / GameplaySettings / LegacyLabel2 / Legacy2Button / OffOn.frame + 1) % 2
    Main.db["legacy_10_speed"] = !Main.db["legacy_10_speed"]

func _on_window_button_pressed() -> void :
    get_tree().call_group("settings", "set_disabled", false)
    $Menu / WindowButton.set_disabled(true)
    get_tree().call_group("windows", "set_visible", false)
    $Menu / WindowSettings.set_visible(true)


func _on_volume_button_pressed() -> void :
    get_tree().call_group("settings", "set_disabled", false)
    $Menu / VolumeButton.set_disabled(true)
    get_tree().call_group("windows", "set_visible", false)
    $Menu / VolumeSettings.set_visible(true)


func _on_control_button_pressed() -> void :
    get_tree().call_group("settings", "set_disabled", false)
    $Menu / ControlButton.set_disabled(true)
    get_tree().call_group("windows", "set_visible", false)
    $Menu / ControlSettings.set_visible(true)


func _on_language_button_pressed() -> void :
    get_tree().call_group("settings", "set_disabled", false)
    $Menu / LanguageButton.set_disabled(true)
    get_tree().call_group("windows", "set_visible", false)
    $Menu / LanguageSettings.set_visible(true)


func _on_gameplay_button_pressed() -> void :
    get_tree().call_group("settings", "set_disabled", false)
    $Menu / GameplayButton.set_disabled(true)
    get_tree().call_group("windows", "set_visible", false)
    $Menu / GameplaySettings.set_visible(true)


func _on_other_button_pressed() -> void :
    get_tree().call_group("settings", "set_disabled", false)
    $Menu / OtherButton.set_disabled(true)
    get_tree().call_group("windows", "set_visible", false)
    $Menu / OtherSettings.set_visible(true)


func _on_exploding_button_pressed() -> void :
    $Menu / OtherSettings / ExplodingLabel / ExplodingButton / OffOn.frame = ($Menu / OtherSettings / ExplodingLabel / ExplodingButton / OffOn.frame + 1) % 2
    Main.db["exploding_mines"] = !Main.db["exploding_mines"]


func _on_spread_left_button_pressed() -> void :
    Main.db["zero_spread_algorithm"] -= 1
    if Main.db["zero_spread_algorithm"] == -1: Main.db["zero_spread_algorithm"] = 1
    update_spread_text()

func _on_spread_right_button_pressed() -> void :
    Main.db["zero_spread_algorithm"] += 1
    Main.db["zero_spread_algorithm"] = Main.db["zero_spread_algorithm"] %2
    update_spread_text()

func update_spread_text() -> void :
    if (Main.db["zero_spread_algorithm"] == 0): $Menu / OtherSettings / SpreadLabel / Label.text = it
    else: $Menu / OtherSettings / SpreadLabel / Label.text = rec


func _on_decor_left_button_pressed() -> void :
    Main.db["decor_density"] -= 1
    if Main.db["decor_density"] == -1: Main.db["decor_density"] = 3
    update_decor_text()


func _on_decor_right_button_pressed() -> void :
    Main.db["decor_density"] += 1
    Main.db["decor_density"] = Main.db["decor_density"] %4
    update_decor_text()

func update_decor_text() -> void :
    if (Main.db["decor_density"] == 0): $Menu / OtherSettings / DecorLabel / Label.text = none
    elif (Main.db["decor_density"] == 1): $Menu / OtherSettings / DecorLabel / Label.text = few
    elif (Main.db["decor_density"] == 2): $Menu / OtherSettings / DecorLabel / Label.text = some
    else: $Menu / OtherSettings / DecorLabel / Label.text = many


func _on_english_button_pressed() -> void :
    language_changed.emit(0)
func _on_spanish_button_pressed() -> void :
    language_changed.emit(1)
func _on_french_button_pressed() -> void :
    language_changed.emit(2)
func _on_portuguese_button_pressed() -> void :
    language_changed.emit(3)
func _on_polish_button_pressed() -> void :
    language_changed.emit(4)
func _on_russian_button_pressed() -> void :
    language_changed.emit(5)
func _on_korean_button_pressed() -> void :
    language_changed.emit(6)
func _on_thai_button_pressed() -> void :
    language_changed.emit(7)
func _on_turkish_button_pressed() -> void :
    language_changed.emit(8)

func translate(language):
    var code = Main.get_language_code(language)

    var file = FileAccess.open("res://text/translate_settings.txt", FileAccess.READ)
    var r = file.get_csv_line(",")
    var c = r.find(code)

    $Menu / WindowButton / Label.text = file.get_csv_line()[c]
    $Menu / VolumeButton / Label.text = file.get_csv_line()[c]
    $Menu / ControlButton / Label.text = file.get_csv_line()[c]
    $Menu / GameplayButton / Label.text = file.get_csv_line()[c]
    $Menu / LanguageButton / Label.text = file.get_csv_line()[c]
    $Menu / OtherButton / Label.text = file.get_csv_line()[c]

    $Menu / WindowSettings / WindowMode / WindowModeLabel.text = file.get_csv_line()[c]
    $Menu / WindowSettings / WindowMode / WindowedButton / ModeLabel.text = file.get_csv_line()[c]
    $Menu / WindowSettings / WindowMode / FullscreenButton / ModeLabel.text = file.get_csv_line()[c]
    $Menu / WindowSettings / StretchMode / WindowModeLabel.text = file.get_csv_line()[c]
    $Menu / WindowSettings / StretchMode / EnabledButton / ModeLabel.text = file.get_csv_line()[c]
    $Menu / WindowSettings / StretchMode / DisabledButton / ModeLabel.text = file.get_csv_line()[c]
    $Menu / WindowSettings / ScaleMode / WindowModeLabel.text = file.get_csv_line()[c]
    $Menu / WindowSettings / ScaleMode / FractionButton / ModeLabel.text = file.get_csv_line()[c]
    $Menu / WindowSettings / ScaleMode / IntegerButton / ModeLabel.text = file.get_csv_line()[c]
    $Menu / WindowSettings / AspectMode / WindowModeLabel.text = file.get_csv_line()[c]
    $Menu / WindowSettings / AspectMode / KeepButton / ModeLabel.text = file.get_csv_line()[c]
    $Menu / WindowSettings / AspectMode / IgnoreButton / ModeLabel.text = file.get_csv_line()[c]

    $Menu / VolumeSettings / MasterVolumeSlider / MasterVolumeLabel.text = file.get_csv_line()[c]
    $Menu / VolumeSettings / MusicVolumeSlider / MusicVolumeLabel.text = file.get_csv_line()[c]
    $Menu / VolumeSettings / SFXVolumeSlider / SFXVolumeLabel.text = file.get_csv_line()[c]

    $Menu / ControlSettings / ReverseLabel.text = file.get_csv_line()[c]
    l_click_to_open = file.get_csv_line()[c]
    r_click_to_open = file.get_csv_line()[c]
    if (Main.db["play_style"] == 0): $Menu / ControlSettings / ReverseLabel / Label.text = l_click_to_open
    else: $Menu / ControlSettings / ReverseLabel / Label.text = r_click_to_open
    $Menu / ControlSettings / HoldLabel.text = file.get_csv_line()[c]
    seconds = " " + file.get_csv_line()[c]
    $Menu / ControlSettings / HoldLabel / HoldTimeSlider / SecondsLabel.text = var_to_str(Main.db["hold_time"]) + seconds
    $Menu / ControlSettings / HoldLabel / HoldTimeSlider / HoldTimeLabel.text = file.get_csv_line()[c]
    $Menu / ControlSettings / ChordLabel.text = file.get_csv_line()[c]
    l_click = file.get_csv_line()[c]
    r_click = file.get_csv_line()[c]
    lr_click = file.get_csv_line()[c]
    update_chord_text()

    $Menu / GameplaySettings / FirstClickLabel.text = file.get_csv_line()[c]
    ThreeByThreeG = file.get_csv_line()[c]
    OneG = file.get_csv_line()[c]
    NoG = file.get_csv_line()[c]
    update_safe_text()
    $Menu / GameplaySettings / ChordingLabel.text = file.get_csv_line()[c]
    $Menu / GameplaySettings / AutoSonarLabel.text = file.get_csv_line()[c]
    $Menu / GameplaySettings / LegacyLabel.text = file.get_csv_line()[c]
    $Menu / GameplaySettings / LegacyLabel / Label.text = file.get_csv_line()[c]
    $Menu / GameplaySettings / LegacyLabel2.text = file.get_csv_line()[c]
    $Menu / GameplaySettings / LegacyLabel2 / Label.text = file.get_csv_line()[c]



    $Menu / LanguageSettings / Label.text = file.get_csv_line()[c]

    $Menu / OtherSettings / ExplodingLabel.text = file.get_csv_line()[c]
    $Menu / OtherSettings / DecorLabel.text = file.get_csv_line()[c]
    none = file.get_csv_line()[c]
    few = file.get_csv_line()[c]
    some = file.get_csv_line()[c]
    many = file.get_csv_line()[c]
    update_decor_text()

    $Menu / OtherSettings / SpreadLabel.text = file.get_csv_line()[c]
    it = file.get_csv_line()[c]
    rec = file.get_csv_line()[c]
    update_spread_text()
    $Menu / OtherSettings / SpreadLabel / Label2.text = file.get_csv_line()[c]

    file.close()


func _on_classic_button_pressed() -> void :
    if (Main.db["classic"] == 1):
        Main.db["classic"] = 0
        $Menu / OtherSettings / ClassicGrid / ClassicButton / OffOn.frame = 1
    else:
        Main.db["classic"] = 1
        $Menu / OtherSettings / ClassicGrid / ClassicButton / OffOn.frame = 0


func _on_mouse_button_pressed() -> void :
    Main.db["mouse_drag"] = !Main.db["mouse_drag"]
    if (Main.db["mouse_drag"]): $Menu / ControlSettings / MouseDragLabel / MouseButton / OffOn.frame = 1
    else: $Menu / ControlSettings / MouseDragLabel / MouseButton / OffOn.frame = 0


func _on_flag_button_pressed() -> void :
    Main.db["flag_click"] = !Main.db["flag_click"]
    if (Main.db["flag_click"]):
        $Menu / ControlSettings / FlagClickLabel / FlagButton / OffOn.frame = 1
        $Menu / ControlSettings / FlagClickLabel / Label.text = click
    else:
        $Menu / ControlSettings / FlagClickLabel / FlagButton / OffOn.frame = 0
        $Menu / ControlSettings / FlagClickLabel / Label.text = click_release

func _on_instant_button_pressed() -> void :
    Main.db["instant_zero_spread"] = !Main.db["instant_zero_spread"]
    if (Main.db["instant_zero_spread"]): $Menu / GameplaySettings / InstantLabel / InstantButton / OffOn.frame = 1
    else: $Menu / GameplaySettings / InstantLabel / InstantButton / OffOn.frame = 0


func _on_instant_boat_button_pressed() -> void :
    Main.db["instant_boat_travel"] = !Main.db["instant_boat_travel"]
    if (Main.db["instant_boat_travel"]): $Menu / OtherSettings / InstantBoatLabel / InstantBoatButton / OffOn.frame = 1
    else: $Menu / OtherSettings / InstantBoatLabel / InstantBoatButton / OffOn.frame = 0


func _on_shake_button_pressed() -> void :
    Main.db["screen_shake"] = !Main.db["screen_shake"]
    if (Main.db["screen_shake"]): $Menu / OtherSettings / ScreenShake / ShakeButton / OffOn.frame = 1
    else: $Menu / OtherSettings / ScreenShake / ShakeButton / OffOn.frame = 0


func _on_flash_button_pressed() -> void :
    Main.db["flashing_lights"] = !Main.db["flashing_lights"]
    if (Main.db["flashing_lights"]): $Menu / OtherSettings / FlashingLights / FlashButton / OffOn.frame = 1
    else: $Menu / OtherSettings / FlashingLights / FlashButton / OffOn.frame = 0


func _on_graphics_button_pressed() -> void :
    Main.db["graphics_quality"] = !Main.db["graphics_quality"]
    if (Main.db["graphics_quality"]): $Menu / OtherSettings / GraphicsLabel / GraphicsButton / OffOn.frame = 1
    else: $Menu / OtherSettings / GraphicsLabel / GraphicsButton / OffOn.frame = 0
