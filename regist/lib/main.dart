import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:regist/membership_regist.dart';
import 'package:regist/regist_page.dart';
import 'package:regist/staticValue/static_value.dart';
import 'package:regist/viewmodel/user_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Future.delayed(const Duration(seconds: 3));
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
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
      title: StaticValues.title,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Notosans"),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StaticValues.title),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(context),
      ),
    );
  }
}

_buildBody(BuildContext context) {
  var loginViewModel = context.watch<LoginViewModel>();
  if (loginViewModel.auth != null) {
    return RegisterScreen(
      reselInfo: loginViewModel.reselInfo,
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
              StaticValues.pageTitle,
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
                    labelText: StaticValues.emailTextField,
                    keyboardType: TextInputType.emailAddress,
                    onChange: (value) => {
                          loginViewModel.changeUpdateValue(
                            StaticValues.googleScopeEmail,
                            value,
                          )
                        }),
                const SizedBox(
                  height: 20,
                ),
                inputBox(
                    labelText: StaticValues.passwordTextField,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    onChange: (value) => {
                          loginViewModel.changeUpdateValue(
                            StaticValues.statePassword,
                            value,
                          )
                        }),
                TextButton(
                    onPressed: () async {
                      await loginViewModel.login(context);
                    },
                    child: const Text(
                      StaticValues.loginButtonTitle,
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
                      child: const Text(StaticValues.joinButtonTitle)),
                  loginButton(loginViewModel.googleSignIn),
                ],
              )),
        ],
      ),
    );
  }
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
    decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );
}

GestureDetector loginButton(GoogleSignIn googleSignIn) {
  return GestureDetector(
    onTap: () async {
      try {
        await googleSignIn.signIn();
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
              StaticValues.imageButtonTitle,
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
