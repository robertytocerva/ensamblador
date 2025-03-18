.MODEL SMALL
.STACK
.DATA

    posFila DB 12h      ; Posición inicial del jugador (fila)
    posColumna DB 10h   ; Posición inicial del jugador (columna)
    jugador DB '*'      ; Carácter que representa al jugador
    mensajeSalir DB 10,13, "Juego terminado. Reiniciar? (Y/N): $"
    obstaculo1Columna DB 4Eh  ; Columna inicial del primer obstáculo (78)
    obstaculo2Columna DB 5Ah  ; Columna del segundo obstáculo (90)
    obstaculo3Columna DB 66h  ; Columna del tercer obstáculo (102)
    obstaculo4Columna DB 72h  ; Columna del cuarto obstáculo (114)
    huecoAlto DB 4      ; Altura del hueco en los obstáculos
    
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    CALL LimpiarPantalla
    CALL DibujarJugador

BuclePrincipal:
    CALL DibujarObstaculos
    CALL DibujarJugador      ; Asegurar que el jugador se redibuje
    CALL LeerTeclas
    CALL Retardo             ; Retardo más largo para ralentizar el movimiento
    CALL VerificarColision   ; Verificar colisiones
    JMP BuclePrincipal       ; Repetir indefinidamente

    INT 20H  
MAIN ENDP

; Procedimiento para limpiar la pantalla
LimpiarPantalla PROC
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 07H
    MOV CH, 00H
    MOV CL, 00H
    MOV DH, 18H
    MOV DL, 4FH
    INT 10H
    RET
LimpiarPantalla ENDP

; Procedimiento para dibujar al jugador
DibujarJugador PROC
    MOV AH, 02H
    MOV BH, 00H
    MOV DH, posFila
    MOV DL, posColumna
    INT 10H

    MOV AH, 09H
    MOV AL, jugador
    MOV BL, 0Fh
    MOV CX, 1
    INT 10H
    RET
DibujarJugador ENDP

; Procedimiento para dibujar los obstáculos (tubos con hueco)
DibujarObstaculos PROC
    ; Limpiar la pantalla antes de redibujar
    CALL LimpiarPantalla

    ; Dibujar todos los obstáculos
    MOV BL, obstaculo1Columna
    CALL DibujarUnObstaculo
    MOV BL, obstaculo2Columna
    CALL DibujarUnObstaculo
    MOV BL, obstaculo3Columna
    CALL DibujarUnObstaculo
    MOV BL, obstaculo4Columna
    CALL DibujarUnObstaculo

    ; Mover todos los obstáculos hacia la izquierda
    CALL MoverObstaculos

    RET
DibujarObstaculos ENDP

; Procedimiento para dibujar un obstáculo individual con hueco
DibujarUnObstaculo PROC
    ; Tubo superior
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 70H  ; Fondo blanco, texto negro
    MOV CH, 00H  ; Fila superior izquierda (fila 0)
    MOV CL, BL   ; Columna superior izquierda
    MOV DH, 08H  ; Fila inferior derecha (fila 8)
    MOV DL, BL   ; Columna inferior derecha
    INC DL       ; Ajustar para que sea una columna de ancho
    INT 10H

    ; Tubo inferior
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 70H  ; Fondo blanco, texto negro
    MOV CH, 10H  ; Fila superior izquierda (fila 16)
    MOV CL, BL   ; Columna superior izquierda
    MOV DH, 18H  ; Fila inferior derecha (fila 24)
    MOV DL, BL   ; Columna inferior derecha
    INC DL       ; Ajustar para que sea una columna de ancho
    INT 10H

    RET
DibujarUnObstaculo ENDP

; Procedimiento para mover los obstáculos hacia la izquierda
MoverObstaculos PROC
    DEC obstaculo1Columna
    DEC obstaculo2Columna
    DEC obstaculo3Columna
    DEC obstaculo4Columna

    ; Verificar si los obstáculos han salido de la pantalla
    CALL ReiniciarObstaculo
    RET
MoverObstaculos ENDP

; Procedimiento para reiniciar un obstáculo cuando sale de la pantalla
ReiniciarObstaculo PROC
    CMP obstaculo1Columna, 00H
    JGE FinReiniciarObstaculo1
    MOV obstaculo1Columna, 4Eh
FinReiniciarObstaculo1:
    CMP obstaculo2Columna, 00H
    JGE FinReiniciarObstaculo2
    MOV obstaculo2Columna, 5Ah
