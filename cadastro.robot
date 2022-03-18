*** Settings ***
Resource                        base.robot

#Test Setup                      Nova Sessão  
#Test Teardown                   Encerra Sessão

*** Test Cases ***
Cadastro de cliente Pessoa Física e geração do contrato
    
  #Se for fazer um looping pra criar contratos, adicionar as linhas abaixo e comentar o Test Setup - Teardown
    FOR       ${var}              IN RANGE     1
      Nova Sessão
      ${classe}=                  Classe Contrato
      ${termo}=                   Novo Contrato PF    ${classe.nome}   ${classe.valorMonit}    ${classe.valorServ}   ${classe.valorTax}     
      Geração de contrato         ${termo} 
      Continue For Loop
    END

Cadastro de cliente Pessoa Juridica e geração do contrato

  #Se for fazer um looping pra criar contratos, adicionar as linhas abaixo e comentar o Test Setup - Teardown
    FOR       ${var}              IN RANGE     1
      Nova Sessão
      ${classe}=                  Classe Contrato
      ${termo}=                   Novo Contrato PJ    ${classe.nome}   ${classe.valorMonit}    ${classe.valorServ}   ${classe.valorTax}   
      Geração de contrato         ${termo}
      Continue For Loop
    END
    