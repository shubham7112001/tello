import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/zoom/zoom_bloc.dart';

class ZoomableWidget extends StatelessWidget {
  final Widget child;

  const ZoomableWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZoomBloc, ZoomState>(
      builder: (context, state) {
       return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
         child: Transform.scale(
          scale: state.scale,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: MediaQuery.of(context).size.width / state.scale,
            child: child,
          ),
               ),
       );

      },
    );
  }
}

