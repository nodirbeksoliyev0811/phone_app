import 'contact_sql.dart';

class Contact {
  int? id;
  String name;
  String surname;
  String phoneNumber;

  Contact(
      {required this.name,
      required this.surname,
      required this.phoneNumber,
      this.id});

  Map<String, dynamic> toMap() => {
        ContactModelFields.name: name,
        ContactModelFields.surname: surname,
        ContactModelFields.phoneNumber: phoneNumber,
      };

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
        id: json['id'],
        name: json['name'],
        surname: json['surname'],
        phoneNumber: json['phoneNumber'],
    );
  }
}
