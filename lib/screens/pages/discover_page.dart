import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heavenly/miscellaneous/circle_indicator.dart';
import 'package:heavenly/components/display_card.dart';
import 'package:heavenly/components/page_header.dart';
import 'package:heavenly/screens/sound_player.dart';

import '../../components/private_collection.dart';

final firestore = FirebaseFirestore.instance;

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with TickerProviderStateMixin {
  List categoryNamesList = [];

  void getTabData() async {
    await firestore
        .collection('category_names')
        .get()
        .then((QuerySnapshot? querySnapshot) {
      for (var doc in querySnapshot!.docs) {
        setState(() {
          categoryNamesList = doc['category_names'];
        });
      }
    });
  }

  dynamic listViewChildren(int collectionIndex) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection(categoryNamesList.elementAt(collectionIndex))
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final sounds = snapshot.data?.docs;
          List<Widget> soundWidgets = [];
          for (var sound in sounds!) {
            soundWidgets.add(
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SoundPlayer(
                        soundID: sound.get('sound'),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DisplayCard(
                    soundID: sound.get('sound'),
                  ),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            scrollDirection: Axis.horizontal,
            children: soundWidgets,
          );
        } else {
          return const Center(
            child: Text(
              'Loading...',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    getTabData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController =
        TabController(length: categoryNamesList.length, vsync: this);
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PageHeader(
            title: 'Discover\nNew sounds',
            requireSearchBar: true,
            requireUserDetails: true,
          ),
          TabBar(
            controller: tabController,
            isScrollable: true,
            splashFactory: NoSplash.splashFactory,
            indicator: const DotIndicator(),
            indicatorPadding: const EdgeInsets.all(10),
            labelColor: Colors.teal.shade700,
            unselectedLabelColor: Colors.black38,
            tabs: List.generate(categoryNamesList.length,
                (index) => Tab(text: categoryNamesList.elementAt(index))),
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3.5,
            child: TabBarView(
              controller: tabController,
              children: List.generate(
                categoryNamesList.length,
                (index) => listViewChildren(index),
              ),
            ),
          ),
          const Expanded(child: PrivateCollection(showDel: false)),
        ],
      ),
    );
  }
}
