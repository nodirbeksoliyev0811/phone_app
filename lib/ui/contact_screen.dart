import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phone_app/ui/single_contact_screen.dart';
import 'package:phone_app/ui/widgets/custom_searchbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/contact.dart';
import '../repository/contact_repository.dart';
import 'contact_add.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> contacts = [];
  String searchText = "";

  _loadContacts() async {
    List<Contact> newContacts = await DatabaseHelper.getContacts();
    setState(() {
      contacts = newContacts;
    });
  }

  _getSortBy(String order) async {
    contacts = await DatabaseHelper.getSortBy(order);
    setState(() {});
  }

  _getContactsByQuery(String query) async {
    contacts = await DatabaseHelper.search(query);
    setState(() {});
  }

  int select = 1;

  @override
  void initState() {
    _loadContacts();
    super.initState();
  }

  void save(int index) {
    saveName.text = contacts[index].name;
    saveSurname.text = contacts[index].surname;
    savePhoneNumber.text = contacts[index].phoneNumber;
  }

  TextEditingController saveName = TextEditingController();
  TextEditingController saveSurname = TextEditingController();
  TextEditingController savePhoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () async {
              showSearch(context: context, delegate: CustomSearchDelegate());
              if (searchText.isNotEmpty) _getContactsByQuery(searchText);
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            initialValue: select,
            // Callback that sets the selected popup menu item.
            onSelected: (int item) {
              setState(() {
                select = item;
              });
              if (select == 1) {
              } else {
                _getSortBy(select == 2 ? "ASC" : "DESC");
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                child: const Text(
                  "Delete all",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Future.delayed(
                    const Duration(seconds: 0),
                    () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Delete everything?',
                          style: TextStyle(color: Colors.red),
                        ),
                        content: const Text(
                          'Are you sure you want to remove everything',
                        ),
                        actions: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              )),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              DatabaseHelper.deleteContacts();
                              setState(() {});
                              _loadContacts();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("Sort A-Z"),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text('Sort Z-A'),
              ),
            ],
          ),
        ],
      ),
      body: contacts.isNotEmpty
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: contacts.length,
              itemBuilder: (context, index) => Slidable(
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => {
                        Future.delayed(
                          const Duration(seconds: 0),
                          () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                'Delete the contact?',
                                style: TextStyle(color: Colors.red),
                              ),
                              content: ListTile(
                                title: Text(
                                  "${contacts[index].name} ${contacts[index].surname}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 24),
                                ),
                                subtitle: Text(contacts[index].phoneNumber),
                              ),
                              actions: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  onPressed: () {
                                    DatabaseHelper.deleteContact(
                                        contacts[index].id!);
                                    setState(() {});
                                    _loadContacts();
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: "Delete",
                    ),
                    SlidableAction(
                      onPressed: (context) => {
                        save(index),
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Dialog(
                            child: Container(
                              height: 305,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: SizedBox(
                                      height: 55,
                                      child: TextField(
                                        controller: saveName,
                                        decoration: InputDecoration(
                                          labelText: "Name",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: Colors.black,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: SizedBox(
                                      height: 55,
                                      child: TextField(
                                        controller: saveSurname,
                                        decoration: InputDecoration(
                                          labelText: "Surname",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: Colors.black,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: SizedBox(
                                      height: 55,
                                      child: TextField(
                                        controller: savePhoneNumber,
                                        decoration: InputDecoration(
                                          labelText: "Phone Number",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: Colors.black,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Center(
                                            child: Text("Cancel"),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          onPressed: () {
                                            setState(() {});
                                            setState(() {Navigator.pop(context);});
                                            setState(() {
                                              DatabaseHelper.updateContact((
                                                contacts[index].name =
                                                    saveName.text,
                                                contacts[index].surname =
                                                    saveSurname.text,
                                                contacts[index].phoneNumber =
                                                    savePhoneNumber.text,
                                              ) as Contact);
                                            });
                                            _loadContacts();
                                          },
                                          child: const Center(
                                            child: Text("Save"),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10)
                                    ],
                                  ),
                                  const SizedBox(height: 10)
                                ],
                              ),
                            ),
                          ),
                        )
                      },
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: "Edit",
                    ),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SingleContactScreen(contact: contacts[index]),
                      ),
                    );
                  },
                  leading: const Icon(Icons.account_circle, size: 50),
                  title: Text(
                    "${contacts[index].name}  ${contacts[index].surname}",
                  ),
                  subtitle: Text(contacts[index].phoneNumber),
                  trailing: IconButton(
                    onPressed: () {
                      launchUrl(Uri.parse("tel:${contacts[index].phoneNumber}"));
                    },
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            )
          : const Center(child: Icon(Icons.add_call, size: 120)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContactAddScreen(),
              ));
        },
        elevation: 10,
        autofocus: true,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
