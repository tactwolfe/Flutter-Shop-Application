//own custom exception class


class HttpExceptions implements Exception{ //here Exception is abstract class

  final String message;

  HttpExceptions(this.message);

  //override the to string method of exception class that would
  //have returned a message "Instance of exceptions" so we can return
  //a custom exception witch clear message
  @override
  String toString() {
    return message;
  }


}