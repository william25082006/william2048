import 'package:flutter/material.dart';

void main() {
  runApp(const Jogo2048App());
}

class Jogo2048App extends StatelessWidget {
  const Jogo2048App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desafio 2048',
      home: const Jogo2048HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Jogo2048HomePage extends StatefulWidget {
  const Jogo2048HomePage({super.key});

  @override
  State<Jogo2048HomePage> createState() => _Jogo2048HomePageState();
}

class _Jogo2048HomePageState extends State<Jogo2048HomePage> {
  int gridSize = 4;
  int movimentos = 0;
  int objetivo = 1024;
  String status = '';
  List<List<int>> grid = [];

  @override
  void initState() {
    super.initState();
    _inicializarGrid();
  }

  void _inicializarGrid() {
    grid = List.generate(gridSize, (_) => List.generate(gridSize, (_) => 0));
    movimentos = 0;
    status = '';
    _adicionarNovoNumero();
  }

  void _mudarNivel(int tamanho, int objetivoNovo) {
    setState(() {
      gridSize = tamanho;
      objetivo = objetivoNovo;
      _inicializarGrid();
    });
  }

  void _adicionarNovoNumero() {
    final vazio = <Map<String, int>>[];

    for (var i = 0; i < gridSize; i++) {
      for (var j = 0; j < gridSize; j++) {
        if (grid[i][j] == 0) {
          vazio.add({'x': i, 'y': j});
        }
      }
    }

    if (vazio.isNotEmpty) {
      final pos = vazio[DateTime.now().millisecondsSinceEpoch % vazio.length];
      grid[pos['x']!][pos['y']!] = 1;
    }
  }

  bool _verificaVitoria() {
    for (var linha in grid) {
      for (var valor in linha) {
        if (valor == objetivo) {
          return true;
        }
      }
    }
    return false;
  }

  bool _verificaDerrota() {
    for (var linha in grid) {
      if (linha.contains(0)) return false;
    }
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (i < gridSize - 1 && grid[i][j] == grid[i + 1][j]) return false;
        if (j < gridSize - 1 && grid[i][j] == grid[i][j + 1]) return false;
      }
    }
    return true;
  }

  void _movimento(Function combinar) {
    setState(() {
      List<List<int>> gridAntes = grid.map((linha) => List<int>.from(linha)).toList();
      combinar();

      if (gridAntes.toString() != grid.toString()) {
        movimentos++;
        _adicionarNovoNumero();

        if (_verificaVitoria()) {
          status = 'PARABÉNS! VOCÊ VENCEU!';
        } else if (_verificaDerrota()) {
          status = 'FIM DE JOGO!';
        }
      }
    });
  }

  void _moverParaCima() {
    _movimento(() {
      for (int j = 0; j < gridSize; j++) {
        List<int> coluna = [];
        for (int i = 0; i < gridSize; i++) {
          if (grid[i][j] != 0) coluna.add(grid[i][j]);
        }
        coluna = _combinar(coluna);
        while (coluna.length < gridSize) coluna.add(0);
        for (int i = 0; i < gridSize; i++) grid[i][j] = coluna[i];
      }
    });
  }

  void _moverParaBaixo() {
    _movimento(() {
      for (int j = 0; j < gridSize; j++) {
        List<int> coluna = [];
        for (int i = gridSize - 1; i >= 0; i--) {
          if (grid[i][j] != 0) coluna.add(grid[i][j]);
        }
        coluna = _combinar(coluna);
        while (coluna.length < gridSize) coluna.add(0);
        for (int i = 0; i < gridSize; i++) grid[gridSize - 1 - i][j] = coluna[i];
      }
    });
  }

  void _moverParaEsquerda() {
    _movimento(() {
      for (int i = 0; i < gridSize; i++) {
        List<int> linha = [];
        for (int j = 0; j < gridSize; j++) {
          if (grid[i][j] != 0) linha.add(grid[i][j]);
        }
        linha = _combinar(linha);
        while (linha.length < gridSize) linha.add(0);
        for (int j = 0; j < gridSize; j++) grid[i][j] = linha[j];
      }
    });
  }

  void _moverParaDireita() {
    _movimento(() {
      for (int i = 0; i < gridSize; i++) {
        List<int> linha = [];
        for (int j = gridSize - 1; j >= 0; j--) {
          if (grid[i][j] != 0) linha.add(grid[i][j]);
        }
        linha = _combinar(linha);
        while (linha.length < gridSize) linha.add(0);
        for (int j = 0; j < gridSize; j++) grid[i][gridSize - 1 - j] = linha[j];
      }
    });
  }

  List<int> _combinar(List<int> lista) {
    for (int i = 0; i < lista.length - 1; i++) {
      if (lista[i] == lista[i + 1]) {
        lista[i] *= 2;
        lista[i + 1] = 0;
      }
    }
    return lista.where((v) => v != 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joguinho 2048'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Jogadas: $movimentos', style: const TextStyle(fontSize: 20)),
                Text(status, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: _inicializarGrid,
                  child: const Text('Novo Jogo'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _mudarNivel(4, 1024), child: const Text('Iniciante')),
                ElevatedButton(onPressed: () => _mudarNivel(5, 2048), child: const Text('Intermediário')),
                ElevatedButton(onPressed: () => _mudarNivel(6, 4096), child: const Text('Avançado')),
              ],
            ),
            const SizedBox(height: 20),
            _buildGrid(),
            const SizedBox(height: 20),
            _buildControles(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Expanded(
      child: GridView.builder(
        itemCount: gridSize * gridSize,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
        ),
        itemBuilder: (context, index) {
          int x = index ~/ gridSize;
          int y = index % gridSize;
          int valor = grid[x][y];

          return Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: valor == 0 ? Colors.grey[300] : (valor.bitLength % 2 == 0
    ? Colors.purple[(valor.bitLength * 100) % 900 + 100]
    : Colors.blue[(valor.bitLength * 100) % 900 + 100]),

              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                valor == 0 ? '' : '$valor',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControles() {
    return Column(
      children: [
        IconButton(icon: const Icon(Icons.arrow_upward), onPressed: _moverParaCima),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: _moverParaEsquerda),
            const SizedBox(width: 40),
            IconButton(icon: const Icon(Icons.arrow_forward), onPressed: _moverParaDireita),
          ],
        ),
        IconButton(icon: const Icon(Icons.arrow_downward), onPressed: _moverParaBaixo),
      ],
    );
  }
}
