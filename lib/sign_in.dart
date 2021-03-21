//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mysql1/mysql1.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
// Eventually this will be loading in the Firebase database for cross-device synchronization
// But that's a lot of trouble for right now
//final firebaseInstance = FirebaseFirestore.instance;

// retrieved from the FirebaseUser
String name;
String email;
String imageUrl;
String user_id;
// Author: Nathan Fenske
// Implements signing into Google via the Firebase module
// Much of this code comes from Google themselves for how to actually implement google sign-in/sign-out
// I've never worked with Firebase/google login before, so if I were to try to code all of this myself without reference
// It would be a buggy nightmare or at the very least horribly inefficient
Future<String> signInWithGoogle() async {
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  // Sign-in/authorize the user
  final UserCredential authResult = await _auth.signInWithCredential(credential);
  // Get the data (as an object) for our user
  final User user = authResult.user;

  // connect to our mysql database
  var settings = new ConnectionSettings(
      host: 'sql5.freesqldatabase.com',
      port: 3306,
      user: 'sql5399694',
      password: '4k6zvHCLMV',
      db: 'sql5399694'
  );
  var conn = await MySqlConnection.connect(settings);

  if (user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    // Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);
    // Store the retrieved data
    name = user.displayName;
    email = user.email;
    imageUrl = user.photoURL;
    user_id = user.uid;
    print(user_id);

    // testing mysql request, grabs all rows for this user
    var results = await conn.query('select userID, class from users where userID = ?', [user_id]);
    // grabs and prints all ID/class name entries for this user
    for (var row in results) {
      print('Name: ${row[0]}, email: ${row[1]}');
    };

    // Grab the first name
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }

    print('signInWithGoogle succeeded: $user');
    //var document = await firebaseInstance.collection('users').document(user.uid).get();
    //var doc = await document;
    //print(doc.data());
    return '$user';
  }

  return null;
}



// Author: Nathan Fenske
// Implements signing out of Google via the Firebase module
void signOutGoogle() async{
  await googleSignIn.signOut();

  print("User Signed Out");
}