FinReiniciarObstaculo2:
    CMP obstaculo3Columna, 00H
    JGE FinReiniciarObstaculo3
    MOV obstaculo3Columna, 66h
FinReiniciarObstaculo3:
    CMP obstaculo4Columna, 00H
    JGE FinReiniciarObstaculo4
    MOV obstaculo4Columna, 72h
FinReiniciarObstaculo4:
    RET
ReiniciarObstaculo ENDP

; Procedimiento para verificar colisiones
VerificarColision PROC
    MOV BL, obstaculo1Columna
    CALL VerificarColisionObstaculo
    MOV BL, obstaculo2Columna
    CALL VerificarColisionObstaculo
    MOV BL, obstaculo3Columna
    CALL VerificarColisionObstaculo
    MOV BL, obstaculo4Columna
    CALL VerificarColisionObstaculo
    RET
VerificarColision ENDP

; Procedimiento para verificar colisión con un obstáculo específico
VerificarColisionObstaculo PROC
    ; Verificar colisión con el tubo superior
    MOV AL, posFila
    CMP AL, 00H
    JL NoColision
    CMP AL, 08H
    JG VerificarHueco
    MOV AL, posColumna
    CMP AL, BL
    JL NoColision
    CMP AL, BL
    JG NoColision
    JMP JuegoTerminado

VerificarHueco:
    ; Verificar si el jugador está en el hueco
    MOV AL, posFila
    CMP AL, 08H
    JL NoColision
    CMP AL, 10H
    JG NoColision
    MOV AL, posColumna
    CMP AL, BL
    JL NoColision
    CMP AL, BL
    JG NoColision
    JMP NoColision

NoColision:
    ; Verificar colisión con el tubo inferior
    MOV AL, posFila
    CMP AL, 10H
    JL FinVerificarColision
    CMP AL, 18H
    JG FinVerificarColision
    MOV AL, posColumna
    CMP AL, BL
    JL FinVerificarColision
    CMP AL, BL
    JG FinVerificarColision
    JMP JuegoTerminado

FinVerificarColision:
    RET

JuegoTerminado:
    ; Mostrar mensaje de "Juego terminado"
    MOV AH, 09H
    LEA DX, mensajeSalir
    INT 21H

    ; Leer la tecla presionada
    MOV AH, 00H
    INT 16H

    ; Verificar si el jugador quiere reiniciar
    CMP AL, 'y'
    JE ReiniciarJuego
    CMP AL, 'Y'
    JE ReiniciarJuego

    ; Salir del juego
    MOV AH, 4CH
    INT 21H

ReiniciarJuego:
    ; Reiniciar las posiciones del jugador y los obstáculos
    MOV posFila, 12h
    MOV posColumna, 10h
    MOV obstaculo1Columna, 4Eh
    MOV obstaculo2Columna, 5Ah
    MOV obstaculo3Columna, 66h
    MOV obstaculo4Columna, 72h
    CALL LimpiarPantalla
    CALL DibujarObstaculos
    CALL DibujarJugador
    RET
VerificarColisionObstaculo ENDP

; Procedimiento para leer las teclas y mover el jugador
LeerTeclas PROC
    MOV AH, 01H       ; Verificar si hay una tecla presionada
    INT 16H
    JZ FinLeerTeclas  ; Si no hay tecla, salir

    MOV AH, 00H       ; Leer la tecla presionada
    INT 16H

    CMP AL, 'w'
    JE MoverArriba
    CMP AL, 's'
    JE MoverAbajo
    CMP AL, 27        ; ESC
    JE MenuSalir
    JMP FinLeerTeclas

MoverArriba:
    CMP posFila, 00H
    JE FinLeerTeclas
    DEC posFila
    JMP FinLeerTeclas

MoverAbajo:
    CMP posFila, 18H
    JE FinLeerTeclas
    INC posFila
    JMP FinLeerTeclas

MenuSalir:
    MOV AH, 09H
    LEA DX, mensajeSalir
    INT 21H
    
    MOV AH, 00H
    INT 16H
    CMP AL, 'y'
    JE Salir
    CMP AL, 'Y'
    JE Salir
    JMP FinLeerTeclas

Salir:
    MOV AH, 4CH
    INT 21H

FinLeerTeclas:
    RET
LeerTeclas ENDP

; Procedimiento para agregar un retardo más largo
Retardo PROC
    MOV CX, 0FFFFH      ; Valor más grande para el retardo
RetardoLoop:
    LOOP RetardoLoop
    RET
Retardo ENDP

END MAIN