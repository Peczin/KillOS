; terminal.asm - Terminal simples para KillOS
[org 0x7C00]
[bits 16]

start:
    call clear_screen
    call show_banner

main_loop:
    call show_prompt
    call read_input
    call parse_command
    jmp main_loop

; -------------------------------------------------
; Funções auxiliares
; -------------------------------------------------

clear_screen:
    mov ah, 0x0
    mov al, 0x03
    int 0x10
    ret

show_banner:
    mov si, banner
.print_banner:
    lodsb
    or al, al
    jz .done
    call print_char
    jmp .print_banner
.done:
    ret

show_prompt:
    mov si, prompt
.print_prompt:
    lodsb
    or al, al
    jz .done
    call print_char
    jmp .print_prompt
.done:
    ret

; -------------------------------------------------
; Leitura de linha do usuário
; -------------------------------------------------

read_input:
    mov di, input_buffer
.read_char:
    mov ah, 0x00
    int 0x16
    cmp al, 0x0D ; Enter
    je .end
    call print_char
    stosb
    jmp .read_char
.end:
    mov al, 0
    stosb
    ret

; -------------------------------------------------
; Impressão de caractere
; -------------------------------------------------

print_char:
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    ret

; -------------------------------------------------
; Comparação e execução de comandos
; -------------------------------------------------

parse_command:
    mov si, input_buffer

    ; Comando: help
    mov di, cmd_help
    call strcmp
    cmp al, 1
    je do_help

    ; Comando: about
    mov di, cmd_about
    call strcmp
    cmp al, 1
    je do_about

    ; Comando: clear
    mov di, cmd_clear
    call strcmp
    cmp al, 1
    je do_clear

    ; Comando: halt
    mov di, cmd_halt
    call strcmp
    cmp al, 1
    je do_halt

    ; Comando: date
    mov di, cmd_date
    call strcmp
    cmp al, 1
    je do_date

    ; Comando desconhecido
    mov si, unknown_cmd
    call print_string
    ret

do_help:
    mov si, help_text
    call print_string
    ret

do_about:
    mov si, about_text
    call print_string
    ret

do_clear:
    call clear_screen
    ret

do_halt:
.hang: jmp .hang

do_date:
    mov si, date_msg
    call print_string
    ret

; -------------------------------------------------
; Função de comparar strings (strcmp)
; Retorna AL = 1 se iguais, 0 se diferentes
; -------------------------------------------------

strcmp:
.loop:
    lodsb
    scasb
    jne .fail
    or al, al
    jnz .loop
    mov al, 1
    ret
.fail:
    mov al, 0
    ret

; -------------------------------------------------
; Impressão de strings terminadas em zero
; -------------------------------------------------

print_string:
    lodsb
    or al, al
    jz .done
    call print_char
    jmp print_string
.done:
    ret

; -------------------------------------------------
; Dados
; -------------------------------------------------

banner db 'KillOS Terminal v0.1', 0x0D, 0x0A, 0
prompt db 0x0A, 'KOS > ', 0
unknown_cmd db 'Comando invalido.', 0x0D, 0x0A, 0
help_text db 'Comandos: help, about, clear, date, halt', 0x0D, 0x0A, 0
about_text db 'KillOS by Lucas, 2025.', 0x0D, 0x0A, 0
date_msg db 'Data: 20/07/2025', 0x0D, 0x0A, 0

cmd_help db 'help', 0
cmd_about db 'about', 0
cmd_clear db 'clear', 0
cmd_halt db 'halt', 0
cmd_date db 'date', 0

input_buffer times 128 db 0

times 510 - ($ - $$) db 0
dw 0xAA55
