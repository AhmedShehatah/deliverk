import 'package:deliverk/presentation/widgets/restaurant/record_item_model.dart';
import 'package:flutter/material.dart';

class RestaurantRecordScreen extends StatelessWidget {
  const RestaurantRecordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل الطلبات المسلمة"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (ctx, idx) {
            return const RecordItemModel();
          },
          itemCount: 3,
        ),
      ),
    );
  }
}
