// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_print, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common_widgets/custome_text_field.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';
import 'admin_appBar.dart';

class UsersTab extends StatefulWidget {
  const UsersTab({super.key});

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  final storeController = Get.put(StoreController());
  final searchCont = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isUserSearched = false;

  updateUserActivaty(String id, active) {
    try {
      FirebaseFirestore.instance.collection('users').doc(id).update({
        'isActive': active,
      });
      print("done active");
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteAccount(BuildContext context, String id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete Account'),
              content: Text('Are you sure you want to delete your account?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(id)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Account deleted successfully')));
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to delete account: $e')));
                    }
                  },
                  child: Text('Delete'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: TColor.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TColor.background,
              TColor.primary.withOpacity(0.03),
              TColor.secondary.withOpacity(0.02),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  AdminAppbar(),
                  SizedBox(height: 32),

                  // Header Section with Stats
                  FadeInDown(
                    delay: Duration(milliseconds: 300),
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: TColor.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: TColor.primary.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: TColor.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.people,
                              color: TColor.primary,
                              size: 32,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "User Management",
                                  style: TextStyle(
                                    color: TColor.onSurface,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Manage all users in the system",
                                  style: TextStyle(
                                    color: TColor.onSurfaceVariant,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Search Section
                  FadeInDown(
                    delay: Duration(milliseconds: 400),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: TColor.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: TColor.primary.withOpacity(0.08),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: SearchAndFilter(
                        searchCont: searchCont,
                        onChanged: (value) {
                          HapticFeedback.lightImpact();
                          if (value.isNotEmpty) {
                            setState(() {
                              isUserSearched = true;
                            });
                          } else {
                            setState(() {
                              isUserSearched = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Users List Header
                  FadeInDown(
                    delay: Duration(milliseconds: 500),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: TColor.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.group,
                            color: TColor.secondary,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "All Users",
                          style: TextStyle(
                            color: TColor.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              int userCount = snapshot.data!.docs
                                  .where((doc) =>
                                      doc["email"] != auth.currentUser!.email)
                                  .length;
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: TColor.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "$userCount users",
                                  style: TextStyle(
                                    color: TColor.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  SizedBox(height: 20),

                  // Users Grid
                  SizedBox(
                    width: double.infinity,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Container(
                              padding: EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: TColor.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.error_outline,
                                      color: TColor.error, size: 48),
                                  SizedBox(height: 16),
                                  Text(
                                    "Error loading users",
                                    style: TextStyle(
                                        color: TColor.error,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              padding: EdgeInsets.all(48),
                              child: Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(
                                        color: TColor.primary),
                                    SizedBox(height: 16),
                                    Text(
                                      "Loading users...",
                                      style: TextStyle(
                                        color: TColor.onSurfaceVariant,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasData || snapshot.data != null) {
                            List snap = snapshot.data!.docs;
                            if (isUserSearched) {
                              snap.removeWhere((e) {
                                return !e
                                    .data()["name"]
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(searchCont.text.toLowerCase());
                              });
                            }

                            List filteredUsers = snap
                                .where((user) =>
                                    user["email"] != auth.currentUser!.email)
                                .toList();

                            if (filteredUsers.isEmpty) {
                              return Container(
                                padding: EdgeInsets.all(48),
                                decoration: BoxDecoration(
                                  color: TColor.surface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.people_outline,
                                        color: TColor.onSurfaceVariant,
                                        size: 64),
                                    SizedBox(height: 16),
                                    Text(
                                      isUserSearched
                                          ? "No users found"
                                          : "No users yet",
                                      style: TextStyle(
                                        color: TColor.onSurface,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      isUserSearched
                                          ? "Try a different search term"
                                          : "Users will appear here when they register",
                                      style: TextStyle(
                                        color: TColor.onSurfaceVariant,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: filteredUsers.length,
                              itemBuilder: (context, index) {
                                var user = filteredUsers[index];
                                return FadeInDown(
                                  delay: Duration(
                                      milliseconds: 600 + (index * 100)),
                                  child: ProfrssorTile(
                                    name: user['name'],
                                    detailOnTap: () {
                                      HapticFeedback.lightImpact();
                                      customDialog(
                                          context, user['name'], user['email']);
                                    },
                                    activateOnPressed: () {
                                      HapticFeedback.mediumImpact();
                                      updateUserActivaty(user['uid'], true);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(Icons.check_circle,
                                                  color: Colors.white),
                                              SizedBox(width: 12),
                                              Text(
                                                  "Account activated successfully"),
                                            ],
                                          ),
                                          backgroundColor: TColor.success,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      );
                                    },
                                    deactivateOnPressed: () {
                                      HapticFeedback.mediumImpact();
                                      updateUserActivaty(user['uid'], false);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(Icons.block,
                                                  color: Colors.white),
                                              SizedBox(width: 12),
                                              Text(
                                                  "Account deactivated successfully"),
                                            ],
                                          ),
                                          backgroundColor: TColor.warning,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      );
                                    },
                                    deleteOnPressed: () async {
                                      HapticFeedback.heavyImpact();
                                      deleteAccount(context, user['uid']);
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container(
                              padding: EdgeInsets.all(48),
                              child: Center(
                                child: Text(
                                  "No data available",
                                  style: TextStyle(
                                    color: TColor.onSurfaceVariant,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  ),

                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//===============
class ProfrssorTile extends StatelessWidget {
  const ProfrssorTile({
    super.key,
    required this.name,
    required this.detailOnTap,
    this.activateOnPressed,
    this.deactivateOnPressed,
    this.deleteOnPressed,
  });
  final String name;
  final void Function() detailOnTap;
  final void Function()? activateOnPressed;
  final void Function()? deactivateOnPressed;
  final void Function()? deleteOnPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColor.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Header with Avatar and Name
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    TColor.primary.withOpacity(0.1),
                    TColor.secondary.withOpacity(0.05),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [TColor.primary, TColor.secondary],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: TColor.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: TextStyle(
                          color: TColor.onPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: TColor.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: TColor.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Active User",
                            style: TextStyle(
                              color: TColor.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: detailOnTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: TColor.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: activateOnPressed,
                      icon: Icon(Icons.check_circle_outline, size: 18),
                      label: Text("Activate"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.success,
                        foregroundColor: TColor.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: deactivateOnPressed,
                      icon: Icon(Icons.block, size: 18),
                      label: Text("Block"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.warning,
                        foregroundColor: TColor.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: deleteOnPressed,
                      icon: Icon(Icons.delete_outline, size: 18),
                      label: Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.error,
                        foregroundColor: TColor.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//================
class SearchAndFilter extends StatelessWidget {
  SearchAndFilter({
    super.key,
    required this.searchCont,
    this.onChanged,
  });

  final TextEditingController searchCont;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: TColor.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: searchCont,
              onChanged: onChanged,
              style: TextStyle(
                color: TColor.onSurface,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: "Search users by name...",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: TColor.onSurfaceVariant,
                ),
                prefixIcon: Container(
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TColor.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.search,
                    color: TColor.primary,
                    size: 20,
                  ),
                ),
                suffixIcon: searchCont.text.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          searchCont.clear();
                          if (onChanged != null) onChanged!("");
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          margin: EdgeInsets.all(12),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.clear,
                            color: TColor.onSurfaceVariant,
                            size: 16,
                          ),
                        ),
                      )
                    : null,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                filled: true,
                fillColor: TColor.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: TColor.primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: TColor.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: TColor.secondary.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // TODO: Add filter functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Filter options coming soon!"),
                  backgroundColor: TColor.secondary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.secondary,
              foregroundColor: TColor.onPrimary,
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: Icon(Icons.filter_list, size: 24),
          ),
        ),
      ],
    );
  }
}

//================
Future<dynamic> customDialog(
  BuildContext context,
  String userName,
  String userMail,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: TColor.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: TColor.primary.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TColor.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: TColor.primary,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "User Details",
                style: TextStyle(
                  color: TColor.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 24),

              // User Info Cards
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TColor.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: TColor.primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColor.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        color: TColor.secondary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Full Name",
                            style: TextStyle(
                              color: TColor.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            userName,
                            style: TextStyle(
                              color: TColor.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TColor.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: TColor.primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.email_outlined,
                        color: TColor.primary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email Address",
                            style: TextStyle(
                              color: TColor.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            userMail,
                            style: TextStyle(
                              color: TColor.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary,
                    foregroundColor: TColor.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
