import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/item_model.dart';
import '../providers/Base.dart';
import '../providers/kards.dart';
import '../enums/condition.dart';
import '../enums/card_type.dart';
import '../enums/activation.dart';
import '../classes/range.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  bool _showingContent = false;
  Widget _drawerContent = Container();

  @override
  void initState() {
    super.initState();
    final base = Provider.of<Base>(context, listen: false);
    base.initialize('Cards');
    base.mongoDBService.fetchop();
  }

  void _showDrawerContent(Widget content) {
    setState(() {
      _showingContent = true;
      _drawerContent = content;
    });
  }

  void _showDrawerButtons() {
    setState(() {
      _showingContent = false;
      _drawerContent = _buildDrawerButtons();
    });
  }

  //// this is temp to be del
  void deleteTemp() {
    final base = Provider.of<Base>(context, listen: false);
    base.initialize('');
    base.mongoDBService.deleteCookie();
    context.go('/');
  }

  Widget _buildDrawerButtons() {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          title: Text('Option 1'),
          onTap: () =>
              _showDrawerContent(_buildContent('Content for Option 1')),
        ),
        ListTile(
          title: Text('Option 2'),
          onTap: () =>
              _showDrawerContent(_buildContent('Content for Option 2')),
        ),
        ListTile(
          title: Text('Decks'),
          onTap: () => context.go('/decks'),
        ),
        ListTile(
          title: Text('LogOut'),
          onTap: () => deleteTemp(),
        ),
      ],
    );
  }

  Widget _buildContent(String contentText) {
    return Column(
      children: [
        AppBar(
          title: Text('Content View'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _showDrawerButtons,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              contentText,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  void _showItemDetails(Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildItemDetail('Turns', item.turns),
                _buildItemDetail('Can Attack', item.canAttack),
                _buildItemDetail('Can Defend', item.canDefend),
                _buildItemDetail('Can Switch Defend', item.canSwitchDefend),
                _buildItemDetail('Can Heal', item.canHeal),
                _buildItemDetail('Can Die', item.canDie),
                _buildItemDetail('Can Kill', item.canKill),
                _buildItemDetail('Can Go Grave', item.canGoGrave),
                _buildItemDetail('Has Ability', item.hasAbility),
                _buildItemDetail('Can Use Ability', item.canUseAbility),
                _buildItemDetail('Needs Condition', item.needsCondition),
                _buildItemDetail('Can Revive', item.canRevive),
                _buildItemDetail('Can Be Revived', item.canBeRevived),
                _buildItemDetail('Can Be Equipped', item.canBeEquipped),
                _buildItemDetail('Can have Equipped', item.canhaveEquipped),
                _buildItemDetail('Can Equip Other', item.canequipOther),
                _buildItemDetail(
                    'Is There ability Condition', item.isThereabilityCondition),
                _buildItemDetail('HP', item.hp),
                _buildItemDetail('Attack', item.attk),
                _buildItemDetail('Defense', item.def),
                _buildItemDetail('Heal', item.heal),
                _buildItemDetail('Grave Amount', item.graveAmount),
                _buildItemDetail('Hand Amount', item.handAmount),
                _buildItemDetail('Ability Duration', item.abilityDuration),
                _buildItemDetail(
                    'Ability Duration Repeat', item.abilityDurationRepeat),
                _buildItemDetail('Equipped Number', item.equippedNumber),
                _buildItemDetail('Has Effect On It', item.hasEffectOnIt),
                _buildItemDetail('Effect Active', item.effectActive),
                _buildItemDetail(
                    'Can Effect Be Applied On', item.canEffectBeAppliedOn),
                _buildItemDetail('Can Use Effect', item.canUseEffect),
                _buildItemDetail('Condition',
                    item.condition.map((e) => e.toString()).join(', ')),
                _buildItemDetail('Card Type', item.cardType.toString()),
                _buildItemDetail('Activation', item.activation.toString()),
                _buildItemDetail('Range',
                    'Start: ${item.range.start}, End: ${item.range.end}'),
                _buildItemDetail('Target Number', item.targetNumber),
                _buildItemDetail('Target Type',
                    item.targetType.map((e) => e.toString()).join(', ')),
                _buildItemDetail('Ability',
                    item.ability.map((e) => e.toString()).join(', ')),
                // ignore: unnecessary_null_comparison
              ]
                  .where((element) => element != null)
                  .toList(), // Remove null entries
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildItemDetail(String title, dynamic value) {
    if (value == null) return value;
    return Text('$title: $value');
  }

  @override
  Widget build(BuildContext context) {
    final base = Provider.of<Base>(context);
    final itemsProvider = Provider.of<ItemsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Items'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.go('/arena');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: _showingContent ? _drawerContent : _buildDrawerButtons(),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Item>>(
              stream: base.mongoDBService.itemsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No items available'));
                } else {
                  List<Item> items = snapshot.data!;
                  itemsProvider.setItems(items); //tempo remove later

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      Uint8List imageBytes = base64Decode(items[index].image);
                      return GestureDetector(
                        onTap: () => _showItemDetails(items[index]),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  12), // Adjust the radius as needed
                              child: Image.memory(
                                imageBytes,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black.withOpacity(0.6),
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Center(
                                  child: Text(
                                    items[index].name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final picker = ImagePicker();
          final pickedFile =
              await picker.pickImage(source: ImageSource.gallery);

          if (pickedFile != null) {
            String base64Image =
                await base.mongoDBService.encodeImageToBase64(pickedFile.path);
            Item newItem = Item(
              name: 'New Name',
              image: base64Image,
              canAttack: true,
              canDefend: true,
              canSwitchDefend: true,
              canHeal: true,
              canDie: true,
              canKill: true,
              canGoGrave: true,
              hasAbility: true,
              canUseAbility: true,
              needsCondition: true,
              canRevive: true,
              canBeRevived: true,
              canBeEquipped: true,
              canhaveEquipped: true,
              canequipOther: true,
              isThereabilityCondition: true,
              equippedCards: [],
              hp: [10, 5, 3],
              attk: [8, 4, 2],
              def: [7, 3, 1],
              heal: [5, 2, 1],
              graveAmount: [2, 1, 0],
              handAmount: [3, 2, 1],
              abilityDuration: [3, 2, 1],
              abilityDurationRepeat: 3,
              turns: 0,
              equippedNumber: [1, 0, 0],
              hasEffectOnIt: false,
              effectActive: false,
              canEffectBeAppliedOn: true,
              canUseEffect: true,
              condition: [Condition.hp, Condition.attack],
              cardType: CardType.monster,
              activation: Activation.manual,
              range: Rangen(0, 1),
              target: [],
              targetNumber: [1, 0],
              targetType: [CardType.monster, CardType.player],
              ability: [Condition.hp, Condition.defence],
              effectValidFromGrave: false,
              effectValidFromNone: false,
              isAbilityRev: false,
              date: DateTime.now(),
              id: null,
            );

            // bring these back
            await base.mongoDBService.insertItem(newItem);
            base.mongoDBService.fetchop();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
