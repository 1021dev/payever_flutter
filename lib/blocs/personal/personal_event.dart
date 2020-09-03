
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/settings/models/models.dart';

abstract class PersonalScreenEvent extends Equatable {
  PersonalScreenEvent();

  @override
  List<Object> get props => [];
}

class PersonalScreenInitEvent extends PersonalScreenEvent {
  final String business;
  final User user;
  PersonalScreenInitEvent({
    this.business,
    this.user,
  });

  @override
  List<Object> get props => [
    this.business,
    this.user,
  ];
}