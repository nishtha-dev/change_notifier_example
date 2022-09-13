import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class SliderData extends ChangeNotifier {
  double _value = 0.0;

  double get value => _value;

  set value(double newValue) {
    if (newValue != _value) {
      _value = newValue;
      notifyListeners();
    }
  }
}

final sliderData = SliderData();

class SliderInheritedWidget extends InheritedNotifier<SliderData> {
  const SliderInheritedWidget({
    Key? key,
    required Widget child,
    required SliderData sliderData,
  }) : super(key: key, child: child, notifier: sliderData);

  static double of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<SliderInheritedWidget>()
            ?.notifier
            ?.value ??
        0.0;
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: SliderInheritedWidget(
        sliderData: sliderData,
        child: Builder(builder: (context) {
          return Column(
            children: [
              Slider(
                  value: SliderInheritedWidget.of(context),
                  onChanged: (value) {
                    sliderData.value = value;
                  }),
              Row(
                children: [
                  Opacity(
                    opacity: SliderInheritedWidget.of(context),
                    child: Container(
                      height: 200,
                      color: Colors.yellow,
                    ),
                  ),
                  Opacity(
                    opacity: SliderInheritedWidget.of(context),
                    child: Container(
                      height: 200,
                      color: Colors.blue,
                    ),
                  )
                ].expandWidget().toList(),
              )
            ],
          );
        }),
      ),
    );
  }
}

extension ExpandWidget on Iterable<Widget> {
  Iterable<Widget> expandWidget() {
    return map((e) => Expanded(child: e));
  }
}
