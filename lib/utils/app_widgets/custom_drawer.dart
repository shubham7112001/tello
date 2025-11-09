import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/app_widgets/background_widgets.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool active = true;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: AppBackgroundWidgets(
        child: ListView(children: [
          DrawerHeader(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.red,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text("trello.user.name!"),
              ),
              Text("sdfghj"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(".user.email"),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          active = !active;
                        });
                      },
                      icon: Icon((active)
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up))
                ],
              )
            ],
          )),
          (active)
              ? Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.pages,
                        color: Colors.brown,
                      ),
                      title: const Text(
                        'Boards',
                        style: TextStyle(
                            color: Colors.brown, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        
                      },
                    ),
                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.brown,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Workspaces"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.card_membership),
                      title: const Text("My cards"),
                      onTap: () {
                        
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.pages),
                      title: const Text("Offline boards"),
                      onTap: () {
                        
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text("Settings"),
                      onTap: () {
                        
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.help_outline_rounded),
                      title: const Text("Help!"),
                      onTap: () {},
                    ),
                  ],
                )
              : ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Add account'),
                  onTap: () {},
                )
        ]),
      ),
    );
  }
}