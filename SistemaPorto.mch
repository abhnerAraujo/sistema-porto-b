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
    CONTAINERS_ID;//Containers cadastrados
//    CONTAINERS_RECEPCAO;//Containers em recepcao
//    CONTAINERS_ACEITOS;
//    CONTAINERS_RECUSADOS;
//    STATUS_NAVIO = {recepcionado, atendido, liberado};
    STATUS_CONTAINER = {recepcionado, auditado, retirado, encaminhado};
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
    REG_CONTAINER,
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
    & REG_CONTAINER = struct(registro: CONTAINERS_ID, status: STATUS_CONTAINER)
VARIABLES
//    navios,
//    carros,
//    containers,
//    modoAtual,
    navioContainer,
//    ancoradouro,
    funcionarios,
    navios,
    capacidades,
    administrador,
    containers
    
    
INVARIANT
    navios: POW(TIEM)
    & containers: POW(CONTAINERS_ID)
    & funcionarios: POW(CPF) 
    & administrador : funcionarios --> BOOL
    & capacidades: navios --> NATURAL
    & 0 /: ran(capacidades) & ran(capacidades) <: 1..CAPACIDADE_MAXIMA
    & navioContainer: navios +-> POW(REG_CONTAINER)
    & ! (cn1,cn2) . (
        (cn1 : dom(navioContainer) & cn2 : dom(navioContainer) & cn1 /= cn2)
        => navioContainer(cn1) /\ navioContainer(cn2) = {})
INITIALISATION
    navios := {}
    || capacidades := {}
    || administrador := {}
    || funcionarios := {}
    || containers := {}
    || navioContainer := {}
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
        END;
        
    /* ----------- containers ----------- */
    
    cadastrarContainer(func, reg, tiem, stat) =        
        PRE
            func : CPF & func : funcionarios & administrador(func) = TRUE
            & tiem : TIEM & tiem : navios
            & reg : CONTAINERS_ID & reg /: containers
            & stat : STATUS_CONTAINER & stat = recepcionado
        THEN
            containers := containers \/ {reg}
            ||
            IF tiem : dom(navioContainer) THEN
                navioContainer := navioContainer 
                <+ {(tiem, navioContainer(tiem) \/ {rec(registro:reg, status:stat)})}
            ELSE
                navioContainer := navioContainer \/ {tiem |-> {rec(registro:reg, status:stat)}}
            END
        END;
        
    retirarContainer(func, reg) =
        PRE
            func : CPF & func : funcionarios & administrador(func) = TRUE
            & reg : CONTAINERS_ID & reg : containers
        THEN
            ANY tiem WHERE
                tiem : dom(navioContainer) &
                tiem : {num | num : TIEM & num : dom(navioContainer) & 
                    # num2 . (num2: REG_CONTAINER & num2 : navioContainer(num) 
                        & num2'registro = reg)}
            THEN
                IF card(navioContainer(tiem)) = 1 THEN
                    navioContainer := {tiem} <<| navioContainer
                ELSE
                    navioContainer(tiem) := navioContainer(tiem) 
                    /\ {reg2 | reg2: REG_CONTAINER & reg2 : navioContainer(tiem) & reg2'registro = reg}
                END
            END
        END;
        
     atualizarStatus(func, tiem, reg) =
        PRE
            func : CPF & func : funcionarios & administrador(func) = TRUE
            & tiem : navios & tiem : dom(navioContainer)
            & reg : REG_CONTAINER & reg : navioContainer(tiem)
        THEN
            navioContainer(tiem) := navioContainer(tiem) - {reg}
                
        END
     //{recepcionado, auditado, retirado, encaminhado};
      
END
