// TP2 - App de Preferências Musicais
// Autora: Mariana Vieira
//
// Todos os dados ficam apenas em memória (sem banco de dados ou arquivos).

import 'package:flutter/material.dart';

void main() {
  runApp(const PreferenciasMusicaisApp());
}

/// Modelo de dados de um gênero musical (mantido em memória).
class GeneroMusical {
  final String nome;
  final String descricao;
  final String imagemUrl; // link http(s) da imagem (mostrada na tela de configurações)
  final IconData icone; // usado na lista e como reserva se a imagem não carregar
  final MaterialColor cor;

  bool curte;
  double volume;
  bool recebeRecomendacoes;

  GeneroMusical({
    required this.nome,
    required this.descricao,
    required this.imagemUrl,
    required this.icone,
    required this.cor,
    this.curte = false,
    this.volume = 50,
    this.recebeRecomendacoes = false,
  });
}

class PreferenciasMusicaisApp extends StatelessWidget {
  const PreferenciasMusicaisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preferências Musicais',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TelaGeneros(),
    );
  }
}

/// Quadrado colorido com o ícone do gênero (usado na lista e como reserva).
class IconeGenero extends StatelessWidget {
  final GeneroMusical genero;
  final double tamanho;

  const IconeGenero({super.key, required this.genero, required this.tamanho});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: tamanho,
        height: tamanho,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [genero.cor.shade300, genero.cor.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Icon(genero.icone, color: Colors.white, size: tamanho * 0.5),
      ),
    );
  }
}

/// Imagem do gênero carregada via HTTP (Image.network).
/// Se o link estiver vazio ou falhar, mostra o IconeGenero no lugar.
class ImagemGenero extends StatelessWidget {
  final GeneroMusical genero;
  final double tamanho;

  const ImagemGenero({super.key, required this.genero, required this.tamanho});

  @override
  Widget build(BuildContext context) {
    if (genero.imagemUrl.isEmpty) {
      return IconeGenero(genero: genero, tamanho: tamanho);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        genero.imagemUrl,
        width: tamanho,
        height: tamanho,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progresso) {
          if (progresso == null) return child;
          return SizedBox(
            width: tamanho,
            height: tamanho,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, erro, stackTrace) =>
            IconeGenero(genero: genero, tamanho: tamanho),
      ),
    );
  }
}

/// Tela inicial: lista de gêneros com Switch.
class TelaGeneros extends StatefulWidget {
  const TelaGeneros({super.key});

  @override
  State<TelaGeneros> createState() => _TelaGenerosState();
}

class _TelaGenerosState extends State<TelaGeneros> {
  // Lista mantida apenas em memória.
  // Troque as URLs por imagens em assets/ se preferir (Image.asset).
  final List<GeneroMusical> _generos = [
    GeneroMusical(
      nome: 'Rock',
      descricao:
          'Gênero marcado por guitarras elétricas, baixo e bateria marcantes, '
          'com letras que vão da rebeldia ao romantismo.',
      imagemUrl: '', // cole aqui o link da imagem de Rock
      icone: Icons.electric_bolt,
      cor: Colors.red,
    ),
    GeneroMusical(
      nome: 'Pop',
      descricao:
          'Música popular com melodias cativantes e refrões fáceis de '
          'memorizar, feita para alcançar um grande público.',
      imagemUrl: '', // cole aqui o link da imagem de Pop
      icone: Icons.star,
      cor: Colors.pink,
    ),
    GeneroMusical(
      nome: 'MPB',
      descricao:
          'Música Popular Brasileira: mistura ritmos nacionais com poesia '
          'nas letras e harmonias elaboradas.',
      imagemUrl: '', // cole aqui o link da imagem de MPB
      icone: Icons.music_note,
      cor: Colors.green,
    ),
    GeneroMusical(
      nome: 'Samba',
      descricao:
          'Ritmo brasileiro de raízes afro, com percussão marcante e '
          'forte ligação com o Carnaval e as rodas de samba.',
      imagemUrl: '', // cole aqui o link da imagem de Samba
      icone: Icons.celebration,
      cor: Colors.orange,
    ),
    GeneroMusical(
      nome: 'Jazz',
      descricao:
          'Gênero nascido nos Estados Unidos, conhecido pela improvisação, '
          'swing e harmonias sofisticadas.',
      imagemUrl: '', // cole aqui o link da imagem de Jazz
      icone: Icons.piano,
      cor: Colors.indigo,
    ),
    GeneroMusical(
      nome: 'Hip Hop',
      descricao:
          'Cultura musical baseada em rimas (rap), batidas e samples, '
          'com letras que retratam o cotidiano urbano.',
      imagemUrl: '', // cole aqui o link da imagem de Hip Hop
      icone: Icons.mic,
      cor: Colors.blueGrey,
    ),
    GeneroMusical(
      nome: 'Música Clássica',
      descricao:
          'Tradição da música erudita ocidental, executada por orquestras '
          'e instrumentistas, de Bach a Beethoven.',
      imagemUrl: '', // cole aqui o link da imagem de Música Clássica
      icone: Icons.library_music,
      cor: Colors.brown,
    ),
  ];

  Future<void> _abrirConfiguracoes(GeneroMusical genero) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaConfiguracoes(genero: genero),
      ),
    );
    // Ao voltar, atualiza a lista com os dados salvos.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mariana Vieira'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: _generos.length,
        itemBuilder: (context, indice) {
          final genero = _generos[indice];
          return ListTile(
            leading: IconeGenero(genero: genero, tamanho: 56),
            title: Text(genero.nome),
            subtitle: Text(genero.curte ? 'Você curte' : 'Não curte'),
            trailing: Switch(
              value: genero.curte,
              onChanged: (valor) {
                setState(() {
                  genero.curte = valor;
                });
              },
            ),
            onTap: () => _abrirConfiguracoes(genero),
          );
        },
      ),
    );
  }
}

/// Tela de configurações de um gênero: descrição, Slider, Checkbox e botão.
class TelaConfiguracoes extends StatefulWidget {
  final GeneroMusical genero;

  const TelaConfiguracoes({super.key, required this.genero});

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  late double _volume;
  late bool _recebeRecomendacoes;

  @override
  void initState() {
    super.initState();
    _volume = widget.genero.volume;
    _recebeRecomendacoes = widget.genero.recebeRecomendacoes;
  }

  void _salvarPreferencias() {
    // Grava os valores no objeto em memória.
    widget.genero.volume = _volume;
    widget.genero.recebeRecomendacoes = _recebeRecomendacoes;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Preferências de ${widget.genero.nome} salvas com sucesso!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mariana Vieira'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ImagemGenero(genero: widget.genero, tamanho: 120),
            ),
            const SizedBox(height: 16),
            Text(
              widget.genero.nome,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(widget.genero.descricao),
            const SizedBox(height: 24),
            Text('Volume preferido: ${_volume.round()}'),
            Slider(
              value: _volume,
              min: 0,
              max: 100,
              divisions: 100,
              label: _volume.round().toString(),
              onChanged: (valor) {
                setState(() {
                  _volume = valor;
                });
              },
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Desejo receber recomendações deste gênero'),
              value: _recebeRecomendacoes,
              onChanged: (valor) {
                setState(() {
                  _recebeRecomendacoes = valor ?? false;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _salvarPreferencias,
              child: const Text('Salvar Preferências'),
            ),
          ],
        ),
      ),
    );
  }
}