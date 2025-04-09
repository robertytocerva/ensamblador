.MODEL small
.STACK 100h
.data
    msgBienvenida db 10,13, "Ingresa un numero del 1 al 9:  $"
    msgError db 10,13, "Error: El numero no es valido. Debe ser del 1 al 9.$"
    msgResultado db 10,13, "El factorial es: $"
    resultado dw ?  ; Variable para guardar el resultado (16 bits)
.code
main PROC 
    mov ax, @data
    mov ds, ax

    ; Mostrar mensaje de bienvenida
    mov ah, 09h
    lea dx, msgBienvenida
    int 21h

    ; Leer un número del usuario
    call leer_numero

    ; Verificar si el número es válido (1-9)
    cmp al, 1
    jb numero_invalido
    cmp al, 9
    ja numero_invalido

    ; Calcular el factorial
    mov bl, al
    call factorial

    ; Guardar el resultado (que está en AX)
    mov resultado, ax

    ; Mostrar mensaje de resultado
    mov ah, 09h
    lea dx, msgResultado
    int 21h

    ; Mostrar el resultado (AX ya contiene el factorial)
    call imprimir_numero

    ; Terminar el programa
    mov ax, 4C00H
    int 21h

numero_invalido:
    mov ah, 09h
    lea dx, msgError
    int 21h
    mov ax, 4C00H
    int 21h
main ENDP

leer_numero PROC
    mov ah, 01h
    int 21h
    sub al, '0'
    ret
leer_numero ENDP

factorial PROC
    mov cl, bl
    mov ax, 1  ; Usamos AX en lugar de AL para resultados de 16 bits
factorial_loop: 
    mul cl     ; AX = AX * CL
    dec cl
    jnz factorial_loop
    ret
factorial ENDP

imprimir_numero PROC
  push ax ; Guardar AX en la pila
        xor ah, ah ; Limpiar AH para la impresión
        mov bl,10 ; Divisor para convertir a decimal
        xor dx, dx ; Limpiar DX antes de la división
        div bl ; Dividir AL entre 10, cociente en AL, residuo en AH

        mov bl,ah
        cmp al, 0 ; Verificar si el cociente es cero
        je solo_unidad ; Si es cero, solo imprimir la unidad
        add al, '0' ; Convertir a ASCII
        mov dl, al ; Mover el cociente a DL para imprimir
        mov ah, 02h ; Función para imprimir carácter
        int 21h ; Imprimir el cociente

        solo_unidad:
        mov ah,bl ; Mover el residuo a AH
        add ah, '0' ; Convertir el residuo a ASCII
        mov dl, ah ; Mover el residuo a DL para imprimir
        mov ah, 02h ; Función para imprimir carácter
        int 21h ; Imprimir el residuo
        pop ax ; Recuperar AX de la pila
        ret
imprimir_numero ENDP

end main