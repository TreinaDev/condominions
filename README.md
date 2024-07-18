<a id="readme-top"></a>

<div align="center">

  [![Contributors][contributors-shield]][contributors-url]
  [![Stargazers][stars-shield]][stars-url]
  [![Issues][issues-shield]][issues-url]
  [![MIT License][license-shield]][license-url]
  [![Status][status-shield]][status-url]

</div>

<!-- PROJECT LOGO -->
<br/>
<div align="center">

  <h1 align="center">CondoMinions</h1>

  <p align="justify">
    Projeto desenvolvido na Vivência em Time do TreinaDev 12.
    <br/>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details open>
  <summary>Sumário</summary>
  <ol>
    <li>
      <a href="#sobre-o-projeto">Sobre o projeto</a>
      <ul>
        <li><a href="#Tecnologias">Tecnologias</a></li>
        <li><a href="#funcionalidade">Funcionalidade</a></li>
        <li><a href="#endpoints-da-api">Endpoints da API</a></li>
      </ul>
    </li>
    <li>
      <a href="#instalacao-e-execucao">Instalação e Execução</a>
      <ul>
        <li><a href="#pre-requisitos">Pré-Requisitos</a></li>
        <li><a href="#instalacao">Instalação</a></li>
        <li><a href="#execucao-de-testes">Execução de testes</a></li>
        <li><a href="#execucao-da-aplicacao">Execução da aplicação</a></li>
        <li><a href="#estrutura-banco-de-dados">Estrutura banco de dados</a></li>
        <li><a href="#banco-de-dados">Banco de dados</a></li>
        <li><a href="#desenvolvedores">Desenvolvedores</a></li>
      </ul>
    </li>
  </ol>
</details>

<div id='sobre-o-projeto'/> 

<!-- Sobre o projeto -->
## Sobre o Projeto

<p align="justify">CondoMinions consiste em um sistema que, integrado à aplicação <a href="https://github.com/TreinaDev/pague-aluguel">PagueAluguel</a>, pode ser utilizado por uma equipe administrativa e moradores para gerenciamento de imóveis e outras atividades dentro de um condomínio.</p>

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<div id='tecnologias'/>

### Tecnologias

[![Ruby][Ruby.com]][Ruby-url]
[![RubyOnRails][RubyOnRails.com]][RubyOnRails-url]
[![Bootstrap][Bootstrap.com]][Bootstrap-url]
<!-- [![Vue][Vue.js]][Vue-url] -->

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<div id='funcionalidade'/>

## Funcionalidades

<p align="justify">Usuários administrativos podem ser cadastrados no sistema e usuários proprietários e moradores podem ser convidados por e-mail a se registrar.</p>

<p align="justify">Apenas usuários administrativos categorizados como super no momento da criação podem cadastrar outros usuários administrativos, cadastrar um condomínio com endereço e associar um usuário ou mais usuários administrativos àquele condomínio.</p>

<p align="justify">Usuários administrativos regulares podem cadastrar torres, tipos de unidade, unidade de um condomínio, andares, áreas comuns e moradores.</p>

<p align="justify">Tanto administradores quanto moradores podem ver a página de listagem e detalhes de condomínio. Tendo sua exibição alterada para cada tipo de usuário.</p>

<p align="justify">Moradores podem fazer uma reserva de área comum, bem como cancelar essa reserva.</p>

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<div id='instalacao-e-execucao'/> 

## Endpoints da API

### Endpoint de Listagem de Condomínios

`GET /api/v1/condos`

<p align="justify">Retorna todos os condomínios com o id, nome, cidade e estado de cada um.</p>

Exemplo de resposta:
```json
[
  {
    "id": 1,
    "name": "Condomínio Residencial Paineiras",
    "city": "Rio Branco",
    "state": "AC"
  },
  {
    "id": 2,
    "name": "Condomínio dos Rubinhos",
    "city": "Campo Formoso",
    "state": "BA"
  }
]
```

### Endpoint de Detalhes de Condomínio

`GET /api/v1/condos/{id}`

