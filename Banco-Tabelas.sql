CREATE DATABASE Pizzaria;

use Pizzaria;

CREATE TABLE Clientes ( 
    id_cliente INT PRIMARY KEY AUTO_INCREMENT, 
    nome VARCHAR(100) NOT NULL, 
    telefone VARCHAR(20), 
    email VARCHAR(100), 
    endereco_entrega TEXT, 
    data_cadastro DATE, 
    ativo BOOLEAN DEFAULT TRUE 
); 

CREATE TABLE Funcionarios ( 
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT, 
    nome VARCHAR(100) NOT NULL, 
    cargo VARCHAR(50), -- 'entregador', 'cozinheiro', 'atendente' 
    telefone VARCHAR(20), 
    veiculo_entrega VARCHAR(50), 
    placa_veiculo VARCHAR(10), 
    ativo BOOLEAN DEFAULT TRUE 
); 






CREATE TABLE CategoriasIngredientes ( 
    id_categoria INT PRIMARY KEY AUTO_INCREMENT, 
    nome VARCHAR(50) NOT NULL, -- 'Queijos', 'Carnes', 'Vegetais', 'Massas' 
    descricao TEXT 
); 



CREATE TABLE Ingredientes ( 
    id_ingrediente INT PRIMARY KEY AUTO_INCREMENT, 
    nome VARCHAR(100) NOT NULL, 
    id_categoria INT, 
    unidade_medida VARCHAR(20), -- 'kg', 'g', 'litros', 'unidades' 
    estoque_minimo DECIMAL(10,2), 
    estoque_atual DECIMAL(10,2), 
    custo_unitario DECIMAL(10,2), 
    fornecedor VARCHAR(100), 
    ativo BOOLEAN DEFAULT TRUE, 
    FOREIGN KEY (id_categoria) REFERENCES CategoriasIngredientes(id_categoria) 
); 


CREATE TABLE MovimentacoesEstoque ( 
    id_movimentacao INT PRIMARY KEY AUTO_INCREMENT, 
    id_ingrediente INT, 
    tipo_movimentacao ENUM('entrada', 'saida', 'ajuste'), 
    quantidade DECIMAL(10,2), 
    data_movimentacao DATETIME, 
    motivo VARCHAR(200), 
    id_funcionario INT, 
    FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente), 
    FOREIGN KEY (id_funcionario) REFERENCES Funcionarios(id_funcionario) 
); 


CREATE TABLE PedidosCompra ( 
    id_pedido_compra INT PRIMARY KEY AUTO_INCREMENT, 
    data_pedido DATE, 
    fornecedor VARCHAR(100), 
    status ENUM('pendente', 'recebido', 'cancelado'), 
    valor_total DECIMAL(10,2), 
    data_prevista_entrega DATE 
); 


CREATE TABLE ItensPedidoCompra ( 
    id_item_pedido INT PRIMARY KEY AUTO_INCREMENT, 
    id_pedido_compra INT, 
    id_ingrediente INT, 
    quantidade DECIMAL(10,2), 
    valor_unitario DECIMAL(10,2), 
    FOREIGN KEY (id_pedido_compra) REFERENCES PedidosCompra(id_pedido_compra), 
    FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente) 
); 



CREATE TABLE CategoriasPizza ( 
    id_categoria_pizza INT PRIMARY KEY AUTO_INCREMENT, 
    nome VARCHAR(50) NOT NULL, -- 'Tradicional', 'Especial', 'Doce' 
    descricao TEXT 
); 



CREATE TABLE Pizzas ( 
    id_pizza INT PRIMARY KEY AUTO_INCREMENT, 
    nome VARCHAR(100) NOT NULL, 
    id_categoria_pizza INT, 
    descricao TEXT, 
    preco_base DECIMAL(10,2), 
    tamanho ENUM('P', 'M', 'G', 'GG'), 
    tempo_preparo_min INT, 
    ativo BOOLEAN DEFAULT TRUE, 
    FOREIGN KEY (id_categoria_pizza) REFERENCES CategoriasPizza(id_categoria_pizza) 
); 



CREATE TABLE PizzaIngredientes ( 
    id_pizza_ingrediente INT PRIMARY KEY AUTO_INCREMENT, 
    id_pizza INT, 
    id_ingrediente INT, 
    quantidade DECIMAL(8,3), -- Quantidade necessária por pizza 
    FOREIGN KEY (id_pizza) REFERENCES Pizzas(id_pizza), 
    FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente) 
); 


CREATE TABLE Pedidos ( 
    id_pedido INT PRIMARY KEY AUTO_INCREMENT, 
    id_cliente INT, 
    data_pedido DATETIME, 
    tipo_entrega ENUM('retirada', 'entrega'), 
    endereco_entrega TEXT, 
    status ENUM('recebido', 'preparando', 'pronto', 'entregue', 'cancelado'), 
    valor_total DECIMAL(10,2), 
    observacoes TEXT, 
    tempo_estimado_entrega INT, 
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente) 
); 

CREATE TABLE ItensPedido ( 
    id_item_pedido INT PRIMARY KEY AUTO_INCREMENT, 
    id_pedido INT, 
    id_pizza INT, 
    quantidade INT, 
    preco_unitario DECIMAL(10,2), 
    observacoes TEXT, 
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido), 
    FOREIGN KEY (id_pizza) REFERENCES Pizzas(id_pizza) 
); 



CREATE TABLE Entregas ( 
    id_entrega INT PRIMARY KEY AUTO_INCREMENT, 
    id_pedido INT, 
    id_entregador INT, 
    data_saida DATETIME, 
    data_entrega DATETIME, 
    statusEntrega ENUM('pendente', 'saiu_entrega', 'entregue', 'cancelada'), 
    tempo_entrega_min INT, 
    valor_entrega DECIMAL(10,2), 
    observacoes_entrega TEXT, 
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido), 
    FOREIGN KEY (id_entregador) REFERENCES Funcionarios(id_funcionario) 
); 



CREATE TABLE HistoricoStatusEntrega ( 
    id_historico INT PRIMARY KEY AUTO_INCREMENT, 
    id_entrega INT, 
    statusHistoricoEntrega ENUM('pendente', 'saiu_entrega', 'entregue', 'cancelada'), 
    data_hora DATETIME, 
    localizacao VARCHAR(200), 
    observacao TEXT, 
    FOREIGN KEY (id_entrega) REFERENCES Entregas(id_entrega) 
); 



CREATE TABLE Fornecedores ( 
    id_fornecedor INT PRIMARY KEY AUTO_INCREMENT, 
    nome VARCHAR(100) NOT NULL, 
    telefone VARCHAR(20), 
    email VARCHAR(100), 
    endereco TEXT, 
    tipo_fornecedor VARCHAR(50) -- 'laticinios', 'hortifruti', 'carnes' 
); 



CREATE TABLE AlertasEstoque ( 
    id_alerta INT PRIMARY KEY AUTO_INCREMENT, 
    id_ingrediente INT, 
    tipo_alerta ENUM('estoque_baixo', 'estoque_zerado'), 
    data_alerta DATETIME, 
    resolvido BOOLEAN DEFAULT FALSE, 
    FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente) 
); 


 