<a id="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]


<!-- PROJECT LOGO -->
<br />
<div align="center">

  <h2 align="center">CondoMinion</h2>

  <p align="center">
    Projeto desenvolvido na Vivência em Time do TreinaDev12.
    <br />
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
      </ul>
    </li>
  </ol>
</details>


<div id='sobre-o-projeto'/> 

<!-- Sobre o projeto -->
## Sobre o projeto

Condominions consiste em um sistema que, integrado à aplicação [PagueAluguel](https://github.com/TreinaDev/pague-aluguel), pode ser utilizado por uma equipe administrativa e moradores para gerenciamento de imóveis e outras
atividades dentro de um condomínio. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<div id='tecnologias' />

### Tecnologias

* [![Ruby][Ruby.com]][Ruby-url]
* [![RubyOnRails][RubyOnRails.com]][RubyOnRails-url]
* [![Vue][Vue.js]][Vue-url]
* [![Bootstrap][Bootstrap.com]][Bootstrap-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<div id='funcionalidade' />

## Funcionalidades

 Usuários administrativos podem ser cadastrados no sistema e usuários proprietários e moradores podem ser convidados por e-mail a se registrar.


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<div id='instalacao-e-execucao'/> 

<!-- GETTING STARTED -->
## Instalação e Execução

<div id='pre-requisitos'/> 

### Pré-Requisitos

Você vai precisar da versão 3.2.2 do Ruby, libvips e uma versão atual de NodeJS com Yarn instalado. Recomendamos sempre a instalação das versões LTS (Long Term Support).

#### Instalação do [libvips](https://github.com/libvips/libvips/wiki/Build-for-Ubuntu) no ubuntu:
```sh
sudo apt install libvips
```

<div id='instalacao'/> 

### Instalação do projeto

No terminal, clone o projeto:
```sh
https://github.com/TreinaDev/condominions.git
```
Entre na pasta do projeto:
```sh
cd condominions
```
Instale as dependecias:
```sh
bin/setup
```

<div id='execucao-de-testes'/> 

### Execução de testes
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

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<div id='estrutura-banco-de-dados'/> 

## Estrutura do banco de dados



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
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/othneildrew
[product-screenshot]: images/screenshot.png
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://v2.vuejs.org/
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[Ruby.com]: https://img.shields.io/static/v1?label=Ruby&message=3.2.2&color=red&style=for-the-badge&logo=ruby
[Ruby-url]: https://www.ruby-lang.org/en/news/2023/03/30/ruby-3-2-2-released/
[RubyOnRails.com]: https://img.shields.io/static/v1?label=Ruby%20On%20Rails%20&message=7.1.2&color=red&style=for-the-badge&logo=ruby
[RubyOnRails-url]: https://rubyonrails.org/2023/11/10/Rails-7-1-2-has-been-released
