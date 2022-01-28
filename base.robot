*** Settings ***
Library                             SeleniumLibrary
Library                             DateTime
Library                             FakerLibrary    locale=pt_BR

*** Variables ***
${url}                              https://hom1-intranet.sascar.com.br/sistemaWeb/index.php        #Homologação
#${url}                             https://desenvolvimento.sascar.com.br/ORGMKTOTVS-4468/          #Desenvolvimento
#${url}                              https://intranet-hom-wsprotheus.sascar.com.br/intranet-prod/index.php                  #PROTHEUS

${contrato}                         Set Variable                                    ${EMPTY}        #Setando contrato
&{classe}                           nome=TESTE   valorMonit=1   valorServ=2   valorTax=3            #Setando variáveis de classe
*** Keywords ***
#Keyword para abrir a Intranet
Nova Sessão
    Open Browser                    ${url}                                          chrome
    Maximize Browser Window 
    Login With
    
#Keyword para encerrar sessão e tirar screenshot    
Encerra Sessão
    Evidencia                       fimProcessamento
    Close Browser

#Keyword que passa o parâmetro <nome>, e adiciona ao dateTime atual, a fim de criar uma chave 'única' para cada screenshot.
Evidencia
    [Arguments]                     ${nome}
    ${now}                          Evaluate                                        '{dt.day}.{dt.month}.{dt.year}.{dt.hour}.{dt.minute}.{dt.second}'.format(dt=datetime.datetime.now())    modules=datetime
    Capture Page Screenshot         ${nome}-${now}.png

#Keyword que faz o login com usuário e senha atuais
Login With
    Input text                      css:input[name=login]                           admin.desenv
    Input text                      css:input[name=senha]                           12345
    Click Element                   css:input[type=image]
    Evidencia                       login

