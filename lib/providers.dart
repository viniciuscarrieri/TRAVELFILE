import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:travelfile/features/auth/data/auth_repository.dart';
import 'package:travelfile/features/auth/data/user_repository.dart';
import 'package:travelfile/features/auth/presentation/auth_controller.dart';
import 'package:travelfile/features/travel_documents/data/travel_repository.dart';
import 'package:travelfile/features/travel_documents/presentation/travel_documents_controller.dart';
import 'package:travelfile/services/local_auth.service.dart';

final providers = <SingleChildWidget>[
  Provider<AuthRepository>(
    create: (context) => AuthRepository(),
  ),
  Provider<UserRepository>(
    create: (context) => UserRepository(),
  ),
  Provider<TravelRepository>(
    create: (context) => TravelRepository(),
  ),
  Provider<AuthController>(
    create: (context) => AuthController(repository: context.read<AuthRepository>()),
  ),
  ChangeNotifierProvider<TravelDocumentsController>(
    create: (context) => TravelDocumentsController(
      repository: context.read<TravelRepository>(),
    ),
  ),
  Provider<LocalAuthService>(
    create: (context) => LocalAuthService(auth: LocalAuthentication()),
  ),
];
