
class PhaserGame extends Phaser.Game
	constructor : ->
		super 640,480
		@state.add 'main',MainState
		@state.start 'main', true, false, 1

class MainState
	constructor :->
		@currentGame = 0

	init : (gameID) ->
		console.log "Game",gameID
		@gameNumber = gameID

	create : ->
		console.log 'create'
		@game.stage.backgroundColor = "#BD22C5"
		@game.physics.startSystem Phaser.Physics.ARCADE
		@frame = @game.add.group()

		@ball = @createEntity(@game.width/2,Math.random()*@game.height/2+@game.height/4,20,20,"#FFFF00")
		@ball.body.velocity.x = 300
		if Math.random() < 0.5
			@ball.body.velocity.y = -300
		else
			@ball.body.velocity.y = 300
		@ball.body.bounce.x = 1
		@ball.body.bounce.y = 1

		@createWall(0,0,@game.width-20,20,"#FF8000")
		@createWall(0,@game.height-20,@game.width-20,20,"#FF8000")
		@createWall(@game.width-20,0,20,@game.height,"#FF0000")

	update : ->
		@game.physics.arcade.collide(@ball,@frame)


	createWall: (x,y,w,h,colour) ->
		newSprite = @createBox(x,y,w,h,colour)
		@frame.add(newSprite)
		newSprite.body.immovable = true
		newSprite

	createEntity: (x,y,w,h,colour) ->
		@createBox(x,y,w,h,colour)

	createBox: (x,y,w,h,colour) ->
		box = @game.add.bitmapData(w,h)
		box.ctx.beginPath()
		box.ctx.rect(0,0,w,h)
		box.ctx.fillStyle = colour
		box.ctx.fill()
		newSprite = @game.add.sprite(x,y,box)
		@game.physics.arcade.enable(newSprite)
		newSprite

x = new PhaserGame()		
