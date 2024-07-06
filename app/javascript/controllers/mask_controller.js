import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  registrationNumberFormated(element){
    let button = element.target

    button.value = button.value.replace(/\D+/g, "")
                               .replace(/(\d{3})(\d+)/, "$1.$2")
                               .replace(/(\d{3})(\d+)/, "$1.$2")
                               .replace(/(\d{3})(\d+)/, "$1-$2")
                               .replace(/(-\d{2})\d+$/, '$1')
    
  }
  
  zipPressed(event){
    let button = event.target
    button.value = button.value.replace(/\D/g, '')
                                .replace(/(\d{5})(\d)/, '$1-$2')
                                .replace(/(\d{5}-\d{3})/, '$1')
                                .replace(/(-\d{3})\d+$/, '$1')
  }

  RegistrationNumberPressed(event){
    let button = event.target
    button.value = button.value.replace(/\D/g, '')
                                .replace(/(\d{2})(\d+)/, '$1.$2')
                                .replace(/(\d{3})(\d+)/, '$1.$2')
                                .replace(/(\d{3})(\d+)/, '$1/$2')
                                .replace(/(\d{4})(\d+)/, '$1-$2')
                                .replace(/(-\d{2})\d+$/, '$1')
  }
}


