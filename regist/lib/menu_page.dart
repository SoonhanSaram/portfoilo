import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:regist/calendar.dart';
import 'package:regist/reservation_confirmation_page.dart';
import 'package:regist/ui_modules/ui_modules.dart';
import 'package:regist/viewmodel/booked_view_model.dart';
import 'package:regist/viewmodel/login_view_model.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    var loginViewModel = context.watch<LoginViewModel>();
    var bookedViewModel = context.watch<BookedViewModel>();
    var uiModule = UiModules();
    return Scaffold(
      appBar: AppBar(
        title: Text(dotenv.env["TITLE"]!),
      ),
      body: ConstrainedBox(constraints: const BoxConstraints.expand(), child: menu_body(loginViewModel, context, uiModule, bookedViewModel)),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: uiModule.drawerTitle.length,
          itemBuilder: (context, i) {
            return ListTile(
                title: Text(uiModule.drawerTitle[i]),
                onTap: () => uiModule.removeToCompos(
                      context: context,
                      page: uiModule.drawerCompos[i],
                    ));
          },
        ),
      ),
    );
  }

  Column menu_body(LoginViewModel loginViewModel, BuildContext context, UiModules uiModule, BookedViewModel bookedViewModel) {
    return Column(
      children: [
        Text(
          "${loginViewModel.reselInfo!.user}님 환영합니다",
          style: const TextStyle(fontSize: 24),
        ),
        const Flexible(fit: FlexFit.tight, child: SizedBox()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
            shrinkWrap: true,
            children: [
              reselvationButton(
                context,
                dotenv.env["MAIN_PAGE_TITLE1"] ?? "",
                () => uiModule.toCompos(context: context, page: const Calendar()),
              ),
              reselvationButton(
                  context,
                  dotenv.env["MAIN_PAGE_TITLE2"] ?? "",
                  () => {
                        bookedViewModel.getInfoFunc(user: bookedViewModel.user),
                        () => uiModule.toCompos(context: context, page: const ReservationConfirmationPage()),
                      }),
              reselvationButton(
                context,
                dotenv.env["MAIN_MESSAGE"] ?? "",
                () {},
              ),
              reselvationButton(
                context,
                dotenv.env["MAIN_ALARM"] ?? "",
                () {},
              ),
            ],
          ),
        ),
        const Flexible(fit: FlexFit.tight, child: SizedBox()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: reselvationButton(
              context,
              dotenv.env["LOGOUT_BUTTON"]!,
              () => loginViewModel.logout(context),
            ),
          ),
        )
      ],
    );
  }

  GestureDetector reselvationButton(
    BuildContext context,
    String buttonTitle,
    Function() function,
  ) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Color(int.parse(dotenv.env["BACKGROUND_COLOR"]!)),
          borderRadius: BorderRadius.circular(16.0), // Container의 모서리를 둥글게 설정
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
