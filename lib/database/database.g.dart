// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LevelContentTable extends LevelContent
    with TableInfo<$LevelContentTable, LevelContentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelContentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _circularMeta = const VerificationMeta(
    'circular',
  );
  @override
  late final GeneratedColumn<bool> circular = GeneratedColumn<bool>(
    'circular',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("circular" IN (0, 1))',
    ),
  );
  static const VerificationMeta _depthMeta = const VerificationMeta('depth');
  @override
  late final GeneratedColumn<double> depth = GeneratedColumn<double>(
    'depth',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<String> points = GeneratedColumn<String>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, circular, depth, points];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'level_content';
  @override
  VerificationContext validateIntegrity(
    Insertable<LevelContentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('circular')) {
      context.handle(
        _circularMeta,
        circular.isAcceptableOrUnknown(data['circular']!, _circularMeta),
      );
    } else if (isInserting) {
      context.missing(_circularMeta);
    }
    if (data.containsKey('depth')) {
      context.handle(
        _depthMeta,
        depth.isAcceptableOrUnknown(data['depth']!, _depthMeta),
      );
    } else if (isInserting) {
      context.missing(_depthMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LevelContentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelContentData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      circular:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}circular'],
          )!,
      depth:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}depth'],
          )!,
      points:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}points'],
          )!,
    );
  }

  @override
  $LevelContentTable createAlias(String alias) {
    return $LevelContentTable(attachedDatabase, alias);
  }
}

