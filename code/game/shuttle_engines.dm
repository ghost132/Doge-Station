/obj/structure/shuttle
	name = "nave"
	icon = 'icons/turf/shuttle.dmi'

/obj/structure/shuttle/shuttleRotate(rotation)
	..()
	var/matrix/M = transform
	M.Turn(rotation)
	transform = M

/obj/structure/shuttle/window
	name = "janela da nave"
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "1"
	density = 1
	opacity = 0
	anchored = 1

	CanPass(atom/movable/mover, turf/target, height)
		if(!height) return 0
		else return ..()

	CanAtmosPass(turf/T)
		return !density

/obj/structure/shuttle/engine
	name = "motor"
	density = 1
	anchored = 1.0

/obj/structure/shuttle/engine/heater
	name = "aquecedor"
	icon_state = "heater"

/obj/structure/shuttle/engine/platform
	name = "plataforma"
	icon_state = "platform"

/obj/structure/shuttle/engine/propulsion
	name = "propulsão"
	icon_state = "propulsion"
	opacity = 1

/obj/structure/shuttle/engine/propulsion/burst
	name = "enginição"

/obj/structure/shuttle/engine/propulsion/burst/left
	name = "esquerda"
	icon_state = "burst_l"

/obj/structure/shuttle/engine/propulsion/burst/right
	name = "direita"
	icon_state = "burst_r"

/obj/structure/shuttle/engine/router
	name = "router"
	icon_state = "router"
