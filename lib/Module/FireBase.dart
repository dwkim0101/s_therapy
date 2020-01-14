import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireBase {
  GoogleSignIn _googleSignIn;
  bool _isSignedIn = false;
  StreamSubscription<GoogleSignInAccount> _accountStream;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentReference _documentReference;
  void Function() _userChagedCb;

  FireBase._() {
    _googleSignIn = GoogleSignIn();
  }
  static final FireBase instance = FireBase._();

  void setUserStateChagedCb(void Function() cb){
    print("setUserStateChangedCb");
    _accountStream?.cancel();
    _userChagedCb = cb;
    if (cb == null) return ;
    _accountStream = _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if (account != null) print("userChaged!! ${account.email}");
      else print("user Changed to null");
      _documentReference = account == null ? null : Firestore.instance.document("purchase/${account.email}");
      _isSignedIn = account == null ? false : true;
      _userChagedCb?.call();
    });
  }

  String getUserPhotoUrl() => _googleSignIn.currentUser.photoUrl;
  String getUserDisPlayName() => _googleSignIn.currentUser.displayName;

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult userResult = await _auth.signInWithCredential(credential);
    print("User Name : " + userResult.user.displayName);
    _isSignedIn = true;
    return userResult.user;
  }

  void signOut() {
    _googleSignIn.signOut();
    _isSignedIn = false;
  }

  bool isSignedIn(){
    return _isSignedIn;
  }

  void silentlySignIn(){
    _googleSignIn.isSignedIn().then((v){
      if (v == false) return;
      _googleSignIn.signInSilently().then((v){
        print("Silently SignIn");
        _documentReference = Firestore.instance.document("purchase/${_googleSignIn.currentUser.email}");
      });
      _isSignedIn = v;
    });
  }

  void add() {
    Map<String, String> data = <String, String>{
      "date": DateTime.now().toString(),
      "month": "1"
    };
    _documentReference.setData(data).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));
  }

  void delete() {
    _documentReference.delete().whenComplete(() {
      print("Deleted Successfully");
      //setState(() {});
    }).catchError((e) => print(e));
  }

  void update() {
    Map<String, String> data = <String, String>{
      "date": DateTime.now().toString(),
      "month": "1"
    };
    _documentReference.updateData(data).whenComplete(() {
      print("Document Updated");
    }).catchError((e) => print(e));
  }

  Future<String> fetch() async{
    DocumentSnapshot snapShot = await _documentReference.get();
    if (snapShot.exists == false) return "{}";
    return snapShot.data.toString();
  }
}