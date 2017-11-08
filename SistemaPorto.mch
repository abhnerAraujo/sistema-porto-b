/* SistemaPorto
 * Author: abhner
 * Creation date: 25/10/2017
 */
MACHINE
    SistemaPorto

SETS
    TIEM;//Conjunto dos navios cadastrados
    //NAVIOS_RECEPCAO;//Fila de navios em recepcao
    //NAVIOS_ATENDIMENTO;//Fila de navios em atendimento
    //NAVIOS_QUARENTENA;//Navios que estão em quarentena
//    VEICULO;//Carros cadastrados
//    CONTAINERS;//Containers cadastrados
//    CONTAINERS_RECEPCAO;//Containers em recepcao
//    CONTAINERS_ACEITOS;
//    CONTAINERS_RECUSADOS;
//    STATUS_NAVIO = {recepcionado, atendido, liberado};
//    STATUS_CONTAINER = {recepcionado, auditado, aceito, encaminhado};
//    MODO_PORTO = {aberto, fechado};
    CPF
//    ANCORADOURO
CONSTANTS
//   MAX_NAVIOS_RECEPCAO,
//   MAX_NAVIOS_ATENDIMENTO,
//   MAX_CONTAINERS_NAVIO,
//   MAX_CARROS_PORTO,
//   MAX_ITENS_CARRO,
//   MAX_PESO_CARRO,
//   MAX_NAVIOS_ANCORADOURO
    REG_NAVIO,
    CAPACIDADE_MAXIMA
PROPERTIES
//    MAX_NAVIOS_RECEPCAO : NATURAL & MAX_NAVIOS_RECEPCAO = 5 &
//    MAX_NAVIOS_ATENDIMENTO : NATURAL & MAX_NAVIOS_ATENDIMENTO = 3 &
//    MAX_CONTAINERS_NAVIO : NATURAL & MAX_CONTAINERS_NAVIO = 18500 &
//    MAX_CARROS_PORTO : NATURAL & MAX_CARROS_PORTO = 50 &
//    MAX_ITENS_CARRO : NATURAL & MAX_ITENS_CARRO = 50 &
//    MAX_PESO_CARRO : NATURAL & MAX_PESO_CARRO = 700 &
//    MAX_NAVIOS_ANCORADOURO : NATURAL & MAX_NAVIOS_ANCORADOURO = 1
    REG_NAVIO = struct(inscricao: TIEM, maxContainers: NATURAL)
    & CAPACIDADE_MAXIMA : NATURAL & CAPACIDADE_MAXIMA = 10
VARIABLES
//    navios,
//    carros,
//    containers,
//    modoAtual,
//    containerNavio,
//    ancoradouro,
    funcionarios,
    navios,
    capacidades,
    administrador
    
    
INVARIANT
    navios: POW(TIEM) &
    funcionarios: POW(CPF) &
    administrador : funcionarios --> BOOL &
    capacidades: navios --> NATURAL &
    0 /: ran(capacidades) & ran(capacidades) <: 1..CAPACIDADE_MAXIMA
    
INITIALISATION
    navios := {}
    || capacidades := {}
    || administrador := {}
    || funcionarios := {}
OPERATIONS
     /* ----------- usuários ----------- */
    
    cadastrarFuncionario(func) =
        PRE
            func : CPF & func /: funcionarios
        THEN
            funcionarios := funcionarios \/ {func}
            || administrador := administrador \/ { (func,FALSE) }
        END;
        
        atualizarPrivilegio(func,valor) =
        PRE
            func : CPF & func : funcionarios &
            valor : BOOL &
            administrador(func) /= valor
        THEN
            administrador := administrador <+ { (func,valor) }
        END;
    
    /* ----------- navios ----------- */
    
    cadastrarNavio(func, tiem, capacidade) =        
        PRE
            func : CPF & func : funcionarios & administrador(func) = TRUE
            & tiem : TIEM & tiem /: navios
            & capacidade : NATURAL & capacidade > 0 & capacidade < CAPACIDADE_MAXIMA
        THEN
            navios := navios \/ {tiem}
            || capacidades := capacidades \/ { (tiem, capacidade) }
        END;
        
    removerNavio(func, tiem) =
        PRE
            func : CPF & func : funcionarios & administrador(func) = TRUE
            & tiem : TIEM & tiem : navios
        THEN
            navios := navios - {tiem}
            || capacidades := {tiem} <<| capacidades
        END
      
END
