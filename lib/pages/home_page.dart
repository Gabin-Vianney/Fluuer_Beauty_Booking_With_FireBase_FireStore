import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebasebookingapp/pages/manage_appoinment_page.dart';
import 'package:firebasebookingapp/pages/profile_page.dart';
import 'package:firebasebookingapp/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebookingapp/pages/login_page.dart';
import 'package:firebasebookingapp/pages/service_details_page.dart';
import 'package:firebasebookingapp/service/auth/auth_service.dart';
import 'package:firebasebookingapp/service/database_service.dart';
import 'package:firebasebookingapp/shared/constants.dart';
import 'package:firebasebookingapp/widgets/widgets.dart';
import 'dart:io';
import '../model/service_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color bottomNavBgColor = const Color(0XFF17203A);

  String fullName = "";
  String email = "";
  String profileImageUrl = "";
  AuthService authService = AuthService();
  final ImagePicker _picker = ImagePicker();
  ThemeMode _themeMode = ThemeMode.system;
  int _selectedIndex = 0;

  List<Service> services = [
    Service(
        name: "Haircut",
        price: 20.0,
        imageUrl: "assets/images/coupe_cheveux.png",
        description:
            "Treat yourself to a stylish haircut perfectly tailored to your style. Our expert hairstylists are here to transform your look with precision and creativity."),
    Service(
        name: "Manicure",
        price: 15.0,
        imageUrl: "assets/images/manucure.png",
        description:
            "Treat yourself to a trendy haircut that perfectly suits your style. Our expert hairstylists are here to transform your look with precision and creativity."),
    Service(
        name: "Massage",
        price: 50.0,
        imageUrl: "assets/images/massage.png",
        description:
            "Relax with a soothing massage that relieves tension and revitalizes you. Our qualified therapists use personalized techniques to meet your needs."),
    Service(
        name: "Facial care",
        price: 30.0,
        imageUrl: "assets/images/soin_visage.png",
        description:
            "Revitalize your skin with our complete facial treatment. This treatment hydrates, purifies, and revitalizes your complexion for a radiant glow."),
  ];

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  void _getUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userData = await DatabaseService(uid: user.uid).getUserData();
      setState(() {
        email = user.email!;
        fullName = userData['fullName'] ?? "";
        profileImageUrl = userData['profilePic'] ?? "";
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      await _uploadImage(imageFile);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String fileName = '${user.uid}/profile.jpg';
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(imageFile);

        await uploadTask.whenComplete(() => null);
        String downloadUrl = await storageRef.getDownloadURL();

        await DatabaseService(uid: user.uid).updateProfileImage(downloadUrl);

        setState(() {
          profileImageUrl = downloadUrl;
        });
      }
    } catch (e) {
      print('Erreur lors du téléchargement de l\'image: $e');
    }
  }

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToServiceDetails(Service service) {
    nextScreenReplace(context, ServiceDetailsPage(service: service));
  }

  @override
  Widget build(BuildContext context) {
    Widget getBody() {
      switch (_selectedIndex) {
        case 0:
          return LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome to Beauty Radiance,",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          textAlign: TextAlign.justify,
                          "Your oasis of relaxation and well-being in the heart of the city. We offer a wide range of services from stylish haircuts to revitalizing facials, soothing massages, and perfect manicures. At Éclat Beauté, your beauty is our priority. Treat yourself to a moment of luxury and let us take care of you in a warm and relaxing atmosphere.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CarouselSlider.builder(
                        itemCount: services.length,
                        itemBuilder: (context, index, realIndex) {
                          final service = services[index];
                          return GestureDetector(
                            onTap: () => _navigateToServiceDetails(service),
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              borderOnForeground: false,
                              clipBehavior: Clip.antiAlias,
                              semanticContainer: true,
                              shadowColor: Colors.blue,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    service.imageUrl,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(service.name,
                                      style: const TextStyle(fontSize: 18)),
                                  Text("\$${service.price.toStringAsFixed(2)}",
                                      style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 250,
                          autoPlay: true,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        case 1:
          return const ProfilePage();
        case 2:
          return const SettingsPage();
        case 3:
          return const ManageAppointmentsPage();
        default:
          return const Center(
            child: Text("Page  not found"),
          );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: bottomNavBgColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: primaryColor,
              ),
              accountName: Text(
                fullName,
                style: const TextStyle(color: secondaryColor),
              ),
              accountEmail: Text(
                email,
                style: const TextStyle(color: secondaryColor),
              ),
              currentAccountPicture: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : null,
                    backgroundColor: Colors.white,
                    child: profileImageUrl.isEmpty
                        ? const Icon(Icons.person,
                            size: 50, color: primaryColor)
                        : null,
                  ),
                  Positioned(
                    bottom: 1,
                    right: -15,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: primaryColor),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: primaryColor,
              ),
              title: const Text('Settings',
                  style: TextStyle(
                    color: secondaryColor,
                  )),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: primaryColor,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(color: secondaryColor),
              ),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          textAlign: TextAlign.center,
                          "Log out",
                        ),
                        content: const Text(
                          "Are you sure you want to logout?",
                          style: TextStyle(
                            color: Color(0xffee7b64),
                          ),
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                            ),
                            color: const Color(0xffee7b64),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            icon: const Icon(
                              Icons.done,
                            ),
                            color: Colors.green,
                          ),
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: const Icon(Icons.exit_to_app, color: primaryColor),
              title: const Text(
                "Logout",
                style: TextStyle(color: secondaryColor, fontSize: 15.0),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(child: getBody()),
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          backgroundColor: bottomNavBgColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: "Appointment"),
          ],
        ),
      ),
    );
  }
}
