import 'package:meta/meta.dart';
import '../entities/entities.dart';
import 'level.dart';
import 'sex.dart';

@immutable
class Player {
  final String? id;
  final String nickname;
  final Level level;
  final bool available;
  final Sex sex;

  Player({
    this.id,
    required this.nickname,
    this.level = Level.beginner,
    this.sex = Sex.man,
    this.available = true,
  });

  Player copyWith(
      {bool? available, String? id, Level? level, Sex? sex, String? nickname}) {
    return Player(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      level: level ?? this.level,
      sex: sex ?? this.sex,
      available: available ?? this.available,
    );
  }

  PlayerEntity toEntity() {
    return PlayerEntity(id, nickname, level, sex, available);
  }

  static Player fromEntity(PlayerEntity entity) {
    return Player(
      id: entity.id,
      nickname: entity.nickname,
      level: entity.level,
      sex: entity.sex,
      available: entity.available,
    );
  }

  int compareTo(String a, String b) {
    var lettersRusUk = [
      "а",
      "б",
      "в",
      "г",
      "ґ",
      "д",
      "е",
      "є",
      "ж",
      "з",
      "и",
      "і",
      "ї",
      "й",
      "к",
      "л",
      "м",
      "н",
      "о",
      "п",
      "р",
      "с",
      "т",
      "у",
      "ф",
      "х",
      "ц",
      "ч",
      "ш",
      "щ",
      "ь",
      "ю",
      "я"
    ];
    a = a.toLowerCase();
    b = b.toLowerCase();
    int minLength = b.length < a.length ? b.length : a.length;
    for (int i = 0; i < minLength; ++i) {
      if (!lettersRusUk.contains(a[i]) || !lettersRusUk.contains(b[i])) {
        if (a[i].compareTo(b[i]) == 0) continue;
        return a[i].compareTo(b[i]);
      }
      if (lettersRusUk.indexOf(a[i]) > lettersRusUk.indexOf(b[i]))
        return 1;
      else if (lettersRusUk.indexOf(a[i]) < lettersRusUk.indexOf(b[i]))
        return -1;
    }
    if (a.length < b.length)
      return -1;
    else if (a.length > b.length) return 1;
    return 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nickname == other.nickname &&
          level == other.level &&
          sex == other.sex &&
          available == other.available;

  @override
  int get hashCode =>
      id.hashCode ^ nickname.hashCode ^ level.hashCode ^ sex.hashCode ^ available.hashCode;

  @override
  String toString() {
    return 'Player { id: $id, nickname: $nickname, level: $level, sex: $sex, available: $available }';
  }
}
