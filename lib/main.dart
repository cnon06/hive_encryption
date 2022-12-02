import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_project/home_page.dart';
import 'package:hive_project/model.dart';

void main() async {
  await Hive.initFlutter('depo');

  var secureStorage = const FlutterSecureStorage();
  var containsEncryptionKey = await secureStorage.containsKey(key: 'key');
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: 'key', value: base64UrlEncode(key));
  }

  var encryptionKey =
      base64Url.decode(await secureStorage.read(key: 'key') ?? 'newKey');
  debugPrint("encryptionKey: $encryptionKey");
  //  await Hive.openBox('test');
  Hive.registerAdapter(StudentAdapter());

  // await Hive.openBox<Student>('students');
 await Hive.openLazyBox<Student>('students1', encryptionCipher: HiveAesCipher(encryptionKey));
  // await Hive.openLazyBox<Student>('students1');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // myOpenBox();
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: HomePage(),
    );
  }
}
