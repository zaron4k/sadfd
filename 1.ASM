format PE GUI 4.0
entry start
include 'D:\FASM\INCLUDE\win32A.inc'
;Перечень идентификаторов диалогового окна кнопки
ID_DIALOG = 1
ID_BUTTON = 2
section '.code' code readable executable
start:
invoke GetModuleHandle, 0
invoke DialogBoxParam, eax, ID_DIALOG, HWND_DESKTOP, DialogProc, 0
invoke ExitProcess, 0
proc DialogProc, hwnddlg, msg, wParam, lParam
cmp [msg], WM_CLOSE



;Если получено сообщение WM_CLOSE, то переходим к уничтожению окна
je FreeDialog
;Если это не «нажатие на кнопку», то выходим из процедуры
cmp [msg], WM_COMMAND
jne ExitProc
mov eax, BN_CLICKED
shl eax, 10h
add eax, ID_BUTTON
cmp [wParam], eax
jne ExitProc
;Определяем текущее количество нажатий на кнопку
invoke GetDlgItemInt, [hwnddlg], ID_BUTTON, _Translated, FALSE
;Увеличиваем это количество на единицу
inc eax
;Записываем новое количество в заголовок кнопки
invoke SetDlgItemInt, [hwnddlg], ID_BUTTON, eax, FALSE
jmp ExitProc
FreeDialog:
invoke EndDialog, [hwnddlg], 0
ExitProc:
xor eax, eax
ret
endp
section '.idata' data readable writeable
_Translated: db TRUE
data import
library kernel, 'KERNEL32.DLL',\
user, 'USER32.DLL'
import kernel,\
ExitProcess, 'ExitProcess',\
GetModuleHandle , 'GetModuleHandleA'
import user,\
DialogBoxParam , 'DialogBoxParamA',\
EndDialog , 'EndDialog' ,\
GetDlgItemInt , 'GetDlgItemInt' ,\
SetDlgItemInt , 'SetDlgItemInt'
end data
section '.rsrc' data resource readable
directory RT_DIALOG, dlg
resource dlg, ID_DIALOG, LANG_NEUTRAL, MainWindow
dialog MainWindow, '---', 100, 100, 100, 50, WS_VISIBLE+WS_CAPTION+WS_SYSMENU+DS_CENTER
dialogitem 'BUTTON', '0', ID_BUTTON, 25, 10, 50, 30, WS_VISIBLE
enddialog