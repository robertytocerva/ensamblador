.MODEL SMALL
.STACK
.DATA
    m1 DB 10, "Ingrese 3 numeros: $"
    m2 DB 10, "Los numeros en la pila (al reves) son: $"
    m3 DB 10, "La suma de los numeros es: $"
    m4 DB 10, "La suma es PAR$"
    m5 DB 10, "La suma es IMPAR$"
    suma DB 0
.CODE
START:
    MOV AX, @DATA
    MOV DS, AX

    ; Mostrar mensaje de entrada
    MOV AH, 09H
    MOV DX, OFFSET m1
    INT 21H

    ; Ingresar 3 números
    MOV CX, 3
INGRESAR:
    MOV AH, 01H  ; Leer un número
    INT 21H
    SUB AL, '0'  ; Convertir ASCII a número
    PUSH AX      ; Guardar en la pila
    ADD SUMA, AL ; Acumular la suma
    LOOP INGRESAR

    ; Mostrar mensaje de números al revés
    MOV AH, 09H
    MOV DX, OFFSET m2
    INT 21H

    ; Imprimir números al revés
    MOV CX, 3
IMPRIMIR_REVERSO:
    POP DX       ; Usamos DX en lugar de AX para evitar conflictos
    ADD DL, '0'  ; Convertir a ASCII
    MOV AH, 02H
    INT 21H
    LOOP IMPRIMIR_REVERSO

    ; Mostrar mensaje de suma
    MOV AH, 09H
    MOV DX, OFFSET m3
    INT 21H

    ; Imprimir suma (corregido)
    MOV AL, SUMA
    MOV AH, 0     ; Limpiamos AH para la división
    MOV BL, 10
    DIV BL        ; AL = cociente 

    ; Imprimir decenas 
    CMP AL, 0
    JE IMPRIMIR_UNIDAD
    MOV DL, AL
    ADD DL, '0'
    PUSH AX       ; Guardamos AH (unidades)
    MOV AH, 02H
    INT 21H
    POP AX        ; Recuperamos AH (unidades)

IMPRIMIR_UNIDAD:
    MOV DL, AH
    ADD DL, '0'
    MOV AH, 02H
    INT 21H

    ; Determinar par o impar
    MOV AL, SUMA
    MOV AH, 0    
    MOV BL, 2
    DIV BL        
    CMP AH, 0
    JE ES_PAR
    MOV DX, OFFSET m5
    JMP MOSTRAR_PARIDAD

ES_PAR:
    MOV DX, OFFSET m4

MOSTRAR_PARIDAD:
    MOV AH, 09H
    INT 21H

    ; Salir
    MOV AX, 4C00H
    INT 21H
END START