    .MODEL small
    .STACK 100h

    .DATA
        msgIteraciones db 'Ingrese el numero de iteraciones (max 12): $'
        msgError db 'Error! Debe ser un numero entre 1 y 12.$'
        msgSerie db 'Serie de Fibonacci: $'
        msgSerieInv db 'Serie Invertida: $'
        msgSuma db 'Suma de la serie: $'
        msgPrimo db 'La suma es un numero primo.$'
        msgNoPrimo db 'La suma NO es un numero primo.$'
        msgReiniciar db 'Presione ESC para salir o cualquier tecla para continuar.$'
        saltoLinea db 10,13,'$'
        iteraciones db ?
        suma dw ?
        pila dw 12 dup(?)

    .CODE
    print macro mensaje
        mov ah, 09h
        lea dx, mensaje
        int 21h
    endm

    start:
        mov ax, @data
        mov ds, ax

    ciclo_principal:
        print saltoLinea
        print msgIteraciones
        call leerIteraciones
        print saltoLinea

        call calcularFibonacci
        
        ; Mostrar serie original
        print msgSerie
        call mostrarPilaSinPerderAX
        print saltoLinea
        
        ; Mostrar serie invertida
        print msgSerieInv
        call mostrarPilaInvertidaSinPerderAX
        print saltoLinea
        
        ; Calcular y mostrar suma
        call calcularSuma
        print msgSuma
        mov ax, suma  ; Asegurar que AX tenga el valor correcto
        call imprimirNumero
        print saltoLinea
        ; Verificar si es primo
        call esPrimo
        print saltoLinea
        
        ; Opción para reiniciar o salir
        print msgReiniciar
        call esperarTecla
        cmp al, 1Bh
        jne ciclo_principal

        mov ax, 4C00h
        int 21h

leerIteraciones proc
    push bx
    push ax
    push dx

    xor ax, ax           ; Limpiar AX
    xor bx, bx           ; BX almacenará el número leído

    ; Leer primer carácter
    mov ah, 01h
    int 21h
    cmp al, 13           ; Si es ENTER sin ingresar nada, repetir
    je leerIteraciones
    cmp al, '1'          ; Si es menor que '1', es inválido
    jl error
    cmp al, '9'          ; Si es mayor que '9', verificar si es de dos cifras
    jg verificarDosCifras

    sub al, '0'          ; Convertir ASCII a número
    mov bl, al           ; Guardar en BX temporalmente

    ; Leer segundo carácter
    mov ah, 01h
    int 21h
    cmp al, 13           ; Si es ENTER, solo hay un dígito (1-9)
    je almacenar_numero
    cmp al, '0'          ; Verificar si es '10' o '11'
    je esDiez
    cmp al, '1'
    je esOnce
    cmp al, '2'
    je esDoce
    jmp error            ; Si no es '0' o '1', es inválido

verificarDosCifras:
    cmp al, '1'          ; Si el primer dígito es '1', puede ser '10' u '11'
    jne error            ; Si no es '1', error

    sub al, '0'          ; Convertir '1' a número
    mov bl, al           ; Guardar en BX

    ; Leer segundo carácter
    mov ah, 01h
    int 21h
    cmp al, '0'          ; Puede ser '10' o '11'
    je esDiez
    cmp al, '1'
    je esOnce
    cmp al, '2'
    je esDoce
    jmp error            ; Si no es '0' o '1', es inválido

esDiez:
    mov bl, 10           ; Guardar 10 en BL
    jmp almacenar_numero

esOnce:
    mov bl, 11 
    jmp almacenar_numero
    
esDoce:
    mov bl,12; Guardar 11 en BL

almacenar_numero:
    mov iteraciones, bl  ; Guardar el número en `iteraciones`
    pop dx
    pop ax
    pop bx
    ret

error:
    print saltoLinea
    print msgError
    jmp leerIteraciones
leerIteraciones endp

    calcularFibonacci proc
        push cx
        push si
        push ax
        
        mov cx, 0
        mov cl, iteraciones
        mov si, 0
        mov ax, 0
        mov pila[si], ax
        add si, 2
        dec cx
        jz fin_fibo
        
        mov ax, 1
        mov pila[si], ax
        add si, 2
        dec cx
        jz fin_fibo

    siguiente:
        mov ax, pila[si-4]
        add ax, pila[si-2]
        mov pila[si], ax
        add si, 2
        loop siguiente

    fin_fibo:
        pop ax
        pop si
        pop cx
        ret
    calcularFibonacci endp

    mostrarPilaSinPerderAX proc
        push ax
        push cx
        push si
        push dx
        
        mov cx, 0
        mov cl, iteraciones
        mov si, 0
    bucle_mostrar:
        mov ax, pila[si]
        call imprimirNumero
        mov dl, ' '          ; Espacio entre números
        mov ah, 02h
        int 21h
        add si, 2
        loop bucle_mostrar
        
        pop dx
        pop si
        pop cx
        pop ax
        ret
    mostrarPilaSinPerderAX endp

    mostrarPilaInvertidaSinPerderAX proc
        push ax
        push cx
        push si
        push dx
        
        mov cx, 0
        mov cl, iteraciones
        mov si, cx
        shl si, 1
        sub si, 2
    bucle_inv:
        mov ax, pila[si]
        call imprimirNumero
        mov dl, ' '          ; Espacio entre números
        mov ah, 02h
        int 21h
        sub si, 2
        loop bucle_inv
        
        pop dx
        pop si
        pop cx
        pop ax
        ret
    mostrarPilaInvertidaSinPerderAX endp

    calcularSuma proc
        push cx
        push si
        
        mov cx, 0
        mov cl, iteraciones
        mov si, 0
        mov ax, 0
        
    suma_loop:
        add ax, pila[si]
        add si, 2
        loop suma_loop
        
        mov suma, ax
        pop si
        pop cx
        ret
    calcularSuma endp

    esPrimo proc
        push ax
        push bx
        push cx
        push dx
        
        mov ax, suma
        cmp ax, 1
        jbe no_primo
        
        cmp ax, 2
        je es_primo
        
        test ax, 1
        jz no_primo
        
        mov bx, ax
        mov cx, 3
    prueba_divisor:
        mov ax, bx
        xor dx, dx
        div cx
        cmp dx, 0
        je no_primo
        
        add cx, 2
        mov ax, cx
        mul cx
        cmp ax, bx
        jbe prueba_divisor
        
    es_primo:
        print msgPrimo
        jmp fin_primo
    no_primo:
        print msgNoPrimo
    fin_primo:
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    esPrimo endp

    imprimirNumero proc
        push ax
        push bx
        push cx
        push dx
        
        mov bx, 10
        xor cx, cx
        
        cmp ax, 0
        jne convertir
        mov dl, '0'
        mov ah, 02h
        int 21h
        jmp fin_imprimir
        
    convertir:
        xor dx, dx
        div bx
        push dx
        inc cx
        test ax, ax
        jnz convertir
        
    imprimir:
        pop dx
        add dl, '0'
        mov ah, 02h
        int 21h
        loop imprimir
        
    fin_imprimir:
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    imprimirNumero endp

    esperarTecla proc
        mov ah, 00h
        int 16h
        ret
    esperarTecla endp

    END start