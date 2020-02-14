import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'image_provider_view_model.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(
    create: (context) => ImageProviderViewModel(),
  ),
];
