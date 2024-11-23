#SingleInstance, force
if (A_ScreenDPI*100//96 != 100) {
	Run, ms-settings:display
	msgbox, 0x1030, WARNING!!, % "Your Display Scale seems to be a value other than 100`%. This means the macro will NOT work correctly!`n`nTo change this, right click on your Desktop -> Click 'Display Settings' -> Under 'Scale & Layout', set Scale to 100`% -> Close and Restart Roblox before starting the macro.", 60
	ExitApp
}
If !FileExist("Settings.ini") {
	Msgbox,,Fisch Macro,You don't have a settings file yet. Would you like to create one? Press OK to proceed
	IniWrite, 0.05, Settings.ini, Fisch, Control 
}
IniRead, Control, Settings.ini, Fisch, Control 
If (Control = "ERROR") {
	IniWrite, 0.05, Settings.ini, Fisch, Control 
	Control := "0.05"
}
Control := StrSplit(Control, "|")
If (Control[2]) {
	Msgbox The control settings are outdated.`nRestored the settings to their default values.
	IniWrite, 0.05, Settings.ini, Fisch, Control 
	ExitApp
}
Control := Floor(96+(Control[1]*326.67)) ; calculating the catch bar size pretty pro right
Tooltip % Control
If (!Control) {
	Msgbox, Failed to retrieve control from settings.ini
	ExitApp
}
if GetRobloxHWND() {
	x := A_ScreenWidth
	y := A_ScreenHeight
	WinActivate, ahk_exe RobloxPlayerbeta.exe
	WinMove, ahk_exe RobloxPlayerBeta.exe,, x/2-408, y/2-408, 100, 100
} else {
	Msgbox Roblox need to be opened
	ExitApp
}
Reels()
Timer := A_TickCount
Loop,
{
	Send {down}{enter}
	If (A_TickCount - Timer >= 40000) { 
		Reels()
		Timer := A_TickCount
	}
	PixelSearch,,, 246, 533, 569, 533, 0xf1f1f1, 20, FastRGB
	if (ErrorLevel = 0) {
		PixelSearch,,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB 
		If (ErrorLevel = 0) {
			MouseMove, 100, 400
			Loop
			{
				PixelSearch,,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
				if (ErrorLevel = 1) {
					Reels()
					tooltip
					Timer := A_TickCount
					Break
				}
				PixelSearch,,, 246, 533, 569, 533, 0xf1f1f1, 20,FastRGB
				If (ErrorLevel = 0) { 
					Loop
					{
						PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
						If (ErrorLevel = 1) {
							Break
						} else {
							If (CurrentTarget <= (Control + 247 - 10)) {
								Sleep 40
								tooltip go left
							} else If (CurrentTarget >= (568 - Control + 10)) {
								Click, Down
								tooltip go right
								Loop
								{
									Tooltip, % A_Index
									PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
									If (ErrorLevel = 0) {
										If (CurrentTarget <= (568 - Control)) {
											Break
										}
									} else {
										Break
									}
								}
								Click, Up
								AtRight := True
							} else {
								PixelSearch, CurrentBarPosition,, 246, 533, 569, 533, 0xf1f1f1, 20,FastRGB ; calculation stuff
								If (ErrorLevel = 0) {
									PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
									CurrentBarPosition := CurrentBarPosition + (Control / 2)
									Distance := CurrentTarget - CurrentBarPosition
									Percentage := (Distance / Control) * 100
									Tooltip % Percentage "x" Distance "x" CurrentBarPosition
									if (Percentage >= 0) {
										Val := Floor(140 + ((440 - 140) * (Percentage / 100)))
										tooltip % Val
										If (Val = 0) {
											Reels(30)
										} else {
											Reels(Val)
										}
									} else {
										Val := 0 + ((100 - 0) * (Percentage / 100))
										Val := Floor((-1 * Val))
										if (Val < 30) {
											tooltip, i'd click
											Reels(30)
										} else {
											tooltip % Val - 30 " sleeptime"
											Sleep % Val - 30
										}
									}
								} else {
									Break
								}
							}
						}
					}
					PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
					If (CurrenTarget > 408) {
						AtRight := True
					}
				} else {
					PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
					If (ErrorLevel = 0) {
						If (CurrentTarget <= (Control + 247)) {
							Sleep 40
							tooltip go left
						} else If (CurrentTarget >= (568 - Control - 10)) {
							Click, Down
							tooltip go right
							Loop
							{
								Tooltip, % A_Index " 2"
								PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
								If (ErrorLevel = 0) {
									If (CurrentTarget <= (568 - Control + 10)) {
										Break
									}
								} else {
									Break
								}
							}
							Click, Up
						} else {
							If (AtRight and (CurrentTarget >= 408)) {
								Sleep 100
								AtRight := false
							} else {
								Tooltip, i reel 300
								Reels(300, True)
							}
						}

						PixelSearch, CurrentTarget,, 246, 533, 569, 533, 0x434b5b, 3, FastRGB
						If (CurrenTarget > 408) {
							AtRight := True
						}
					}
				}
			}
		}
	}
}
ExitApp
$Space::ExitApp
Reels(x := 0, Stop := false) {
	If (!x) {
		Sleep 2000
		Click, Down, 100, 400
		Sleep 2000
		Click, Up, 100, 400
		Sleep 2000
		Send \
		Return True
	}
	Click, Down
	Timer := A_TickCount
	Loop
	{
		If (Stop) {
			PixelSearch,,, 246, 533, 569, 533, 0xf1f1f1, 20, FastRGB
			If (ErrorLevel = 0) {
				Whitebar := true
				Break
			}
		}
		If (A_TickCount - Timer >= x) {
			Break
		}
	}
	Click, Up
	Return % Whitebar
}
GetRobloxHWND() {
	if (hwnd := WinExist("Roblox ahk_exe RobloxPlayerBeta.exe"))
		return hwnd
} ; yoooo fire macro with 200 line???
