import 'package:flutter/material.dart';
import 'package:movie_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // bool _isDarkTheme = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dynamic _name = "";
  dynamic _email = "";

  @override
  void initState() {
    super.initState();
    // _loadTheme();
  }

  // // Load theme from SharedPreferences
  // void _loadTheme() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
  //   });
  // }

  // // Save theme to SharedPreferences
  // void _saveTheme(bool isDarkTheme) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isDarkTheme', isDarkTheme);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(builder: (context) {
          return Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (value) => _name = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value != null && !value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        onSaved: (value) => _email = value,
                      ),
                      IconButton(
                          onPressed: () => {
                                if (_formKey.currentState != null)
                                  {
                                    print('Name: $_name'),
                                    print('Email: $_email')
                                  }
                              },
                          icon: Icon(Icons.file_copy_sharp)),
                      // (
                      //   onPressed: () {
                      //     if (_formKey.currentState.validate()) {
                      //       _formKey.currentState.save();
                      //       print('Name: $_nameController');
                      //       print('Email: $_emailController');
                      //     }
                      //   },
                      //   child: Text('Submit'),
                      // ),
                    ],
                  )),
              ListTile(
                title: Text('Dark Theme'),
                trailing: IconButton(
                  icon: Icon(Icons.settings_brightness),
                  onPressed: () {
                    ThemeProvider themeProvider =
                        Provider.of<ThemeProvider>(context, listen: false);
                    themeProvider.toggleTheme();
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:movie_app/theme/theme_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   bool _darkMode = false;



//   @override
//   void initState() {
//     super.initState();
//     _loadDarkModePreference();
//     // _getTheme();
//   }

//   // void _getTheme() {
//   //   _darkMode = Provider.of<ThemeProvider>().isDarkMode;
//   // }

//   void _loadDarkModePreference() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _darkMode = prefs.getBool('darkMode') ?? false;
//     });
//   }

//   void _saveDarkModePreference(bool value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('darkMode', value);
//     setState(() {
//       _darkMode = value; // Update _darkMode immediately
//     });
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(16.0),
//         children: [
//           TextField(
//             controller: _nameController,
//             decoration: InputDecoration(labelText: 'Name'),
//           ),
//           SizedBox(height: 16.0),
//           TextField(
//             controller: _emailController,
//             decoration: InputDecoration(labelText: 'Email'),
//           ),
//           SizedBox(height: 16.0),
//           ListTile(
//             title: Text('Dark Mode'),
//             trailing: Switch(
//               value: _darkMode,
//               onChanged: (value) {
//                 Provider.of<ThemeProvider>(context, listen: false)
//                     .toggleTheme();
//                 // _saveDarkModePreference(value);
//                 // setState(() {
//                 //   _darkMode = value;
//                 // });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
