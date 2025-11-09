import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';

class ImageScrollCubit extends Cubit<int> {
  ImageScrollCubit() : super(0);

  void updatePage(int page) => emit(page);
}
class ImageScrollerBlocWrapper extends StatelessWidget {
  const ImageScrollerBlocWrapper({super.key, required this.boards});

  final List<HomeBoardModel> boards;
  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImageScrollCubit(),
      child: ImageScroller(boards: boards,),
    );
  }
}

class ImageScroller extends StatelessWidget {
  const ImageScroller({super.key, required this.boards});
  final List<HomeBoardModel> boards;

  final double cardWidth = 100;
  final double cardHeight = 40;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(viewportFraction: 0.23.w);
    final totalPages = boards.length;

    controller.addListener(() {
      final page = controller.page?.round() ?? 0;
      context.read<ImageScrollCubit>().updatePage(page);
    });

    return SizedBox(
      height: cardHeight.h,
      child: Stack(
        children: [
          PageView.builder(
            physics: ClampingScrollPhysics(),
            padEnds: false,
            controller: controller,
            itemCount: totalPages,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 16 : 4,
                    right: index == totalPages - 1 ? 16 : 4,
                  ),
                  child: InkWell(
                    onTap: (){
                      AppNavigator.goToBoard(homeBoard: boards[index]);
                    },
                    child: Container(
                      height: cardHeight.h,
                      width: cardWidth.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: getDarkRandomColor(),
                      ),
                      child: Center(child: Text(boards[index].name ?? 'Untitled', style: AppTextStyles.labelLargeDark,)),
                    ),
                  ),
                ),
              );
            },
          ),
          // Left Icon
          BlocBuilder<ImageScrollCubit, int>(
            builder: (context, currentPage) {
              if (currentPage == 0) return const SizedBox();
              return Positioned(
                left: -10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                  ),
                ),
              );
            },
          ),
          // Right Icon
          BlocBuilder<ImageScrollCubit, int>(
            builder: (context, currentPage) {
              if (totalPages < 5 || currentPage == totalPages - 3) return const SizedBox();
              debugPrint("Current Page: $currentPage");
              return Positioned(
                right: -15,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Color getDarkRandomColor() {
  final Random random = Random();

  int r = random.nextInt(101); 
  int g = random.nextInt(101);
  int b = random.nextInt(101);

  return Color.fromARGB(255, r, g, b);
}

