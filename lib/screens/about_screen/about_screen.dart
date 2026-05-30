import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../../data/constants.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late Future<String> info;
  @override
  void initState() {
    super.initState();
    info = _loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'သိမှတ်ဖွယ်',
          textScaler: TextScaler.linear(1.0),
        ),
      ),
      body: FutureBuilder(
          future: info,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SelectionArea(
                  child: HtmlWidget(
                    snapshot.data!,
                    // factoryBuilder: () => CustomFactory(),
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator.adaptive());
          }),
    );
  }

  Future<String> _loadInfo() async {
    return rootBundle.loadString(infoAssetsPath);
  }
}


