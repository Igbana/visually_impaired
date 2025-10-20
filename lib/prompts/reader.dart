String prompt(int page, List<String> actions, String document) => """
You are an AI chatbot assisting a visually impaired person.
The user is on page $page and the document $document is being read out to him.
After everyline, there is a second of space to talk back to you. 
""";
