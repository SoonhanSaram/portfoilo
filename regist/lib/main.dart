import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:regist/membership_regist.dart';
import 'package:regist/menu_page.dart';
import 'package:regist/models/reservation_info_model.dart';
import 'package:regist/viewmodel/booked_view_model.dart';
import 'package:regist/viewmodel/login_view_model.dart';

void main() async {
  await dotenv.load(fileName: 'assets/config/.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase database = FirebaseDatabase.instance;
  // await Future.delayed(const Duration(seconds: 3));

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => ReserInfo(user: "undetermined user"),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
        ),
        ChangeNotifierProxyProvider<LoginViewModel, BookedViewModel>(
          create: (_) => BookedViewModel(),
          update: (_, loginViewModel, bookedViewModel) {
            bookedViewModel!.user = loginViewModel.reselInfo!.user;
            return bookedViewModel;
          },
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: dotenv.env["TITLE"]!,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Notosans"),
      routes: {
        "/menu": (BuildContext context) => const MenuPage(),
      },
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var loginViewModel = context.watch<LoginViewModel>();

    if (loginViewModel.auth != null || loginViewModel.currentUser != null) {
      return Scaffold(
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: const MenuPage(),
        ),
      );
    } else if (loginViewModel.auth == null || loginViewModel.currentUser!.displayName == null) {}
    return Scaffold(
      appBar: AppBar(
        title: Text(dotenv.env["TITLE"]!),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(context, loginViewModel),
      ),
    );
  }
}

_buildBody(BuildContext context, LoginViewModel loginViewModel) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Flexible(
        fit: FlexFit.loose,
        flex: 2,
        child: Text(
          dotenv.env["PAGE_TITLE"]!,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: Colors.blue),
        ),
      ),
      Flexible(
        fit: FlexFit.tight,
        flex: 4,
        child: Column(
          children: [
            inputBox(
                labelText: dotenv.env["EMAIL_TEXT_FIELD"]!,
                keyboardType: TextInputType.emailAddress,
                onChange: (value) => {
                      loginViewModel.changeUpdateValue(
                        dotenv.env["GOOGLE_SCOPE_EMAIL"]!,
                        value,
                      )
                    }),
            const SizedBox(
              height: 20,
            ),
            inputBox(
                labelText: dotenv.env["PASSWORD_TEXT_FIELD"]!,
                obscureText: true,
                keyboardType: TextInputType.text,
                onChange: (value) => {
                      loginViewModel.changeUpdateValue(
                        dotenv.env["STATE_PASSWORD"]!,
                        value,
                      )
                    }),
            TextButton(
                onPressed: () async {
                  await loginViewModel.login(context);
                },
                child: Text(
                  dotenv.env["LOGIN_BUTTON_TITLE"]!,
                  style: const TextStyle(fontSize: 24),
                )),
          ],
        ),
      ),

      /**
             * Flexible
             * 내부에 있는 widget 이 화면을 벗어나려고 할 때,
             * fit 속성을 Flexible.tight 로 설정하면
             * 화면 범위내에서 화면에 남은 영역만 차지하도록
             * 내부 화면 범위를 제한
             */
      Flexible(
          flex: 2,
          fit: FlexFit.loose,
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EmailRegist()));
                },
                child: Text(dotenv.env["JOIN_BUTTON_TITLE"]!),
              ),
              loginButton(loginViewModel, context),
            ],
          )),
    ],
  );
}

GestureDetector loginButton(LoginViewModel loginViewModel, BuildContext context) {
  return GestureDetector(
    onTap: () async {
      try {
        await loginViewModel.loginUser(context);
      } catch (e) {
        print(e);
      }
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF4285F4),
              ),
            ),
            width: 35,
            height: 35,
            child: Image.asset(
              "assets/images/btn_google.png",
            )),
        Container(
          color: const Color(0xFF4285F4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dotenv.env["IMAGE_BUTTON_TITLE"]!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    ),
  );
}

Center iconButton() {
  return Center(
    child: ElevatedButton(
      style: const ButtonStyle(
        elevation: MaterialStatePropertyAll(0),
        backgroundColor: MaterialStatePropertyAll(Colors.white),
        minimumSize: MaterialStatePropertyAll(
          Size(200, 200),
        ),
      ),
      onPressed: () {},
      child: const Icon(
        Icons.add_reaction_sharp,
        size: 200,
      ),
    ),
  );
}

TextFormField inputBox({
  String labelText = "",
  bool obscureText = false,
  String stateValue = "",
  TextInputType keyboardType = TextInputType.emailAddress,
  required Set<void> Function(dynamic) onChange,
}) {
  return TextFormField(
    keyboardType: keyboardType,
    onChanged: onChange,
    obscureText: obscureText,
    decoration: InputDecoration(labelText: labelText, labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );
}
