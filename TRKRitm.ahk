SendMessage, 0x50,, 0x4190419,, A
FileDelete, %A_Temp%/updt.ahk
FileDelete, %A_Temp%/verlen.ini
buildscr = 6



downlurl = https://raw.githubusercontent.com/SergeySander/updater/master/updt.ahk
downllen = https://raw.githubusercontent.com/SergeySander/updater/master/verlen.ini
Utf8ToAnsi(ByRef Utf8String, CodePage = 1251)
{
If (NumGet(Utf8String) & 0xFFFFFF) = 0xBFBBEF
BOM = 3
Else
BOM = 0
UniSize := DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
, "UInt", &Utf8String + BOM, "Int", -1
, "Int", 0, "Int", 0)
VarSetCapacity(UniBuf, UniSize * 2)
DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
, "UInt", &Utf8String + BOM, "Int", -1
, "UInt", &UniBuf, "Int", UniSize)
AnsiSize := DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
, "UInt", &UniBuf, "Int", -1
, "Int", 0, "Int", 0
, "Int", 0, "Int", 0)
VarSetCapacity(AnsiString, AnsiSize)
DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
, "UInt", &UniBuf, "Int", -1
, "Str", AnsiString, "Int", AnsiSize
, "Int", 0, "Int", 0)
Return AnsiString
}
WM_HELP(){
IniRead, vupd, %A_Temp%/verlen.ini, UPD, v
IniRead, desupd, %A_Temp%/verlen.ini, UPD, des
desupd := Utf8ToAnsi(desupd)
IniRead, updupd, %A_Temp%/verlen.ini, UPD, upd
updupd := Utf8ToAnsi(updupd)
updupd := Utf8ToAnsi(updupd)
msgbox, , Список изменений версии %vupd%, %updupd%
return
}
OnMessage(0x53, "WM_HELP")
Gui +OwnDialogs
SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nПроверяем наличие обновлений.
URLDownloadToFile, %downllen%, %A_Temp%/verlen.ini
IniRead, buildupd, %A_Temp%/verlen.ini, UPD, build
if buildupd =
{
SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОшибка. Нет связи с сервером.
sleep, 2000
}
if buildupd > % buildscr
{
IniRead, vupd, %A_Temp%/verlen.ini, UPD, v
SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОбнаружено обновление до версии %vupd%!
sleep, 2000
IniRead, desupd, %A_Temp%/verlen.ini, UPD, des
IniRead, updupd, %A_Temp%/verlen.ini, UPD, upd
SplashTextoff
msgbox, 1, Обновление скрипта до версии %vupd%, Обновиться ?
IfMsgBox OK
{
put2 := % A_ScriptFullPath
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\AHK ,put2 , % put2
SplashTextOn, , 60,Автообновление, Обновление. Ожидайте..`nОбновляем скрипт до версии %vupd%!
URLDownloadToFile, %downlurl%, %A_Temp%/updt.ahk
sleep, 1000
FileRead, Src, %A_Temp%/updt.ahk ; Читаем Utf8.
Ansi := Utf8ToAnsi(Src)  ; Преобразуем в Ansi.
FileAppend, %Ansi%, %A_Temp%/updt.ahk  ; Сохраняем.
run, %A_Temp%/updt.ahk
exitapp
}
IfMsgBox Cancel
{
SplashTextOn, , 60,Автообновление, Ну и ладно.`nОбновление обязательное...`nAHK не запуститься.
sleep 1500
exitapp
}
}
SplashTextoff
