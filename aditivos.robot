*** Settings ***
Resource                        base.robot

Test Setup                      Nova Sessão  
Test Teardown                   Encerra Sessão

*** Test Cases ***
Cadastro de termo aditivo de Hardware
    Geração aditivo Hardware    				Renan Mendes        1050708674     LOCAÇÃO TRAVA DE 5ª RODA   N   


#Cadastro de termo aditivo de Software
    #Geração aditivo Software        Robot Marlon I  1050708105  Pacote Rastreamento  Sensor de Porta  10,00