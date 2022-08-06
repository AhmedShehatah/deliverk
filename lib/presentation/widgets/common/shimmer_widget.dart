import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 5,
          child: SizedBox(
            height: 100,
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.white,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 100,
                      height: 15,
                      color: Colors.white,
                    ),
                    Container(
                      width: 50,
                      height: 15,
                      color: Colors.white,
                    ),
                    Container(
                      width: 200,
                      height: 15,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
