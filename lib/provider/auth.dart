// ignore_for_file: null_check_always_fails, unnecessary_null_comparison

import 'dart:convert';
import "dart:async";
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import "package:http/http.dart" as http;
import 'package:shop/models/http_exception.dart';
import "package:shared_preferences/shared_preferences.dart";

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  Timer? _autotimer;
  DateTime? _expireDate;
  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBoM0HZY_zoGguK2yj6lBPGc32WVff_NYY';
    try {
      final res = await http.post(
        Uri.parse(url),
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      print(json.decode(res.body));
      final responsData = jsonDecode(res.body);
      if (responsData['error'] != null) {
        throw HttpException(responsData['error']['message']);
      }

      _token = responsData['idToken'];
      _userId = responsData['localId'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responsData['expiresIn'])));
      _autologout();
      notifyListeners();

      final prefrences = await SharedPreferences.getInstance();
      final userInput = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expireDate?.toIso8601String()
      });
      prefrences.setString('userData', userInput);
    } catch (error) {
      throw error;
    }
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null &&
        _expireDate != null &&
        _expireDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> SignUp(String email, String password) async {
    return authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return authenticate(email, password, "signInWithPassword");
  }

  Future<bool> autoLogin() async {
    final prefrence = await SharedPreferences.getInstance();

    if (!prefrence.containsKey("userData")) {
      return false;
    }

    final extractedData =
        json.decode(prefrence.getString("userData")!) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData["expiryDate"] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedData['token'] as String;
    _userId = extractedData['userId'] as String;
    _expireDate = expiryDate;
    notifyListeners();
    _autologout();
    return true;
  }

  Future<void> Logout() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_autotimer != null) {
      _autotimer?.cancel();
      _autotimer = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autologout() {
    if (_autotimer != null) {
      _autotimer?.cancel();
    }
    final exireTimeout = _expireDate!.difference(DateTime.now()).inSeconds;
    _autotimer = Timer(Duration(seconds: exireTimeout), Logout);
  }
}
