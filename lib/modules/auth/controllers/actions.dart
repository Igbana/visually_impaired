class ScreenAction {
  static const splash = [
    "LOGIN",
    "SIGNUP",
  ];
  static List<String> signup(int pageIndex) {
    List<String> _login = [
      "TERMS (Optional)",
      "PRIVACY (Optional)",
      "SIGNUP (Optional)",
    ];
    List<String> _subPages = [
      "ENTER_FULL_NAME",
      "ENTER_PHONE",
      "ENTER_DEPARTMENT",
    ];
    _login.add(_subPages[pageIndex]);
    return _login;
  }

  static const List<String> login = [
    "ENTER_USER",
    "TERMS (Optional)",
    "PRIVACY (Optional)",
    "SIGNUP (Optional)",
  ];
}
