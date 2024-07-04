// app/javascript/controllers/ola_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
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