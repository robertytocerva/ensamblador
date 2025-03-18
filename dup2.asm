.MODEL SMALL
.STACK 100h
.DATA
    cadena DB 50 DUP('$')   ; Cadena de 50 caracteres (inicialmente vacía)
    mensajeMenu DB '1. Ingresar cadena', 13, 10
                DB '2. Buscar caracter', 13, 10
                DB '3. Recorrer y mostrar caracteres', 13, 10
                DB '4. Limpiar cadena', 13, 10
                DB '5. Cambiar cadena', 13, 10
                DB '6. Salir', 13, 10, '$'
    mensajeIngrese DB 13, 10,  'Ingrese la cadena (max 50 caracteres): $'
    mensajeBuscar DB 13, 10,  'Ingrese el caracter a buscar: $'
    mensajeEncontrado DB 13, 10, 'Caracter encontrado!$'
    mensajeNoEncontrado DB 13, 10, 'Caracter no encontrado$'
    mensajeLimpieza DB 13, 10, 'Cadena limpiada!$'
    mensajeCambio DB 13, 10, 'Cadena cambiada!$'
    mensajeOpcionInvalida DB 13, 10, 'Opcion invalida!$'
    saltoLinea DB 13, 10, '$'
    caracterBuscar DB ?     ; Almacena el caracter a buscar

.CODE
    MOV AX, @DATA
    MOV DS, AX

MENU:
    ; Mostrar menú
    MOV DX, OFFSET mensajeMenu
    MOV AH, 09h
    INT 21h

    ; Leer opción
    MOV AH, 01h
    INT 21h
    CMP AL, '1'
    JE INGRESAR_CADENA
    CMP AL, '2'
    JE BUSCAR_CARACTER
    CMP AL, '3'
    JE RECORRER_CADENA
    CMP AL, '4'
    JE LIMPIAR_CADENA
    CMP AL, '5'
    JE CAMBIAR_CADENA
    CMP AL, '6'
    JE SALIR

    ; Opción inválida
    MOV DX, OFFSET mensajeOpcionInvalida
    MOV AH, 09h
    INT 21h
    JMP MENU

INGRESAR_CADENA:
    MOV DX, OFFSET mensajeIngrese
    MOV AH, 09h
    INT 21h

    MOV DX, OFFSET cadena
    MOV AH, 0Ah
    INT 21h
    JMP MENU

BUSCAR_CARACTER:
    MOV DX, OFFSET mensajeBuscar
    MOV AH, 09h
    INT 21h

    MOV AH, 01h
    INT 21h
    MOV caracterBuscar, AL

    ; Buscar en la cadena
    MOV SI, OFFSET cadena
    MOV CX, 50
BUSCAR_LOOP:
    CMP CX, 0
    JE NO_ENCONTRADO
    MOV AL, [SI]
    CMP AL, caracterBuscar
    JE ENCONTRADO
    INC SI
    LOOP BUSCAR_LOOP

NO_ENCONTRADO:
    MOV DX, OFFSET mensajeNoEncontrado
    MOV AH, 09h
    INT 21h
    JMP MENU

ENCONTRADO:
    MOV DX, OFFSET mensajeEncontrado
    MOV AH, 09h
    INT 21h
    JMP MENU

RECORRER_CADENA:
    MOV SI, OFFSET cadena
    MOV CX, 50
MOSTRAR_LOOP:
    MOV DL, [SI]
    CMP DL, '$'
    JE FIN_MOSTRAR
    MOV AH, 02h
    INT 21h
    INC SI
    LOOP MOSTRAR_LOOP
FIN_MOSTRAR:
    JMP MENU

CAMBIAR_CADENA:
    MOV DX, OFFSET mensajeCambio
    MOV AH, 09h
    INT 21h
    JMP INGRESAR_CADENA

SALIR:
    MOV AX, 4C00h
    INT 21h
LIMPIAR_CADENA:
    MOV SI, OFFSET cadena
    MOV CX, 50
LIMPIAR_LOOP:
    MOV BYTE PTR [SI], '$'
    INC SI
    LOOP LIMPIAR_LOOP

    MOV DX, OFFSET mensajeLimpieza
    MOV AH, 09h
    INT 21h
    JMP MENU




END 