import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/components/reward_page/reward_card.dart';
import 'package:utusan_sarawak/stores/reward_store/reward_store.dart';

class RewardTab extends StatefulWidget {
  const RewardTab({
    Key? key,
    required this.category,
  }) : super(key: key);

  final String category;

  @override
  State<RewardTab> createState() => RewardTabState();
}

class RewardTabState extends State<RewardTab> {
  late Future<List<Map<String, dynamic>>> futureRewards;

  Future<List<Map<String, dynamic>>> loadRewards() async{
    RewardStore rewardStore = GetIt.I<RewardStore>();
    List<Map<String, dynamic>> reward = await rewardStore.getRewards();

    return List<Map<String, dynamic>>.from(reward);
  }

  @override
  void initState() {
    super.initState();
    futureRewards = loadRewards();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureRewards,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No rewards found.'));
        }

        final rewards = snapshot.data!
            .where((reward) => reward['category'] == widget.category)
            .toList();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: rewards.map((reward) => RewardCard(reward: reward)).toList(),
            ),
          ),
        );
      },
    );
  }
}
