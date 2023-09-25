import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/onboarding/signup_screen.dart';
import 'chat/chat_content.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:my_app/hobbies/main.dart';
import 'package:my_app/login/password_reset_screen.dart';
import 'package:my_app/swipes_completed/main.dart';
import 'package:video_player/video_player.dart';
import 'home/home_screen.dart';
import 'login/forgot_password_screen.dart';
import 'login/login_screen.dart';
import 'login/password_reset_landing_screen.dart';
import 'matches/match_screen.dart';
import 'models/user_data.dart';
import 'my_profile/my_profile_screen.dart';
import 'onboarding/dob_screen.dart';
import 'onboarding/gender_identification_screen.dart';
import 'onboarding/ethnicity_identification_screen.dart';
import 'onboarding/generating_matches_screen.dart';
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
      create: (context) => PhoneNumberProvider(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
      50: const Color.fromRGBO(115, 1, 228, .1),
      100: const Color.fromRGBO(115, 1, 228, .2),
      200: const Color.fromRGBO(115, 1, 228, .3),
      300: const Color.fromRGBO(115, 1, 228, .4),
      400: const Color.fromRGBO(115, 1, 228, .5),
      500: const Color.fromRGBO(115, 1, 228, .6),
      600: const Color.fromRGBO(115, 1, 228, .7),
      700: const Color.fromRGBO(115, 1, 228, .8),
      800: const Color.fromRGBO(115, 1, 228, .9),
      900: const Color.fromRGBO(115, 1, 228, 1),
    };

    MaterialColor colorCustom = MaterialColor(0xFF4f4f4f, color);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/password-reset': (context) => const PasswordResetScreen(),
        '/password-reset-landing-page': (context) =>
            const PasswordResetLandingScreen(),
        '/matches': (context) => const MatchScreen(
              userId: 555,
            ),
        '/hobbies': (context) => HobbyScreen(hobby: 'Tennis'),
        '/onboarding': (context) => const PhoneNumberEntryScreen(),
        '/onboarding-name': (context) => const NameEntryScreen(),
        '/onboarding-dob': (context) => const DOBEntryScreen(),
        '/onboarding-gender': (context) => const GenderIDEntryScreen(),
        '/onboarding-ethnicity': (context) => const EthnicityIDEntryScreen(),
        '/onboarding-signup': (context) => const SignupScreen(),
        '/location-disclaimer': (context) => const LocationDisclaimerScreen(),
        '/generating-matches': (context) => const GeneratingMatchesScreen(),
        '/verification-screen': (context) => const VerificationScreen(),
        '/swipes-completed': (context) => const SwipesCompletedScreen(),
        '/subscription-page': (context) => const MyProfileScreen(),
        '/chat-content': (context) => const ChatContent()
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
