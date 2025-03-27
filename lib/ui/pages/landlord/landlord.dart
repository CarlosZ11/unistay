import 'package:flutter/material.dart';
import 'package:unistay/ui/widgets/Accommodation_card.dart';
import '../../colors/colors.dart';

class Landlord extends StatelessWidget {
  const Landlord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Landlord'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return const AccommodationCard(
                imageUrl:
                    "https://th.bing.com/th/id/R.752a118fa0183c370fe39671b3b72219?rik=I307Oo5cKCRfzA&pid=ImgRaw&r=0",
                location: "colombia",
                price: "150000",
                rate: 4.5,
                title: "Casa en la playa",
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        tooltip: 'Add new Accodmmoation',
        child: const Icon(Icons.add),
      ),
    );
  }
}
