import 'package:flutter/material.dart';
import 'package:phone_app/ui/widgets/custom_input_widget.dart';

import '../models/contact.dart';
import '../repository/contact_repository.dart';
import 'contact_screen.dart';

class ContactAddScreen extends StatefulWidget {
  const ContactAddScreen({Key? key}) : super(key: key);

  @override
  State<ContactAddScreen> createState() => _ContactAddScreenState();
}

class _ContactAddScreenState extends State<ContactAddScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController surnameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController imageController = TextEditingController();

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            )),
        title: const Text('Add', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                  DatabaseHelper.insertContact(
                    Contact(
                      name: nameController.text,
                      surname: surnameController.text,
                      phoneNumber: phoneController.text,
                    ),
                  );
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Ma'lumotlani to'ldiring!"),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.done,
                color: Colors.black,
              ))
        ],
      ),
      body: ListView(
        children: [
          Expanded(
            child: Column(
              children: [
                InputTextField(
                  label: 'Name',
                  hint: 'Enter name',
                  controller: nameController,
                ),
                InputTextField(
                  label: 'Surname',
                  hint: 'Enter surname',
                  controller: surnameController,
                ),
                InputTextField(
                  label: 'Phone number',
                  hint: '+998  _ _  _ _ _  _ _  _ _',
                  inputType: TextInputType.phone,
                  controller: phoneController,
                ),
                SizedBox(
                  height: 80,
                  child: Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...List.generate(
                          images.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                setState(() {
                                  count = index;
                                });
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black12,
                                    ),
                                    child: Center(
                                        child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.asset(
                                        images[index],
                                        height: 60,
                                        width: 60,
                                      ),
                                    )),
                                  ),
                                  index == count
                                      ? Center(
                                          child: Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius: BorderRadius.circular(40),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.done,
                                                size: 50,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
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

List<String> images = [
  "assets/img/img.png",
  "assets/img/img_1.png",
  "assets/img/img_2.png",
  "assets/img/img_3.png",
  "assets/img/img_4.png",
  "assets/img/img_5.png",
  "assets/img/img_6.png",
  "assets/img/img_7.png",
  "assets/img/img_8.png",
  "assets/img/img_9.png",
];
