import 'dart:io';
import 'dart:isolate';

/**
 * Run through the files that end with _tests.dart in the test directory
 */
void main() {
  ReceivePort receivePort = new ReceivePort();
  
  final path = new Path(new Directory.current().path).append('test');
  final testDirectory = new Directory.fromPath(path);
  final lister = testDirectory.list(recursive: false);
  lister.listen((FileSystemEntity e) {
    if (e.path.endsWith("_tests.dart")) {
      SendPort sendPort = spawnUri("file://${e.path}");
    }
  });
}