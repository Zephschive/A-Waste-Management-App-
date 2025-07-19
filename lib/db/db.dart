import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_core/firebase_core.dart';

class DB {

  static final FirebaseAuth auth = FirebaseAuth.instance;


  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

 
}

// For convenience, re-export the auth & firestore instances


FirebaseAuth get auth => DB.auth;
FirebaseFirestore get firestore => DB.firestore;

