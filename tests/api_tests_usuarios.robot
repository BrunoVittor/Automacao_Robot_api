*** Settings ***
Resource    ../resources/api_tests_usuarios.resource

*** Test Cases ***
Cenário 1: Cadastrar um novo usuário no site serverest.dev
    Criar um novo usuario
    Cadastrar usuario no site serverest.dev    ${USER_EMAIL}    201
    Conferir se o usuario foi cadastrado

Cenário 2: Cadastrar um ususário existente
    Criar um novo usuario
    Cadastrar usuario no site serverest.dev    ${USER_EMAIL}    201
    Repetir cadastro do ussuario
    Verificar se a API não permitiu o cadastro ja existente

Cenário 3: Consultar um usuário cadastrado
    Criar um novo usuario
    Cadastrar usuario no site serverest.dev    ${USER_EMAIL}    201
    Consultar usuário via id
    Consultar dados do novo usuário cadastrado

Cenário 4: Realizando login com usuário cadastrado
    Criar um novo usuario
    Cadastrar usuario no site serverest.dev    ${USER_EMAIL}    201
    Realizar login                             ${USER_EMAIL}
    Conferir se o Login ocorreu com sucesso
