import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regist/viewmodel/booked_view_model.dart';

class ReservationConfirmationPage extends StatelessWidget {
  const ReservationConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bookedViewModel = context.watch<BookedViewModel>();
    
    return ListView.builder(itemBuilder:);
  }
}
