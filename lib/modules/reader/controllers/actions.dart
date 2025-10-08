class ReaderAction {
  static const List<String> docList = [
    "SELECT_BOOK",
    "LIST_BOOKS",
  ];

  static const List<String> docPage = [
    "GOTO_PAGE",
    "READ_PAGE",
    // "SUMMARIZE_PAGE",
    // "GET_TOPICS",      they are all under questions, in the input
    "QUESTION",
  ];
}