<p align="justify">Retorna os detalhes de um condomínio com o nome, cnpj, logradouro, número, bairro, cidade, estado e cep de cada um.

Retorna erro 404 caso não exista um condomínio cadastrado com esse id.</p>

Exemplo de resposta:
```json
{
  "name": "Condominio Residencial Paineiras",
  "registration_number": "62.810.952/2718-22",
  "address": {
    "public_place": "Travessa João Edimar",
    "number": "29",
    "neighborhood": "João Eduardo II",
    "city": "Rio Branco",
    "state": "AC",
    "zip": "69911-520"
  }
}
```

### Endpoint de detalhes de uma unidade

`GET /api/v1/units/{id}`

<p align="justify">Retorna os detalhes de uma unidade especificada pelo id passado no endpoint, caso exista, senão retorna erro 404 e corpo de resposta nulo.

Exemplo de resposta:

```json

{
  "id": 1,
  "area": "150.45",
  "floor": 1,
  "number": "11",
  "unit_type_id": 1,
  "condo_id": 1,
  "condo_name": "Residencial Paineiras",
  "tenant_id": 1,
  "owner_id": 1,
  "description": "Duplex com varanda"
}

```

Retorna 404 caso não exista um condomínio com o id informado</p>

<p align="justify">Retorna a lista de tipos de unidade registradas em um condomínio e os ids da unidades vinculadas a ele.

Retorna 404 caso não exista um condomínio com o id informado</p>

### Endpoint Listar Tipos de Unidade

`GET /api/v1/condos/{id}/unit_types`

Exemplo de resposta:
```json
[
  {
    "id": 1,
    "description": "Apartamento grande",
    "metreage": "100.0",
    "fraction": "4.0",
    "unit_ids": [
      1,
      2,
      3,
      4,
      6,
      9
    ]
  },
  {
    "id": 2,
    "description": "Apartamento médio",
    "metreage": "70.2",
    "fraction": "2.5",
    "unit_ids": [
      5,
      7,
      8,
      10
    ]
  }
]
```
### Endpoint Listar Unidades

`GET /api/v1/condos/{id}/units`

<p align="justify">Retorna a lista de todas as unidades registradas em um condomínio, com o id de cada unidade, número do andar e identificação de unidade.

Retorna 404 caso não exista um condomínio com o id informado</p>

Exemplo de resposta:

```json
{
  "units": [
    {
      "id": 1,
      "floor": 1,
      "number": "11"
    },
    {
      "id": 2,
      "floor": 1,
      "number": "12"
    }
  ]
}
```

### Endpoint de checar um CPF

`/api/v1/check_owner?registration_number={CPF}`

<p align="justify">Retorna a confirmação se o CPF informado pertence a um usuário da aplicação CondoMinions, ainda retorna o perfil de usuário e o id de sua unidade</p>

Possíveis respostas
```
Retorna 200 se existe um proprietário com o CPF informado na aplicação CondoMinions;
Retorna 404 se não existe um proprietário com o CPF informado na aplicação CondoMínios;
Retorna 412 se o CPF não for válido para consulta.
OBS: Esse Endpoint trata puramente da validação do CPF, o JSON retornado possui corpo vazio.
```

### Endpoint de buscar moradia de um CPF

`/api/v1/get_tenant_residence?registration_number={CPF}`

<p align="justify">Retorna os detalhes da unidade de residência de um morador de determinado CPF</p>

Possíveis respostas
```
Retorna 404 se não existe um proprietário com o CPF informado na aplicação CondoMinions, ou se existe, mas não reside em nenhuma unidade;
Retorna 412 se o CPF não for válido para consulta.
Retorna 200 se o CPF é de um inquilino de alguma unidade e o seguinte JSON
```

```json

{
  "resident": {
    "name": "resident.full_name", "tenant_id": "resident.id",
    "residence": {
      "id": "residence.id", 
      "area": "unit_type.metreage",
      "floor": "residence.floor.identifier",
      "number": "residence.short_identifier",
      "unit_type_id": "unit_type.id",
      "description": "unit_type.description",
      "condo_id": "condo.id",
      "condo_name": "condo.name",
      "owner_id": "residence.owner.id"
      }
  }
}
```
### Endpoint de buscar lista de residências de um CPF

