
class PongGame extends Phaser.Game

	PongGame.TENNIS = 1
	PongGame.SOCCER = 2
	PongGame.SQUASH = 3
	PongGame.PRACTICE = 4

	constructor : ->
		super 640,480
		@state.add 'main',MainState
		@state.start 'main', true, false, { game:2,speed:1,size:1,angles:1 }

class MainState
	constructor :->
		@currentGame = 0
		@scores = [0,0]

	init : (setup) ->
		@gameNumber = setup.game
		@ballSpeed = setup.speed
		@batSize = setup.size
		@fourangles = (setup.angles != 0)
		if @gameNumber != @currentGame
			@currentGame = setup.game
			@scores = [0,0]
			if @currentGame == PongGame.PRACTICE then @scores = [0,null]

	create : ->
		@game.physics.startSystem Phaser.Physics.ARCADE
		@frameGroup = @game.add.group()
		@createFrame()
		@batGroup = @game.add.group()
		@bats = []
		@createBats()
		@ball = new Ball(@)
		@scoreText = [ @createScoreText(@,@game.width/2-120,10),null ]
		if @scores[1] != null
			@scoreText[1] = @createScoreText(@,@game.width/2+16,10)

	update : ->
		@game.physics.arcade.collide(@ball.sprite,@frameGroup)
		@game.physics.arcade.overlap(@batGroup,@ball.sprite,@hitBat,null,@)

	hitBat : (batSprite,ballSprite) ->
		batObject = null
		for bat in @bats
			if Math.abs(bat.x-batSprite.x) < 24 then batObject = bat

		console.log "Hit",batObject.sprite.x,batObject.sprite.y,batSprite.x,batSprite.y

	createScoreText: (state,x,y) ->
		state.game.add.text(x,y,"00", { font: "96px Arial", fill:"#FFFFFF", align:"center"})

	createFrame:->
		frameSize = 6
		if @currentGame == PongGame.TENNIS or @currentGame == PongGame.SOCCER
			@createBox(@game.width/2-frameSize/2,0,frameSize,@game.height,false,true)
		@createWall 0,0,@game.width,frameSize
		@createWall 0,@game.height-frameSize,@game.width,frameSize
		if @currentGame == PongGame.SQUASH or @currentGame == PongGame.PRACTICE
			@createWall 0,0,frameSize,@game.height
		if @currentGame == PongGame.SOCCER
			for x in [0..1]
				edgeSize = @game.height*0.45
				@createWall x*(@game.width-frameSize),0,frameSize,edgeSize
				@createWall x*(@game.width-frameSize),@game.height-edgeSize,frameSize,edgeSize

	createBats:->
		switch @currentGame
			when PongGame.SOCCER
				@createBat 	1,32
				@createBat 	1,@game.width*70/100
				@createBat 	2,@game.width-32
				@createBat 	2,@game.width*30/100
			when PongGame.TENNIS
				@createBat 	1,32
				@createBat 	2,@game.width-32
			when PongGame.SQUASH
				@createBat 	1,@game.width*3/4
				@createBat 	2,@game.width*3/4+32
			when PongGame.PRACTICE
				@createBat 	1,@game.width*3/4


	createBat: (side,x) ->
		if @batSize == 1 then h = @game.height/5 else h = @game.height/7
		bat = new Bat(@,side,x,@game.height/2,10,h)
		console.log bat.x
		@batGroup.add(bat.sprite)
		@bats.push(bat)

	createWall: (x,y,w,h) ->
		wall = @createBox(x,y,w,h,w>h)
		wall.body.immovable = true
		@frameGroup.add(wall)

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

class Bat 
	constructor: (@state,@side,@x,@y,@w,@h) ->
		@sprite = @state.createBox(@x,@y,@w,@h,false,false)
		@sprite.anchor.setTo(0.5,0.5)

class Ball
	constructor : (@state) ->
		@sprite = @state.createBox(100,100,20,20,false,false)		
		@sprite.anchor.setTo(0.5,0.5)
		@sprite.body.velocity.x = 300
		@sprite.body.velocity.y = 300
		@sprite.body.bounce.x = 1
		@sprite.body.bounce.y = 1

x = new PongGame()		
