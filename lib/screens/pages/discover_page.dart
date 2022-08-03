import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heavenly/miscellaneous/circle_indicator.dart';
import 'package:heavenly/components/display_card.dart';
import 'package:heavenly/components/page_header.dart';
import 'package:heavenly/screens/sound_player.dart';

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
      stream: firestore.collection('$collectionIndex').snapshots(),
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
                        title: sound.get('title'),
                        image:
                            'Images/${categoryNamesList.elementAt(collectionIndex)}/${sound.get('image')}',
                        // change hardcoded index to collectionIndex after populating database
                        fileName:
                            'Music/${categoryNamesList.elementAt(collectionIndex)}/${sound.get('file_name')}',
                      ),
                    ),
                  );
                },
                child: DisplayCard(
                  cardImage:
                      'Images/${categoryNamesList.elementAt(collectionIndex)}/${sound.get('image')}',
                  cardTitle: sound.get('title'),
                  cardSubTitle: sound.get('description'),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
    return Column(
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
      ],
    );
  }
}
