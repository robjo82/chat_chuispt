class LocalQuestion {
  int id = 0;
  String text = "";
  int blueThumb = 0;
  int redThumb = 0;
  int usage = 0;
  double repetitionScore = 1.0;
  double globalScore = 0.0;

  LocalQuestion(
      {required this.id,
      required this.text,
      required this.blueThumb,
      required this.redThumb}) {
    updateGlobalScore();
  }

  String getText() {
    return text;
  }

  void increaseBlueThumb() {
    blueThumb++;
  }

  void increaseRedThumb() {
    redThumb++;
  }

  void increaseUsage() {
    usage++;
  }

  void addUsage(int elementNumber) {
    usage++;
    repetitionScore /= elementNumber;
    updateGlobalScore();
  }

  void addNonUsage(int elementNumber) {
    repetitionScore *= (1 + 1 / elementNumber);
    updateGlobalScore();
  }

  void updateGlobalScore() {
    globalScore = blueThumb / redThumb * repetitionScore;
  }

  static LocalQuestion fromJson(Map<String, dynamic>? json) {
    return LocalQuestion(
      id: json?['id'] ?? 0,
      text: json?['text'] ?? "",
      blueThumb: json?['blue_thumb'] ?? 0,
      redThumb: json?['red_thumb'] ?? 0,
    );
  }
}
