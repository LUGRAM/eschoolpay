import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/services/annee_scolaire_service.dart';
import '../models/annee_scolaire.dart';

class AnneeScolaireController extends GetxController {
  final AnneeScolaireService service;

  AnneeScolaireController(this.service);

  final schoolYears = <AnneeScolaire>[].obs;
  final selectedYear = Rxn<AnneeScolaire>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchYears();
  }

  Future<void> fetchYears() async {
    try {
      isLoading.value = true;

      final years = await service.fetchSchoolYears();
      schoolYears.assignAll(years);

      await _restoreYear();

      selectedYear.value ??= schoolYears.isNotEmpty ? schoolYears.first : null;
    } catch (e) {
      print("fetchYears error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setSelectedYear(AnneeScolaire year) async {
    selectedYear.value = year;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_year_id', year.id);
  }

  Future<void> _restoreYear() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getInt('selected_year_id');

    if (savedId != null) {
      selectedYear.value = schoolYears.firstWhereOrNull((y) => y.id == savedId);
    }
  }
}