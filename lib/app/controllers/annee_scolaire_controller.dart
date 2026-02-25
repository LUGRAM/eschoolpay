import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/services/annee_scolaire_service.dart';
import '../models/annee_scolaire.dart';

class AnneeScolaireController extends GetxController {

  final AnneeScolaireService service;

  AnneeScolaireController(this.service);

  var schoolYears = <AnneeScolaire>[].obs;
  var selectedYear = Rxn<AnneeScolaire>();
  var isLoading = false.obs;
  static final GetStorage _box = GetStorage();

  // =====================================================
  // TOKEN CENTRALISÉ
  // =====================================================
  static String? get _token =>
      _box.read("auth_token") ?? _box.read("token");

  @override
  void onInit() {
    fetchYears(_token);
    super.onInit();
  }

  void fetchYears(String? token) async {
    try {
      isLoading.value = true;
      final years = await service.fetchSchoolYears(token!);
      schoolYears.assignAll(years);
      selectedYear.value = years.first;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}