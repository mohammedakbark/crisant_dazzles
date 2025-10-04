import 'package:dazzles/core/paint/action_grid_item_paint.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionGridItemTile extends StatelessWidget {
  final Color color;
  final String title;
  final void Function()? onTap;
  final IconData icon;

  const ActionGridItemTile(
      {super.key,
      required this.color,
      required this.title,
      this.onTap,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: CustomPaint(
        painter: ActionGridItemPaint(color: color),
        child: Material(
          color: color.withAlpha(50),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: color.withAlpha(100), width: 2),
              borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withAlpha(40),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withAlpha(30),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(icon,
                        size: 24, semanticLabel: title, color: color),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppStyle.boldStyle(fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
