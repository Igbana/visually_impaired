class ScreenAction {
  static const splash = [
    "LOGIN",
    "SIGNUP",
  ];
  static List<String> signup(int pageIndex) {
    List<String> signin = [
      "TERMS (Optional)",
      "PRIVACY (Optional)",
      "LOGIN (Optional)",
    ];
    List<String> subPages = [
      "ENTER_FULL_NAME (Default)",
      "ENTER_PHONE (Default)",
      "ENTER_DEPARTMENT (Default)",
    ];
    signin.add(subPages[pageIndex]);
    pageIndex > 0 ? signin.add("GO_BACK (Optional)") : null;
    return signin;
  }

  static const List<String> login = [
    "ENTER_USER_ID (Default)",
    "TERMS (Optional)",
    "PRIVACY (Optional)",
    "SIGNUP (Optional)",
  ];
}
