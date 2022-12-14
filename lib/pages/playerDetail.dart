import 'package:doppelkopf/classes/Player.dart';
import 'package:doppelkopf/classes/PlayerController.dart';
import 'package:flutter/material.dart';

class playerDetail extends StatefulWidget {
  Player player;
  playerDetail(this.player);

  @override
  _playerDetailState createState() => _playerDetailState();
}

class _playerDetailState extends State<playerDetail> {
  Future<Player> createEditPlayerDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter the Players Details."),
            content: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                ),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    hintText: "Age",
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(Player(
                        nameController.text.toString(),
                        ageController.text.toString()));
                  },
                  child: Text("Submit")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Player: ${widget.player.name}"),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Transform.scale(
                    scale: 3.0,
                    child: Hero(
                      tag:
                          "playerAvatar ${widget.player.name}",
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey[800],
                        child: Text(widget.player.name.substring(0, 1),
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(widget.player.name),
              Text(widget.player.age),
              ElevatedButton(
                  onPressed: () {
                    createEditPlayerDialog(context).then((onValue) {
                      if (onValue != null) {
                        widget.player.name = onValue.name;
                        widget.player.age = onValue.age;

                        setState(() {});
                      }
                    });
                  },
                  child: Text("Edit")),
              ElevatedButton(
                  onPressed: () {
                    createDeletePlayerConfirmationDialog(context)
                        .then((onValue) {
                      if (onValue == true) {
                        Navigator.pop(context);
                      }
                    });
                  },
                  child: Text("Delete"))
            ],
          ),
        ));
  }

  Future<bool> createDeletePlayerConfirmationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter the Players Details."),
            content:
                Text("Do you want to delete Player ${widget.player.name}?"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    PlayerController.deletePlayer(widget.player);
                    Navigator.of(context)
                        .pop(true); // return true if palyer was deleted
                  },
                  child: Text("Yes")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // return false if player wasnt deleted
                  },
                  child: Text("No"))
            ],
          );
        });
  }
}
