import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webdiary/models/diary.dart';
import 'package:webdiary/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DiaryService {
  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('usuarios');
  final CollectionReference diaryCollectionReference =
      FirebaseFirestore.instance.collection('diaries');

  // // Future<void> loginUser(String email, String password) async {
  // //   FirebaseAuth.instance
  // //       .signInWithEmailAndPassword(email: email, password: password);
  // //   return;
  // // }

  // Future<void> createUser(
  //     String firstName, BuildContext context, String uid) async {
  //   print('...creating user...');
  //   UserModel user = UserModel(firstName: firstName, uid: uid);
  //   userCollectionReference.add(user.toMap());
  //   return;
  // }

  // Future<void> update(
  //     UserModel user, String displayName, BuildContext context) async {
  //   UserModel updateUser = UserModel(firstName: displayName, uid: user.uid);

  //   userCollectionReference.doc(user.uid).update(updateUser.toMap());
  //   return;
  // }

  getAllDiariesByUser() {
    return diaryCollectionReference.snapshots().map((event) {
      return event.docs.map((diary) {
        return Diary.fromDocument(diary);
      }).where((element) {
        return (element.userId == FirebaseAuth.instance.currentUser!.uid);
      });
    });
  }

  Future<List<Diary>> getSameDateDiaries(DateTime first, String userId) {
    return diaryCollectionReference
        .where('entry_time',
            isGreaterThanOrEqualTo: Timestamp.fromDate(first).toDate())
        .where('entry_time',
            isLessThan:
                Timestamp.fromDate(first.add(Duration(days: 1))).toDate())
        .where('user_id', isEqualTo: userId)
        .get()
        .then((value) {
      // print('Items ==> ${value.docs.length}');
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      }).toList();
    });
  }

  getLatestDiaries(String uid) {
    return diaryCollectionReference
        .where('user_id', isEqualTo: uid)
        .orderBy('entry_time', descending: true)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      });
    });
  }

  getEarliestDiaries(String uid) {
    return diaryCollectionReference
        .where('user_id', isEqualTo: uid)
        .orderBy('entry_time', descending: false)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      });
    });
  }
}
