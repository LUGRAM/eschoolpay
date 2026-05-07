import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/exercices_controller.dart';
import '../models/exercice_model.dart';
import '../widgets/exercice_card.dart';
import '../widgets/exercice_shimmer_grid.dart';
import '../widgets/matiere_filter_chips.dart';
import 'exercice_detail_page.dart';

class ExercicesListPage extends StatefulWidget {
  const ExercicesListPage({super.key});

  @override
  State<ExercicesListPage> createState() => _ExercicesListPageState();
}

class _ExercicesListPageState extends State<ExercicesListPage> {
  late final ExercicesController _ctrl;
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(ExercicesController());
    _searchCtrl = TextEditingController();
    _searchCtrl.addListener(() => _ctrl.onSearchChanged(_searchCtrl.text));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openDetail(ExerciceModel exercice) {
    Get.to(
      () => ExerciceDetailPage(),
      arguments: {'exerciceId': exercice.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildSearchBar()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: const MatiereFilterChips(),
            ),
          ),
          Obx(() {
            if (_ctrl.isLoading.value) return const ExerciceShimmerGrid();
            if (_ctrl.exercices.isEmpty) return _buildEmpty();
            return _buildGrid();
          }),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 56, bottom: 14),
        title: const Text(
          'Exercices',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.gradientEnd],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 52),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.quiz_outlined,
                      color: Colors.white38, size: 44),
                  const SizedBox(width: 12),
                  Obx(() => Text(
                        '${_ctrl.exercices.length} exercice${_ctrl.exercices.length > 1 ? 's' : ''} disponibles',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchCtrl,
          decoration: const InputDecoration(
            hintText: 'Rechercher un exercice, matière, niveau…',
            hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, i) => ExerciceCard(
            key: ValueKey(_ctrl.exercices[i].id),
            exercice: _ctrl.exercices[i],
            onTap: () => _openDetail(_ctrl.exercices[i]),
          ),
          childCount: _ctrl.exercices.length,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.quiz_outlined,
                  size: 64, color: AppColors.textMuted),
              const SizedBox(height: 16),
              const Text(
                'Aucun exercice trouvé',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Essayez un autre mot-clé ou filtre',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
