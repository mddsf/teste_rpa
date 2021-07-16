*** Settings ***
Documentation     Teste Desenvolvedor RPA.
Resource          keywords.robot

*** Variables ***
${clan_name}    The resistance
${clan_tag}     \#9V2Y
${user_email}   mddsf01@gmail.com
${user_psw}     testerpa

*** Test Cases ***
Teste Desenvolvedor RPA
    Abrir Navegador Maximizado
    Buscar IP Externo
    Login Clash Royale          ${user_email}   ${user_psw}
    Criar Chave
    Buscar API Token
    Buscar Membros do Clan      ${clan_name}    ${clan_tag}
    [Teardown]   Sair e Fechar