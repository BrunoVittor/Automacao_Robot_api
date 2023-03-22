*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections
Library    yaml

*** Keywords ***

Criar um novo usuario 
    ${palavra_aleatoria}    Generate Random String    length=4    chars=[LETTERS]
    ${palavra_aleatoria}    Convert To Lower Case    ${palavra_aleatoria}
    Set Test Variable       ${USER_EMAIL}    ${palavra_aleatoria}@emailteste.com 
    Log    ${USER_EMAIL}

Cadastrar usuario no site serverest.dev
    [Arguments]    ${email}    ${status_code_wanted}
    ${body}    Create Dictionary    
    ...    nome=Fulano da Silva    
    ...    email=${email}    
    ...    password=1234    
    ...    administrador=true

    Criar sessão na servrest

    ${response}    POST On Session    
    ...    alias=servrest    
    ...    url=/usuarios
    ...    json=${body}
    ...    expected_status=${status_code_wanted}
    
    IF    ${response.status_code} == 201
        Set Test Variable    ${USER_ID}    ${response.json()["_id"]}
    END
    
    Set Test Variable    ${RESPONSE}   ${response.json()}
    
Criar sessão na servrest
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=servrest    url=https://serverest.dev    headers=${headers}

Conferir se o usuario foi cadastrado
    Log    ${RESPONSE}

    Dictionary Should Contain Item    
    ...    ${RESPONSE}   
    ...    key=message    
    ...    value=Cadastro realizado com sucesso
    
    Dictionary Should Contain Key    
    ...    ${RESPONSE}    
    ...    key=_id
    
Repetir cadastro do ussuario    
    Cadastrar usuario no site serverest.dev    ${USER_EMAIL}    400

Verificar se a API não permitiu o cadastro ja existente
    Dictionary Should Contain Item    ${RESPONSE}    key=message    value=Este email já está sendo usado

Consultar usuário via id
    ${user_data}    GET On Session    
    ...    alias=servrest    
    ...    url=/usuarios/${USER_ID}
    Set Test Variable    ${user_data}    ${user_data.json()}

Consultar dados do novo usuário cadastrado
    Dictionary Should Contain Item    ${user_data}    nome             Fulano da Silva
    Dictionary Should Contain Item    ${user_data}    email            ${USER_EMAIL}
    Dictionary Should Contain Item    ${user_data}    password         1234
    Dictionary Should Contain Item    ${user_data}    administrador    true
    Dictionary Should Contain Item    ${user_data}    _id              ${USER_ID}

Realizar login
    [Arguments]    ${email}
    ${body}    Create Dictionary    
    ...    email=${email}    
    ...    password=1234    
    POST On Session    alias=servrest    url=/login    json=${body}