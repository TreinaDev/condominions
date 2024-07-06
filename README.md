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

<p align="justify">Usuários administrativos podem cadastrar um condomínio com endereço, podem cadastrar torres, tipos de unidade, unidade de um condomínio, andares e áreas comuns.</p>

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<div id='instalacao-e-execucao'/> 

## Endpoints da API

### Endpoint de Listagem de Condomínios
`GET /api/v1/condos`

<p align="justify">Retorna todos os condomínios com o id, nome, cidade e estado de cada um, ou retorna um vetor vazio caso não exista nenhum condomínio cadastrado.</p>

Exemplo de Resposta:
```
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

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

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