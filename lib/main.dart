import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(SheenApp());
}

class SheenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sheen',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: TranslatePage(),
    );
  }
}

class TranslatePage extends StatefulWidget {
  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  final translator = GoogleTranslator();
  final inputController = TextEditingController();
  String translatedText = "";

  String fromLang = "en"; // من لغة
  String toLang = "ar"; // إلى لغة

  void translate() async {
    final result = await translator.translate(
      inputController.text,
      from: fromLang,
      to: toLang,
    );
    setState(() {
      translatedText = result.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sheen Translator")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: inputController,
              decoration: InputDecoration(labelText: "اكتب النص هنا"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("من: "),
                DropdownButton<String>(
                  value: fromLang,
                  onChanged: (newVal) => setState(() => fromLang = newVal!),
                  items: ['en', 'ar', 'fr', 'tr', 'de', 'es', 'ru', 'it']
                      .map((lang) => DropdownMenuItem(
                            child: Text(lang),
                            value: lang,
                          ))
                      .toList(),
                ),
                Text("  إلى: "),
                DropdownButton<String>(
                  value: toLang,
                  onChanged: (newVal) => setState(() => toLang = newVal!),
                  items: ['en', 'ar', 'fr', 'tr', 'de', 'es', 'ru', 'it']
                      .map((lang) => DropdownMenuItem(
                            child: Text(lang),
                            value: lang,
                          ))
                      .toList(),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: translate,
              child: Text("ترجم"),
            ),
            SizedBox(height: 20),
            Text(
              translatedText,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