`/api/v1/get_owner_properties?registration_number={cpf}`

<p align="justify">Retorna uma lista com os detalhes das unidades possuídas por um proprietário</p>

Possíveis respostas
```
Retorna 404 se não existe um proprietário com o CPF informado na aplicação CondoMínios, ou se existe, mas não possui nenhuma unidade como propriedade;
Retorna 412 se o CPF não for válido para consulta.
Retorna 200 se o CPF é de um proprietário de alguma unidade e o seguinte JSON
```

```json

{
  "resident": {
    "name": "Cláudia Rodrigues Gomes",
    "owner_id": 1,
    "properties": [
      {
        "id": 1,
        "area": "150.45",
        "floor": 1,
        "number": "11",
        "unit_type_id": 1,
        "description": "Duplex com varanda",
        "condo_id": 1,
        "condo_name": "Residencial Paineiras",
        "tenant_id": 1
      },
      {
        "id": 16,
        "area": "150.45",
        "floor": 4,
        "number": "43",
        "unit_type_id": 1,
        "description": "Duplex com varanda",
        "condo_id": 1,
        "condo_name": "Residencial Paineiras",
        "tenant_id": null
      },
      {
        "id": 17,
        "area": "150.45",
        "floor": 5,
        "number": "51",
        "unit_type_id": 1,
        "description": "Duplex com varanda",
        "condo_id": 1,
        "condo_name": "Residencial Paineiras",
        "tenant_id": null
      }
    ]
  }
}

```


<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

### Endpoint de Listagem de Áreas Comuns

`GET /api/v1/condos/{id}/common_areas`

<p align="justify">Retorna todas as áreas comuns a partir do `id` do condomínio informado, com nome, descrição.</p>

Exemplo de Resposta:

```json
{
  "common_areas": [
    {
      "id": 1,
      "name": "Piscina",
      "description": "Para adultos e crianças"
    },
    {
      "id": 2,
      "name": "Salão de Festas",
      "description": "Salão para vários eventos"
    }
  ]
}

```

<p align="justify">caso não existam áreas comuns cadastradas para o condomínio informado retorna o `id` do condomínio e um array vazio.</p>

<p align="justify">Retorna erro `404` caso o condomínio informado não esteja cadastrado.</p>

### Endpoint de Detalhes de Área Comum

`GET /api/v1/common_areas/{id}`

<p align="justify">Retorna os detalhes de uma área comum específica a partir do `id` da área comum, com nome, descrição, capacidade máxima e regras de uso.</p>

Exemplo de Resposta:
```json
{
    "name": "Piscina",
    "description": "Para adultos e crianças",
    "max_occupancy": 20,
    "rules": "Só pode ser usada até 22h",
    "condo_id": 1
}
```

<p align="justify">Retorna erro `404` caso a área comum informada não esteja cadastrada para o condomínio informado.</p>

<!-- GETTING STARTED -->
## Instalação e Execução

<div id='pre-requisitos'/> 

### Pré-Requisitos

<p align="justify">Você vai precisar da versão 3.2.2 do Ruby, libvips e uma versão atual de NodeJS com Yarn instalado. Recomendamos sempre a instalação das versões LTS (Long Term Support).</p>

#### Instalação do [libvips](https://github.com/libvips/libvips/wiki/Build-for-Ubuntu) no ubuntu:
```sh
sudo apt install libvips
```

<div id='instalacao'/> 

### Instalação do Projeto

No terminal, clone o projeto:
```sh
git clone https://github.com/TreinaDev/condominions.git
```
Entre na pasta do projeto:
```sh
cd condominions
```
Instale as dependências:
```sh
bin/setup
```
Para popular o banco de dados:
```sh
rails db:seed
```

<div id='execucao-de-testes'/> 

### Execução de Testes
Para rodar os testes, execute:
```sh
rake spec
```

<div id='execucao-da-aplicacao'/> 

