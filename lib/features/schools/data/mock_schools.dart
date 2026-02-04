import '../models/school_model.dart';
import '../models/class_level_model.dart';

const mockSchools = [
  SchoolModel(
    id: 'sch_1',
    name: 'Lycée National Léon Mba',
    city: 'Libreville',
    levels: [
      ClassLevelModel(id: 'c_6e', label: '6e', cycle: 'Collège'),
      ClassLevelModel(id: 'c_5e', label: '5e', cycle: 'Collège'),
      ClassLevelModel(id: 'c_4e', label: '4e', cycle: 'Collège'),
      ClassLevelModel(id: 'c_3e', label: '3e', cycle: 'Collège'),
      ClassLevelModel(id: 'l_2nde', label: '2nde', cycle: 'Lycée'),
      ClassLevelModel(id: 'l_1ere', label: '1ère', cycle: 'Lycée'),
      ClassLevelModel(id: 'l_tle_a', label: 'Terminale A', cycle: 'Lycée'),
      ClassLevelModel(id: 'l_tle_c', label: 'Terminale C', cycle: 'Lycée'),
    ],
  ),
  SchoolModel(
    id: 'sch_2',
    name: 'Lycée Bessieux',
    city: 'Libreville',
    levels: [
      ClassLevelModel(id: 'c_6e', label: '6e', cycle: 'Collège'),
      ClassLevelModel(id: 'c_5e', label: '5e', cycle: 'Collège'),
      ClassLevelModel(id: 'c_4e', label: '4e', cycle: 'Collège'),
      ClassLevelModel(id: 'c_3e', label: '3e', cycle: 'Collège'),
      ClassLevelModel(id: 'l_2nde', label: '2nde', cycle: 'Lycée'),
      ClassLevelModel(id: 'l_1ere', label: '1ère', cycle: 'Lycée'),
      ClassLevelModel(id: 'l_tle_a', label: 'Terminale A', cycle: 'Lycée'),
      ClassLevelModel(id: 'l_tle_c', label: 'Terminale C', cycle: 'Lycée'),
    ],
  ),
  SchoolModel(
    id: 'sch_3',
    name: "CES d'Akebe",
    city: 'Libreville',
    levels: [
      ClassLevelModel(id: 'c_6e_2', label: '6e', cycle: 'Collège'),
      ClassLevelModel(id: 'c_5e_2', label: '5e', cycle: 'Collège'),
      ClassLevelModel(id: 'c_4e_2', label: '4e', cycle: 'Collège'),
      ClassLevelModel(id: 'c_3e_2', label: '3e', cycle: 'Collège'),
    ],
  ),
];
