import 'package:cryptkey/widgets/customTiles.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 2, 18, 46),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 2, 18, 46),
            leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             mainAxisSize: MainAxisSize.max,
             children: [
              SizedBox(height: 20,),
               Row(
                 children: [
                   SizedBox(
                     width: 15,
                   ),
                   Hero(
                     tag: 'user',
                     child: CircleAvatar(
                       radius: 50,
                       backgroundColor: Colors.white,
                       backgroundImage: AssetImage('assets/icons/bank.png'),
                     ),
                   ),
                   SizedBox(
                     width: 20,
                   ),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.values[2],
                     children: [
                       Text(
                         'Rohan Karn',
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 27,
                           fontWeight: FontWeight.w400,
                           letterSpacing: 1.5,
                         ),
                       ),
                       const SizedBox(height: 10),
                       Text(
                         'rohankarn35@gmail.com',
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 13,
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
                SizedBox(height: 20,),
             
                Divider(color: Colors.white.withOpacity(0.3),),
                   SizedBox(height: 30,),
                CustomTile().customTile("Clear Data", "Clear all your data", Icons.circle_outlined, () { }),
                CustomTile().customTile("Privacy Policy", "App Privacy Policy", Icons.privacy_tip_outlined, () { }),
                CustomTile().customTile("About", "App and Developer Details", Icons.details_outlined, () { }),
                Spacer(),
               TextButton(onPressed: (){}, child: Text("Logout", style: TextStyle(color: Colors.red,fontSize: 17),)), 
                SizedBox(height: 20,),
               
               
             ],
           ));
  }
}
