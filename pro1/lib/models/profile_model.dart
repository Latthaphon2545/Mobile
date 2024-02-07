import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String name;
  String phoneNumber;
  String createdAt;
  String uid;
  String bookingCode;
  String numberOfPeople;

  UserModel({
    required this.name,
    required this.phoneNumber,
    required this.createdAt,
    required this.uid,
    this.bookingCode = '',
    this.numberOfPeople = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      createdAt: json['createdAt'] ?? '',
      uid: json['uid'] ?? '',
      bookingCode: json['bookingCode'] ?? '',
      numberOfPeople: json['numberOfPeople'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'uid': uid,
      'bookingCode': bookingCode,
      'numberOfPeople': numberOfPeople,
    };
  }

  factory UserModel.fromsnapshot(DocumentSnapshot <Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      name: data['name'],
      phoneNumber: data['phoneNumber'],
      createdAt: data['createdAt'],
      uid: data['uid'],
      bookingCode: data['bookingCode'],
      numberOfPeople: data['numberOfPeople'],
    );
  }
}