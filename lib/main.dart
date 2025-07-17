import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/ui/splash/widgets/splash_screen.dart';
import 'package:inspecoespoty/utils/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'inspecoespoty',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),


        ),
        searchBarTheme: SearchBarThemeData(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
          elevation: WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
          ),
          constraints: BoxConstraints(maxHeight: 50, minHeight: 50),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(),
          border: borderStyle(),
          focusedBorder: borderStyle(type: 'focused'),
          enabledBorder: borderStyle(),
          errorBorder: borderStyle(type: 'error'),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(),
            border: borderStyle(),
            focusedBorder: borderStyle(type: 'focused'),
            enabledBorder: borderStyle(),
            errorBorder: borderStyle(type: 'error'),
          ),
          menuStyle: MenuStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            backgroundColor: WidgetStateProperty.all(Colors.white),
            minimumSize: WidgetStateProperty.all(
              Size(MediaQuery.of(context).size.width, 100),
            ),
            maximumSize: WidgetStateProperty.all(
              Size(MediaQuery.of(context).size.width, 400),
            ),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

borderStyle({String type = 'default'}) {
  Color borderColor = Colors.grey.shade300;
  if (type == 'error') {
    borderColor = Colors.red;
  } else if (type == 'focused') {
    borderColor = primaryColor;
  }
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: BorderSide(color: borderColor, width: 1.5),
  );
}
