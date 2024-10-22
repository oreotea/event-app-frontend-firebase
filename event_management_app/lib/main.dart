// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/landing_page.dart';
import 'screens/event_list_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/event_form_screen.dart';
import 'providers/event_provider.dart';
import 'models/event_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: Config.apiKey!,
      authDomain: Config.authDomain!,
      projectId: Config.projectId!,
      storageBucket: Config.storageBucket!,
      messagingSenderId: Config.messagingSenderId!,
      appId: Config.appId!,
    ),
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EventProvider()..loadEvents(),
        ),
      ],
      child: MaterialApp(
        title: 'Event Management App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/landing',
        routes: {
          '/landing': (context) => const LandingPage(),
          '/': (context) => const EventListScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/eventDetail') {
            final event = settings.arguments as Event?;
            if (event != null) {
              return MaterialPageRoute(
                builder: (context) => EventDetailScreen(event: event),
              );
            }
            return _errorRoute(); // Handle missing argument
          } else if (settings.name == '/eventForm') {
            final existingEvent = settings.arguments as Event?;
            return MaterialPageRoute(
              builder: (context) => EventFormScreen(initialEvent: existingEvent),
            );
          }
          return _errorRoute(); // Handle unknown routes
        },
      ),
    );
  }

  // Error route for handling unknown or invalid routes
  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }
}
