import '../models/exercice_model.dart';
import '../models/question_model.dart';

class ExercicesService {
  Future<List<ExerciceModel>> fetchExercices({String? search}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    var list = _mockExercices;
    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      list = list
          .where((e) =>
              e.title.toLowerCase().contains(q) ||
              e.subject.toLowerCase().contains(q) ||
              e.level.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  Future<ExerciceModel> fetchExerciceDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockExercices.firstWhere((e) => e.id == id);
  }

  Future<Map<String, dynamic>> verifierReponse({
    required String exerciceId,
    required String questionId,
    required String reponse,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final exercice = _mockExercices.firstWhere((e) => e.id == exerciceId);
    final question = exercice.allQuestions.firstWhere((q) => q.id == questionId);
    final correct =
        reponse.toLowerCase().trim() == question.correctAnswer.toLowerCase().trim();
    return {
      'correct': correct,
      'correct_answer': question.correctAnswer,
      'explanation': question.explanation,
    };
  }

  static final _mockExercices = <ExerciceModel>[
    ExerciceModel(
      id: '1',
      title: 'Fractions et Nombres Décimaux',
      subject: 'Mathématiques',
      level: 'CM1',
      difficulty: 'moyen',
      questionCount: 8,
      description:
          'Testez vos connaissances sur les fractions simples, les fractions équivalentes et la conversion en décimaux.',
      sections: [
        ExerciceSectionModel(
          id: 'es1',
          title: 'Les fractions simples',
          questions: [
            QuestionModel(
              id: 'q1',
              statement: 'Quelle fraction est équivalente à 1/2 ?',
              type: 'qcm',
              options: ['1/3', '2/4', '3/5', '4/9'],
              correctAnswer: '2/4',
              explanation:
                  '1/2 = 2/4 car on multiplie le numérateur et le dénominateur par 2. Les fractions équivalentes ont le même rapport numérateur/dénominateur.',
            ),
            QuestionModel(
              id: 'q2',
              statement: 'Simplifiez la fraction 6/9.',
              type: 'qcm',
              options: ['1/2', '2/3', '3/4', '4/6'],
              correctAnswer: '2/3',
              explanation:
                  '6/9 : on divise numérateur et dénominateur par leur PGCD qui est 3. 6÷3=2 et 9÷3=3, donc 6/9 = 2/3.',
            ),
            QuestionModel(
              id: 'q3',
              statement:
                  'Marie a mangé 3 parts sur 8 d\'une pizza. Quelle fraction de la pizza reste-t-il ?',
              type: 'qcm',
              options: ['3/8', '5/8', '4/8', '6/8'],
              correctAnswer: '5/8',
              explanation:
                  'Il y avait 8/8 (la pizza entière). Marie a mangé 3/8. Reste : 8/8 - 3/8 = 5/8.',
            ),
            QuestionModel(
              id: 'q4',
              statement: 'Quel est le résultat de 1/4 + 2/4 ?',
              type: 'texte_libre',
              correctAnswer: '3/4',
              explanation:
                  'Quand les dénominateurs sont identiques, on additionne uniquement les numérateurs : 1/4 + 2/4 = (1+2)/4 = 3/4.',
            ),
          ],
        ),
        ExerciceSectionModel(
          id: 'es2',
          title: 'Conversions décimales',
          questions: [
            QuestionModel(
              id: 'q5',
              statement: 'Convertissez 3/4 en nombre décimal.',
              type: 'qcm',
              options: ['0,25', '0,50', '0,75', '0,80'],
              correctAnswer: '0,75',
              explanation:
                  '3/4 signifie 3 divisé par 4. 3 ÷ 4 = 0,75. On peut vérifier : 0,75 × 4 = 3.',
            ),
            QuestionModel(
              id: 'q6',
              statement: 'Quel nombre décimal correspond à 1/5 ?',
              type: 'texte_libre',
              correctAnswer: '0,2',
              explanation:
                  '1/5 = 1 ÷ 5 = 0,2. Autre méthode : 1/5 = 2/10 = 0,2.',
            ),
            QuestionModel(
              id: 'q7',
              statement: 'Ordonnez du plus petit au plus grand : 3/4, 1/2, 2/3.',
              type: 'qcm',
              options: [
                '1/2 < 2/3 < 3/4',
                '2/3 < 1/2 < 3/4',
                '1/2 < 3/4 < 2/3',
                '3/4 < 2/3 < 1/2'
              ],
              correctAnswer: '1/2 < 2/3 < 3/4',
              explanation:
                  'En décimaux : 1/2=0,5 ; 2/3≈0,67 ; 3/4=0,75. Donc 0,5 < 0,67 < 0,75, soit 1/2 < 2/3 < 3/4.',
            ),
            QuestionModel(
              id: 'q8',
              statement:
                  'Un élève a réussi 15 questions sur 20. Quelle fraction représente ses bonnes réponses ?',
              type: 'texte_libre',
              correctAnswer: '3/4',
              explanation:
                  '15/20 = 3/4 (on divise par 5). Cela correspond aussi à 75% de réussite.',
            ),
          ],
        ),
      ],
    ),
    ExerciceModel(
      id: '2',
      title: 'Conjugaison — Temps du passé',
      subject: 'Français',
      level: 'CE2',
      difficulty: 'facile',
      questionCount: 6,
      description:
          'Exercices sur le passé composé, l\'imparfait et le passé simple. Identifiez et conjuguez correctement les verbes.',
      sections: [
        ExerciceSectionModel(
          id: 'fe1',
          title: 'Identification des temps',
          questions: [
            QuestionModel(
              id: 'fq1',
              statement:
                  'Dans la phrase "Il jouait au football", quel est le temps du verbe ?',
              type: 'qcm',
              options: [
                'Passé composé',
                'Imparfait',
                'Passé simple',
                'Présent'
              ],
              correctAnswer: 'Imparfait',
              explanation:
                  '"Jouait" est à l\'imparfait (radical "jou-" + terminaison "-ait"). L\'imparfait exprime une action passée habituelle ou en cours dans le passé.',
            ),
            QuestionModel(
              id: 'fq2',
              statement:
                  'Conjuguez le verbe "aller" au passé composé, à la 1ère personne du singulier.',
              type: 'texte_libre',
              correctAnswer: 'je suis allé',
              explanation:
                  '"Aller" se conjugue avec l\'auxiliaire ÊTRE au passé composé : je suis allé(e). Attention : avec ÊTRE, le participe passé s\'accorde avec le sujet.',
            ),
            QuestionModel(
              id: 'fq3',
              statement:
                  'Choisissez la bonne conjugaison : "Hier, nous ___ (manger) au restaurant."',
              type: 'qcm',
              options: [
                'mangions',
                'avons mangé',
                'mangeâmes',
                'mangeons'
              ],
              correctAnswer: 'avons mangé',
              explanation:
                  '"Hier" indique une action précise et terminée → passé composé. Nous avons mangé = auxiliaire AVOIR (avons) + participe passé (mangé).',
            ),
          ],
        ),
        ExerciceSectionModel(
          id: 'fe2',
          title: 'Conjugaison pratique',
          questions: [
            QuestionModel(
              id: 'fq4',
              statement:
                  'Mettez à l\'imparfait : "Les enfants (chanter) dans la cour."',
              type: 'texte_libre',
              correctAnswer: 'chantaient',
              explanation:
                  'Imparfait de "chanter" à la 3ème personne du pluriel : ils/elles chantaient (radical "chant-" + terminaison "-aient").',
            ),
            QuestionModel(
              id: 'fq5',
              statement:
                  'Quel auxiliaire utilise-t-on avec le verbe "partir" au passé composé ?',
              type: 'qcm',
              options: ['AVOIR', 'ÊTRE', 'LES DEUX', 'AUCUN'],
              correctAnswer: 'ÊTRE',
              explanation:
                  '"Partir" est un verbe de mouvement qui se conjugue avec l\'auxiliaire ÊTRE : je suis parti(e), tu es parti(e), il/elle est parti(e)...',
            ),
            QuestionModel(
              id: 'fq6',
              statement:
                  'Transformez au passé composé : "Il finit ses devoirs."',
              type: 'texte_libre',
              correctAnswer: 'il a fini ses devoirs',
              explanation:
                  '"Finir" → auxiliaire AVOIR + participe passé "fini". Il a fini ses devoirs.',
            ),
          ],
        ),
      ],
    ),
    ExerciceModel(
      id: '3',
      title: 'Les Plantes et la Photosynthèse',
      subject: 'Sciences',
      level: 'CM2',
      difficulty: 'moyen',
      questionCount: 5,
      description:
          'Comprenez comment les plantes fabriquent leur nourriture grâce à la lumière. Questions sur la photosynthèse et le rôle des feuilles.',
      sections: [
        ExerciceSectionModel(
          id: 'se1',
          title: 'La photosynthèse',
          questions: [
            QuestionModel(
              id: 'sq1',
              statement:
                  'Quels sont les deux éléments indispensables à la photosynthèse ?',
              type: 'qcm',
              options: [
                'Eau et lumière',
                'Azote et oxygène',
                'Sucre et CO₂',
                'Chaleur et vent'
              ],
              correctAnswer: 'Eau et lumière',
              explanation:
                  'La photosynthèse nécessite : l\'eau (H₂O) absorbée par les racines, la lumière (énergie solaire) captée par la chlorophylle, et le CO₂ de l\'air. Elle produit du glucose et libère de l\'oxygène.',
            ),
            QuestionModel(
              id: 'sq2',
              statement:
                  'Quelle substance donne la couleur verte aux feuilles et capte la lumière ?',
              type: 'texte_libre',
              correctAnswer: 'la chlorophylle',
              explanation:
                  'La chlorophylle est le pigment vert contenu dans les chloroplastes des cellules végétales. Elle absorbe principalement la lumière rouge et bleue pour alimenter la photosynthèse.',
            ),
            QuestionModel(
              id: 'sq3',
              statement:
                  'Quel gaz les plantes rejettent-elles lors de la photosynthèse ?',
              type: 'qcm',
              options: ['CO₂', 'Azote', 'Oxygène', 'Vapeur d\'eau'],
              correctAnswer: 'Oxygène',
              explanation:
                  'La photosynthèse produit du glucose (sucre) et libère de l\'oxygène (O₂) dans l\'atmosphère. C\'est pour cela que les plantes sont essentielles à la vie sur Terre.',
            ),
            QuestionModel(
              id: 'sq4',
              statement:
                  'Pourquoi les feuilles tombent-elles en automne pour certains arbres ?',
              type: 'qcm',
              options: [
                'Manque d\'eau',
                'Moins de lumière et froid',
                'Trop de CO₂',
                'Les racines meurent'
              ],
              correctAnswer: 'Moins de lumière et froid',
              explanation:
                  'En automne, les jours raccourcissent et les températures baissent. Les arbres à feuilles caduques stoppent la photosynthèse, la chlorophylle se dégrade (les feuilles changent de couleur) et tombent pour économiser l\'énergie.',
            ),
            QuestionModel(
              id: 'sq5',
              statement:
                  'Complétez : La photosynthèse transforme l\'énergie ___ en énergie chimique.',
              type: 'texte_libre',
              correctAnswer: 'lumineuse',
              explanation:
                  'La photosynthèse convertit l\'énergie lumineuse (soleil) en énergie chimique stockée sous forme de glucose dans les cellules végétales.',
            ),
          ],
        ),
      ],
    ),
    ExerciceModel(
      id: '4',
      title: 'Équations — Niveau avancé',
      subject: 'Mathématiques',
      level: 'CM2',
      difficulty: 'difficile',
      questionCount: 8,
      description:
          'Résolution d\'équations à une et deux inconnues. Problèmes contextualisés et vérification des solutions.',
      sections: [
        ExerciceSectionModel(
          id: 'ae1',
          title: 'Équations simples',
          questions: [
            QuestionModel(
              id: 'aq1',
              statement: 'Résolvez : 4x − 8 = 0',
              type: 'texte_libre',
              correctAnswer: 'x = 2',
              explanation:
                  '4x = 8 → x = 8/4 = 2. Vérification : 4×2 − 8 = 8 − 8 = 0 ✓',
            ),
            QuestionModel(
              id: 'aq2',
              statement: 'Quelle est la solution de 3x + 6 = 15 ?',
              type: 'qcm',
              options: ['x = 2', 'x = 3', 'x = 5', 'x = 7'],
              correctAnswer: 'x = 3',
              explanation:
                  '3x = 15 − 6 = 9 → x = 9/3 = 3. Vérification : 3×3 + 6 = 9 + 6 = 15 ✓',
            ),
            QuestionModel(
              id: 'aq3',
              statement: 'Résolvez : 2x − 3 = x + 5',
              type: 'texte_libre',
              correctAnswer: 'x = 8',
              explanation:
                  '2x − x = 5 + 3 → x = 8. Vérification : 2×8−3 = 13 et 8+5 = 13 ✓',
            ),
            QuestionModel(
              id: 'aq4',
              statement:
                  'Un rectangle a un périmètre de 28 cm. Sa longueur est le double de sa largeur. Quelle est sa largeur ?',
              type: 'qcm',
              options: ['4 cm', '5 cm', 'cm', '7 cm'],
              correctAnswer: 'cm',
              explanation:
                  'Soit l la largeur. Longueur = 2l. Périmètre = 2(l + 2l) = 6l = 28 → l = 28/6 ≈ 4,67 cm. En arrondissant : environ 5 cm avec longueur 10 cm → 2(5+10)=30≠28. Réponse exacte : l = 14/3 cm.',
            ),
          ],
        ),
        ExerciceSectionModel(
          id: 'ae2',
          title: 'Problèmes contextualisés',
          questions: [
            QuestionModel(
              id: 'aq5',
              statement:
                  'Jean a le double de l\'âge de Paul. Dans 5 ans, leur âge total sera de 37 ans. Quel est l\'âge actuel de Jean ?',
              type: 'qcm',
              options: ['12 ans', '16 ans', '18 ans', '20 ans'],
              correctAnswer: '18 ans',
              explanation:
                  'Soit p l\'âge de Paul, Jean a 2p. Dans 5 ans : (p+5) + (2p+5) = 37 → 3p + 10 = 37 → 3p = 27 → p = 9. Jean a 2×9 = 18 ans.',
            ),
            QuestionModel(
              id: 'aq6',
              statement:
                  'Une marchandise coûte x FCFA. Après une remise de 1000 FCFA, elle coûte 4500 FCFA. Quelle est la valeur de x ?',
              type: 'texte_libre',
              correctAnswer: 'x = 5500',
              explanation:
                  'x − 1000 = 4500 → x = 4500 + 1000 = 5500 FCFA.',
            ),
            QuestionModel(
              id: 'aq7',
              statement: 'Résolvez : 5(x − 2) = 15',
              type: 'texte_libre',
              correctAnswer: 'x = 5',
              explanation:
                  '5x − 10 = 15 → 5x = 25 → x = 5. Vérification : 5(5−2) = 5×3 = 15 ✓',
            ),
            QuestionModel(
              id: 'aq8',
              statement:
                  'Si 2x + y = 10 et x = 3, quelle est la valeur de y ?',
              type: 'qcm',
              options: ['y = 2', 'y = 4', 'y = 6', 'y = 8'],
              correctAnswer: 'y = 4',
              explanation:
                  'On substitue x = 3 : 2(3) + y = 10 → 6 + y = 10 → y = 4.',
            ),
          ],
        ),
      ],
    ),
  ];
}