#Keyword que recebe 4 argumentos, que são os dados obrigatórios que devem ser alterados em cada contrato PF
Novo Contrato PF
        [Arguments]                 ${tipoContrato}  ${valorService}  ${valorMonitoramento}	${valorTaxa}	
    #Variáveis 
        ${cpf}                      FakerLibrary.Cpf                                #Geração de um CPF Fake
        ${rg}                       FakerLibrary.Rg                                 #Geração de um RG Fake
        ${nome}                     FakerLibrary.Name                               #Geração de um Nome Fake
        ${nomeMae}                  FakerLibrary.Name                               #Geração de um Nome da Mãe Fake
        ${email}                    FakerLibrary.Email                              #Geração de um Email Fake
        ${emailFinanceiro}          FakerLibrary.Email                              #Geração de um email financeiro Fake
        ${chassi}                   FakerLibrary.Ean                                #Geração de um número Fake
        ${placa}                    FakerLibrary.Ean 8                              #Geração de uma placa Fake
        ${fone1}                    FakerLibrary.Phone Number                       #Geração de um telefone fake
        ${fone2}                    FakerLibrary.Phone Number                       #Geração de um telefone fake
        ${fone3}                    FakerLibrary.Phone Number                       #Geração de um telefone fake
        ${ano}                      FakerLibrary.year                               #Geração de um ano fake
        ${cor}                      FakerLibrary.color name                         #Geração de uma cor fake
        ${texto}                    FakerLibrary.text                               #Geração de um texto fake                  
    # Caminho para a tela Pré-cadastro
        Click Element               xpath=//a[contains(text(),'Principal')]
        Click Element               xpath=//a[contains(@href, 'pre_cadastro.php')]
        Click Element               xpath=//input[@name='bt_envia']
        Click Element               xpath=//select[@id='id_proposta']
    # Dados Principais
        Select From List By Label   id=id_proposta                                  Mensalidade Locação
        Select From List By Label   xpath=//select[@id='prptpcoid']                 Cliente
    # Dados do Contratante
        Click Element               xpath=//input[@id='prptipo_pessoa_fis']
    # Pessoa Física
        Input text                  css=#prpno_cpf_cgc_fis                          ${cpf}              #Váriavel faker CPF 
        Input text                  css=#prplocatario_fis                           ${nome}             #Váriavel faker Nome
        Input text                  css=#prpno_rg                                   ${rg}               #Variável faker RG
        Select From List By Label   id=prpemissor_rg                                SSP - Secretaria de Segurança Pública
        Input text                  css=#prpdt_nascimento_fis                       01/01/1990
        Input text                  css=#prpmae                                     ${nomeMae}          #Variável faker Nome Mãe
    # Endereço
        Input text                  css=#prpno_cep1                                 80320180
        Input text                  css=#prpno_endereco1                            1234
        Input text                  css=#prpcompl1                                  bloco 1 ap 1
        Input text                  css=#prpfone1                                   ${fone1}            #Variável faker fone 1
        Input text                  css=#prpfone2                                   ${fone2}            #Variável faker fone 2
        Input text                  css=#prpfone3                                   ${fone3}            #Variável faker fone 3
        Input text                  css=#prpemail                                   ${email}            #Variável faker Email
        Input text                  css=#prpemail_nfe                               ${emailFinanceiro}  #Variável faker email Financeiro
        Click Element               xpath=//input[@id='copiar_dados_cobranca']
        Click Element               xpath=//input[@id='copiar_dados']
    # Dados do Veículo
        Input text                  css=#prpchassi                                  ${chassi}           #Variável faker CHASSI
        Input text                  css=#prpplaca                                   ${placa}            #Variável faker PLACA
        Select From List By Label   id=prpmcaoid                                    8.160 DRC
        Sleep                       2
        Select From List By Label   id=prpmlooid                                    TESTE
        Input text                  css=#prpno_ano                                  2017
        Input text                  css=#prpcor                                     ${cor}
        Input text                  css=#prprenavam                                 ${chassi}           #variável faker Renavam
        Click Element               xpath=//input[@id='bt_add_veiculo']
        Sleep                       2
    # Dados Comerciais
        Select From List By Label   id=execcontas                                   ALINE CAVALCANTE TEIXEIRA
    # Pagamento
        Sleep                       4
        Select From List By Label   css=#prpforcoid                                 Dinheiro
        Sleep                       4
        Select From List By Label   id=prpdia_vcto_boleto                           28
    # Produto
        Select From List By Label   id=prpeqcoid                                    ${tipoContrato}  #VARIAVEL PARAMETRO TIPO CONTRATO
        Select From List By Label   id=prpcpvoid                                    999 x
        Sleep                       5
        Input text                  css=#prpvl_servico                              ${valorService}  #Variável PARAMETRO valor Serviço                              
        Input text                  id=prpvl_monitoramento                          ${valorMonitoramento}  #Variável PARAMETRO valor Monitoramento
        Input text                  id=valorTaxaInstalacao                          ${valorTaxa}
        Select From List By Label   id=prpprazo_contrato                            15
    # Pessoas Autorizadas 
        Input text                  css=#prcnome_aut                                ${nome} 
        Input text                  css=#prccpf_aut                                 ${cpf}
        Input text                  css=#prcrg_aut                                  ${rg}
        Input text                  css=#prcfone_res_aut                            ${fone1}
        #Input text                  css=#prcemail_aut                               ${email} 
        Click Element               css=#bt_add_aut
        Sleep                       2
        Click Element               css=#replicar_aut
        Select From List By Label   id=replicar_aut                                 Todos
  # Confirmação
        Sleep                       5
        Click Element               css=#bt_confirmar
    # Pegar o contrato criado
        ${contrato}                 Get WebElement                                  css:.tdc > td:nth-child(7)
        Click Element               css=.tdc > td:nth-child(7)
        Evidencia                   contrato.${contrato.text}
        [return]                    ${contrato.text}

