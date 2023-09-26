import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/contact.dart';
import '../repository/contact_repository.dart';

class SingleContactScreen extends StatefulWidget {
  const SingleContactScreen({
    super.key,
    required this.contact,
  });

  final Contact contact;

  @override
  State<SingleContactScreen> createState() => _SingleContactScreenState();
}

class _SingleContactScreenState extends State<SingleContactScreen> {
  List<Contact> contacts = [];

  _loadContacts() async {
    List<Contact> newContacts = await DatabaseHelper.getContacts();
    setState(() {
      contacts = newContacts;
    });
  }

  @override
  void initState() {
    _loadContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black)),
        title: const Text("Contact", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.only(top: 52, right: 12),
                child: Icon(
                  Icons.account_circle,
                  size: 150,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              "${widget.contact.name} ${widget.contact.surname}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Text(
                  widget.contact.phoneNumber,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.green),
                  child: IconButton(
                    onPressed: () {
                      launchUrl(Uri.parse("tel:${widget.contact.phoneNumber}"));
                    },
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.orange),
                  child: IconButton(
                    onPressed: () {
                      launchUrl(Uri.parse("sms:${widget.contact.phoneNumber}"));
                    },
                    icon: const Icon(
                      Icons.chat,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
