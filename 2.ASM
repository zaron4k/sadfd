format PE GUI 4.0
entry start
include 'D:\FASM\INCLUDE\win32a.inc'

section '.code' code readable executable
start:
    invoke GetModuleHandle, 0
    invoke DialogBoxParam, eax, 1, HWND_DESKTOP, DialogProc, 0
    invoke ExitProcess, 0

proc DialogProc, hwnddlg, msg, wparam, lparam
    xor eax, eax
    cmp [msg], WM_CLOSE
    je FreeDialog
    cmp [msg], WM_COMMAND
    jne ExitProc

    mov eax, BN_CLICKED
    shl eax, 10h
    add eax, 3
    cmp [wparam], eax
    jne ExitProc

    invoke GetDlgItemText, [hwnddlg], 2, text, 20h
    invoke MessageBox, [hwnddlg], text, text, MB_OK
    ret

FreeDialog:
    invoke EndDialog, [hwnddlg], 0

ExitProc:
    ret
endp

section '.bss' readable writeable
text rb 20h

section '.idata' import data readable writeable
library kernel, 'KERNEL32.DLL', user, 'USER32.DLL'

import kernel, \
    GetModuleHandle, 'GetModuleHandleA', \
    ExitProcess, 'ExitProcess'

import user, \
    DialogBoxParam, 'DialogBoxParamA', \
    EndDialog, 'EndDialog', \
    MessageBox, 'MessageBoxA', \
    GetDlgItemText, 'GetDlgItemTextA'

section '.rsrc' resource data readable
directory RT_DIALOG, dialogs
resource dialogs, 1, LANG_NEUTRAL, WorkWithEdit

dialog WorkWithEdit, 'Work with Editclass', 0, 0, 150, 50, WS_CAPTION + WS_SYSMENU + DS_CENTER
    dialogitem 'Edit', '', 2, 10, 10, 130, 12, WS_VISIBLE + WS_BORDER
    dialogitem 'Button', 'Show text', 3, 45, 25, 50, 15, WS_VISIBLE
enddialog