#Keyword que recebe 4 argumentos, para criar contratos PJ
Novo Contrato PJ
    [Arguments]                     ${tipoContrato}  ${valorService}  ${valorMonitoramento}	${valorTaxa}	
        #Variáveis 
            ${cnpj}                     FakerLibrary.Cnpj                               #Geração de um CNPJ Fake
            ${contratante}              FakerLibrary.Name                               #Geração de um Nome Fake
            ${cpf}                      FakerLibrary.Cpf                                #Geração de um CPF Fake
            ${rg}                       FakerLibrary.Rg                                 #Geração de um RG Fake
            ${nome}                     FakerLibrary.Name                               #Geração de um Nome Fake
            ${email}                    FakerLibrary.Email                              #Geração de um Email Fake
            ${emailFinanceiro}          FakerLibrary.Email                              #Geração de um email financeiro Fake
            ${chassi}                   FakerLibrary.Ean                                #Geração de um número Fake
            ${placa}                    FakerLibrary.Ean 8                              #Geração de uma placa Fake
            ${fone1}                    FakerLibrary.Phone Number                       #Geração de um telefone fake
            ${fone2}                    FakerLibrary.Phone Number                       #Geração de um telefone fake
            ${fone3}                    FakerLibrary.Phone Number                       #Geração de um telefone fake
            ${ano}                      FakerLibrary.year                               #Geração de um ano fake
            ${cor}                      FakerLibrary.color name                         #Geração de uma cor fake
            ${texto}                    FakerLibrary.text                               #Geração de um texto fake

        # Caminho para a tela Pré-cadastro
            Click Element               xpath=//a[contains(text(),'Principal')]
            Click Element               xpath=//a[contains(@href, 'pre_cadastro.php')]
            Click Element               xpath=//input[@name='bt_envia']
            Click Element               xpath=//select[@id='id_proposta']
        # Dados Principais
            Select From List By Label   id=id_proposta                                  Mensalidade Locação
            Select From List By Label   xpath=//select[@id='prptpcoid']                 Cliente
        # Dados do Contratante
            Click Element               xpath=//input[@id='prptipo_pessoa_jur']
        # Pessoa Jurídica
            Input text                  css=#prpno_cpf_cgc_jur                          ${cnpj}             #Variável faker CNPJ 
            Select From List By Label   css=#prpoptante_simples                         Sim
            Input text                  css=#prplocatario_jur                           ${contratante}      #Variável faker Nome Contratante
            Select From List By Label   css=#prpinscricao_uf                            PR
            #Click Element               css=#chk_prpinscricao                           
        # Endereço
            Input text                  css=#prpno_cep1                                 80620210
            Input text                  css=#prpno_endereco1                            1234
            Input text                  css=#prpcompl1                                  bloco 1 ap 1
            Input text                  css=#prpfone1                                   ${fone1}            #Variável faker fone 1
            Input text                  css=#prpfone2                                   ${fone2}            #Variável faker fone 2
            Input text                  css=#prpfone3                                   ${fone3}            #Variável faker fone 3
            Input text                  css=#prpemail                                   ${email}            #Variável faker Email
            Input text                  css=#prpemail_nfe                               ${emailFinanceiro}  #Variável faker email Financeiro
            Click Element               xpath=//input[@id='copiar_dados_cobranca']
            Click Element               xpath=//input[@id='copiar_dados']
        # Dados do Veículo
            Input text                  css=#prpchassi                                  ${chassi}           #Variável faker CHASSI
            Input text                  css=#prpplaca                                   ${placa}            #Variável faker PLACA
            Select From List By Label   id=prpmcaoid                                    8.160 DRC
            Sleep                       2
            Select From List By Label   id=prpmlooid                                    TESTE 
            Input text                  css=#prpno_ano                                  2017
            Input text                  css=#prpcor                                     ${cor}
            Input text                  css=#prprenavam                                 ${chassi}           #variável faker Renavam
            Click Element               xpath=//input[@id='bt_add_veiculo']
            Sleep                       2
        # Dados Comerciais
            Select From List By Label   id=execcontas                                   ALINE CAVALCANTE TEIXEIRA
        # Pagamento
            Sleep                       4
            Select From List By Label   css=#prpforcoid                                 Dinheiro
            Sleep                       4
            Select From List By Label   id=prpdia_vcto_boleto                           28
        # Produto
            Select From List By Label   id=prpeqcoid                                    ${tipoContrato}  #VARIAVEL PARAMETRO TIPO CONTRATO
            Select From List By Label   id=prpcpvoid                                    999 x
            Sleep                       5
            Input text                  css=#prpvl_servico                              ${valorService}  #Variável PARAMETRO valor Serviço                              
            Input text                  id=prpvl_monitoramento                          ${valorMonitoramento}  #Variável PARAMETRO valor Monitoramento
            Input text                  id=valorTaxaInstalacao                          ${valorTaxa}
            Select From List By Label   id=prpprazo_contrato                            24
        # Pessoas Autorizadas 
            Input text                  css=#prcnome_aut                                ${nome} 
            Input text                  css=#prccpf_aut                                 ${cpf}
            Input text                  css=#prcrg_aut                                  ${rg}
            Input text                  css=#prcfone_res_aut                            ${fone1}
            #Input text                  css=#prcemail_aut                               ${email} 
            Click Element               css=#bt_add_aut
            Sleep                       2
            Click Element               css=#replicar_aut
            Select From List By Label   id=replicar_aut                                 Todos
        # Confirmação
            Sleep                       5
            Click Element               css=#chk_prpinscricao                           
            Click Element               css=#bt_confirmar
        # Pegar o contrato criado
            ${contrato}                 Get WebElement                                  css:.tdc > td:nth-child(7)
            Click Element               css=.tdc > td:nth-child(7)
            Evidencia                   contrato.${contrato.text}
            [return]                    ${contrato.text}
        
