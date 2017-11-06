/* SistemaPorto
 * Author: abhner
 * Creation date: 25/10/2017
 */
MACHINE
    SistemaPorto

SETS
    NAVIOS;//Conjunto dos navios cadastrados
    NAVIOS_RECEPCAO;//Fila de navios em recepcao
    NAVIOS_ATENDIMENTO;//Fila de navios em atendimento
    NAVIOS_QUARENTENA;//Navios que estão em quarentena
    CARROS;//Carros cadastrados
    CONTAINERS;//Containers cadastrados
    CONTAINERS_RECEPCAO;//Containers em recepcao
    CONTAINERS_ACEITOS;
    CONTAINERS_RECUSADOS;
    STATUS_NAVIO = {recepcionado, atendido, liberado};
    STATUS_CONTAINER = {recepcionado, auditado, aceito, encaminhado};
    MODO_PORTO = {aberto, fechado};
    FUNCIONARIO;

CONSTANTS
   MAX_NAVIOS_RECEPCAO
   MAX_NAVIOS_ATENDIMENTO
   MAX_CONTAINERS_NAVIO
   MAX_CARROS_PORTO
   MAX_ITENS_CARRO
   MAX_PESO_CARRO
PROPERTIES
    MAX_NAVIOS_RECEPCAO : NATURAL & MAX_NAVIOS_RECEPCAO = 5
    MAX_NAVIOS_ATENDIMENTO : NATURAL & MAX_NAVIOS_ATENDIMENTO = 3 &
    MAX_CONTAINERS_NAVIO : NATURAL & MAX_CONTAINERS_NAVIO = 18500 &
    MAX_CARROS_PORTO : NATURAL & MAX_CARROS_PORTO = 50 &
    MAX_ITENS_CARRO : NATURAL & MAX_ITENS_CARRO = 50 &
    MAX_PESO_CARRO : NATURAL & MAX_PESO_CARRO = 700
    
VARIABLES
    
INVARIANT
    
INITIALISATION
    
OPERATIONS
      
END
