// Generated by CoffeeScript 1.12.3
var MainState, PhaserGame, x,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

PhaserGame = (function(superClass) {
  extend(PhaserGame, superClass);

  function PhaserGame() {
    PhaserGame.__super__.constructor.call(this, 640, 480);
    this.state.add('main', MainState);
    this.state.start('main', true, false, 1);
  }

  return PhaserGame;

})(Phaser.Game);

MainState = (function() {
  function MainState() {
    this.currentGame = 0;
  }

  MainState.prototype.init = function(gameID) {
    console.log("Game", gameID);
    return this.gameNumber = gameID;
  };

  MainState.prototype.create = function() {
    console.log('create');
    this.game.stage.backgroundColor = "#BD22C5";
    this.game.physics.startSystem(Phaser.Physics.ARCADE);
    this.frame = this.game.add.group();
    this.ball = this.createEntity(this.game.width / 2, Math.random() * this.game.height / 2 + this.game.height / 4, 20, 20, "#FFFF00");
    this.ball.body.velocity.x = 300;
    if (Math.random() < 0.5) {
      this.ball.body.velocity.y = -300;
    } else {
      this.ball.body.velocity.y = 300;
    }
    this.ball.body.bounce.x = 1;
    this.ball.body.bounce.y = 1;
    this.createWall(0, 0, this.game.width - 20, 20, "#FF8000");
    this.createWall(0, this.game.height - 20, this.game.width - 20, 20, "#FF8000");
    return this.createWall(this.game.width - 20, 0, 20, this.game.height, "#FF0000");
  };

  MainState.prototype.update = function() {
    return this.game.physics.arcade.collide(this.ball, this.frame);
  };

  MainState.prototype.createWall = function(x, y, w, h, colour) {
    var newSprite;
    newSprite = this.createBox(x, y, w, h, colour);
    this.frame.add(newSprite);
    newSprite.body.immovable = true;
    return newSprite;
  };

  MainState.prototype.createEntity = function(x, y, w, h, colour) {
    return this.createBox(x, y, w, h, colour);
  };

  MainState.prototype.createBox = function(x, y, w, h, colour) {
    var box, newSprite;
    box = this.game.add.bitmapData(w, h);
    box.ctx.beginPath();
    box.ctx.rect(0, 0, w, h);
    box.ctx.fillStyle = colour;
    box.ctx.fill();
    newSprite = this.game.add.sprite(x, y, box);
    this.game.physics.arcade.enable(newSprite);
    return newSprite;
  };

  return MainState;

})();

x = new PhaserGame();
