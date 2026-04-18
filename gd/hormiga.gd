class_name Hormiga

enum Estado { HUEVO, LARVA, PUPA, ADULTA, MUERTA }
enum Tipo { NINGUNO, CONSTRUCTORA, SOLDADO, EXPLORADORA }
enum Accion { NINGUNA, RECOLECTANDO, EXCAVANDO, EXPLORANDO, COMIENDO }
enum FaseRecoleccion { BUSCANDO , REGRESANDO }
enum FaseExploracion { SALIENDO, BUSCANDO, REGRESANDO}
enum Stat { VIDA, FUERZA , AGILIDAD , INTELIGENCIA }

var acumulador := 0.0
var intervalo := 1.0

# --- VARIABLES ESTADOS ---
var estado : Estado = Estado.HUEVO
var tipo : Tipo = Tipo.NINGUNO
var accion : Accion = Accion.NINGUNA
var fase_recoleccion : FaseRecoleccion = FaseRecoleccion.BUSCANDO
var fase_exploracion : FaseExploracion = FaseExploracion.SALIENDO

# --- VARIABLES EXPLORACION ---
var punto_descubierto_temp = null
var punto_actual = null
var progreso_exploracion := 0
var umbral_exploracion := randi_range(5, 15)

# --- VARIABLES RECOLECCION ---
var ticks_viaje := 0
var carga := 0

# --- VARIABLES ESTADISTICAS ---
var edad_maxima := 1000
var edad := 0
var vida := 0
var fuerza := 0
var agilidad := 0
var inteligencia := 0
var hambre := 10.0
var salud := 100.0

var consumo_por_tick := 0.1
var mordisco_por_tick := 0.5
var hambre_max := 10.0

var en_exterior := false
var muerta := false

var buff_recoleccion := 1.0
var sala_seleccionada : SalaData = null 


# -- FUNCIONES CONTROL --
func _init():
	acumulador = randf() * intervalo

func update(delta):
	acumulador += delta
	if acumulador >= intervalo:
		acumulador -= intervalo
		tick()

func tick():
	edad += 1
	procesar_estado()
	if not puede_actuar():
		return
	procesar_accion()

func procesar_accion():
	match accion:
		Accion.NINGUNA:
			idle()
		Accion.RECOLECTANDO:
			recolectar()
		Accion.EXPLORANDO:
			explorar()
		Accion.COMIENDO:
			comer()
		Accion.EXCAVANDO:
			excavar(sala_seleccionada)

func procesar_estado():
	if edad >= edad_maxima:
		die()
		return

	match estado:
		Estado.HUEVO:
			if edad >= 2:
				evolucionar()

		Estado.LARVA:
			if edad >= 4:
				evolucionar()

		Estado.PUPA:
			if edad >= 6:
				evolucionar()

		Estado.ADULTA:
			hambre -= consumo_por_tick
			if hambre <= 0:
				die()
# -- FUNCIONES CONTROL --

# -- FUNCIONES VITALES --
func get_consumo() -> float:
	if estado != Estado.ADULTA or muerta:
		return 0.0
	return consumo_por_tick

func puede_actuar() -> bool:
	return estado == Estado.ADULTA and not muerta

func evolucionar():
	match estado:
		Estado.HUEVO:
			estado = Estado.LARVA
		Estado.LARVA:
			estado = Estado.PUPA
		Estado.PUPA:
			estado = Estado.ADULTA
			definir_tipo()

func die():
	if muerta:
		return
	muerta = true
	estado = Estado.MUERTA
	print("LA HORMIGA MURIÓ")
# -- FUNCIONES VITALES --

func get_salas_por_construir() -> Array:
	var lista_en_construccion : Array = []
	var salas_disponibles = ControllerExcavacion.salas_disponibles
	for sala in salas_disponibles:
		if sala.estado == SalaData.Estado.EN_CONSTRUCCION:
			lista_en_construccion.append(sala)
			return lista_en_construccion
	return lista_en_construccion

# --- FUNCIONES IDLE --- 
func idle():
	
	if hambre < 5 and not en_exterior:
		iniciar_comer()
		return
	if randf() < 0.05:
		if get_salas_por_construir() != null:
			iniciar_excavacion()
			return
	if randf() < 0.10:
		iniciar_exploracion()
		return
	var punto = ControllerForrajeo.obtener_punto()
	if punto != null:
		asignar_punto(punto)
# --- FUNCIONES IDLE --- 

# -- FUCNIONES EXPLORACION --
func iniciar_exploracion():
	accion = Accion.EXPLORANDO
	fase_exploracion = FaseExploracion.SALIENDO
	ticks_viaje = randi_range(3,8)
	en_exterior = true

