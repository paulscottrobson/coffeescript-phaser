
class PongGame extends Phaser.Game

	PongGame.TENNIS = 1
	PongGame.SOCCER = 2
	PongGame.SQUASH = 3
	PongGame.PRACTICE = 4

	constructor : ->
		super 640,480
		@state.add 'main',MainState
		@state.start 'main', true, false, 2

class MainState
	constructor :->
		@currentGame = 0
		@scores = [0,0]

	init : (gameID) ->
		@gameNumber = gameID
		if @gameNumber != @currentGame
			console.log "Game",gameID
			@currentGame = gameID
			@scores = [0,0]
			if @currentGame == PongGame.PRACTICE then @scores = [0,null]

	create : ->
		@game.physics.startSystem Phaser.Physics.ARCADE
		@createFrame()
		@ball = new Ball(@)
		@bats = []
		@scoreText = [ @createScoreText(@,24,16),null ]
		if @scores[1] != null
			@scoreText[1] = @createScoreText(@,@game.width-128,16)

	update : ->
		@game.physics.arcade.collide(@ball.sprite,@frame)

	createScoreText: (state,x,y) ->
		state.game.add.text(x,y,"00", { font: "96px Arial", fill:"#FFFFFF", align:"center"})

	createFrame:->
		console.log @currentGame
		frameSize = 6
		if @currentGame == PongGame.TENNIS or @currentGame == PongGame.SOCCER
			@createBox(@game.width/2-frameSize/2,0,frameSize,@game.height,false,true)
		@frame = @game.add.group()
		@createWall 0,0,@game.width,frameSize
		@createWall 0,@game.height-frameSize,@game.width,frameSize
		if @currentGame == PongGame.SQUASH or @currentGame == PongGame.PRACTICE
			@createWall 0,0,frameSize,@game.height
		if @currentGame == PongGame.SOCCER
			for x in [0..1]
				edgeSize = @game.height*0.45
				@createWall x*(@game.width-frameSize),0,frameSize,edgeSize
				@createWall x*(@game.width-frameSize),@game.height-edgeSize,frameSize,edgeSize

	createWall: (x,y,w,h) ->
		wall = @createBox(x,y,w,h,w>h)
		wall.body.immovable = true
		@frame.add(wall)

	createBox: (x,y,w,h,isDashed = false,isDecoration = false) ->
		box = @game.add.bitmapData(w,h)
		box.ctx.beginPath()
		box.ctx.rect(0,0,w,h)
		box.ctx.fillStyle = "#FFFFFF"
		box.ctx.fill()
		if isDashed
			xDash = 0
			while xDash < w
				xDash = xDash + 17
				box.ctx.beginPath()
				box.ctx.rect(xDash,0,6,h)
				box.ctx.fillStyle = "#000000"
				box.ctx.fill()
				xDash = xDash + 6
		newSprite = @game.add.sprite(x,y,box)
		if not isDecoration
			@game.physics.arcade.enable(newSprite)
		newSprite

class Ball
	constructor : (@state) ->
		@sprite = @state.createBox(100,100,20,20,false,false)		
		@sprite.body.velocity.x = 300
		@sprite.body.velocity.y = 300
		@sprite.body.bounce.x = 1
		@sprite.body.bounce.y = 1

x = new PongGame()		
