.MODEL SMALL
.STACK
.DATA

    posFila DB 09h      ; Posición inicial del jugador (fila)
    posColumna DB 10h   ; Posición inicial del jugador (columna)
    jugador DB '#'      ; Carácter que representa al jugador
    mensajeSalir DB 10,13, "Juego terminado. Reiniciar? (Y / N): $"
    obstaculo1Columna DB 4Eh  ; Columna inicial del primer obstáculo (78)
    obstaculo2Columna DB 7Ah  ; Columna del segundo obstáculo (122)
    obstaculo3Columna DB 0A6h ; Columna del tercer obstáculo (166)
    obstaculo4Columna DB 0D2h ; Columna del cuarto obstáculo (210)
    huecoAlto1 DB 8      ; Altura del hueco en el primer obstáculo
    huecoAlto2 DB 6      ; Altura del hueco en el segundo obstáculo
    huecoAlto3 DB 10     ; Altura del hueco en el tercer obstáculo
    huecoAlto4 DB 7      ; Altura del hueco en el cuarto obstáculo
    huecoBajo1 DB 6      ; Altura del hueco inferior en el primer obstáculo
    huecoBajo2 DB 4      ; Altura del hueco inferior en el segundo obstáculo
    huecoBajo3 DB 8      ; Altura del hueco inferior en el tercer obstáculo
    huecoBajo4 DB 5      ; Altura del hueco inferior en el cuarto obstáculo
    contadorMovimiento DB 0  ; Contador para controlar el movimiento de los obstáculos
    contadorGravedad DB 0    ; Contador para controlar la aplicación de la gravedad
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
    CALL AplicarGravedad     ; Aplicar gravedad al jugador
    CALL Retardo             ; Retardo más largo para ralentizar el movimiento
    CALL VerificarColision   ; Verificar colisiones
    JMP BuclePrincipal       ; Repetir indefinidamente
    
    INT 20H  
MAIN ENDP

; Procedimiento para aplicar gravedad (hacer que el jugador caiga)
AplicarGravedad PROC
    ; Incrementar el contador de gravedad
    INC contadorGravedad
    CMP contadorGravedad, 15  ; Aplicar gravedad cada 3 iteraciones
    JL FinAplicarGravedad    ; Si no es tiempo de aplicar gravedad, salir

    ; Reiniciar el contador de gravedad
    MOV contadorGravedad, 0

    ; Verificar si el jugador está en el límite inferior de la pantalla
    CMP posFila, 18H
    JGE FinAplicarGravedad   ; Si está en el límite, no caer más

    ; Borrar la posición actual del jugador
    CALL BorrarJugador

    ; Hacer que el jugador caiga (aumentar la fila)
    INC posFila

FinAplicarGravedad:
    RET
AplicarGravedad ENDP

; Procedimiento para borrar al jugador (dibujar un espacio en su posición actual)
BorrarJugador PROC
    MOV AH, 02H
    MOV BH, 00H
    MOV DH, posFila
    MOV DL, posColumna
    INT 10H

    MOV AH, 09H
    MOV AL, ' '      ; Dibujar un espacio en blanco
    MOV BL, 0Fh
    MOV CX, 1
    INT 10H
    RET
BorrarJugador ENDP

; Procedimiento para limpiar la pantalla con fondo verde
LimpiarPantalla PROC
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 20H  ; Fondo verde (2), texto negro (0)
    MOV CH, 00H
    MOV CL, 00H
    MOV DH, 18H
    MOV DL, 4FH
    INT 10H
    RET
LimpiarPantalla ENDP

; Procedimiento para dibujar al jugador (amarillo)
DibujarJugador PROC
    MOV AH, 02H
    MOV BH, 00H
    MOV DH, posFila
    MOV DL, posColumna
    INT 10H

    MOV AH, 09H
    MOV AL, jugador
    MOV BL, 0Eh  ; Color amarillo (E)
    MOV CX, 1
    INT 10H
    RET
DibujarJugador ENDP

