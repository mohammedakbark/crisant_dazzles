import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppMargin(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) => _buildTile(),
      ),
    );
  }

  Widget _buildTile() {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kPrimaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container(color: AppColors.kWhite)),
          Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Sari"), Text("2000.0")],
            ),
          ),
        ],
      ),
    );
  }
}