func explorar():
	match fase_exploracion:
		
		FaseExploracion.SALIENDO:
			ticks_viaje -= 1
			if ticks_viaje <= 0:
				fase_exploracion = FaseExploracion.BUSCANDO
				progreso_exploracion = 0
		
		FaseExploracion.BUSCANDO:
			progreso_exploracion += 1
			if progreso_exploracion >= umbral_exploracion:
				generar_descubrimiento()
				ticks_viaje = randi_range(3,8)
				fase_exploracion = FaseExploracion.REGRESANDO
		
		FaseExploracion.REGRESANDO:
			ticks_viaje -= 1
			if ticks_viaje <= 0:
				registrar_descubrimiento()
				accion = Accion.NINGUNA

func generar_descubrimiento():
	var distancia = randi_range(5, 25)
	var cantidad = distancia * randi_range(10, 25)
	
	punto_descubierto_temp = {
		"cantidad":cantidad,
		"distancia":distancia
	}

func registrar_descubrimiento():
	if punto_descubierto_temp == null:
		return
	ControllerForrajeo.generar_punto_con_datos(
		punto_descubierto_temp.cantidad,
		punto_descubierto_temp.distancia
	)
	punto_descubierto_temp == null
# --- FUCNIONES EXPLORACION ---

# --- FUNCIONES COMER ---
func iniciar_comer():
	accion = Accion.COMIENDO
	en_exterior = false

func comer():
	var comida = ControllerHormiguero.tomar_comida(mordisco_por_tick)
	if comida:
		hambre = min(hambre + mordisco_por_tick, hambre_max)
	else:
		return
	if hambre >= hambre_max:
		accion = Accion.NINGUNA
# --- FUNCIONES COMER ---

# --- FUNCIONES RECOLECCION ---
func recolectar():
	match fase_recoleccion:
		FaseRecoleccion.BUSCANDO:
			ticks_viaje -= 1
			if ticks_viaje <= 0:
				llegar_a_punto()
		
		FaseRecoleccion.REGRESANDO:
			ticks_viaje -= 1
			if ticks_viaje <= 0:
				entregar()

func asignar_punto(punto):
	punto_actual = punto
	accion = Accion.RECOLECTANDO
	fase_recoleccion = FaseRecoleccion.BUSCANDO
	ticks_viaje = calcular_tiempo_viaje(punto)

func llegar_a_punto():
	if punto_actual == null:
		return
	
	carga = ControllerForrajeo.consumir_punto(punto_actual, calcular_carga())
	ticks_viaje = calcular_tiempo_viaje(punto_actual)
	fase_recoleccion = FaseRecoleccion.REGRESANDO
	
func entregar():
	ControllerHormiguero.entregar_comida(carga)
	carga = 0
	punto_actual = null
	accion = Accion.NINGUNA
	en_exterior = false

func calcular_tiempo_viaje(punto) -> int:
	return max(1, int(punto.distancia))

func calcular_carga() -> int:
	carga = randi_range(3,10) 
	return carga
# --- FIN FUNCIONES RECOLECCION ---

# -- FUNCIONES EXCAVAR ---
func iniciar_excavacion():
	seleccionar_sala()
	accion = Accion.EXCAVANDO
	pass

func seleccionar_sala():
	if ControllerExcavacion.salas_disponibles.is_empty():
		accion = Accion.NINGUNA
		return
	sala_seleccionada = ControllerExcavacion.salas_en_construccion.pick_random()


func excavar(sala : SalaData):
	# RECIBIR SALA A EXCAVAR EN SALAS_DISPONIBLES
	var sala_elegida = sala
	if sala_elegida == null:
		return
	
	if sala_elegida.estado == SalaData.Estado.EN_CONSTRUCCION:
		var ticks_ayuda := randf_range(2,4)
		for tick in ticks_ayuda:
			sala_elegida.avanzar(mordisco_por_tick)
		accion = Accion.NINGUNA
	
	if sala_elegida.estado == SalaData.Estado.CONSTRUIDA:
		sala_elegida.terminar_sala()
# -- FIN FUNCIONES EXCAVAR ---


#FUNCIONES SIN UTILIZAR ACTUALMENTE 
func mejorar_larva(stat: int, cantidad: int):
	match stat:
		Stat.VIDA:
			vida += cantidad
		Stat.FUERZA:
			fuerza += cantidad
		Stat.AGILIDAD:
			agilidad += cantidad
		Stat.INTELIGENCIA:
			inteligencia += cantidad

func definir_tipo():
	if fuerza >= 7:
		tipo = Tipo.SOLDADO
	elif agilidad >= 7:
		tipo = Tipo.EXPLORADORA
	else:
		tipo = Tipo.CONSTRUCTORA





