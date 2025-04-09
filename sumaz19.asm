.MODEL small
.STACK 100h
.data
    msgBienvenida db 10,13, "Ingresa un numero del 1 al 9:  $"
    msgError db 10,13, "Error: El numero no es valido. Debe ser del 1 al 9.$"
    msgResultado db 10,13, "La suma es: $"
    resultado db ?  
.code
main PROC 
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    lea dx, msgBienvenida
    int 21h

    call leer_numero

    
    cmp al, 1
    jb numero_invalido
    cmp al, 9
    ja numero_invalido

    
    mov bl, al
    call suma_descendente

    mov resultado, ax

    
    mov ah, 09h
    lea dx, msgResultado
    int 21h

    
    call imprimir_numero

    
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

suma_descendente PROC
    xor ax, ax     
    mov cl, bl     
suma_loop:
    add ax, cx     
    dec cx
    jnz suma_loop
    ret
suma_descendente ENDP

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
