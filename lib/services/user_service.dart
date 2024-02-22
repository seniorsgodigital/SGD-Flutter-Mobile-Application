

import 'package:seniors_go_digital/constants/firebase_Collection.dart';
import 'package:seniors_go_digital/models/userDataModel.dart';

class UserServices {
  static Future<Stream<UserProfile>> streamUsers(String doc) async {
    var ref = FBCollections.userData.doc(doc).snapshots().asBroadcastStream();
    return ref.map((user) => UserProfile.fromMap(user.data() as Map<String, dynamic>?));
  }
}
