import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(SheenApp());
}

class SheenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sheen Translator',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: TranslatorScreen(),
    );
  }
}

class TranslatorScreen extends StatefulWidget {
  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  TextEditingController inputController = TextEditingController();
  String translatedText = '';
  String fromLang = 'auto';
  String toLang = 'en';

  final Map<String, String> languages = {
    'العربية': 'ar',
    'الإنجليزية': 'en',
    'الفرنسية': 'fr',
    'التركية': 'tr',
    'الألمانية': 'de',
    'الإيطالية': 'it',
    'الإسبانية': 'es',
    'الهندية': 'hi',
  };

  Future<void> translateText() async {
    final url = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=$fromLang&tl=$toLang&dt=t&q=${Uri.encodeComponent(inputController.text)}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        translatedText = jsonData[0][0][0];
      });
    } else {
      setState(() {
        translatedText = 'فشلت الترجمة، جرّب مرة ثانية';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sheen - مترجم النصوص')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                labelText: 'اكتب النص هنا',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: fromLang,
                    items: languages.entries
                        .map((e) => DropdownMenuItem(
                              child: Text('من ${e.key}'),
                              value: e.value,
                            ))
                        .toList()
                          ..insert(
                            0,
                            DropdownMenuItem(
                              child: Text('تلقائي'),
                              value: 'auto',
                            ),
                          ),
                    onChanged: (val) {
                      setState(() => fromLang = val ?? 'auto');
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: toLang,
                    items: languages.entries
                        .map((e) => DropdownMenuItem(
                              child: Text('إلى ${e.key}'),
                              value: e.value,
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() => toLang = val ?? 'en');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: translateText,
              child: Text('ترجم'),
            ),
            SizedBox(height: 15),
            Text(
              translatedText,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
