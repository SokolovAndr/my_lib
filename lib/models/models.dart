import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:http/http.dart' as http;

part 'models.g.dart';

//объявление таблиц
const SqfEntityTable tableAuthor = SqfEntityTable(
    tableName: 'authors',
    primaryKeyName: 'id',
    useSoftDeleting: false,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('name', DbType.text),
      SqfEntityField('isInactive', DbType.bool, defaultValue: false)
    ]);

const SqfEntityTable tableGenre = SqfEntityTable(
    tableName: 'genres',
    primaryKeyName: 'id',
    useSoftDeleting: false,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('name', DbType.text),
    ]);

const SqfEntityTable tableBook = SqfEntityTable(
    tableName: 'books',
    primaryKeyName: 'id',
    useSoftDeleting: false,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('title', DbType.text),
      SqfEntityField('image', DbType.text),
      SqfEntityField('isInactive', DbType.bool, defaultValue: false),
      SqfEntityFieldRelationship(
          parentTable: tableAuthor,
          relationType: RelationType.ONE_TO_MANY,
          deleteRule: DeleteRule.CASCADE,
          defaultValue: 0),
      SqfEntityFieldRelationship(
          parentTable: tableGenre,
          relationType: RelationType.ONE_TO_MANY,
          deleteRule: DeleteRule.CASCADE,
          defaultValue: 0),
    ]);


const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

//объявление БД
@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
  modelName: 'MyAppDatabaseModel',
  databaseName: 'lib.db',
  sequences: [seqIdentity],
  databaseTables: [tableAuthor, tableBook, tableGenre],  //здесь добавляем таблицы
);

//после этого в терминале пишим flutter pub run build_runner build --delete-conflicting-outputs