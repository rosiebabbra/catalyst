import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:my_app/hobbies/main.dart';
import 'package:my_app/login/password_reset_screen.dart';
import 'package:my_app/onboarding/ideal_date_screen.dart';
import 'package:my_app/onboarding/ideal_match_screen.dart';
import 'package:my_app/onboarding/interests_screen.dart';
import 'package:my_app/swipes_completed/main.dart';
import 'package:video_player/video_player.dart';
import 'home/home_screen.dart';
import 'login/forgot_password_screen.dart';
import 'matches/match_screen.dart';
import 'hobbies/main.dart';
import 'models/user_data.dart';
import 'my_profile/my_profile_screen.dart';
import 'onboarding/dob_screen.dart';
import 'onboarding/gender_identification_screen.dart';
import 'onboarding/ethnicity_identification_screen.dart';
import 'onboarding/generating_matches_screen.dart';
import 'onboarding/interested_in_screen.dart';
import 'onboarding/location_disclaimer_screen.dart';
import 'onboarding/name_screen.dart';
import 'onboarding/phone_number_screen.dart';
import 'onboarding/verification_code_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => PhoneNumberProvider(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _BackgroundVideoState createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<MyApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/videos/production_id_4881692.mp4')
          ..initialize().then((_) {
            _controller.play();
            _controller.setLooping(true);
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      50: Color.fromRGBO(115, 1, 228, .1),
      100: Color.fromRGBO(115, 1, 228, .2),
      200: Color.fromRGBO(115, 1, 228, .3),
      300: Color.fromRGBO(115, 1, 228, .4),
      400: Color.fromRGBO(115, 1, 228, .5),
      500: Color.fromRGBO(115, 1, 228, .6),
      600: Color.fromRGBO(115, 1, 228, .7),
      700: Color.fromRGBO(115, 1, 228, .8),
      800: Color.fromRGBO(115, 1, 228, .9),
      900: Color.fromRGBO(115, 1, 228, 1),
    };

    MaterialColor colorCustom = MaterialColor(0xFF4f4f4f, color);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      initialRoute: '/',
      routes: {
        // '/login': (context) => const LoginScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/password-reset': (context) => const PasswordResetScreen(),
        '/matches': (context) => const MatchScreen(
              userId: 555,
            ),
        '/hobbies': (context) => HobbyScreen(hobby: 'Tennis'),
        '/onboarding': (context) => const PhoneNumberEntryScreen(),
        '/onboarding-name': (context) => const NameEntryScreen(),
        '/onboarding-dob': (context) => const DOBEntryScreen(),
        '/onboarding-gender': (context) => const GenderIDEntryScreen(),
        '/onboarding-ethnicity': (context) => const EthnicityIDEntryScreen(),
        '/onboarding-interested': (context) => const InterestedInScreen(),
        '/location-disclaimer': (context) => const LocationDisclaimerScreen(),
        '/onboarding-ideal-date': (context) => const IdealDateScreen(),
        '/onboarding-ideal-match': (context) => const IdealMatchScreen(),
        '/onboarding-interests': (context) => InterestsScreen(),
        '/generating-matches': (context) => GeneratingMatchesScreen(),
        '/verification-screen': (context) => VerificationScreen(),
        '/swipes-completed': (context) => SwipesCompletedScreen(),
        '/subscription-page': (context) => MyProfileScreen()
      },
      home: Stack(
        children: <Widget>[
          VideoPlayer(_controller),
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.transparent],
          ))),
          const HomeScreen()
        ],
      ),
    );
  }
}