#Keyword que recebe o termo, para confirmar e gerar
Geração de contrato 
        [Arguments]                 ${termo}
    # Encerra a sessão da criação do contrato e inicia a dos passos para geração do contrato
        Encerra Sessão
        Nova Sessão
    # Caminho para a tela Pré-cadastro
        Click Element               xpath=//a[contains(text(),'Principal')]
        Click Element               xpath=//a[contains(@href, 'pre_cadastro.php')]
    # Pesquisa pelo termo
        Input text                  css=#prptermo_pesquisa                          ${termo}  #Variável para o termo
        Click Element               xpath=//input[@name='pesquisar']
        Click Element               css=.it_link
    # Gerar contrato
        Switch Window               NEW
        Get Location
        #Sleep                       5
        Click Element               id=bt_gerar
        Sleep                       5
        Evidencia                   contratoGerado
        Encerra Sessão

#Keyword que recebe o nome, numero do contrato, nome do acessório, valor e gera aditivo de Hardware
Geração aditivo Hardware
        [Arguments]                 ${name}     ${numeroContrato}   ${nomeAcessorio}   ${valorAcessorio}
    #Variáveis
        ${nome}                     FakerLibrary.Name                               #Geração de um Nome Fake
        ${email}                    FakerLibrary.Email                              #Geração de um Email Fake
        ${emailFinanceiro}          FakerLibrary.Email                              #Geração de um email financeiro Fake
        ${fone}                     FakerLibrary.Phone Number                       #Geração de um telefone fake             
    # Caminho até a tela de geração de termos aditivos de Hardware
        Click Element               xpath=//a[contains(text(),'Principal')]
        Click Element               xpath=//a[contains(@href, 'cad_termo_aditivo_servicos.php')]     
        Click Element               xpath=//input[@id='btNovo']
    # Pesquisa pelo nome do cliente e escolha do mesmo
        Input text                  xpath=//input[@id='clienteNome']                ${name}
        Click Element               xpath=//input[@id='bt_pesquisar']
        Click Element               css=#frm > div > table > tbody > tr:nth-child(3) > td > table:nth-child(3) > tbody > tr:nth-child(5) > td:nth-child(1) > a
    # Inserção dos dados para geração do termo aditivo                                      
        Input text                  xpath=//input[@id='reponsavel']                 ${nome}
        Input Text                  xpath=//input[@id='emailResponsavel']           ${email}
        Input Text                  xpath=//input[@id='telResponsavel']             ${fone}
        Input Text                  xpath=//input[@id='emailSupervisor']            ${emailFinanceiro}
        Sleep                       1
        Select From List By Label   id=contrato_combo                               ${numeroContrato}
        Sleep                       1
        Select From List By Label   id=atuador                                      ${nomeAcessorio}
        Select From List By Label   id=tadprazo_contrato                            12
        Select From List By Label   id=situacao                                     Locação
        Sleep                       1
        Input Text                  xpath=//input[@id='valorAlterado']              ${valorAcessorio}
        #Input Text                  xpath=//input[@id='valorDesconto']              ${valorDesconto}
    # Botão para adicionar o termo aditivo
        Click Element               xpath=//input[@id='btAddAtuadores']
        Sleep                       1
        Evidencia                   aditivoHardwareAdicionado
    # Confirmação e autorização do termo aditivo
        Select From List By Label   id=tadprazo_contrato                            12
        Select From List By Label   id=tadcpvoid                                    999 x
        Click Element               xpath=//input[@id='bt_pesquisar']
        Click Element               xpath=//input[@value='Autorizar (Cadastro)']
        Evidencia                   aditivoAutorizadoCadastro
        Click Element               xpath=//input[@value='Autorizar (Técnico)']
        Evidencia                   aditivoAutorizadoTecnico
        Click Element               xpath=//input[@id='bt_retornar']
        Handle Alert
