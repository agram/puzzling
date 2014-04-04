import Common;

class Const
{
	public static var TS = 32; // TILE SIZE

	public static var SCENE_W = 960; // SCENE WIDTH
	public static var SCENE_H = 480; // SCENE HEIGHT
	
	//***
	public var CASTLE_PLAYER:Int;
	public var CASTLE_ENEMY:Int;
	
	public var TIMER:Int; // PLAYER WIDTH
	
	public var playerWave:Int; 
	public var enemyWave:Int; 
	public var enemySupply:Int; 
	public var battleground:Int; // Champs de bataille séparant les 2 armées. Plus c'est court, plus c'est difficile.
	public var nbTroup:Int; // combien de troupes dans chaque colonnes
	
	public static var MOVESPEED = 10;
	public static var SUPPLYSPEED = 10;
	public static var ASSAULTSPEED = 5;
	public static var DEATHSPEED = 20;
	
	public var chosenMode:ModeJeu;
	
	public function new (chosenMode:ModeJeu) {
		
		this.chosenMode = chosenMode;
		
		switch(chosenMode) {
			case AVENTURE:
				TIMER = 14;
				CASTLE_PLAYER = 10;
				CASTLE_ENEMY = 1;
				playerWave = 1;
				enemyWave = 1;
				enemySupply = 1;
				battleground = 4;
				nbTroup = 4;
			case FACILE:
				TIMER = 14;
				CASTLE_PLAYER = 10;
				CASTLE_ENEMY = 10;
				playerWave = 1;
				enemyWave = 1;
				enemySupply = 1;
				battleground = 4;
				nbTroup = 4;
			case MOYEN:
				TIMER = 12;
				CASTLE_PLAYER = 20;
				CASTLE_ENEMY = 20;
				playerWave = 2;
				enemyWave = 4;
				enemySupply = 2;
				battleground = 4;
				nbTroup = 4;
			case DIFFICILE:
				TIMER = 10;
				CASTLE_PLAYER = 20;
				CASTLE_ENEMY = 30;
				playerWave = 3;
				enemyWave = 6;
				enemySupply = 3;
				battleground = 4;
				nbTroup = 6;
			case EXPERT:
				TIMER = 8;
				CASTLE_PLAYER = 20;
				CASTLE_ENEMY = 50;
				playerWave = 3;
				enemyWave = 8;
				enemySupply = 5;
				battleground = 4;
				nbTroup = 8;
			case IMPOSSIBLE:
				TIMER = 6;
				CASTLE_PLAYER = 20;
				CASTLE_ENEMY = 100;
				playerWave = 3;
				enemyWave = 10;
				enemySupply = 3;
				battleground = 2;
				nbTroup = 10;
		}
	}
}