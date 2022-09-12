class httpExeptions implements Exception{
  final String message;
  httpExeptions(this.message);
  @override
  String toString(){
    return message;
  }
}