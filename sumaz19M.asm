.MODEL small
.STACK 100h
.data
    msgBienvenida db 10,13, "Ingresa un numero del 1 al 9:  $"
    msgError db 10,13, "Error: El numero no es valido. Debe ser del 1 al 9.$"
    msgResultado db 10,13, "La suma es: $"
    resultado db ?  
.code
macroMsg MACRO msg
    mov ah, 09h
    lea dx, msg
    int 21h
ENDM

leer_numero MACRO
    mov ah, 01h
    int 21h
    sub al, '0'

    cmp al, 1
    jb numero_invalido
    cmp al, 9
    ja numero_invalido

    mov bl, al
    jmp finMacro

    numero_invalido:
    macroMsg msgError
    mov ax, 4C00H
    int 21h

    finMacro:
ENDM


suma_descendente MACRO numero
    xor ax, ax       
    mov cl, numero   
suma_loop:
    add ax, cx       
    dec cx           
    jnz suma_loop 
    mov resultado, ax   
ENDM

imprimir_numero MACRO numero
    push ax          ; Guardar AX en la pila
    xor ah, ah       ; Limpiar AH para la impresión
    mov bl, 10       ; Divisor para convertir a decimal
    xor dx, dx       ; Limpiar DX antes de la división
    div bl           ; Dividir AL entre 10, cociente en AL, residuo en AH

    mov bl, ah
    cmp al, 0        ; Verificar si el cociente es cero
    je solo_unidad   ; Si es cero, solo imprimir la unidad
    add al, '0'      ; Convertir a ASCII
    mov dl, al       ; Mover el cociente a DL para imprimir
    mov ah, 02h      ; Función para imprimir carácter
    int 21h          ; Imprimir el cociente

solo_unidad:
    mov ah, bl       ; Mover el residuo a AH
    add ah, '0'      ; Convertir el residuo a ASCII
    mov dl, ah       ; Mover el residuo a DL para imprimir
    mov ah, 02h      ; Función para imprimir carácter
    int 21h          ; Imprimir el residuo
    pop ax           ; Recuperar AX de la pila
ENDM

main PROC 
    mov ax, @data
    mov ds, ax

    macroMsg msgBienvenida

    leer_numero       

    suma_descendente bl 

    macroMsg msgResultado

    imprimir_numero ax

    mov ax, 4C00H
    int 21h

main ENDP

end main
