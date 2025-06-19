format PE console
entry start

include 'win32a.inc'

section '.data' data readable writeable
    targetLetter db 'G'                     ; The letter to guess
    msgPrompt    db 'Guess the letter (A-Z): ', 0
    msgSuccess   db 13,10,'You guessed it!',13,10,0
    msgTries     db 'Number of tries: %d',13,10,0
    msgPause     db 13,10,'Press Enter to exit...',0
    tryCount     dd 0
    userInput    db 100 dup(0)

section '.code' code readable executable

start:
guess_loop:
    inc [tryCount]                          ; Increment try counter

    push msgPrompt
    call [printf]

    push userInput
    call [gets]                             ; Read input string

    mov al, [userInput]                     ; Get first char of input
    cmp al, [targetLetter]
    jne guess_loop                          ; If not correct, try again

    push msgSuccess
    call [printf]

    push [tryCount]
    push msgTries
    call [printf]

    push msgPause
    call [printf]

    call [getchar]                          ; Wait for Enter key

    call [ExitProcess]

section '.idata' import data readable
    library msvcrt, 'msvcrt.dll', \
            kernel32, 'kernel32.dll'

    import msvcrt, \
           printf, 'printf', \
           gets, 'gets', \
           getchar, 'getchar'

    import kernel32, \
           ExitProcess, 'ExitProcess'
