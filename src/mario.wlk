import wollok.game.*
    
const velocidad = 300

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Mario Game")
		game.addVisual(fondomario)
		game.addVisual(tuberia)
		game.addVisual(mario)
		game.addVisual(reloj)
		game.addVisual(goomba)
		game.addVisual(moneda)
	
		keyboard.space().onPressDo{self.jugar()}
		
		game.onCollideDo(mario,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method    iniciar(){
		mario.iniciar()
		reloj.iniciar()
		tuberia.iniciar()
		goomba.iniciar()
		moneda.iniciar()
		
		
	}
	
	method jugar(){
		if (mario.estaVivo()) 
			mario.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		tuberia.detener()
		reloj.detener()
		goomba.detener()
		moneda.detener()
		mario.morir()		
	}
	
}

object gameOver {
	method position() = game.center().left(5.15).down(5.15).up(1)
	method image() = "gameovermario.png"
}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object tuberia {
	 
	const posicionInicial = game.at(game.width()-1,fondomario.position().y())
	var position = posicionInicial

	method image() = "tuberia2.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverTuberia",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverTuberia")
	}
}

object fondomario{
	
	method position() = game.origin().up(0)
	method image() = "fondomario2.png"
}


object mario {
	var paso = 0
	var vivo = true
	var position = game.at(1,fondomario.position().y())
	
	method image() = "mario3.png"
	method position() = position
	
	method saltar(){
		if(position.y() == fondomario.position().y()) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	
	method correr(){
		if (paso == 0){
			paso = 1
		}
		else{
			paso = 0
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}

object goomba {
	 
	const posicionInicial = game.at(game.width()+8,fondomario.position().y())
	var position = posicionInicial

	method image() = "goomba2.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverGoomba",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverGoomba")
	}
}

object moneda{
	
	const posicionInicial = game.at(game.width()+4, fondomario.position().y())
	var posicion = posicionInicial
	var moned = 0 

	method image() = "moneda2.png"
	method position() = posicion

	method iniciar(){
		posicion = posicionInicial
		game.onTick(velocidad,"moverMoneda",{self.mover()})
		moned = 0
	}
	
	method mover(){
		posicion = posicion.left(1)
		if (posicion.x() == -2)
			posicion = posicionInicial
	}
	method chocar(){
		moned = moned +1 
		posicion = game.at(-1,-1)
		return moned 
	}
	method detener(){
		game.removeTickEvent("moverMoneda")
	}
}
