import 'package:flutter/material.dart';

import '../../inspector/inspector_model.dart';
import 'tabs/error_tab.dart';
import 'tabs/overview_tab.dart';
import 'tabs/request_tab.dart';
import 'tabs/response_tab.dart';

class InspectorDetailsScreen extends StatefulWidget {
  final InspectorModel inspectorModel;

  const InspectorDetailsScreen({super.key, required this.inspectorModel});

  @override
  State<InspectorDetailsScreen> createState() => _InspectorDetailsScreenState();
}

class _InspectorDetailsScreenState extends State<InspectorDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (tabController.index) {
      0 => 'Overview',
      1 => 'Request',
      2 => 'Response',
      _ => 'Error',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.info_outline)),
            Tab(text: 'Request', icon: Icon(Icons.arrow_upward)),
            Tab(text: 'Response', icon: Icon(Icons.arrow_downward)),
            Tab(text: 'Error', icon: Icon(Icons.error_outline)),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          OverviewTab(inspectorModel: widget.inspectorModel),
          RequestTab(inspectorModel: widget.inspectorModel),
          ResponseTab(inspectorModel: widget.inspectorModel),
          ErrorTab(inspectorModel: widget.inspectorModel),
        ],
      ),
    );
  }
}
