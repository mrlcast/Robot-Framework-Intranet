*** Settings ***
Resource                        base.robot

Test Setup                      Nova Sessão  
Test Teardown                   Encerra Sessão

*** Test Cases ***
Upgrade de Contrato 
    
    #Caminho para a tela Pré-cadastro
    Click Element               xpath=//a[contains(text(),'Principal')]
    Click Element               xpath=//a[contains(@href, 'pre_cadastro.php')]
    Click Element               xpath=//input[@name='bt_envia']
    Click Element               xpath=//select[@id='id_proposta']
    
    #Dados Principais
    Select From List By Label   id=id_proposta                                  Alteração
    Select From List By Label   xpath=//select[@id='prptpcoid']                 Cliente
    Input Text                  id=prptermo_original                            1050708098 
    Sleep                       2
    Select From List By Label   id=prpmsuboid                                   UPGRADE DE SASTM FULL X GSM/GPS FROTAS
    Sleep                       5
    Click Element               id=copiar_dados_cobranca
    Click Element               id=copiar_dados
    Select From List By Label   id=execcontas                                   RODRIGO LUTZ
    Select From List By Label   id=prpforcoid                                   Dinheiro
    Select From List By Label   id=prpdia_vcto_boleto                           7
    Sleep                       20

    
