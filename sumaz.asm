.MODEL
.STACK
.DATA
    msg1 DB 10,13,"Ingrese un numero: $"
    msg2 db 10,13,"Numero 2: $"
    msgr db 10,13,"Resultado: $"
.code
    main PROC 
        mov ax, @data
        mov ds, ax

        call pedir_numero
        mov bl, al ; Guardar el primer número en BL
        call pedir_numero
        mov bh, al ; Guardar el segundo número en BH
        call sumar 

        ;moastrar resultado
        mov ah, 09h
        lea dx, msgr
        int 21h
        
        call imprimir_al ; Imprimir el resultado en AL

        ;Terminar el programa
        mov ax, 4C00H
        int 21h
    main ENDP

    pedir_numero PROC
        ; Mostrar mensaje para ingresar un número
        mov ah, 09h
        lea dx, msg1
        int 21h

        mov ah, 01h ; Leer un carácter
        int 21h
        sub al, '0' ; Convertir de ASCII a número
        ret
    pedir_numero ENDP

    sumar PROC
        ; Sumar los números en BL y BH
        mov al, bl ; Mover el primer número a AL
        add al, bh ; Sumar el segundo número
        ret
    sumar ENDP

    imprimir_al PROC
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
    imprimir_al ENDP

    end main