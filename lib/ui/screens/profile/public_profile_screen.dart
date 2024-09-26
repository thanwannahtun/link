import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/core/theme_extension.dart';

import '../../../bloc/agency/agency_cubit.dart';
import '../../../models/agency.dart';

class PublicProfileScreen extends StatefulWidget {
  const PublicProfileScreen({super.key});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  Agency? _agency;

  bool _initial = true;

  @override
  void didChangeDependencies() {
    if (_initial) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        _agency = ModalRoute.of(context)?.settings.arguments as Agency;
        context.read<AgencyCubit>().fetAgencies(agencyId: _agency?.id);
      }
      _initial = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_agency?.name ?? ""),
      ),
      backgroundColor: context.tertiaryColor,
    );
  }
}
