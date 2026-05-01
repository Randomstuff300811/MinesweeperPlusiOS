extends PopupPanel

var ruleset = -1
var special_pages = 7
var default = "How to play Minesweeper Plus:\n\nClick 'Basic Gameplay' to learn how Minesweeper is played.\nClick 'Special Rules' to see how Minesweeper Plus differs from the classic game.\nClick outside this window at any time to close it."





var text = [
    [
"Every game of Minesweeper starts with a grid like the example in the image. The objective of the game is to open every tile on the grid that does NOT contain a mine.", 
"This number indicates how many mines are hidden on the grid.", 
"This number keeps track of the number of seconds that have elapsed from the start of the game to the end of the game.", 
"Left-click on any tile to start the game. Left-clicking on a tile opens it and reveals what is underneath. Numbered tiles indicate how many mines are contained in the 8 adjacent tiles around the numbered tile. For example, a tile containing '1' has 1 mine adjacent to it, a tile containing '2' has 2 mines adjacent to it, etc. If a tile has nothing under it when opened, all tiles adjacent to that tile will be opened as well.", 
"If you think you know a tile contains a mine, you can flag that tile by right-clicking it. Flagged tiles cannot be opened and are great for keeping track of where mines are. The number at the top-left of the screen will decrease for every flag you place. Be careful: you can also flag tiles that don't contain mines. Remove a flag from a tile by right-clicking it again.", 
"Chording: Clicking on an opened numbered tile when it has the corresponding number of flags around it will open all of the unopened and unflagged tiles around it. Chording is useful for players who want to improve their minesweeping efficiency. Warning: doing this will also reveal any unflagged mines. Only use when you're certain you haven't made any flagging mistakes.", 
"The game ends when a mine is revealed or every tile that does not contain a mine has been opened. If you're able to open every tile on the grid without revealing a mine, you win! \nNote: Flagging tiles is optional. You do not need to flag every mine to win."\
, 
"Click on the smiley face any time during the game to pause the game and open the pause menu. You can reset the current game or exit the current game from the pause menu. Click on the smiley face again to close the pause menu and unpause the game"
    ], 
[
"While the classic version of Minesweeper doesn't allow any mistakes, Minesweeper Plus allows you to reveal three mines before it's game over. This gauge shows you your remaining health. If the dial is in the red, that means you only have one more strike before you're out.", 
"Winning a game of Minesweeper rewards you with Minecoins. The more challenging the level, the more Minecoins you will win upon completing the level.", 
"You can spend the Minecoins you collect to use the sonar. The sonar costs 50 Minecoins to use, and 50 more Minecoins for every time you use it during a level. Activate the sonar by toggling the OFF/ON switch. Click any tile while the sonar is active to see what it contains for 3 seconds. The sonar automatically deactivates after one use, or you can deactivate it without using it by toggling the OFF/ON switch again.", 
"If you would prefer to play the game with classic rules (zero mistakes, no sonar), you can toggle master mode on and off by clicking the face icon on the game select screen. You will also earn more Minecoins while playing on master mode.", 
"There are two modes of play. In 'Free Play', you can create a custom Minesweeper level and play as much as you want with no gameplay restrictions. Toggling the practice mode button in Free Play will allow you to play a Minesweeper practice stage. In practice mode, clicking on mines has no consequences and the sonar is free to use, but no Minecoins are gained upon clearing.", 
"In 'Minesweeper Adventure', you must complete 8 Minesweeper levels in a row with limited resources. You start the adventure with 100 Minecoins. Health is not restored upon completing a level. If you fail, you can choose to continue your game if you have enough Minecoins to spend and start from the beginning of the level. If not, it's game over. The number of Minecoins you end with will be added to your total.", 
"Saving and exiting from the adventure will create a quick save. Click on the 'CONTINUE' button on the game select screen to continue from where you left off. Starting a new adventure will overwrite any existing adventure data. At the end of the adventure, you will be ranked according to how well you performed.", 
"As of version 2, you now have the ability to zoom in on larger Minesweeper grids. Scroll the mouse wheel up to zoom in and scroll the mouse wheel down to zoom out. Hold down the middle mouse button while zoomed in to pan the camera around. You can also pan the camera using the arrow keys or WASD keys.\n\nYou can also now play Episode 2 of Minesweeper Adventure. Episode 2 is more difficult than Episode 1, so the sonar cost has been slightly reduced, and you can acquire shields that will be used up in place of your health if you make a mistake.", 
"There is a boss battle in this game. The battle works the same as normal Minesweeper, but with some key distinctions: you won't know the number of mines hidden on the grid, you have limited time to complete the level, and you won't be able to use the sonar or pause the game. Clicking on a mine will make the time run out faster. To win, you must click on the boss ONLY AFTER revealing all the tiles that don't contain mines. If the timer hits 0, or you click on the boss before revealing the entire grid, it's game over.", 
"There is another boss battle in this game. As soon as the game starts, this boss will start counting down from 10. If it counts all the way down to 0, it's game over. Click on the boss to reset the countdown back to 10, but be careful. The boss will move faster and faster every time you click on it. Clicking on a mine will cause the boss to count down more quickly. To win, reveal the entire grid before the boss is able to finish its countdown.", 
"There is yet another boss battle in this game. The top left number now shows how many more tiles are allowed to be flagged before it's game over. The boss will teleport around the grid placing flags. If you can click the boss before it materializes, you can prevent it from placing a flag, but don't click the boss when its electrical coils are active or you will receive a penalty. Unflagging tiles before the game starts will also result in a penalty. Furthermore, the mines in this boss's grid are pressure mines. Do not remove flags from tiles that contain pressure mines. The boss will place many flags in quick succession if a mine is revealed. To win, reveal the entire grid before the flag counter reaches 0, or before no more flags can be placed on the grid."
    ]
]


