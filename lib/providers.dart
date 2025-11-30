import 'package:local_auth/local_auth.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:travelfile/services/local_auth.service.dart';

final providers = <SingleChildWidget>[
  Provider<LocalAuthService>(
    create: (context) => LocalAuthService(auth: LocalAuthentication()),
  ),
];
