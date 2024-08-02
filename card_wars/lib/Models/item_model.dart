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
  bool effectValidFromGrave; // is the effect valid from the grave or not?
  bool effectValidFromNone; // is the effect valied after beiong completely destroyed?
  bool
      isAbilityRev; // is the ability of this card's effects reversible after the duration ends?
  List<bool>
      isCurrentAbilityRev; //is the cuurent applied ability revesible each value corrosponds to the respective value in the item CARED EFFECT?
  List<Item> equippedCards; // the cards equuiped to this card
  List<Item>
      appliedEffectCards; // the cards thatapplied an eefect on this one // to be updated every time there's a change in the real card
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
      required this. effectValidFromGrave, 
  required this. effectValidFromNone, 
required this.      isAbilityRev, 
   this.
      isCurrentAbilityRev= const[], 
   this.
      appliedEffectCards=const [],
    this.turns = 0,
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
      turns: map['turns'] ?? 0,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      canAttack: map['canAttack'] ?? false,
      canDefend: map['canDefend'] ?? false,
      canSwitchDefend: map['canSwitchDefend'] ?? false,
      canHeal: map['canHeal'] ?? false,
      canDie: map['canDie'] ?? false,
      canKill: map['canKill'] ?? false,
      canGoGrave: map['canGoGrave'] ?? false,
      hasAbility: map['hasAbility'] ?? false,
      canUseAbility: map['canUseAbility'] ?? false,
      needsCondition: map['needsCondition'] ?? false,
      canRevive: map['canRevive'] ?? false,
      canBeRevived: map['canBeRevived'] ?? false,
      canBeEquipped: map['canBeEquipped'] ?? false,
      canhaveEquipped: map['canhaveEquipped'] ?? false,
      canequipOther: map['canequipOther'] ?? false,
      isThereabilityCondition: map['isThereabilityCondition'] ?? false,
      equippedCards: map['equippedCards'] != null
          ? List<Item>.from(map['equippedCards'].map((x) => Item.fromMap(x)))
          : [],
      hp: map['hp'] != null ? List<int>.from(map['hp']) : [],
      target: map['target'] != null ? List<Object>.from(map['target']) : [],
      attk: map['attk'] != null ? List<int>.from(map['attk']) : [],
      def: map['def'] != null ? List<int>.from(map['def']) : [],
      heal: map['heal'] != null ? List<int>.from(map['heal']) : [],
      graveAmount:
          map['graveAmount'] != null ? List<int>.from(map['graveAmount']) : [],
      handAmount:
          map['handAmount'] != null ? List<int>.from(map['handAmount']) : [],
      abilityDuration: map['abilityDuration'] != null
          ? List<int>.from(map['abilityDuration'])
          : [],
      abilityDurationRepeat: map['abilityDurationRepeat'] ?? 0,
      equippedNumber: map['equippedNumber'] != null
          ? List<int>.from(map['equippedNumber'])
          : [],
      hasEffectOnIt: map['hasEffectOnIt'] ?? false,
      effectActive: map['effectActive'] ?? false,
      canEffectBeAppliedOn: map['canEffectBeAppliedOn'] ?? false,
      canUseEffect: map['canUseEffect'] ?? false,
      condition: map['condition'] != null
          ? List<Condition>.from(
              map['condition'].map((x) => Condition.values[x]))
          : [],
      cardType: map['cardType'] != null
          ? CardType.values[map['cardType']]
          : CardType.monster, // Default to Type1
      activation: map['activation'] != null
          ? Activation.values[map['activation']]
          : Activation.manual, // Default to Activation1
      range: map['range'] != null
          ? Rangen(map['range']['start'], map['range']['end'])
          : Rangen(0, 0), // Default to Rangen(0, 0)
      targetNumber: map['targetNumber'] != null
          ? List<int>.from(map['targetNumber'])
          : [],
      targetType: map['targetType'] != null
          ? List<CardType>.from(
              map['targetType'].map((x) => CardType.values[x]))
          : [],
      ability: map['ability'] != null
          ? List<Condition>.from(map['ability'].map((x) => Condition.values[x]))
          : [],
          isCurrentAbilityRev: map['isCurrentAbilityRev'] != null
          ? List<bool>.from(map['equippedNumber'])
          : [],
          appliedEffectCards: map['appliedEffectCards'] != null
          ? List<Item>.from(map['appliedEffectCards'])
          : [], effectValidFromGrave: map['effectValidFromGrave'] ?? false, effectValidFromNone: map['effectValidFromNone'] ?? false, isAbilityRev: map['isAbilityRev'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
      'isCurrentAbilityRev': isCurrentAbilityRev,
      'appliedEffectCards': appliedEffectCards.map((x) => x.toMap()).toList(),
      'target': target, // Add target to toMap
      'effectValidFromGrave': effectValidFromGrave,
      'effectValidFromNone': effectValidFromNone,
      'isAbilityRev': isAbilityRev,
    };
  }
}
