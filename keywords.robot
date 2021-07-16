*** Settings ***
Library       SeleniumLibrary
Library       String
Library       Library.py
Resource      elements.resource

*** Keywords ***
Abrir Navegador Maximizado
    # Abre o novegador chrome e maximiza a janela do mesmo.
    Log To Console  Abrindo navegador maximizado
    Open Browser    about:blank   chrome
    Maximize Browser Window

Buscar IP Externo
    # Navega para obter o ip externo, obtém e seta o mesmo como variável global
    Log To Console  Buscando ip externo
    Go To    https://www.whatismyip.com/
    Wait Until Element Is Visible  ${myip.ipv4}
    ${ip}=  Get Text    ${myip.ipv4}
    Set Global Variable      ${ip}

Nome da Nova Chave
    # Incrementar o contador da chave, ex: key1 -> key2
    Log To Console  Gerando novo nome para chave
    ${count}=       Get Element Count    ${clash.item_key}
    ${key_name}=    Set Variable    key1
    IF  ${count} > 0
        ${key_name}=    Get Text    ${clash.last_key_name}
        ${key_name}=    Get Substring     ${key_name}     3
        ${key_name}=    Convert To Integer     ${key_name}
        ${key_name}=    Evaluate    ${key_name}+1
        ${key_name}=    Catenate    SEPARATOR=  key   ${key_name}
    END
    [Return]    ${key_name}

Ir Para Minha Conta
    # Navegar para "My Account"
    Log To Console  Navegando para "Minha Conta"
    Wait Until Element Is Visible   ${clash.menu_account}
    Click Element                   ${clash.dropdown_menu_account}
    Click Element                   ${clash.my_account}
    Wait Until Element Is Visible   ${clash.list_keys}

Criar Chave
    # Cria uma nova chave
    Ir Para Minha Conta
    Log To Console  Criando Nova Chave
    ${key_name}=    Nome da Nova Chave
    ${desc}=        Catenate        description of   ${key_name}
    Wait Until Element Is Visible   ${clash.btn_create_new_key}
    Click Element                   ${clash.btn_create_new_key}
    Input Text      name            ${key_name}
    Input Text      description     ${desc}
    Input Text      range-0         ${ip} 
    Submit Form

Login Clash Royale
    # Navega para developer.clashroyale.com e realizar o login
    Log To Console  Realizando Log In no site developer.clashroyale.com
    [Arguments]     ${user_email}   ${user_psw}
    Go To    https://developer.clashroyale.com/
    Wait Until Element Is Visible   ${clash.cookie_consent}
    Click Element                   ${clash.cookie_consent}
    Wait Until Element Is Visible   ${clash.menu}
    Click Element                   ${clash.btn_login}
    Wait Until Element Is Visible   ${clash.form_login}
    Input Text         email        ${user_email}
    Input Password     password     ${user_psw}
    Submit Form

Buscar API Token
    # Navega para "My Account" e pega o Token da última chave criada
    Ir Para Minha Conta
    Log To Console  Buscando Token para acessar API do clashroyale
    ${count}=       Get Element Count    ${clash.item_key}
    IF  ${count} == 0
        Criar Chave
        Wait Until Element Is Visible    ${clash.list_keys}
    END
    ${count}=   Get Element Count    ${clash.item_key}
    IF  ${count} > 0
        Click Element           ${clash.last_key_name}
        ${api_token}=           Get Text         ${clash.api_token}
        Set Api Token           ${api_token}
        Click Element           ${clash.back_to_mykeys}
    ELSE
        Log To Console          Nenhuma key disponível e não foi possível criar uma nova
    END

Buscar Membros do Clan
    # Busca clan, os integrantes do mesmo e então gera um arquivo com as informações básicas
    [Arguments]     ${name}      ${tag}
    ${full_tag}=    Run Keyword  Get Clan  ${name}  ${tag}
    IF  '${full_tag}' != 'None'
        Run Keyword      Get Members  ${full_tag}
    ELSE
        Log To Console   Nenhum clan encontrado com os dados inseridos.
    END
    
Sair e Fechar
    # Efetua logout e fecha o navegador
    Log To Console  Efetuando Log Out e fechando navegador.
    Click Element   ${clash.dropdown_menu_account}
    Click Element   ${clash.logout}
    Close Browser