func _ready() -> void :
    if (Main.db["nine_seen"] == true):
        special_pages += 1
    if (Main.db["ten_seen"] == true):
        special_pages += 1
    if (Main.db["eleven_seen"] == true):
        special_pages += 1
    $Control / ILabel.text = default



func _process(_delta: float) -> void :
    pass


func _on_basic_button_pressed() -> void :
    ruleset = 0
    $Control / BasicButton.visible = false
    $Control / SpecialButton.visible = false
    $Control / Image0.visible = true
    $Control / NextButton.visible = true
    $Control / Back.visible = true
    $Control / ILabel.text = text[ruleset][$Control / Image0.frame]


func _on_special_button_pressed() -> void :
    ruleset = 1
    $Control / BasicButton.visible = false
    $Control / SpecialButton.visible = false
    $Control / Image1.visible = true
    $Control / NextButton.visible = true
    $Control / Back.visible = true
    $Control / ILabel.text = text[ruleset][$Control / Image1.frame]


func _on_next_button_pressed() -> void :
    $Control / NextButton.visible = true
    $Control / BackButton.visible = true

    get_node("Control/Image" + var_to_str(ruleset)).frame += 1
    $Control / ILabel.text = text[ruleset][get_node("Control/Image" + var_to_str(ruleset)).frame]
    if ((ruleset == 0 && get_node("Control/Image" + var_to_str(ruleset)).frame == 7)
    || (ruleset == 1 && get_node("Control/Image" + var_to_str(ruleset)).frame == special_pages)):
        $Control / NextButton.visible = false



func _on_back_button_pressed() -> void :
    $Control / NextButton.visible = true
    $Control / BackButton.visible = true

    get_node("Control/Image" + var_to_str(ruleset)).frame -= 1
    $Control / ILabel.text = text[ruleset][get_node("Control/Image" + var_to_str(ruleset)).frame]
    if (get_node("Control/Image" + var_to_str(ruleset)).frame == 0):
        $Control / BackButton.visible = false


func _on_back_pressed() -> void :
    ruleset = -1
    $Control / BasicButton.visible = true
    $Control / SpecialButton.visible = true
    $Control / Image0.visible = false
    $Control / Image1.visible = false
    $Control / Image0.frame = 0
    $Control / Image1.frame = 0
    $Control / ILabel.text = default
    $Control / NextButton.visible = false
    $Control / BackButton.visible = false
    $Control / Back.visible = false


func _on_popup_hide() -> void :
    _on_back_pressed()

func translate(language) -> void :
    var code = Main.get_language_code(language)

    var file = FileAccess.open("res://text/translate_howtoplay.txt", FileAccess.READ)
    var r = file.get_csv_line(",")
    var c = r.find(code)





    $Control / BasicButton / Label.text = file.get_csv_line()[c]
    $Control / SpecialButton / Label.text = file.get_csv_line()[c]
    $Control / Back / Label.text = file.get_csv_line()[c]
    default = file.get_csv_line()[c]
    $Control / ILabel.text = default
    text = [
    [
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c]
        ], 
    [
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    file.get_csv_line()[c], 
    "There is yet another boss battle in this game. The top left number now shows how many more tiles are allowed to be flagged before it's game over. The boss will teleport around the grid placing flags. If you can click the boss before it materializes, you can prevent it from placing a flag, but don't click the boss when its electrical coils are active or you will receive a penalty. Unflagging tiles before the game starts will also result in a penalty. Furthermore, the mines in this boss's grid are pressure mines. Do not remove flags from tiles that contain pressure mines. The boss will place many flags in quick succession if a mine is revealed. To win, reveal the entire grid before the flag counter reaches 0, or before no more flags can be placed on the grid."
        ]
    ]

    file.close()
