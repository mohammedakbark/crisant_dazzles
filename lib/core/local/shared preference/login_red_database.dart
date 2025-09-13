import 'package:dazzles/core/shared/models/login_user_ref_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRefDataBase {
  final _token = "TOKEN";
  final _userName = "USER_NAME";
  final _userID = "USER_ID";
  final _pushToken = "PUSH_TOKEN";
  final _role = "ROLE";
  final _roleId = "ROLE_ID";
  final _permissions = "PERMISSIONS";
  LocalUserRefModel? _localUserRefModel;
  LocalUserRefModel get localUserRefModel => _localUserRefModel!;

  Future<LocalUserRefModel> get getUserData async {
    _localUserRefModel = await _getUserData();
    return _localUserRefModel!;
  }

  Future<void> setUseretails(LocalUserRefModel userDataModel) async {
    final userData = await _getUserData();
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(_token, userDataModel.token ?? userData.token ?? '');
    await pref.setString(
      _userName,
      userDataModel.userName ?? userData.userName ?? '',
    );
    await pref.setInt(_userID, userDataModel.userId ?? userData.userId ?? 0);
    await pref.setString(
      _pushToken,
      userDataModel.pushToken ?? userData.pushToken ?? '',
    );
    await pref.setString(
      _role,
      userDataModel.role ?? userData.role ?? '',
    );
    await pref.setInt(
      _roleId,
      userDataModel.roleId ?? userData.roleId ?? 00,
    );
    await pref.setStringList(
        _permissions, userDataModel.permissions ?? userData.permissions ?? []);

    await _getUserData();
  }

  Future<LocalUserRefModel> _getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final token = pref.getString(_token) ?? '';
    final userName = pref.getString(_userName) ?? '';
    final userId = pref.getInt(_userID) ?? 0;
    final pushToken = pref.getString(_pushToken) ?? '';
    final role = pref.getString(_role) ?? '';
    final roleId = pref.getInt(_roleId) ?? 00;
    final permissions = pref.getStringList(_permissions) ?? [];
    // log(token.toString());
    // log(userId.toString());

    return LocalUserRefModel(
        permissions: permissions,
        token: token,
        userId: userId,
        userName: userName,
        pushToken: pushToken,
        role: role,
        roleId: roleId);
  }

  Future<void> clearLoginCredential() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.remove(_token);
    await pref.remove(_userID);
    await pref.remove(_userName);
    await pref.remove(_pushToken);
    await pref.remove(_role);
    await pref.remove(_roleId);
    await pref.remove(_permissions);
  }
}
