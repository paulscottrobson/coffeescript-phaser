


class PhaserGame extends Phaser.Game
	constructor : ->
		super 500,500
		@state.add 'main',MainState
		@state.add "gameover",GameOverState
		@state.start 'main'

class MainState
	create : ->
		console.log 'create'
		@game.stage.backgroundColor = "#BDC2C5"
		@game.physics.startSystem Phaser.Physics.ARCADE
		@game.world.enableBody = true
		@player = new Player(@)

		@walls = @game.add.group()
		@walls.enableBody = true
		top = @walls.create 0,0,@box ({length:@game.world.width,width:16,color:"#374A59"})
		top.body.immovable = true 
		bottom = @walls.create 0,@game.world.height-16,@box ({length:@game.world.width,width:16,color:"#374A59"})
		bottom.body.immovable = true 
		left = @walls.create 0,0,@box ({length:16,width:@game.world.height,color:"#374A59"})
		left.body.immovable = true 
		right = @walls.create @game.world.width-16,0,@box ({length:16,width:@game.world.height,color:"#374A59"})
		right.body.immovable = true 
		inner = @walls.create @game.world.width/4,16,@box ({length:16,width:@game.world.height*3/4,color:"#374A59"})
		inner.body.immovable = true
		inner1 = @walls.create @game.world.width/2,128,@box ({length:16,width:@game.world.height*3/4,color:"#374A59"})
		inner1.body.immovable = true

		@enemy = new Enemy(@)

	update : ->
		#@game.physics.arcade.collide(@player.sprite,@walls)
		@game.physics.arcade.overlap(@player.sprite,@enemy.sprite,@handlePlayerDeath,null,@)
		@player.update() 

	handlePlayerDeath: (player,enemy) ->
		player.kill()
		console.log "killed"
		@game.state.start("gameover")

	box : (options) ->
		bmd = @game.add.bitmapData(options.length,options.width)
		bmd.ctx.beginPath()
		bmd.ctx.rect(0,0,options.length,options.width)
		bmd.ctx.fillStyle = options.color;
		bmd.ctx.fill()
		bmd

class Enemy 
	constructor : (@state) ->
		@sprite =  @state.game.add.sprite 200,32,@state.box( { length:32,width:32,color:"#A96262"})

class Player 
	constructor : (@state) ->
		@sprite =  @state.game.add.sprite 32,32,@state.box( { length:32,width:32,color:"#4F616E"})
		@cursor = @state.game.input.keyboard.createCursorKeys()
		@sprite.body.collideWorldBounds = true

	update: ->		
		speed = 250
		@sprite.body.velocity.x = 0
		@sprite.body.velocity.y = 0
		if @cursor.up.isDown
			@sprite.body.velocity.y -= speed
		if @cursor.down.isDown
			@sprite.body.velocity.y += speed
		if @cursor.left.isDown
			@sprite.body.velocity.x -= speed
		if @cursor.right.isDown
			@sprite.body.velocity.x += speed

class GameOverState
	create :->
		msg = "GAME OVER\nPress SPACE to restart"
		label = @game.add.text(@game.world.width/2,@game.world.height/2,msg, { font:"22px Arial",fill:"#fff",align:"center"})
		label.anchor.setTo(0.5,0.5)
		@spacebar = @game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)

	update :->
		if @spacebar.isDown 
			@game.state.start("main")

x = new PhaserGame()		
