import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPag extends StatefulWidget {
  const PermissionPag({super.key});

  @override
  State<PermissionPag> createState() => _PermissionPagState();
}

class _PermissionPagState extends State<PermissionPag> {
  @override
  Widget build(BuildContext context) {
    @override
    // ignore: override_on_non_overriding_member
    void requestPermission() async {
      final statustracking = await Permission.appTrackingTransparency.status;
      if (statustracking.isGranted) {
        await Permission.appTrackingTransparency.status;
        debugPrint("Permissão de rastreamento concedida");
      } else if (statustracking.isDenied) {
        await Permission.appTrackingTransparency.request();
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.appTrackingTransparency.request(),
          debugPrint("Permissão de rastreamento concedida"),
        };
        debugPrint("Permissão de rastreamento negada");
      } else if (statustracking.isPermanentlyDenied) {
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.appTrackingTransparency.request(),
          debugPrint("Permissão de rastreamento concedida"),
        };
        debugPrint("Permissão de rastreamento negada");
      }

      final statusphone = await Permission.phone.status;
      if (statusphone.isGranted) {
        await Permission.phone.status;
        debugPrint("Todas as Phone concedidas");
      } else if (statusphone.isDenied) {
        await Permission.phone.request();
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.phone.request(),
          debugPrint("Todas as Phone concedidas"),
        };
        debugPrint("Permissões Phone negadas");
      } else if (statusphone.isPermanentlyDenied) {
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.phone.request(),
          debugPrint("Todas as Phone concedidas"),
        };
        debugPrint("Permissões Phone negadas");
      }

      final statusManage = await Permission.manageExternalStorage.status;
      if (statusManage.isGranted) {
        await Permission.manageExternalStorage.status;
        debugPrint("Permissão de armazenamento concedida");
      } else if (statusManage.isDenied) {
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.manageExternalStorage.request(),
          debugPrint("Permissão de armazenamento concedida"),
        };
        debugPrint("Permissão armazenamento negada");
      } else if (statusManage.isPermanentlyDenied) {
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.manageExternalStorage.request(),
        };
        debugPrint("Permissão armazenamento negada");
      }

      final statusStorage = await Permission.storage.status;
      if (statusStorage.isGranted) {
        await Permission.storage.status;
        debugPrint("Permissão de armazenamento concedida");
      } else if (statusStorage.isDenied) {
        await Permission.storage.request();
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.storage.request(),
          debugPrint("Permissão de armazenamento concedida"),
        };
        debugPrint("Permissão armazenamento negada");
      } else if (statusStorage.isPermanentlyDenied) {
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.storage.request(),
          debugPrint("Permissão de armazenamento concedida"),
        };
        debugPrint("Permissão armazenamento negada");
      }

      final statusCamera = await Permission.camera.status;
      if (statusCamera.isGranted) {
        await Permission.camera.status;
        debugPrint("Permissão de camera concedida");
      } else if (statusCamera.isDenied) {
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.camera.request(),
          debugPrint("Permissão de camera concedida"),
        };
        debugPrint("Permissão camera negada");
      } else if (statusCamera.isPermanentlyDenied) {
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.camera.request(),
          debugPrint("Permissão de camera concedida"),
        };
        debugPrint("Permissão camera negada");
      }

      final statusLocation = await Permission.location.status;
      if (statusLocation.isGranted) {
        await Permission.location.status;
        debugPrint("Permissão de location concedida");
      } else if (statusLocation.isDenied) {
        await Permission.location.request();
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.location.request(),
          debugPrint("Permissão de location concedida"),
        };
        debugPrint("Permissão location negada");
      } else if (statusLocation.isPermanentlyDenied) {
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.location.request(),
          debugPrint("Permissão de location concedida"),
        };
        debugPrint("Permissão location negada");
      }

      final statusNotification = await Permission.notification.status;
      if (statusNotification.isGranted) {
        await Permission.notification.status;
        debugPrint("Permissão de notification concedida");
      } else if (statusNotification.isDenied) {
        await Permission.notification.request();
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.notification.request(),
          debugPrint("Permissão de notification concedida"),
        };
        debugPrint("Permissão notification negada");
      } else if (statusNotification.isPermanentlyDenied) {
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.notification.request(),
          debugPrint("Permissão de notification concedida"),
        };
        debugPrint("Permissão notification negada");
      }

      final statusRede = await Permission.locationWhenInUse.status;
      if (statusRede.isGranted) {
        await Permission.locationWhenInUse.request();
        debugPrint("Permissão de rede concedida");
      } else if (statusRede.isDenied) {
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.locationWhenInUse.request(),
          debugPrint("Permissão de rede concedida"),
        };
        debugPrint("Permissão de rede negada");
      } else if (statusRede.isPermanentlyDenied) {
        // ignore: unused_element
        showAboutDialog(context) async => {
          await Permission.locationWhenInUse.request(),
          debugPrint("Permissão de rede concedida"),
        };
        debugPrint("Permissão de rede rede negada");
      }
    }

    requestPermission();
    return Scaffold(
      appBar: AppBar(title: const Text('Permissões')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            requestPermission();
          },
          child: const Text('Solicitar Permissões'),
        ),
      ),
    );
  }
}
