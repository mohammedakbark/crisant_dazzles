import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationController = StateProvider<int>((ref) => 0);

final camaraButtonScaleController=StateProvider((ref) => 1.0,);
