// lib/views/profile/edit_profile_page.dart
import 'package:flutter_masked_text3/flutter_masked_text3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../../widgets/text_field_widget.dart';
import './../../controllers/controllers.dart';
import './../../models/models.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final UserController userController = Get.find<UserController>();

  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneController = MaskedTextController(mask: '(00)00000-0000', text: '41999999999');
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final usuario = userController.user.value;

    _usernameController.text = usuario?.username ?? '';
    _emailController.text = usuario?.email ?? '';
    _passwordController.text = usuario?.password ?? '';
    _firstnameController.text = usuario?.name.firstname ?? '';
    _lastnameController.text = usuario?.name.lastname ?? '';
    _phoneController.text = usuario?.phone ?? '';

    _cityController.text = usuario?.address.city ?? '';
    _streetController.text = usuario?.address.street ?? '';
    _numberController.text = usuario?.address.number.toString() ?? '';
    _zipcodeController.text = usuario?.address.zipcode ?? '';
    _latController.text = usuario?.address.geolocation.lat ?? '';
    _longController.text = usuario?.address.geolocation.long ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Perfil'),
          elevation: 2,
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            unselectedLabelStyle: TextStyle(fontSize: 14, color: Colors.white70),
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Perfil', icon: Icon(Icons.person)),
              Tab(text: 'Endereço', icon: Icon(Icons.location_on)),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildProfileTab(),
              _buildAddressTab(),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text(
              'Salvar Alterações',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
            onPressed: _saveProfile,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        const Text(
          'Informações Pessoais',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFieldWidget(
          controller: _firstnameController,
          labelText: 'Primeiro Nome',
          hintText: 'Informe seu primeiro nome',
          icon: const Icon(Icons.person_outline),
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          controller: _lastnameController,
          labelText: 'Sobrenome',
          hintText: 'Informe seu Sobrenome',
          icon: const Icon(Icons.person_outline),
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          controller: _phoneController,
          labelText: 'Telefone',
          hintText: 'Informe o telefone',
          icon: const Icon(Icons.phone_outlined),
        ),
        const SizedBox(height: 24),
        const Text(
          'Informações da Conta',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFieldWidget(
          controller: _usernameController,
          labelText: 'Username',
          hintText: 'Informe o login',
          icon: const Icon(Icons.account_circle_outlined),
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          controller: _emailController,
          labelText: 'Email',
          hintText: 'Informe seu e-mail',
          icon: const Icon(Icons.email_outlined),
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          controller: _passwordController,
          labelText: 'Senha',
          hintText: 'Informe sua senha',
          isPassword: true,
          icon: const Icon(
            Icons.lock_outline,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        const Text(
          'Endereço',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFieldWidget(
          controller: _cityController,
          labelText: 'Cidade',
          hintText: 'Informe a cidade',
          icon: const Icon(Icons.location_city),
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          controller: _streetController,
          labelText: 'Rua',
          hintText: 'Informe a rua',
          icon: const Icon(Icons.streetview),
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          controller: _numberController,
          labelText: 'Número',
          hintText: 'Informe o número',
          icon: const Icon(Icons.numbers),
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          controller: _zipcodeController,
          labelText: 'CEP',
          hintText: 'Informe o CEP',
          icon: const Icon(Icons.local_post_office),
        ),
        const SizedBox(height: 24),
        const Text(
          'Geolocalização',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFieldWidget(
          controller: _latController,
          labelText: 'Latitude',
          hintText: 'Informe a latitude',
          icon: const Icon(Icons.my_location),
        ),
        const SizedBox(height: 10),
        TextFieldWidget(
          controller: _longController,
          labelText: 'Longitude',
          hintText: 'Informe a longitude',
          icon: const Icon(Icons.my_location),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Future<void> _saveProfile() async {
    final updatedUser = userController.user.value!.copyWith(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: NameModel(
        firstname: _firstnameController.text.trim(),
        lastname: _lastnameController.text.trim(),
      ),
      phone: _phoneController.text.trim(),
      address: AddressModel(
        city: _cityController.text.trim(),
        street: _streetController.text.trim(),
        number: int.tryParse(_numberController.text.trim()) ?? 0,
        zipcode: _zipcodeController.text.trim(),
        geolocation: GeolocationModel(
          lat: _latController.text.trim(),
          long: _longController.text.trim(),
        ),
      ),
    );

    final success = await userController.updateUserReturningSuccess(updatedUser);

    if (success) {
      Get.snackbar(
        'Perfil Atualizado',
        'Suas informações foram atualizadas com sucesso!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      Get.back();
    } else {
      Get.snackbar(
        'Erro',
        userController.erro.value.isNotEmpty
            ? userController.erro.value
            : 'Falha ao atualizar perfil.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}
