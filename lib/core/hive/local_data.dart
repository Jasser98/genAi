import 'package:genai/main.dart';
import 'package:genai/model/user_model.dart';

class LocalData {
  static void saveUserData(LocalUser user) => box!.put('user', user.toJson());

  static void removeUserData() => box!.delete('user');

  static LocalUser? getUserData() =>
      box!.get('user') == null ? null : LocalUser.fromJson(box!.get('user'));
}