; Procedimiento para dibujar los obstáculos (café)
DibujarObstaculos PROC
    ; Limpiar la pantalla antes de redibujar
    CALL LimpiarPantalla

    ; Dibujar todos los obstáculos
    MOV BL, obstaculo1Columna
    MOV DL, huecoAlto1
    MOV DH, huecoBajo1
    CALL DibujarUnObstaculo
    MOV BL, obstaculo2Columna
    MOV DL, huecoAlto2
    MOV DH, huecoBajo2
    CALL DibujarUnObstaculo
    MOV BL, obstaculo3Columna
    MOV DL, huecoAlto3
    MOV DH, huecoBajo3
    CALL DibujarUnObstaculo
    MOV BL, obstaculo4Columna
    MOV DL, huecoAlto4
    MOV DH, huecoBajo4
    CALL DibujarUnObstaculo

    ; Mover todos los obstáculos hacia la izquierda
    CALL MoverObstaculos

    RET
DibujarObstaculos ENDP

; Procedimiento para dibujar un obstáculo individual con hueco (café)
DibujarUnObstaculo PROC
    ; Tubo superior
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 60H  ; Fondo café (6), texto negro (0)
    MOV CH, 00H  ; Fila superior izquierda (fila 0)
    MOV CL, BL   ; Columna superior izquierda
    MOV DH, DL   ; Fila inferior derecha (fila del hueco)
    DEC DH       ; Ajustar para que sea una fila antes del hueco
    MOV DL, BL   ; Columna inferior derecha
    INC DL       ; Ajustar para que sea una columna de ancho
    INT 10H

    ; Tubo inferior
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 60H  ; Fondo café (6), texto negro (0)
    MOV CH, DH   ; Fila superior izquierda (fila del hueco)
    ADD CH, 4    ; Ajustar para que sea dos filas después del hueco
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
    MOV DL, huecoAlto1
    MOV DH, huecoBajo1
    CALL VerificarColisionObstaculo
    MOV BL, obstaculo2Columna
    MOV DL, huecoAlto2
    MOV DH, huecoBajo2
    CALL VerificarColisionObstaculo
    MOV BL, obstaculo3Columna
    MOV DL, huecoAlto3
    MOV DH, huecoBajo3
    CALL VerificarColisionObstaculo
    MOV BL, obstaculo4Columna
    MOV DL, huecoAlto4
    MOV DH, huecoBajo4
    CALL VerificarColisionObstaculo
    RET
VerificarColision ENDP

; Procedimiento para verificar colisión con un obstáculo específico
VerificarColisionObstaculo PROC
    ; Verificar colisión con el tubo superior
    MOV AL, posFila
    CMP AL, 00H
    JL NoColision
    CMP AL, DL
    JL ColisionTuboSuperior
    JMP VerificarHueco

ColisionTuboSuperior:
    MOV AL, posColumna
    CMP AL, BL
    JL NoColision
    CMP AL, BL
    JG NoColision
    JMP JuegoTerminado

VerificarHueco:
    ; Verificar si el jugador está en el hueco
    MOV AL, posFila
    CMP AL, DL
    JL NoColision
    ADD DL, 4
    CMP AL, DL
    JG ColisionTuboInferior
    JMP NoColision

ColisionTuboInferior:
    ; Verificar colisión con el tubo inferior
    MOV AL, posColumna
    CMP AL, BL
    JL NoColision
    CMP AL, BL
    JG NoColision
    JMP JuegoTerminado

NoColision:
    RET

JuegoTerminado:
    ; Mostrar mensaje de "Juego terminado"
    MOV AH, 09H
    LEA DX, mensajeSalir
    INT 21H

    ; Leer la tecla presionada
    MOV AH, 01H
    INT 21H
    CMP AL, 'y'
    JE ReiniciarJuego
    CMP AL, 'Y'
    JE ReiniciarJuego

    ; Salir del juego
    INT 27H

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
    CMP AL, 27        ; ESC para PAUSAR
    JE JuegoTerminado
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