import 'dart:io';
import 'dart:isolate';

/**
 * Run through the files that end with tests.dart in this directory
 */
void main() {
  ReceivePort receivePort = new ReceivePort();

  var lister = new Directory.current().list(recursive: true);
  lister.onFile = (String path) {
    if (path.endsWith("_tests.dart")) {
      SendPort sendPort = spawnUri("file://$path");
    }
  };
}