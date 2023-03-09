import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:regist/calendar.dart';
import 'package:regist/dto/reselvation_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 3));

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Member",
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Notosans"),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// google 로그인을 수행하기 위한 초기화 함수
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class _HomePageState extends State<HomePage> {
  GoogleSignInAccount? _currentUser;
  late ReselInfo reselInfo = ReselInfo(
    user: '',
    date: '',
    from: '',
    destination: '',
    transfer: '',
    number: '',
    pay: '',
  );

  @override
  void initState() {
    super.initState();
    /**
     * google login 이 되면 google 로부터 event가 전달되고
     * event를 기다리다가 user 정보가 오면 _currentUser 에
     * GoogleSignInAccount 타입의 google login 정보를 저장
     */
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
        reselInfo.user = account!.displayName ?? "";
      });
    }); // end SignIn

    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Member"),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      ),
    );
  } // end build

  _buildBody() {
    final GoogleSignInAccount? user = _currentUser;

    if (user != null) {
      return RegisterScreen(
        reselInfo: reselInfo,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            "로그인",
            style: TextStyle(
                fontSize: 36, fontWeight: FontWeight.w600, color: Colors.blue),
          ),
          const SizedBox(
            height: 250,
          ),
          loginButton(),
          const SizedBox(
            height: 20,
          ),

          /**
           * Flexible
           * 내부에 있는 widget 이 화면을 벗어나려고 할 때,
           * fit 속성을 Flexible.tight 로 설정하면
           * 화면 범위내에서 화면에 남은 영역만 차지하도록
           * 내부 화면 범위를 제한
           */
          const Flexible(
            fit: FlexFit.tight,
            child: SizedBox(
              height: 100,
            ),
          )
        ],
      );
    }
  }

  Form loginForm() {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Image(
              width: 200,
              height: 150,
              image: AssetImage("images/user.png"),
            ),
            const SizedBox(
              height: 20,
            ),
            inputBox(
                keyboardType: TextInputType.emailAddress,
                errorMsg: "이메일을 입력해주세요",
                onChanged: (value) {},
                labelText: "이메일"),
            const SizedBox(
              height: 20,
            ),
            inputBox(
                keyboardType: TextInputType.visiblePassword,
                errorMsg: "비밀번호를 입력해주세요",
                onChanged: (value) {},
                labelText: "비밀번호",
                obscureText: true)
          ],
        ),
      ),
    );
  }

  TextFormField inputBox(
      {keyboardType = TextInputType.text,
      String errorMsg = "값을 입력",
      String labelText = "값을 입력",
      bool obscureText = false,
      Function(dynamic value)? onChanged}) {
    return TextFormField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return "이메일을 입력하세요";
        }
        return errorMsg;
      },
      decoration: InputDecoration(
          border: const OutlineInputBorder(), labelText: labelText),
    );
  }

  GestureDetector loginButton() {
    return GestureDetector(
      onTap: () async {
        try {
          await _googleSignIn.signIn();
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
                "구글로그인",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
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

  void _registerUser() {}
}
