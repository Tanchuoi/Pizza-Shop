import 'package:pocketbase/pocketbase.dart';
import '../models/user.dart';
import 'pocketbase_client.dart';

class UserService {
  void Function(User? user)? onAuthChange;

  UserService({this.onAuthChange}) {
    if (onAuthChange != null) {
      getPocketbaseInstance().then((pb) {
        pb.authStore.onChange.listen((event) {
          onAuthChange!(event.record == null
              ? null
              : User.fromJson(event.record!.toJson()));
        });
      });
    }
  }
  Future<void> register(User user, String password) async {
    final pb = await getPocketbaseInstance();
    try {
      await pb.collection('users').create(body: {
        ...user.toJson(),
        'password': password,
        'passwordConfirm': password,
      });
    } catch (error) {
      if (error is ClientException) {
        throw Exception(error.response['message']);
      }
      throw Exception('An error occurred');
    }
  }

  Future<void> login(String email, String password) async {
    final pb = await getPocketbaseInstance();
    try {
      await pb.collection('users').authWithPassword(email, password);
    } catch (error) {
      if (error is ClientException) {
        throw Exception(error.response['message']);
      }
      throw Exception('An error occurred');
    }
  }

  Future<User?> getCurrentUser() async {
    final pb = await getPocketbaseInstance();
    final model = pb.authStore.record;
    if (model == null) {
      return null;
    }
    return User.fromJson(model.toJson());
  }

  Future<void> logout() async {
    final pb = await getPocketbaseInstance();
    pb.authStore.clear();
  }

  Future<void> updateProfile(User user) async {
    final pb = await getPocketbaseInstance();
    final userId = pb.authStore.record?.id;

    if (userId == null) throw Exception("User ID not found");

    try {
      // Remove email from the update payload
      final userData = user.toJson();
      userData.remove("email"); // Prevent direct email update

      await pb.collection('users').update(userId, body: userData);
    } catch (error) {
      if (error is ClientException) {
        throw Exception(error.response['message']);
      }
      throw Exception('An error occurred');
    }
  }

  Future<void> updateAddress(String address) async {
    final pb = await getPocketbaseInstance();
    final user = await getCurrentUser();
    if (user == null) {
      throw Exception('User not found');
    }
    await pb.collection('users').update(user.id!, body: {'address': address});
  }
}
