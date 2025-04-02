import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unistay/domain/controllers/acccommodation_details_controller.dart';

class ImgIndicator extends StatelessWidget {
  final List<String> indexFotos;
  final int alojamientoIndex;
  final DetailsController detailsController;

  ImgIndicator({
    Key? key,
    required this.indexFotos,
    required this.alojamientoIndex,
    required this.detailsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 180,
      right: 0,
      left: 0,
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: indexFotos.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => detailsController.setCurrent(
                entry.key,
              ),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (detailsController.currentImgList[alojamientoIndex] ==
                              entry.key
                          ? Colors.black
                          : Colors.grey)
                      .withOpacity(0.7),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
