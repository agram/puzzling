import hxd.Key in K;

enum ModeJeu {
	AVENTURE;
	FACILE;
	MOYEN;
	DIFFICILE;
	EXPERT;
	IMPOSSIBLE;
}

typedef AllKeys = { 
	up : Bool, 
	down : Bool, 
	right : Bool, 
};

enum SoldierType {
	WARRIOR;
	ARCHER;
	MAGE;
}

enum Owner {
	PLAYER;
	ENEMY;
}

typedef Res = hxd.Res;

enum ResFight {
	NUL;
	WIN;
	DEFEAT;
}

enum BattleState {
	NONE;
	BATTLE_RESOLVING;
	CPU_RENFORT;
	PLAYER_RENFORT;
}