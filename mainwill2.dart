import 'package:flutter/material.dart';

void main() {
  runApp(const Jogo2048App());
}

class Jogo2048App extends StatelessWidget { //clase Jogo2048 "pertence" a StatelessWidget
  const Jogo2048App({super.key});  // constante Jogo2048 dentro da superkey

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desafio 2048', //titulo
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
  int gridSize = 4;  //tamanho da tabela do jogo
  int movimentos = 0; //quantidade de movimentos usados
  int objetivo = 1024; //numero necessario para vitoria dentro do jogo
  String status = '';   //status de vitoria ou derrota
  List<List<int>> grid = [];

  @override
  void initState() {
    super.initState();
    _inicializarGrid(); //inicializa a tabela grid 2D
  }

  void _inicializarGrid() {  // inicializa a tabela grid 2D
    grid = List.generate(gridSize, (_) => List.generate(gridSize, (_) => 0));
    movimentos = 0;      // coloca os movimentos para 0
    status = '';          // status de vitoria ou derrota
    _adicionarNovoNumero();   //adiciona um numero "2" dentro de um 0 aleatorio dentro da tabela
  }

  void _mudarNivel(int tamanho, int objetivoNovo) { //muda o nivel de dificuldade do jogo
    setState(() {
      gridSize = tamanho;   //muda o tamanho para o que foi pedido
      objetivo = objetivoNovo;  //muda o numero que se precisa atingir para a vitoria
      _inicializarGrid();  //inicializa a tabela novamente, zerada
    });
  }

  void _adicionarNovoNumero() {    //adiciona um "2" dentro da tabela, de forma aleatoria
    final vazio = <Map<String, int>>[];  //faz uma busca dentro da tabela, tentando achar lugares vazios

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

  bool _verificaVitoria() { //verificação de vitoria
    for (var linha in grid) {
      for (var valor in linha) {
        if (valor == objetivo) {
          return true;
        }
      }
    }
    return false;
  } 

  bool _verificaDerrota() { //verificação de derrota
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
      combinar(); //combina os numeros iguais

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

  void _moverParaCima() {                                           //
    _movimento(() {                                                 
      for (int j = 0; j < gridSize; j++) {                          
        List<int> coluna = [];                                     
        for (int i = 0; i < gridSize; i++) {                        
          if (grid[i][j] != 0) coluna.add(grid[i][j]);               // botao de movimento para cima
        }                                                           
         coluna = _combinar(coluna);                                
        while (coluna.length < gridSize) coluna.add(0);             
        for (int i = 0; i < gridSize; i++) grid[i][j] = coluna[i];  //
      }
    });
  }

  void _moverParaBaixo() {                                                              //
    _movimento(() {
      for (int j = 0; j < gridSize; j++) {
        List<int> coluna = [];
        for (int i = gridSize - 1; i >= 0; i--) {
          if (grid[i][j] != 0) coluna.add(grid[i][j]);                                  //movimento para baixo
        }               
        coluna = _combinar(coluna);
        while (coluna.length < gridSize) coluna.add(0);
        for (int i = 0; i < gridSize; i++) grid[gridSize - 1 - i][j] = coluna[i];         //
      }
    });
  }

  void _moverParaEsquerda() {                                                //
    _movimento(() {
      for (int i = 0; i < gridSize; i++) {
        List<int> linha = [];
        for (int j = 0; j < gridSize; j++) {
          if (grid[i][j] != 0) linha.add(grid[i][j]);                       //movimento para esquerda
        }
        linha = _combinar(linha);
        while (linha.length < gridSize) linha.add(0);
        for (int j = 0; j < gridSize; j++) grid[i][j] = linha[j];            //     
      }
    });
  }

  void _moverParaDireita() {                                                          //
    _movimento(() {
      for (int i = 0; i < gridSize; i++) {
        List<int> linha = [];
        for (int j = gridSize - 1; j >= 0; j--) {
          if (grid[i][j] != 0) linha.add(grid[i][j]);                                 //movimento para direita
        }
        linha = _combinar(linha);
        while (linha.length < gridSize) linha.add(0);
        for (int j = 0; j < gridSize; j++) grid[i][gridSize - 1 - j] = linha[j];      //
      }
    });
  }

  List<int> _combinar(List<int> lista) {            //
    for (int i = 0; i < lista.length - 1; i++) {
      if (lista[i] == lista[i + 1]) {               // combina os numeros que estao iguais e pertos um do outro e soma-os.
        lista[i] *= 2;
        lista[i + 1] = 0;                           //
      }
    }
    return lista.where((v) => v != 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(                          //estrutura principal que esta sendo utilizada
      appBar: AppBar(                             //appbar
        title: const Text('Joguinho 2048'),       //titulo
        centerTitle: true,                        // centraliza o titulo no meio
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Jogadas: $movimentos', style: const TextStyle(fontSize: 20)), //mostra a palavra "jogadas" juntamente com a quantidade de movimentos feitas
                Text(status, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), //personalizacao do texto "jogadas"
                ElevatedButton(
                  onPressed: _inicializarGrid, //inicializa a tabela grid 2d
                  child: const Text('Novo Jogo'), //botao para reiniciar o jogo do zero
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(                                                                                              //
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _mudarNivel(4, 1024), child: const Text('Iniciante')),        //parte para mudança de niveis dentro do jogo, 3 niveis, 4,5 e 6 mudam o tamanho da tabela para 4x4,5x5,6x6, 1024,2048 e 4096 é o numero necessario para vitoria do jogo.
                ElevatedButton(onPressed: () => _mudarNivel(5, 2048), child: const Text('Intermediário')),      
                ElevatedButton(onPressed: () => _mudarNivel(6, 4096), child: const Text('Avançado')),
              ],                                                                                              //
            ),
            const SizedBox(height: 20), //tamanho das caixinhas do jogo
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

          return Container(                                                       //
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: valor == 0 ? Colors.grey[300] : (valor.bitLength % 2 == 0
    ? Colors.purple[(valor.bitLength * 100) % 900 + 100]                              //personalizacao das cores dos "containers" ou caixas do jogo, fazendo um degrade.
    : Colors.blue[(valor.bitLength * 100) % 900 + 100]),

              borderRadius: BorderRadius.circular(8),                             // bordas arredondadas
            ),                                                                    //
            child: Center(
              child: Text(
                valor == 0 ? '' : '$valor',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),    //personalizacao de texto dos valores dentro das caixas.
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