class LevelContentData extends DataClass
    implements Insertable<LevelContentData> {
  final int id;
  final bool circular;
  final double depth;
  final String points;
  const LevelContentData({
    required this.id,
    required this.circular,
    required this.depth,
    required this.points,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['circular'] = Variable<bool>(circular);
    map['depth'] = Variable<double>(depth);
    map['points'] = Variable<String>(points);
    return map;
  }

  LevelContentCompanion toCompanion(bool nullToAbsent) {
    return LevelContentCompanion(
      id: Value(id),
      circular: Value(circular),
      depth: Value(depth),
      points: Value(points),
    );
  }

  factory LevelContentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelContentData(
      id: serializer.fromJson<int>(json['id']),
      circular: serializer.fromJson<bool>(json['circular']),
      depth: serializer.fromJson<double>(json['depth']),
      points: serializer.fromJson<String>(json['points']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'circular': serializer.toJson<bool>(circular),
      'depth': serializer.toJson<double>(depth),
      'points': serializer.toJson<String>(points),
    };
  }

  LevelContentData copyWith({
    int? id,
    bool? circular,
    double? depth,
    String? points,
  }) => LevelContentData(
    id: id ?? this.id,
    circular: circular ?? this.circular,
    depth: depth ?? this.depth,
    points: points ?? this.points,
  );
  LevelContentData copyWithCompanion(LevelContentCompanion data) {
    return LevelContentData(
      id: data.id.present ? data.id.value : this.id,
      circular: data.circular.present ? data.circular.value : this.circular,
      depth: data.depth.present ? data.depth.value : this.depth,
      points: data.points.present ? data.points.value : this.points,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LevelContentData(')
          ..write('id: $id, ')
          ..write('circular: $circular, ')
          ..write('depth: $depth, ')
          ..write('points: $points')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, circular, depth, points);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelContentData &&
          other.id == this.id &&
          other.circular == this.circular &&
          other.depth == this.depth &&
          other.points == this.points);
}

class LevelContentCompanion extends UpdateCompanion<LevelContentData> {
  final Value<int> id;
  final Value<bool> circular;
  final Value<double> depth;
  final Value<String> points;
  const LevelContentCompanion({
    this.id = const Value.absent(),
    this.circular = const Value.absent(),
    this.depth = const Value.absent(),
    this.points = const Value.absent(),
  });
  LevelContentCompanion.insert({
    this.id = const Value.absent(),
    required bool circular,
    required double depth,
    required String points,
  }) : circular = Value(circular),
       depth = Value(depth),
       points = Value(points);
  static Insertable<LevelContentData> custom({
    Expression<int>? id,
    Expression<bool>? circular,
    Expression<double>? depth,
    Expression<String>? points,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (circular != null) 'circular': circular,
      if (depth != null) 'depth': depth,
      if (points != null) 'points': points,
    });
  }

  LevelContentCompanion copyWith({
    Value<int>? id,
    Value<bool>? circular,
    Value<double>? depth,
    Value<String>? points,
  }) {
    return LevelContentCompanion(
      id: id ?? this.id,
      circular: circular ?? this.circular,
      depth: depth ?? this.depth,
      points: points ?? this.points,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (circular.present) {
      map['circular'] = Variable<bool>(circular.value);
    }
    if (depth.present) {
      map['depth'] = Variable<double>(depth.value);
    }
    if (points.present) {
      map['points'] = Variable<String>(points.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelContentCompanion(')
          ..write('id: $id, ')
          ..write('circular: $circular, ')
          ..write('depth: $depth, ')
          ..write('points: $points')
          ..write(')'))
        .toString();
  }
}

class $BasicLevelInfoTable extends BasicLevelInfo
    with TableInfo<$BasicLevelInfoTable, BasicLevelInfoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BasicLevelInfoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activatedMeta = const VerificationMeta(
    'activated',
  );
  @override
  late final GeneratedColumn<bool> activated = GeneratedColumn<bool>(
    'activated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activated" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<int> content = GeneratedColumn<int>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES level_content (id) ON UPDATE NO ACTION ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, activated, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'basic_level_info';
  @override
  VerificationContext validateIntegrity(
    Insertable<BasicLevelInfoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('activated')) {
      context.handle(
        _activatedMeta,
        activated.isAcceptableOrUnknown(data['activated']!, _activatedMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BasicLevelInfoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BasicLevelInfoData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      activated:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}activated'],
          )!,
      content:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}content'],
          )!,
    );
  }

  @override
  $BasicLevelInfoTable createAlias(String alias) {
    return $BasicLevelInfoTable(attachedDatabase, alias);
  }
}

class BasicLevelInfoData extends DataClass
    implements Insertable<BasicLevelInfoData> {
  final int id;
  final String name;
  final bool activated;
  final int content;
  const BasicLevelInfoData({
    required this.id,
    required this.name,
    required this.activated,
    required this.content,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['activated'] = Variable<bool>(activated);
    map['content'] = Variable<int>(content);
    return map;
  }

  BasicLevelInfoCompanion toCompanion(bool nullToAbsent) {
    return BasicLevelInfoCompanion(
      id: Value(id),
      name: Value(name),
      activated: Value(activated),
      content: Value(content),
    );
  }

  factory BasicLevelInfoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BasicLevelInfoData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      activated: serializer.fromJson<bool>(json['activated']),
      content: serializer.fromJson<int>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'activated': serializer.toJson<bool>(activated),
      'content': serializer.toJson<int>(content),
    };
  }

  BasicLevelInfoData copyWith({
    int? id,
    String? name,
    bool? activated,
    int? content,
  }) => BasicLevelInfoData(
    id: id ?? this.id,
    name: name ?? this.name,
    activated: activated ?? this.activated,
    content: content ?? this.content,
  );
  BasicLevelInfoData copyWithCompanion(BasicLevelInfoCompanion data) {
    return BasicLevelInfoData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      activated: data.activated.present ? data.activated.value : this.activated,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BasicLevelInfoData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('activated: $activated, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, activated, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BasicLevelInfoData &&
          other.id == this.id &&
          other.name == this.name &&
          other.activated == this.activated &&
          other.content == this.content);
}

class BasicLevelInfoCompanion extends UpdateCompanion<BasicLevelInfoData> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> activated;
  final Value<int> content;
  const BasicLevelInfoCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.activated = const Value.absent(),
    this.content = const Value.absent(),
  });
  BasicLevelInfoCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.activated = const Value.absent(),
    required int content,
  }) : name = Value(name),
       content = Value(content);
  static Insertable<BasicLevelInfoData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? activated,
    Expression<int>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (activated != null) 'activated': activated,
      if (content != null) 'content': content,
    });
  }

  BasicLevelInfoCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? activated,
    Value<int>? content,
  }) {
    return BasicLevelInfoCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      activated: activated ?? this.activated,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (activated.present) {
      map['activated'] = Variable<bool>(activated.value);
    }
    if (content.present) {
      map['content'] = Variable<int>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BasicLevelInfoCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('activated: $activated, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

abstract class _$_Database extends GeneratedDatabase {
  _$_Database(QueryExecutor e) : super(e);
  $_DatabaseManager get managers => $_DatabaseManager(this);
  late final $LevelContentTable levelContent = $LevelContentTable(this);
  late final $BasicLevelInfoTable basicLevelInfo = $BasicLevelInfoTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    levelContent,
    basicLevelInfo,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'level_content',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('basic_level_info', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$LevelContentTableCreateCompanionBuilder =
    LevelContentCompanion Function({
      Value<int> id,
      required bool circular,
      required double depth,
      required String points,
    });
typedef $$LevelContentTableUpdateCompanionBuilder =
    LevelContentCompanion Function({
      Value<int> id,
      Value<bool> circular,
      Value<double> depth,
      Value<String> points,
    });

final class $$LevelContentTableReferences
    extends BaseReferences<_$_Database, $LevelContentTable, LevelContentData> {
  $$LevelContentTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BasicLevelInfoTable, List<BasicLevelInfoData>>
  _basicLevelInfoRefsTable(_$_Database db) => MultiTypedResultKey.fromTable(
    db.basicLevelInfo,
    aliasName: $_aliasNameGenerator(
      db.levelContent.id,
      db.basicLevelInfo.content,
    ),
  );

  $$BasicLevelInfoTableProcessedTableManager get basicLevelInfoRefs {
    final manager = $$BasicLevelInfoTableTableManager(
      $_db,
      $_db.basicLevelInfo,
    ).filter((f) => f.content.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_basicLevelInfoRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LevelContentTableFilterComposer
    extends Composer<_$_Database, $LevelContentTable> {
  $$LevelContentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get circular => $composableBuilder(
    column: $table.circular,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get depth => $composableBuilder(
    column: $table.depth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> basicLevelInfoRefs(
    Expression<bool> Function($$BasicLevelInfoTableFilterComposer f) f,
  ) {
    final $$BasicLevelInfoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.basicLevelInfo,
      getReferencedColumn: (t) => t.content,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BasicLevelInfoTableFilterComposer(
            $db: $db,
            $table: $db.basicLevelInfo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LevelContentTableOrderingComposer
    extends Composer<_$_Database, $LevelContentTable> {
  $$LevelContentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get circular => $composableBuilder(
    column: $table.circular,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get depth => $composableBuilder(
    column: $table.depth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LevelContentTableAnnotationComposer
    extends Composer<_$_Database, $LevelContentTable> {
  $$LevelContentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get circular =>
      $composableBuilder(column: $table.circular, builder: (column) => column);

  GeneratedColumn<double> get depth =>
      $composableBuilder(column: $table.depth, builder: (column) => column);

  GeneratedColumn<String> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  Expression<T> basicLevelInfoRefs<T extends Object>(
    Expression<T> Function($$BasicLevelInfoTableAnnotationComposer a) f,
  ) {
    final $$BasicLevelInfoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.basicLevelInfo,
      getReferencedColumn: (t) => t.content,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BasicLevelInfoTableAnnotationComposer(
            $db: $db,
            $table: $db.basicLevelInfo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LevelContentTableTableManager
    extends
        RootTableManager<
          _$_Database,
          $LevelContentTable,
          LevelContentData,
          $$LevelContentTableFilterComposer,
          $$LevelContentTableOrderingComposer,
          $$LevelContentTableAnnotationComposer,
          $$LevelContentTableCreateCompanionBuilder,
          $$LevelContentTableUpdateCompanionBuilder,
          (LevelContentData, $$LevelContentTableReferences),
          LevelContentData,
          PrefetchHooks Function({bool basicLevelInfoRefs})
        > {
  $$LevelContentTableTableManager(_$_Database db, $LevelContentTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$LevelContentTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$LevelContentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$LevelContentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> circular = const Value.absent(),
                Value<double> depth = const Value.absent(),
                Value<String> points = const Value.absent(),
              }) => LevelContentCompanion(
                id: id,
                circular: circular,
                depth: depth,
                points: points,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required bool circular,
                required double depth,
                required String points,
              }) => LevelContentCompanion.insert(
                id: id,
                circular: circular,
                depth: depth,
                points: points,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$LevelContentTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({basicLevelInfoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (basicLevelInfoRefs) db.basicLevelInfo,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (basicLevelInfoRefs)
                    await $_getPrefetchedData<
                      LevelContentData,
                      $LevelContentTable,
                      BasicLevelInfoData
                    >(
                      currentTable: table,
                      referencedTable: $$LevelContentTableReferences
                          ._basicLevelInfoRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$LevelContentTableReferences(
                                db,
                                table,
                                p0,
                              ).basicLevelInfoRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.content == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LevelContentTableProcessedTableManager =
    ProcessedTableManager<
      _$_Database,
      $LevelContentTable,
      LevelContentData,
      $$LevelContentTableFilterComposer,
      $$LevelContentTableOrderingComposer,
      $$LevelContentTableAnnotationComposer,
      $$LevelContentTableCreateCompanionBuilder,
      $$LevelContentTableUpdateCompanionBuilder,
      (LevelContentData, $$LevelContentTableReferences),
      LevelContentData,
      PrefetchHooks Function({bool basicLevelInfoRefs})
    >;
typedef $$BasicLevelInfoTableCreateCompanionBuilder =
    BasicLevelInfoCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> activated,
      required int content,
    });
typedef $$BasicLevelInfoTableUpdateCompanionBuilder =
    BasicLevelInfoCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> activated,
      Value<int> content,
    });

final class $$BasicLevelInfoTableReferences
    extends
        BaseReferences<_$_Database, $BasicLevelInfoTable, BasicLevelInfoData> {
  $$BasicLevelInfoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LevelContentTable _contentTable(_$_Database db) =>
      db.levelContent.createAlias(
        $_aliasNameGenerator(db.basicLevelInfo.content, db.levelContent.id),
      );

  $$LevelContentTableProcessedTableManager get content {
    final $_column = $_itemColumn<int>('content')!;

    final manager = $$LevelContentTableTableManager(
      $_db,
      $_db.levelContent,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BasicLevelInfoTableFilterComposer
    extends Composer<_$_Database, $BasicLevelInfoTable> {
  $$BasicLevelInfoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activated => $composableBuilder(
    column: $table.activated,
    builder: (column) => ColumnFilters(column),
  );

  $$LevelContentTableFilterComposer get content {
    final $$LevelContentTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.content,
      referencedTable: $db.levelContent,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelContentTableFilterComposer(
            $db: $db,
            $table: $db.levelContent,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BasicLevelInfoTableOrderingComposer
    extends Composer<_$_Database, $BasicLevelInfoTable> {
  $$BasicLevelInfoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activated => $composableBuilder(
    column: $table.activated,
    builder: (column) => ColumnOrderings(column),
  );

  $$LevelContentTableOrderingComposer get content {
    final $$LevelContentTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.content,
      referencedTable: $db.levelContent,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelContentTableOrderingComposer(
            $db: $db,
            $table: $db.levelContent,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BasicLevelInfoTableAnnotationComposer
    extends Composer<_$_Database, $BasicLevelInfoTable> {
  $$BasicLevelInfoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get activated =>
      $composableBuilder(column: $table.activated, builder: (column) => column);

  $$LevelContentTableAnnotationComposer get content {
    final $$LevelContentTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.content,
      referencedTable: $db.levelContent,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelContentTableAnnotationComposer(
            $db: $db,
            $table: $db.levelContent,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BasicLevelInfoTableTableManager
    extends
        RootTableManager<
          _$_Database,
          $BasicLevelInfoTable,
          BasicLevelInfoData,
          $$BasicLevelInfoTableFilterComposer,
          $$BasicLevelInfoTableOrderingComposer,
          $$BasicLevelInfoTableAnnotationComposer,
          $$BasicLevelInfoTableCreateCompanionBuilder,
          $$BasicLevelInfoTableUpdateCompanionBuilder,
          (BasicLevelInfoData, $$BasicLevelInfoTableReferences),
          BasicLevelInfoData,
          PrefetchHooks Function({bool content})
        > {
  $$BasicLevelInfoTableTableManager(_$_Database db, $BasicLevelInfoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$BasicLevelInfoTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$BasicLevelInfoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$BasicLevelInfoTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> activated = const Value.absent(),
                Value<int> content = const Value.absent(),
              }) => BasicLevelInfoCompanion(
                id: id,
                name: name,
                activated: activated,
                content: content,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> activated = const Value.absent(),
                required int content,
              }) => BasicLevelInfoCompanion.insert(
                id: id,
                name: name,
                activated: activated,
                content: content,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$BasicLevelInfoTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({content = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (content) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.content,
                            referencedTable: $$BasicLevelInfoTableReferences
                                ._contentTable(db),
                            referencedColumn:
                                $$BasicLevelInfoTableReferences
                                    ._contentTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BasicLevelInfoTableProcessedTableManager =
    ProcessedTableManager<
      _$_Database,
      $BasicLevelInfoTable,
      BasicLevelInfoData,
      $$BasicLevelInfoTableFilterComposer,
      $$BasicLevelInfoTableOrderingComposer,
      $$BasicLevelInfoTableAnnotationComposer,
      $$BasicLevelInfoTableCreateCompanionBuilder,
      $$BasicLevelInfoTableUpdateCompanionBuilder,
      (BasicLevelInfoData, $$BasicLevelInfoTableReferences),
      BasicLevelInfoData,
      PrefetchHooks Function({bool content})
    >;

class $_DatabaseManager {
  final _$_Database _db;
  $_DatabaseManager(this._db);
  $$LevelContentTableTableManager get levelContent =>
      $$LevelContentTableTableManager(_db, _db.levelContent);
  $$BasicLevelInfoTableTableManager get basicLevelInfo =>
      $$BasicLevelInfoTableTableManager(_db, _db.basicLevelInfo);
}
