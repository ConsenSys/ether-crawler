import "ChallengeRegistry";

contract GameStub {
  function over() returns(bool) {}
  function won() returns(bool) {}
  function initialize(uint16 character, address player, LevelStub[] levels) {}
}

contract LevelStub {
  function pay_royalty() {
  }
}

contract GamebuilderStub {
  function create_game() returns (GameStub) {}
}

contract Challenge {
  LevelStub[] public levels;
  uint16 public character;
  uint public bet_value;
  address public player;
  struct Offer { address sender; uint value; }
  Offer public best_offer;
  bool public started;
  GamebuilderStub public gamebuilder;
  GameStub public game;
  ChallengeRegistry registry;
  uint reg_id;
  
  modifier auth(address user) { if (msg.sender == user) _ }

  function Challenge(ChallengeRegistry _registry, uint16 _character) {
    registry = _registry;
    character = _character;
    bet_value = msg.value;
    player = msg.sender;

    reg_id = registry.register(player, bet_value);
  }

  function add_level(LevelStub _level) {
    levels[levels.length++] = _level;
    registry.set_num_levels(reg_id, levels.length);
  }

  function add_levels(LevelStub[] _levels) {
    levels = _levels;
    registry.set_num_levels(reg_id, levels.length);
  }

  function set_gamebuilder(GamebuilderStub _gamebuilder) {
    gamebuilder = _gamebuilder;
    game = gamebuilder.create_game();
  }

  function num_levels() returns(uint) {
    return levels.length;
  }

  function make_offer() {
    if (started == true) { return; }
    if (msg.value > best_offer.value) {
      best_offer.sender.send(best_offer.value);
      best_offer = Offer(msg.sender, msg.value);
      registry.new_offer(reg_id, msg.value);
    } else {
      msg.sender.send(msg.value);
    }
  }

  function accept() auth(player) {
    started = true;
    registry.accept(reg_id);
    game.initialize(character, player, levels);
  }

  function claim() {
    if (game.over() == false) { return; }

    uint payout = this.balance - (this.balance / 10);
    uint total_royalty = this.balance - payout;
    uint royalty = total_royalty / levels.length;

    for (uint i = 0; i < levels.length; i++) {
      levels[i].pay_royalty.value(royalty)();
    }

    if (game.won() == true) {
      player.send(payout);
    } else {
      best_offer.sender.send(payout);
    }
  }
}
