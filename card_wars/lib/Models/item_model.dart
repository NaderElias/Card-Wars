import 'package:mongo_dart/mongo_dart.dart';

import '../enums/condition.dart';
import '../enums/card_type.dart';
import '../enums/activation.dart';
import '../classes/range.dart';

class Item {
  // REQUIRED
  String name; //name
  String image; // image
  bool canAttack; //can this card attack another card?
  bool canDefend; // can this card defend another card?
  bool canSwitchDefend; //can this card switch to defend position?
  bool canHeal; // can this card heal another?
  bool canDie; // can this card be killed(hit points zero?)?
  bool canKill; // can this card kill(hit points zero?)?
  bool canGoGrave; //can it be sent to the grave or destroyed?
  bool hasAbility; // does it have an ability?
  bool canUseAbility; //can it use it's ability?
  bool needsCondition; // does it need to fullfil the condition to activate?
  bool canRevive; // can this card revive something?
  bool canBeRevived; //can this card be revived?
  bool canBeEquipped; // can it equip to other cards?
  bool canhaveEquipped; // can it have equipped cards?
  bool canequipOther; // can this card eqip  a card to another?\
  bool isThereabilityCondition; // is there a condituion for this ability?
  List<Item> equippedCards; // the cards equuiped to this card
  /////////////////////////////////TARGET OF THE ABILITY HAS IT"S OWN var////////////////////////////////////////////
  // AMOUNTS [0] is normal [1] for ability condition [2] ability amounts
  List<int> hp; // hitpoints
  List<int> attk; // attack dmg
  List<int> def; // defence dmg neg
  List<int> heal; // amount to heal another
  List<int> graveAmount; // amount of cards in the grave
  List<int> handAmount; //amount of cards in hand
  List<int>
      abilityDuration; // the duration of the ability in turns 1=> everyturn,2=> every two turns and so forth that's [0] ,[1] is a counter
  int abilityDurationRepeat; // the repeatition meaning if the counter exceeds then ability stop
  int turns; // been alive for how many turns
  List<int> equippedNumber; // number of cards equiped to this one
  /////////////////////////////////////////////////////////////////////////////
  // OTHERS
  bool hasEffectOnIt; // does this card have an effect on it?
  bool effectActive; //is it's effect currently active?
  bool canEffectBeAppliedOn; // can an effect be applied on it?
  bool canUseEffect; // can this effect be activated?
  List<Condition> condition; // the category of the condition
  CardType cardType; // the type of the card
  Activation activation; // the type of ability activation
  Rangen range = Rangen(0, 0); // a range for when useful
  List<Object> target; // the target [0] for ability,[1] for condition
  List<int>
      targetNumber; // [0] ability target number,[1] condition target number
  List<CardType>
      targetType; // [0] ability target type,[1] condition target type
  List<Condition> ability; // the ability
//// the hp condition will be done as the condition target and effect target will be
// Constructor with required parameters
  Item({
    required this.name,
    required this.image,
    required this.canAttack,
    required this.canDefend,
    required this.canSwitchDefend,
    required this.canHeal,
    required this.canDie,
    required this.canKill,
    required this.canGoGrave,
    required this.needsCondition,
    required this.hasAbility,
    required this.canUseAbility,
    required this.canRevive,
    required this.canBeRevived,
    required this.canBeEquipped,
    required this.canhaveEquipped,
    required this.canequipOther,
    required this.isThereabilityCondition,
    required this.equippedCards,
    required this.cardType,
    required this.activation,
    required this.range,
    this.turns=0,
    this.target = const [],
    this.hp = const [],
    this.attk = const [],
    this.def = const [],
    this.heal = const [],
    this.graveAmount = const [],
    this.handAmount = const [],
    this.abilityDuration = const [],
    this.abilityDurationRepeat = 0,
    this.equippedNumber = const [],
    this.hasEffectOnIt = false,
    this.effectActive = false,
    this.canEffectBeAppliedOn = false,
    this.canUseEffect = false,
    this.condition = const [],
    this.targetNumber = const [],
    this.targetType = const [],
    this.ability = const [],
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      turns: map['turns'],
      name: map['name'],
      image: map['image'],
      canAttack: map['canAttack'],
      canDefend: map['canDefend'],
      canSwitchDefend: map['canSwitchDefend'],
      canHeal: map['canHeal'],
      canDie: map['canDie'],
      canKill: map['canKill'],
      canGoGrave: map['canGoGrave'],
      hasAbility: map['hasAbility'],
      canUseAbility: map['canUseAbility'],
      canRevive: map['canRevive'],
      canBeRevived: map['canBeRevived'],
      canBeEquipped: map['canBeEquipped'],
      canhaveEquipped: map['canhaveEquipped'],
      canequipOther: map['canequipOther'],
      isThereabilityCondition: map['isThereabilityCondition'],
      equippedCards: List<Item>.from(
          map['equippedCards']?.map((x) => Item.fromMap(x)) ?? []),
      hp: List<int>.from(map['hp']),
      target: List<Object>.from(map['target']),
      attk: List<int>.from(map['attk']),
      def: List<int>.from(map['def']),
      heal: List<int>.from(map['heal']),
      graveAmount: List<int>.from(map['graveAmount']),
      handAmount: List<int>.from(map['handAmount']),
      abilityDuration: List<int>.from(map['abilityDuration']),
      abilityDurationRepeat: map['abilityDurationRepeat'],
      equippedNumber: List<int>.from(map['equippedNumber']),
      hasEffectOnIt: map['hasEffectOnIt'],
      effectActive: map['effectActive'],
      canEffectBeAppliedOn: map['canEffectBeAppliedOn'],
      canUseEffect: map['canUseEffect'],
      condition: List<Condition>.from(
          map['condition']?.map((x) => Condition.values[x]) ?? []),
      cardType: CardType.values[map['cardType']],
      activation: Activation.values[map['activation']],
      range: Rangen(map['range']['start'], map['range']['end']),
      targetNumber: List<int>.from(map['targetNumber']),
      targetType: List<CardType>.from(
          map['targetType']?.map((x) => CardType.values[x]) ?? []),
      ability: List<Condition>.from(
          map['ability']?.map((x) => Condition.values[x]) ?? []),
      needsCondition: map['needsCondition'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'target':target,
      'turns': turns,
      'name': name,
      'image': image,
      'canAttack': canAttack,
      'canDefend': canDefend,
      'canSwitchDefend': canSwitchDefend,
      'canHeal': canHeal,
      'canDie': canDie,
      'canKill': canKill,
      'canGoGrave': canGoGrave,
      'needsCondition': needsCondition,
      'hasAbility': hasAbility,
      'canUseAbility': canUseAbility,
      'canRevive': canRevive,
      'canBeRevived': canBeRevived,
      'canBeEquipped': canBeEquipped,
      'canhaveEquipped': canhaveEquipped,
      'canequipOther': canequipOther,
      'isThereabilityCondition': isThereabilityCondition,
      'equippedCards': equippedCards.map((x) => x.toMap()).toList(),
      'hp': hp,
      'attk': attk,
      'def': def,
      'heal': heal,
      'graveAmount': graveAmount,
      'handAmount': handAmount,
      'abilityDuration': abilityDuration,
      'abilityDurationRepeat': abilityDurationRepeat,
      'equippedNumber': equippedNumber,
      'hasEffectOnIt': hasEffectOnIt,
      'effectActive': effectActive,
      'canEffectBeAppliedOn': canEffectBeAppliedOn,
      'canUseEffect': canUseEffect,
      'condition': condition.map((x) => x.index).toList(),
      'cardType': cardType.index,
      'activation': activation.index,
      'range': {'start': range.start, 'end': range.end},
      'targetNumber': targetNumber,
      'targetType': targetType.map((x) => x.index).toList(),
      'ability': ability.map((x) => x.index).toList(),
    };
  }
}
