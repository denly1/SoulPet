import 'package:soulpet/core/storage/local_database.dart';
import 'package:soulpet/data/models/pet_model.dart';

class PetLocalDatasource {
  final LocalDatabase _db;
  const PetLocalDatasource(this._db);

  static const String _table = 'pets';

  Future<PetModel> insertPet(PetModel pet) async {
    final existing = await getPetByUserId(pet.userId);
    if (existing != null) {
      await _db.db.update(
        _table,
        pet.toMap(),
        where: 'user_id = ?',
        whereArgs: [pet.userId],
      );
    } else {
      await _db.db.insert(_table, pet.toMap());
    }
    return pet;
  }

  Future<PetModel?> getPetByUserId(String userId) async {
    final result = await _db.db.query(
      _table,
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return PetModel.fromMap(result.first);
  }

  Future<PetModel?> getPetById(String petId) async {
    final result = await _db.db.query(
      _table,
      where: 'id = ?',
      whereArgs: [petId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return PetModel.fromMap(result.first);
  }

  Future<PetModel> updatePet(PetModel pet) async {
    await _db.db.update(
      _table,
      pet.toMap(),
      where: 'id = ?',
      whereArgs: [pet.id],
    );
    return pet;
  }

  Future<void> deletePet(String petId) async {
    await _db.db.delete(
      _table,
      where: 'id = ?',
      whereArgs: [petId],
    );
  }
}
