import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';

class BoardDetailRow extends StatelessWidget{
  final String? title;
  final String? description;
  const BoardDetailRow({super.key, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
              ),
              SizedBox(width: 8,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title ?? "No board", style: Theme.of(context).textTheme.labelLarge),
                  SizedBox(height: 4),
                  Text(description ?? "", style: Theme.of(context).textTheme.labelSmall)
                ],
              ), 
            ],
          ),
           
          Text("Move", style: AppTextStyles.smallBlueText,)
        ],
       
      ),
    );
  }
}
