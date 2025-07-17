import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/utils/config.dart';
import 'package:inspecoespoty/data/services/prefs.dart';
import 'package:inspecoespoty/ui/login/widgets/login_screen.dart';
import 'package:inspecoespoty/ui/splash/widgets/no_internet_screen.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_alert.dart';
import 'package:inspecoespoty/ui/person/widgets/person_screen.dart';
import 'package:inspecoespoty/ui/inspection/widgets/inspection_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    configUserModel?.name ?? '',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  accountEmail: Text(
                    configUserModel?.user ?? '',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  currentAccountPicture: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
                ListTile(
                  title: Text('Inspeções'),
                  subtitle: Text('Cadastrar tipos de inspeção'),
                  leading: Icon(Icons.find_in_page),
                  onTap: () {
                    Get.to(() => InspectionScreen());
                  },
                ),
                ListTile(
                  title: Text('Pessoas'),
                  subtitle: Text('Cadastrar pessoas'),
                  leading: Icon(Icons.person),
                  onTap: () {
                    Get.to(() => PersonScreen());
                  },
                ),
                
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 6),
                  child: Divider(),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Logout'),
            subtitle: Text('Sair do sistema'),
            leading: Icon(Icons.logout),
            onTap: () {
              CustomAlert().confirm(
                content: 'Deseja realmente sair?',
                onConfirm: () async {
                  await Prefs.deleteAll();
                  Get.offAll(() => LoginScreen());
                },
              );
            },
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
