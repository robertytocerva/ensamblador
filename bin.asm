.MODEL SMALL
.STACK 
.DATA
    prompt db 10,13,'Ingrese cadena: $'
    error_msg db 10,13,'Error en la cadena no se puede transformar a decimal y a caracter. $'
    result_msg db 10,13,'Caracter: $'
    exit_msg db 10,13,'¿Desea salir? (S/N): $'
    buffer db 9 dup('$') ; Buffer para almacenar la cadena ingresada (8 dígitos + 1 para el fin de cadena)
    char db ? ; Variable para almacenar el carácter resultante

; Macro para imprimir una cadena


.CODE
MAIN PROC
    mov ax, @data
    mov ds, ax

    PRINT_STRING MACRO msg
    mov ah, 09h
    lea dx, msg
    int 21h
ENDM

; Macro para leer una cadena desde el teclado
READ_STRING MACRO buffer
    mov ah, 0Ah
    lea dx, buffer
    int 21h
ENDM

; Macro para convertir una cadena binaria a decimal
BIN_TO_DEC MACRO bin_str, result
    LOCAL bin_loop, end_loop, invalid_char
    xor ax, ax ; Limpiar AX
    xor bx, bx ; Limpiar BX
    mov cx, 8 ; Contador para 8 bits
    mov si, bin_str ; Cargar la dirección de la cadena binaria en SI

bin_loop:
    lodsb ; Cargar el siguiente byte de la cadena en AL
    cmp al, '0' ; Verificar si es '0'
    je valid_char
    cmp al, '1' ; Verificar si es '1'
    je valid_char
    jmp invalid_char ; Si no es '0' o '1', salta a error

valid_char:
    sub al, '0' ; Convertir el carácter a su valor numérico (0 o 1)
    shl bx, 1 ; Desplazar BX a la izquierda (multiplicar por 2)
    add bx, ax ; Sumar el valor actual a BX
    loop bin_loop ; Repetir hasta que CX sea 0

    mov result, bl ; Guardar el resultado en la variable result
    jmp end_loop

invalid_char:
    mov result, 0FFh ; Marcar como inválido (0FFh es un valor que no es un carácter ASCII válido)

end_loop:
ENDM

start_program:
    ; Mostrar el mensaje para ingresar la cadena
    PRINT_STRING prompt

    ; Leer la cadena desde el teclado
    READ_STRING buffer

    ; Verificar si la cadena tiene exactamente 8 caracteres
    cmp [buffer + 1], 8
    jne invalid_input

    ; Convertir la cadena binaria a decimal
    lea si, buffer + 2 ; Cargar la dirección de la cadena binaria en SI
    BIN_TO_DEC si, char ; Llamar a la macro con la dirección correcta

    ; Verificar si la conversión fue válida
    cmp char, 0FFh
    je invalid_input

    ; Mostrar el resultado
    PRINT_STRING result_msg
    mov dl, char
    mov ah, 02h
    int 21h
    jmp ask_exit

invalid_input:
    ; Mostrar mensaje de error
    PRINT_STRING error_msg

ask_exit:
    ; Preguntar al usuario si desea salir
    PRINT_STRING exit_msg
    mov ah, 01h
    int 21h
    cmp al, 'S'
    je exit_program
    cmp al, 's'
    je exit_program
    jmp start_program ; Repetir el programa

exit_program:
    ; Salir del programa
    mov ah, 4Ch
    int 21h
MAIN ENDP
END MAIN