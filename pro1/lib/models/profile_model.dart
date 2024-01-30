import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String name;
  String phoneNumber;
  String createdAt;
  String uid;
  String bookingCode;

  UserModel({
    required this.name,
    required this.phoneNumber,
    required this.createdAt,
    required this.uid,
    this.bookingCode = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      createdAt: json['createdAt'] ?? '',
      uid: json['uid'] ?? '',
      bookingCode: json['bookingCode'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'uid': uid,
      'bookingCode': bookingCode,
    };
  }

  factory UserModel.fromsnapshot(DocumentSnapshot <Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      name: data['name'],
      phoneNumber: data['phoneNumber'],
      createdAt: data['createdAt'],
      uid: data['uid'],
    );
  }
}