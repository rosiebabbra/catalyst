import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/beta/coming_soon_screen.dart';
import 'package:my_app/onboarding/location_services_denied_screen.dart';
import 'package:my_app/onboarding/signup_screen.dart';
import 'beta/see_you_soon.dart';
import 'chat/chat_content.dart';
import 'firebase_options.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my_app/hobbies/main.dart';
import 'package:my_app/login/password_reset_screen.dart';
import 'package:my_app/swipes_completed/main.dart';
import 'package:video_player/video_player.dart';
import 'home/home_screen.dart';
import 'login/forgot_password_screen.dart';
import 'login/login_screen.dart';
import 'login/password_reset_landing_screen.dart';
import 'models/user_data.dart';
import 'my_profile/my_profile_screen.dart';
import 'onboarding/dob_screen.dart';
import 'onboarding/gender_identification_screen.dart';
import 'onboarding/location_disclaimer_screen.dart';
import 'onboarding/name_screen.dart';
import 'onboarding/phone_number_screen.dart';
import 'onboarding/verification_code_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received a message: ${message.notification?.title}');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('User tapped on the notification');
  });
  runApp(ChangeNotifierProvider(
      create: (context) => PhoneNumberProvider(),
      child: MyApp(
        versionId: '1.0.0',
        useVideoAsset: true,
      )));
}

class MyApp extends StatefulWidget {
  final String versionId;
  bool useVideoAsset;
  MyApp({super.key, required this.versionId, required this.useVideoAsset});

  @override
  BackgroundVideoState createState() => BackgroundVideoState();
}

class BackgroundVideoState extends State<MyApp> {
  VideoPlayerController? _controller;
  ChewieController? chewieController;

  @override
  void initState() {
    initVP();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  void initVP() async {
    if (widget.useVideoAsset == true) {
      _controller = VideoPlayerController.asset(
          'assets/videos/production_id_4881692.mp4');

      await _controller?.initialize();

      chewieController = ChewieController(
        videoPlayerController: _controller ??
            VideoPlayerController.asset(
                'assets/videos/production_id_4881692.mp4'),
        autoPlay: true,
        looping: true,
      );
    }

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
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

    var routes = {
      'beta': {
        '/login': (context) => const LoginScreen(versionId: 'beta'),
        '/location-disclaimer': (context) => const LocationDisclaimerScreen(
              versionId: 'beta',
            ),
        '/location-services-denied': (context) =>
            const LocationServiceDeniedScreen(versionId: 'beta'),
        '/see-you-soon': (context) => const SeeYouSoonScreen(),
        '/coming-soon': (context) => const ComingSoonScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/password-reset': (context) => const PasswordResetScreen(),
        '/password-reset-landing-page': (context) =>
            const PasswordResetLandingScreen(),
        '/verification-screen': (context) => const VerificationScreen(),
        '/onboarding': (context) => const PhoneNumberEntryScreen(),
        '/onboarding-name': (context) => const NameEntryScreen(),
        '/onboarding-dob': (context) => const DOBEntryScreen(),
        '/onboarding-gender': (context) => const GenderIDEntryScreen(),
        '/onboarding-signup': (context) => const SignupScreen(),
      },
      '1.0.0': {
        '/login': (context) => const LoginScreen(versionId: '1.0.0'),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/password-reset': (context) => const PasswordResetScreen(),
        '/password-reset-landing-page': (context) =>
            const PasswordResetLandingScreen(),
        '/hobbies': (context) => const HobbyScreen(),
        '/onboarding': (context) => const PhoneNumberEntryScreen(),
        '/onboarding-name': (context) => const NameEntryScreen(),
        '/onboarding-dob': (context) => const DOBEntryScreen(),
        '/onboarding-gender': (context) => const GenderIDEntryScreen(),
        '/onboarding-signup': (context) => const SignupScreen(),
        '/location-disclaimer': (context) =>
            const LocationDisclaimerScreen(versionId: '1.0.0'),
        '/verification-screen': (context) => const VerificationScreen(),
        '/swipes-completed': (context) => const SwipesCompletedScreen(),
        '/subscription-page': (context) => const MyProfileScreen(),
        '/chat-content': (context) => const ChatContent()
      }
    };

    bool useVideoBackground(useVideoAsset) {
      return chewieController != null;
    }

    var videoBackground = useVideoBackground(widget.useVideoAsset);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      initialRoute: '/',
      routes: routes[widget.versionId]
          as Map<String, Widget Function(BuildContext)>,
      home: Stack(
        children: <Widget>[
          if (videoBackground) VideoPlayer(_controller!),
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xffffffff).withOpacity(0.4),
              Colors.transparent,
              const Color(0xffffffff).withOpacity(0.2)
            ],
          ))),
          const HomeScreen()
        ],
      ),
    );
  }
}