#Keyword que recebe o nome, contrato, serviço, tipo e valor e gera o aditivo de Software
Geração aditivo Software
    [Arguments]                     ${nomeCliente}  ${contrato}  ${servico}  ${tipoServico}  ${valor}              
    # Caminho até a tela de geração de termos aditivos de Software
        Click Element               xpath=//a[contains(text(),'Principal')]
        Click Element               xpath=//a[contains(@href, 'prn_termo_aditivo_servico.php')] 
        Evidencia                   PesquisaCliente    
        Click Element               xpath=//button[@id='novo']
    # Pesquisa pelo nome do cliente e escolha do mesmo
        Click Element               xpath=//input[@id='cliente']
        Input text                  id=cliente                                          ${nomeCliente}
        Click Element               xpath=//button[@id='pesquisar_cliente']
        Sleep                       3
        Click Element               xpath=//div[@id='div_content_result_pesquisa']/div[4]
        Select From List By Label   css=#situacao                                       Faturamento Mensal
        Evidencia                   PaginaAditivoSoftware
        Click Element               xpath=//button[@id='confirmar']
        Sleep                       5
    # Inserção dos dados para geração do termo aditivo de Software
        Select From List By Label   xpath=//select[@id='tipo_serv_pac']                 ${servico}
        Select From List By Label   xpath=//select[@id='pacote']                        ${tipoServico}
        Input Text                  xpath=//input[@id='contrato']                       ${contrato}
        Input Text                  xpath=//input[@id='valor_negociado']                ${valor}
        Click Element               xpath=//button[@id='adicionar_servico']
        Select From List By Label   css=#status                                         APROVADO/CONCLUÍDO
        Evidencia                   ConfirmaAditivo
        Click Element               xpath=//button[@id='confirmar']
        Click Element               xpath=//button[@id='retornar']
        Click Element               xpath=//button[@id='pesquisar']
        Sleep                       3


