class ScreenAction {
  static const splash = [
    "LOGIN (nextMessage = Enter User ID)",
    "SIGNUP (nextMessage = Enter your name)",
  ];
  static List<String> signup(int pageIndex) {
    List<String> signin = [
      "TERMS (nextMessage = Login or Signup)",
      "PRIVACY (nextMessage = Login or Signup)",
      "LOGIN (nextMessage = Login or Signup)",
    ];
    List<String> subPages = [
      "ENTER_NAME (nextMessage = Enter User ID)",
      "ENTER_USERID (nextMessage = Enter Department)",
      "ENTER_DEPARTMENT (nextMessage = Enter Phone Number)",
      "ENTER_PHONE (nextMessage = Enter Password)",
      "ENTER_PASSWORD (nextMessage = Confirm Password)",
      "CONFIRM_PASSWORD (nextMessage = Please Wait, nextAction = CHECK_DETAILS)",
    ];
    signin.add(subPages[pageIndex]);
    pageIndex > 0 ? signin.add("GO_BACK (Optional)") : signin.add("NEXT_PAGE");
    return signin;
  }

  static const List<String> login = [
    "ENTER_USERID ",
    "TERMS (nextMessage = Login or Signup)",
    "PRIVACY (nextMessage = Login or Signup)",
    "SIGNUP (nextMessage = Login or Signup)",
  ];
}
