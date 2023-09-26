import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/contact.dart';
import '../../repository/contact_repository.dart';
import '../single_contact_screen.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate() {
    _loadContacts();
  }

  _loadContacts() async {
    contacts = await DatabaseHelper.getContacts();
  }

  List<Contact> contacts = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    _loadContacts();
    for (var fruit in contacts) {
      if (("${fruit.name} ${fruit.surname}")
          .toLowerCase()
          .contains(query.toLowerCase())) {
        matchQuery.add(fruit.name);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {},
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Contact> matchQuery = [];
    for (var contact in contacts) {
      if (("${contact.name} ${contact.surname} ${contact.phoneNumber}")
          .toLowerCase()
          .contains(query.toLowerCase())) {
        matchQuery.add(contact);
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black12,
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SingleContactScreen(contact: result),
                    ),
                  );
                },
                leading: const Icon(Icons.account_circle, size: 50),
                title: Text(
                  "${result.name} ${result.surname}",
                ),
                subtitle: Text(result.phoneNumber),
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
          );
        },
      ),
    );
  }
}