#Teste pra escolher classe do contrato
Classe Contrato 
    #Variáveis
        #${classe1}=     Set Variable    1 
        ${classe2}=     Set Variable    2
        #${classe3}=     Set Variable    3
        ${classe4}=     Set Variable    4
        ${classe5}=     Set Variable    5
        ${classe6}=     Set Variable    6
        ${classe7}=     Set Variable    7
        ${classe8}=     Set Variable    8
        ${classe9}=     Set Variable    9
        ${classe10}=    Set Variable    10
        #${classe11}=    Set Variable    11

        ${random}=      Evaluate        random.randint(4, 10)
        #${random}=      Set Variable    11

            
        #CCO - MONITORAMENTO LOGÍSTICO  2
        #GF - CONTROLE DE CUSTOS        3
        #GPS/GSM                        4
        #GSM/GPS PLUS                   5
        #RF NACIONAL                    6
        #SASCARGA                       7
        #SASCARGA FULL SAT 500          8
        #SASMDT                         9
        #SASTM FULL SAT III             10
        #SASMDT COM TELEMTRIA           11

    #Retorno das Classes
        #IF    '${random}' == '${classe1}'    
                #${classe.nome} =            Set Variable    BT AEROPORTOS	
                #${classe.valorMonit}=       Set Variable    15000
                #${classe.valorServ}=	     Set Variable    15000
                #${classe.valorTax}=         Set Variable    1000
        #END

        IF    '${random}' == '${classe2}'    
                ${classe.nome} =            Set Variable    CCO - MONITORAMENTO LOGÍSTICO	
                ${classe.valorMonit}=       Set Variable    5000
                ${classe.valorServ}=	    Set Variable    5000
                ${classe.valorTax}=         Set Variable    2500
        END

        #IF    '${random}' == '${classe3}'    
                #${classe.nome} =            Set Variable    GF - CONTROLE DE CUSTOS	
                #${classe.valorMonit}=       Set Variable    5500
                #${classe.valorServ}=	     Set Variable    5500
                #${classe.valorTax}=         Set Variable    7690
        #END

        IF    '${random}' == '${classe4}'    
                ${classe.nome} =            Set Variable    GPS/GSM	
                ${classe.valorMonit}=       Set Variable    7000
                ${classe.valorServ}=	    Set Variable    7000
                ${classe.valorTax}=         Set Variable    8500
        END

        IF    '${random}' == '${classe5}'    
                ${classe.nome} =            Set Variable    GSM/GPS PLUS	
                ${classe.valorMonit}=       Set Variable    6000
                ${classe.valorServ}=	    Set Variable    6000
                ${classe.valorTax}=         Set Variable    9000
        END

        IF    '${random}' == '${classe6}'    
                ${classe.nome} =            Set Variable    RF NACIONAL
                ${classe.valorMonit}=       Set Variable    5500
                ${classe.valorServ}=	    Set Variable    5500
                ${classe.valorTax}=         Set Variable    18000
        END

        IF    '${random}' == '${classe7}'    
                ${classe.nome} =            Set Variable    SASCARGA
                ${classe.valorMonit}=       Set Variable    10000
                ${classe.valorServ}=	    Set Variable    10000
                ${classe.valorTax}=         Set Variable    11590
        END

        IF    '${random}' == '${classe8}'    
                ${classe.nome} =            Set Variable    SASCARGA FULL SAT 500
                ${classe.valorMonit}=       Set Variable    18300
                ${classe.valorServ}=	    Set Variable    18300
                ${classe.valorTax}=         Set Variable    12900
        END

        IF    '${random}' == '${classe9}'    
                ${classe.nome} =            Set Variable    SASMDT
                ${classe.valorMonit}=       Set Variable    10500
                ${classe.valorServ}=	    Set Variable    10500
                ${classe.valorTax}=         Set Variable    10000
        END

        IF    '${random}' == '${classe10}'    
                ${classe.nome} =            Set Variable    SASTM FULL SAT III
                ${classe.valorMonit}=       Set Variable    27000
                ${classe.valorServ}=	    Set Variable    27000
                ${classe.valorTax}=         Set Variable    13000
        END
        
        #IF    '${random}' == '${classe11}'    
                #${classe.nome} =            Set Variable    SASMDT COM TELEMETRIA
                #${classe.valorMonit}=       Evaluate        random.randint(8000, 22000)
                #${classe.valorServ}=        Evaluate        random.randint(8000, 22000)
                #${classe.valorTax}=         Evaluate        random.randint(5000, 15000)
        #END

    [return]     ${classe}

