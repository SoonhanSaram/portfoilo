import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:regist/calendar.dart';
import 'package:regist/dto/reselvation_info.dart';
import 'package:regist/membership_regist.dart';
import 'package:regist/viewmodel/user_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Future.delayed(const Duration(seconds: 3));
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});
  final LoginViewModel _loginViewModel = LoginViewModel();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StaticViewModel.title,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Notosans"),
      home: HomePage(
        loginViewModel: _loginViewModel,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.loginViewModel});

  final LoginViewModel loginViewModel;

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user = loginViewModel.user;
    final ReselInfo reselInfo = loginViewModel.reselInfo;
    final GoogleSignIn googleSignIn = loginViewModel.googleSignIn;
    return Scaffold(
      appBar: AppBar(
        title: const Text(StaticViewModel.title),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(loginViewModel, context),
      ),
    );
  }
}

_buildBody(LoginViewModel loginViewModel, BuildContext context) {
  final GoogleSignInAccount? user = loginViewModel.user;
  final ReselInfo reselInfo = loginViewModel.reselInfo;
  final GoogleSignIn googleSignIn = loginViewModel.googleSignIn;
  if (user != null) {
    return RegisterScreen(
      reselInfo: reselInfo,
    );
  } else {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Flexible(
            fit: FlexFit.loose,
            flex: 2,
            child: Text(
              StaticViewModel.pageTitle,
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 4,
            child: Column(
              children: [
                inputBox(
                    keyboardType: TextInputType.emailAddress,
                    stateValue: loginViewModel.email,
                    onChange: (value) => {
                          loginViewModel.changeUpdateValue(
                              loginViewModel.email, value)
                        }),
                const SizedBox(
                  height: 20,
                ),
                inputBox(
                    labelText: StaticViewModel.passwordTextField,
                    obscureText: true,
                    stateValue: loginViewModel.password,
                    keyboardType: TextInputType.text,
                    onChange: (value) => {
                          loginViewModel.changeUpdateValue(
                              loginViewModel.password, value)
                        }),
                TextButton(
                    onPressed: () {
                      loginViewModel.login;
                    },
                    child: const Text(
                      StaticViewModel.loginButtonTitle,
                      style: TextStyle(fontSize: 24),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EmailRegist()));
                      },
                      child: const Text(StaticViewModel.joinButtonTitle)),
                  loginButton(),
                ],
              )),
        ],
      ),
    );
  }
}

TextFormField inputBox({
  String labelText = "Email을 입력해주세요",
  bool obscureText = false,
  String stateValue = "",
  TextInputType keyboardType = TextInputType.emailAddress,
  required Set<void> Function(dynamic) onChange,
}) {
  return TextFormField(
    keyboardType: keyboardType,
    onChanged: onChange,
    obscureText: obscureText,
    decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );
}

GestureDetector loginButton() {
  return GestureDetector(
    onTap: () async {
      try {
        // await _googleSignIn.signIn();
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
              "images/btn_google.png",
            )),
        Container(
          color: const Color(0xFF4285F4),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              StaticViewModel.imageButtonTitle,
              style: TextStyle(color: Colors.white),
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

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key, this.reselInfo});
  final reselInfo;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2186D1),
          borderRadius: BorderRadius.circular(16.0), // Container의 모서리를 둥글게 설정
        ),
        height: 200,
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '예약하러 가기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            registButton(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton registButton(context) {
    return ElevatedButton(
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.white)),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Calendar(reselInfo: reselInfo);
          },
        ));
      },
      child: const Text(
        '예약',
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
  }
}
