
.MODEL SMALL
.STACK
.DATA

    cad1 db 100 dup(' '),"$"
    cad2 db 100 dup(' '),"$"
    cad3 db 100 dup(' '),"$"
    conta db 0
    tamcad db 0
    es_palindromo db 10, 13, 'La cadena ES un palindromo$'
    no_palindromo db 10,13,'La cadena NO ES un palindromo$'

.CODE

    main proc

        mov ax,@data
        mov ds,ax
        mov es, ax
        
        mov ah, 3fh ; Leer archivo
        mov bx, 00h
        mov cx,100
        mov dx, offset cad1
        int 21h

        lea si, [cad1]

    contar:

        mov cl, [si]
        mov dl, 13 ; Código ASCII de Enter
        inc [tamcad]
        inc si 
        cmp cl, dl
        jne contar

        dec [tamcad] ; Restamos 1 para no contar el Enter

        mov ah, 02h
        mov dl, 10
        int 21h

        lea si, [cad1]
        lea di, [cad2]

    copiar:

        mov al, [si]
        mov dl, 13
        cmp al, dl
        je invertir

        mov dl, 20h ; Espacio
        cmp al, dl
        je guardar_espacio

        mov [di], al ; Copiar solo caracteres que no sean espacios
        inc di
        inc conta

    guardar_espacio:
        inc si
        mov dl, [tamcad]
        cmp dl, [conta]
        jne copiar

    invertir:

        dec di
        lea si, [cad1] ; Reiniciar SI
        lea bx, [cad3] ; BX apunta a cad3
        mov dx, di     ; Guardamos la última posición válida de cad2

    invertir_loop:

        mov al, [si]
        mov dl, 20h ; Espacio
        cmp al, dl
        jne copiar_caracter

        mov [bx], al ; Copiar espacio en la misma posición
        inc bx
        inc si
        jmp seguir

    copiar_caracter:
        mov al, [di]
        mov [bx], al
        dec di
        inc bx
        inc si

    seguir:
        cmp si, dx
        jle invertir_loop

    imprimir:

        mov ah, 02h
        mov dl, 13
        int 21h
        mov ah, 09h
        mov dx, offset cad3
        int 21h

    ; Comparar cad1 (original) y cad3 (invertida) para ver si es palíndromo
    comparar_palindromo:
        lea si, [cad1]  ; Puntero a cad1
        lea di, [cad3]  ; Puntero a cad3
        mov cl, [tamcad] ; Tamaño de la cadena

    comparar_loop:
        mov al, [si]
        mov bl, [di]
        cmp al, bl
        jne no_es_palindromo ; Si no son iguales, no es palíndromo
        inc si
        inc di
        dec cl
        jnz comparar_loop

    ; Si llegamos aquí, es palíndromo
        mov ah, 09h
        mov dx, offset es_palindromo
        int 21h
        jmp salida

    no_es_palindromo:
        mov ah, 09h
        mov dx, offset no_palindromo
        int 21h

    salida:
        mov ax, 4c00h
        int 21h          
    main endp
END