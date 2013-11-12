import 'dart:io';
import 'dart:isolate';

/**
 * Run through the files that end with _tests.dart in the test directory
 */
void main() {
  ReceivePort receivePort = new ReceivePort();
  final testDirectory = new Directory(Directory.current.path);
  final lister = testDirectory.list(recursive: false);
  lister.listen((FileSystemEntity e) {
    if (e.path.endsWith("_tests.dart")) {
      Isolate.spawnUri(Uri.parse("file://${e.path}"),[],"");
    }
  });
}