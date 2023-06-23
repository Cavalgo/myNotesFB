void main() {
  DateTime now = DateTime.now();
  String nowStr = now.toString();
  DateTime nowDT = DateTime.parse(nowStr); //nowStr;

  print(nowStr);
  print(nowDT);
}
