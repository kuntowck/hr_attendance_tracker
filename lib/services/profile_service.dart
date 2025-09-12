import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileService {
  final CollectionReference employees = FirebaseFirestore.instance.collection(
    'employees',
  );
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createUserProfile(Profile profile) async {
    await employees.doc(profile.employeeId).set(profile.toMap());
  }

  Future<Profile?> getUserProfile(String employeeId) async {
    final doc = await employees.doc(employeeId).get();

    if (doc.exists) {
      return Profile.fromMap(doc.data() as Map<String, dynamic>);
    }

    return null;
  }

  Future<void> updateUserProfile(Profile profile) async {
    await employees.doc(profile.employeeId).update(profile.toMap());
  }

  Future<bool> checkUserExists(String employeeId) async {
    final doc = await employees.doc(employeeId).get();

    return doc.exists;
  }

  Future<String> uploadProfilePhoto(String employeeId, File file) async {
    final String fileName = "$employeeId-${DateTime.now()}";

    await _supabase.storage
        .from('employee-profile-photos')
        .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

    final url = _supabase.storage
        .from('employee-profile-photos')
        .getPublicUrl(fileName);

    await employees.doc(employeeId).update({'photo': url});

    return url;
  }

  Future<List<Profile>> getEmployees() async {
    final snapshot = await employees.where("role", isEqualTo: "employee").get();

    return snapshot.docs
        .map((doc) => Profile.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Profile> createEmployee({
    required String email,
    required String password,
    required String name,
    String role = "employee",
  }) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final profile = Profile(
      employeeId: credential.user!.uid,
      name: name,
      email: email,
      role: role,
    );

    await employees.doc(profile.employeeId).set(profile.toMap());

    return profile;
  }
}