### Execução da Aplicação
Para rodar a aplicação, execute:
```sh
bin/dev
```
Agora é possível acessar a aplicação a partir da rota http://localhost:3000/

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<div id='estrutura-banco-de-dados'/> 

## Estrutura do Banco de Dados

![Estrutura do banco de dados](https://i.imgur.com/emiKwf5.png)

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<div id='banco-de-dados'/>

## Banco de Dados Iniciais

Dados inseridos no seeds

>Administradores
>>|Nome Completo|CPF|E-mail|Senha|
>>| :--------: | :--------: |:--------: | :--------: |
>>|Murilo Pereira Rocha|745.808.535-55|adm@teste.com|teste123|

>Endereços
>>|Rua|Número|Bairro|Cidade|Estado|CEP|ID|
>>| :--------: | :--------: | :--------: | :--------: | :--------: | :--------: | :--------: | 
>>|Travessa João Edimar|29|João Eduardo II|Rio Branco|AC|69911-520| 1 |

>Condominions
>>|Nome do condomínio|CNPJ|ID do endereço|
>>| :--------: | :--------: | :--------: |
>>|Condominio Residencial Paineiras|62.810.952/2718-22| 1 | 

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<div id='desenvolvedores'/> 

## Desenvolvedores

[<img src="https://avatars.githubusercontent.com/u/86561064?v=4" width=115 > <br> <sub> Danilo Ribeiro </sub>](https://github.com/DaniloRibeiro07) | [<img src="https://avatars.githubusercontent.com/u/92957969?v=4" width=115 > <br> <sub> Lucas Lima </sub>](https://github.com/luckslima) | [<img src="https://avatars.githubusercontent.com/u/86455751?v=4" width=115 > <br> <sub> Lucas Oliveira </sub>](https://github.com/lucasobx)| [<img src="https://avatars.githubusercontent.com/u/90734901?v=4" width=115 > <br> <sub> Marcella Aleo </sub>](https://github.com/cellaaleo)| [<img src="https://avatars.githubusercontent.com/u/57259396?v=4" width=115 > <br> <sub> Rafael Salgado </sub>](https://github.com/RyanOxon)| [<img src="https://avatars.githubusercontent.com/u/75589284?v=4" width=115 > <br> <sub> Rulian Cruz </sub>](https://github.com/ruliancruz)| [<img src="https://avatars.githubusercontent.com/u/127916125?v=4" width=115 > <br> <sub> Thalyta Lima </sub>](https://github.com/thalytalima211)| [<img src="https://avatars.githubusercontent.com/u/88754301?v=4" width=115 > <br> <sub> Vinícius Peruzzi </sub>](https://github.com/Vinigperuzzi)|
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | 

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/TreinaDev/condominions.svg?style=for-the-badge
[contributors-url]: https://github.com/TreinaDev/condominions/graphs/contributors
[stars-shield]: https://img.shields.io/github/stars/TreinaDev/condominions.svg?style=for-the-badge
[stars-url]: https://github.com/TreinaDev/condominions/stargazers
[issues-shield]: https://img.shields.io/github/issues/TreinaDev/condominions.svg?style=for-the-badge
[issues-url]: https://github.com/TreinaDev/condominions
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[status-shield]: https://img.shields.io/static/v1?label=Status&message=Development&color=yellow&style=for-the-badge
[status-url]: https://github.com/TreinaDev/condominions
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://v2.vuejs.org/
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[Ruby.com]: https://img.shields.io/static/v1?label=Ruby&message=3.2.2&color=red&style=for-the-badge&logo=ruby
[Ruby-url]: https://www.ruby-lang.org/en/news/2023/03/30/ruby-3-2-2-released/
[RubyOnRails.com]: https://img.shields.io/static/v1?label=Ruby%20On%20Rails&message=7.1.3.1&color=red&style=for-the-badge&logo=rubyonrails
[RubyOnRails-url]: https://rubyonrails.org/2023/11/10/Rails-7-1-2-has-been-released
[EstruturaDoBancoDeDados-URL]: https://i.imgur.com/emiKwf5.png