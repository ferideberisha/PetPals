import 'dart:io'; // For File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petpals/models/priceModel.dart';
import 'package:petpals/models/userModel.dart';
import 'package:petpals/pages/home/search/owner_detail_page.dart';
import 'package:petpals/pages/home/search/walker_detail_page.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onFavoriteTap;
  final bool isFavorited;
  final double elevation;
  final EdgeInsetsGeometry margin;
  final Color color;
  final ShapeBorder shape;

  const UserCard({
    Key? key,
    required this.user,
    required this.onFavoriteTap,
    this.isFavorited = false,
    this.elevation = 0.0,
    this.margin = const EdgeInsets.all(10),
    this.color = Colors.white,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  }) : super(key: key);

  Future<List<String>> _fetchPriceIds() async {
    try {
      final subCollection = user.role == 'walker' ? 'walkerInfo' : 'ownerInfo';
      final path = 'users/${user.uid}/$subCollection/${user.uid}/price';
      final querySnapshot = await FirebaseFirestore.instance.collection(path).get();
      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching price IDs: $e');
      return [];
    }
  }

Future<Prices?> _fetchPrices(String priceId) async {
  try {
    // Correct path based on your setup
    final subCollection = user.role == 'walker' ? 'walkerInfo' : 'ownerInfo';
    final priceDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection(subCollection)
        .doc(user.uid)
        .collection('price')
        .doc(priceId)
        .get();

    // Debug print to check the path and ID
    print('Fetching document with ID: $priceId from path: users/${user.uid}/$subCollection/${user.uid}/price');

    if (priceDoc.exists) {
      print('Document data: ${priceDoc.data()}'); // Debug print
      return Prices.fromMap(priceDoc.data()!);
    } else {
      print('Price document does not exist: $priceId');
      return null;
    }
  } catch (e) {
    print('Error fetching prices: $e');
    return null;
  }
}



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _fetchPriceIds(), // Fetch price IDs
      builder: (context, priceIDsnapshot) {
        if (priceIDsnapshot.connectionState == ConnectionState.waiting) {
          return Card(
            elevation: elevation,
            margin: margin,
            color: color,
            shape: shape,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (priceIDsnapshot.hasError || priceIDsnapshot.data == null) {
          return Card(
            elevation: elevation,
            margin: margin,
            color: color,
            shape: shape,
            child: const Center(child: Text('Error fetching priceIDs')),
          );
        }

        final priceIds = priceIDsnapshot.data!;
        if (priceIds.isEmpty) {
          return Card(
            elevation: elevation,
            margin: margin,
            color: color,
            shape: shape,
            child: const Center(child: Text('No price IDs found')),
          );
        }

        return FutureBuilder<Prices?>(
          future: _fetchPrices(priceIds.first), // Fetch Prices document
          builder: (context, pricesSnapshot) {
            final prices = pricesSnapshot.data;
            final isLoading = pricesSnapshot.connectionState == ConnectionState.waiting;
            final error = pricesSnapshot.hasError;

            return Card(
  elevation: elevation,
  margin: margin,
  color: color,
  shape: shape,
  child: InkWell(
    onTap: () {
      if (user.role == 'walker') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WalkerDetailPage(user: user),
          ),
        );
      } else if (user.role == 'owner') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OwnerDetailPage(user: user),
          ),
        );
      }
    },
    child: Container(
      height: 120,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: _getProfileImage(user.profilePicture),
            backgroundColor: user.profilePicture.isEmpty ? Colors.grey.shade200 : null,
            radius: 40,
            child: user.profilePicture.isEmpty
                ? const Icon(Icons.person, size: 40, color: Color.fromRGBO(158, 158, 158, 1))
                : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isLoading) ...[
                  const Text('Loading price...'),
                ] else if (error) ...[
                  const Text('Error fetching price'),
                ] else if (prices != null) ...[
                  RichText(
                    text: TextSpan(
                      text: 'FROM: ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF967BB6), // Adjust color as needed
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${prices.walkingPrice?.toStringAsFixed(0) ?? 'N/A'} EURO',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF967BB6), // Adjust color as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : null,
                ),
                onPressed: onFavoriteTap,
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);

          },
        );
      },
    );
  }

  ImageProvider? _getProfileImage(String profilePicture) {
    try {
      if (profilePicture.isEmpty) {
        return null;
      } else if (_isNetworkUrl(profilePicture)) {
        return NetworkImage(profilePicture);
      } else {
        final file = File(profilePicture);
        if (file.existsSync()) {
          return FileImage(file);
        } else {
          print('File does not exist: $profilePicture');
          return null;
        }
      }
    } catch (e) {
      print('Error loading profile picture: $e');
      return null;
    }
  }

  bool _isNetworkUrl(String url) {
    return url.startsWith('http') || url.startsWith('https');
  }
}
