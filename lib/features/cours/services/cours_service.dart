import '../models/course_model.dart';
import '../models/lesson_model.dart';

class CoursService {
  Future<List<CourseModel>> fetchCours({String? search}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    var list = _mockCours;
    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      list = list
          .where((c) =>
              c.title.toLowerCase().contains(q) ||
              c.subject.toLowerCase().contains(q) ||
              c.level.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  Future<CourseModel> fetchCourseDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCours.firstWhere((c) => c.id == id);
  }

  Future<LessonModel> fetchLesson(String courseId, String lessonId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final course = _mockCours.firstWhere((c) => c.id == courseId);
    return course.allLessons.firstWhere((l) => l.id == lessonId);
  }

  static final _mockCours = <CourseModel>[
    CourseModel(
      id: '1',
      title: 'Algèbre — Équations du 1er degré',
      description:
          'Maîtrisez la résolution des équations simples et leurs applications concrètes dans la vie quotidienne. Un cours structuré avec exercices progressifs.',
      thumbnailUrl: 'https://picsum.photos/seed/math1/400/225',
      duration: '2h30',
      lessonCount: 8,
      subject: 'Mathématiques',
      level: 'CM2',
      sections: [
        CourseSectionModel(
          id: 's1',
          title: 'Introduction aux équations',
          order: 1,
          lessons: [
            LessonModel(
              id: 'l1',
              title: "Qu'est-ce qu'une équation ?",
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '12min',
              order: 1,
            ),
            LessonModel(
              id: 'l2',
              title: 'Membres et termes d\'une équation',
              type: 'text',
              duration: '8min',
              order: 2,
              content: '''📌 Définition

Une équation est une égalité entre deux expressions contenant une inconnue (souvent notée x).

Exemple : 2x + 3 = 7

🔹 Le membre gauche est : 2x + 3
🔹 Le membre droit est : 7
🔹 L'inconnue est : x

📝 Vocabulaire essentiel

• Terme : chaque partie séparée par + ou −
• Coefficient : le nombre qui multiplie l'inconnue (ici 2)
• Constante : un nombre seul (ici 3 et 7)

💡 À retenir
Une solution est une valeur de x qui rend l'égalité vraie. Dans l'exemple ci-dessus, x = 2 est la solution car 2×2 + 3 = 7.''',
            ),
            LessonModel(
              id: 'l3',
              title: 'Types d\'équations — exemples',
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '15min',
              order: 3,
            ),
          ],
        ),
        CourseSectionModel(
          id: 's2',
          title: 'Résolution pas à pas',
          order: 2,
          lessons: [
            LessonModel(
              id: 'l4',
              title: 'Méthode de résolution',
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '18min',
              order: 1,
            ),
            LessonModel(
              id: 'l5',
              title: 'Résolution : exemples guidés',
              type: 'text',
              duration: '20min',
              order: 2,
              content: '''✏️ Exemple 1 : Résoudre 3x − 5 = 10

Étape 1 — Isoler le terme avec x
3x = 10 + 5
3x = 15

Étape 2 — Diviser par le coefficient
x = 15 ÷ 3
✅ x = 5

Vérification : 3×5 − 5 = 15 − 5 = 10 ✓

---

✏️ Exemple 2 : Résoudre 2x + 8 = x − 1

Étape 1 — Regrouper les x d'un côté
2x − x = −1 − 8
x = −9

✅ Solution : x = −9

💡 Règle d'or
Toute opération effectuée d'un côté de l'égalité doit être effectuée de l'autre côté.''',
            ),
          ],
        ),
        CourseSectionModel(
          id: 's3',
          title: 'Applications et problèmes',
          order: 3,
          lessons: [
            LessonModel(
              id: 'l6',
              title: 'Problèmes concrets avec équations',
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '22min',
              order: 1,
            ),
            LessonModel(
              id: 'l7',
              title: 'Inéquations — introduction',
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '16min',
              order: 2,
            ),
            LessonModel(
              id: 'l8',
              title: 'Bilan et révisions',
              type: 'text',
              duration: '15min',
              order: 3,
              content: '''📋 Récapitulatif du cours

✅ Ce que vous avez appris :
1. Identifier les membres et termes d'une équation
2. Isoler l'inconnue en effectuant les mêmes opérations des deux côtés
3. Vérifier votre solution

🎯 Méthode en 3 étapes :
1. Regrouper les termes en x d'un côté
2. Regrouper les constantes de l'autre
3. Diviser par le coefficient de x

📌 Formule générale :
ax + b = c  →  x = (c − b) / a

Bonne chance pour vos exercices !''',
            ),
          ],
        ),
      ],
    ),
    CourseModel(
      id: '2',
      title: 'Conjugaison — Verbes du 3ᵉ groupe',
      description:
          'Apprenez les temps du passé, présent et futur pour les verbes irréguliers du 3ème groupe. Vidéo complète avec tableaux de conjugaison.',
      thumbnailUrl: 'https://picsum.photos/seed/fr2/400/225',
      duration: '1h45',
      lessonCount: 1,
      subject: 'Français',
      level: 'CE2',
      isSingleVideo: true,
      singleLesson: LessonModel(
        id: 'lsv1',
        title: 'Conjugaison complète — Verbes du 3ème groupe',
        type: 'video',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        duration: '1h45',
        order: 1,
      ),
    ),
    CourseModel(
      id: '3',
      title: 'Les états de la matière',
      description:
          'Découvrez les trois états de la matière, les changements d\'état et leurs applications dans la nature et l\'industrie.',
      thumbnailUrl: 'https://picsum.photos/seed/sci3/400/225',
      duration: '1h20',
      lessonCount: 5,
      subject: 'Sciences',
      level: 'CM1',
      sections: [
        CourseSectionModel(
          id: 'sc1',
          title: 'Les trois états',
          order: 1,
          lessons: [
            LessonModel(
              id: 'sl1',
              title: 'Solide, liquide, gazeux',
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '18min',
              order: 1,
            ),
            LessonModel(
              id: 'sl2',
              title: 'Propriétés de chaque état',
              type: 'text',
              duration: '12min',
              order: 2,
              content: '''🧊 État solide
• Forme fixe
• Volume fixe
• Molécules très rapprochées et organisées
Exemple : glace, bois, métal

💧 État liquide
• Forme variable (prend la forme du récipient)
• Volume fixe
• Molécules proches mais désordonnées
Exemple : eau, huile, jus

💨 État gazeux
• Forme variable
• Volume variable (occupe tout l'espace disponible)
• Molécules très éloignées et en mouvement rapide
Exemple : vapeur d'eau, air, oxygène''',
            ),
            LessonModel(
              id: 'sl3',
              title: 'Expériences simples à la maison',
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '20min',
              order: 3,
            ),
          ],
        ),
        CourseSectionModel(
          id: 'sc2',
          title: 'Les changements d\'état',
          order: 2,
          lessons: [
            LessonModel(
              id: 'sl4',
              title: 'Fusion, vaporisation, solidification',
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '15min',
              order: 1,
            ),
            LessonModel(
              id: 'sl5',
              title: 'Le cycle de l\'eau dans la nature',
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '15min',
              order: 2,
            ),
          ],
        ),
      ],
    ),
    CourseModel(
      id: '4',
      title: 'Histoire du Gabon — Origines et civilisations',
      description:
          'Retrace l\'histoire du Gabon depuis les premières populations jusqu\'à l\'indépendance. Culture, royaumes et figures emblématiques.',
      thumbnailUrl: 'https://picsum.photos/seed/hist4/400/225',
      duration: '2h00',
      lessonCount: 6,
      subject: 'Histoire',
      level: '6ème',
      sections: [
        CourseSectionModel(
          id: 'hc1',
          title: 'Les premières populations',
          order: 1,
          lessons: [
            LessonModel(
              id: 'hl1',
              title: 'Les Pygmées — premiers habitants',
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '20min',
              order: 1,
            ),
            LessonModel(
              id: 'hl2',
              title: 'Les grandes migrations Bantoues',
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '18min',
              order: 2,
            ),
            LessonModel(
              id: 'hl3',
              title: 'Les royaumes précoloniaux',
              type: 'text',
              duration: '15min',
              order: 3,
              content: '''👑 Les royaumes précoloniaux du Gabon

🔹 Le royaume Myénè (Mpongwè)
Installé sur l'estuaire du Gabon, ce peuple de pêcheurs et commerçants contrôlait les échanges avec les navigateurs européens dès le XVᵉ siècle.

🔹 Le royaume Fang
Les Fang, venus du nord, s'installèrent au XIXᵉ siècle dans le nord et le centre du Gabon. Réputés pour leur organisation sociale et leur art (masques Ngil).

🔹 Le royaume Nzabi et Kota
Au sud-est, ces royaumes exploitaient les richesses forestières et minières.

📌 À retenir
Avant la colonisation, le Gabon était composé d'une dizaine de peuples distincts avec leurs propres langues, cultures et organisations politiques.''',
            ),
          ],
        ),
        CourseSectionModel(
          id: 'hc2',
          title: 'Colonisation et indépendance',
          order: 2,
          lessons: [
            LessonModel(
              id: 'hl4',
              title: 'L\'arrivée des Français au Gabon',
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '22min',
              order: 1,
            ),
            LessonModel(
              id: 'hl5',
              title: 'Léon Mba et l\'indépendance (1960)',
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '20min',
              order: 2,
            ),
            LessonModel(
              id: 'hl6',
              title: 'Le Gabon moderne — synthèse',
              type: 'text',
              duration: '15min',
              order: 3,
              content: '''🇬🇦 Le Gabon indépendant

📅 17 août 1960 — Proclamation de l'indépendance du Gabon
Premier président : Léon Mba

🔹 Ressources naturelles
Le pétrole, découvert dans les années 1970, devient le pilier économique du pays.

🔹 Géographie
• Superficie : 267 667 km²
• Population : environ 2,3 millions d'habitants
• Capitale : Libreville
• 80% du territoire est couvert de forêt tropicale

🔹 Culture et diversité
Le Gabon compte plus de 40 groupes ethniques avec des langues, traditions et arts distincts. Cette diversité fait la richesse culturelle du pays.

✅ À retenir pour l'examen
- Date d'indépendance : 17 août 1960
- Premier président : Léon Mba
- Capitale : Libreville''',
            ),
          ],
        ),
      ],
    ),
    CourseModel(
      id: '5',
      title: 'Géographie de l\'Afrique Centrale',
      description:
          'Étudiez les reliefs, fleuves, pays et grandes villes de l\'Afrique Centrale. Cartes interactives et données essentielles.',
      thumbnailUrl: 'https://picsum.photos/seed/geo5/400/225',
      duration: '1h10',
      lessonCount: 3,
      subject: 'Géographie',
      level: '5ème',
      sections: [
        CourseSectionModel(
          id: 'gc1',
          title: 'Géographie physique',
          order: 1,
          lessons: [
            LessonModel(
              id: 'gl1',
              title: 'Les reliefs et fleuves majeurs',
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '25min',
              order: 1,
            ),
            LessonModel(
              id: 'gl2',
              title: 'Climat et végétation',
              type: 'text',
              duration: '20min',
              order: 2,
              content: """🌿 Climat de l'Afrique Centrale

L'Afrique Centrale est dominée par un climat équatorial chaud et humide avec deux saisons sèches et deux saisons des pluies par an.

🌡️ Températures moyennes : 25-28°C toute l'année
💧 Précipitations : 1500 à 2000 mm/an

🌲 Végétation
• Forêt dense équatoriale : 2ᵉ plus grande du monde après l'Amazonie
• Savanes au nord et au sud de la forêt
• Mangroves sur les côtes atlantiques

🦁 Faune exceptionnelle
• Gorilles, éléphants de forêt, chimpanzés
• Panthères, buffles, hippopotames
• Oiseaux tropicaux (plus de 1000 espèces)""",
            ),
            LessonModel(
              id: 'gl3',
              title: "Les pays d'Afrique Centrale",
              type: 'video',
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              duration: '25min',
              order: 3,
            ),
          ],
        ),
      ],
    ),
  ];
}
