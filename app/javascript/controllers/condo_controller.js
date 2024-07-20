import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["divBody"]
    connect() {
        const condoId = this.element.getAttribute('condo-id')
        this.find_residents(condoId)
    };

    search(element) {
        const search = element.target.value
        console.log(search)
        if (search == '') {
            this.divBodyTarget.innerHTML = ''
            if (this.residents.length == 0) {
                this.divBodyTarget.innerHTML = "<p>Não existem moradores Cadastrados.</p>"
            } else {
                this.create_resident_list(this.residents)
            }
        } else {
            const filter_residents = this.residents.filter((resident) => {
                return resident.full_name.toUpperCase().includes(search.toUpperCase())
            })
            this.divBodyTarget.innerHTML = ''
            if (filter_residents.length == 0) {
                this.divBodyTarget.innerHTML = "<p>Morador não encontrado.</p>"
            } else {
                this.create_resident_list(filter_residents)
            }
        }
    };

    create_resident_list(residents) {
        residents
            .sort((firstResident, secondResident) => {
                if (firstResident.id < secondResident.id) return 1
                if (firstResident.id > secondResident.id) return -1
                return 0
            })
            .forEach(resident => {
                this.divBodyTarget.innerHTML += this.html_resident(resident)
            });
    }

    find_residents(condoId) {
        fetch(`${window.origin}/condos/${condoId}/residents`)
            .then((response) => {
                return response.json()
            })
            .then((residents) => {
                this.residents = residents
                var residents = residents
                if (residents.length == 0) {
                    this.divBodyTarget.innerHTML = "<p>Não existem moradores Cadastrados.</p>"
                } else {
                    this.create_resident_list(residents)
                }
            })
            .catch(() => { console.log('Towers not found') })
    };

    html_resident(resident) {
        const html = `
      <div class="d-flex align-items-center my-1">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
          <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0"/>
          <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8m8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1"/>
        </svg>
        <p class="m-0 ms-1">${resident.full_name}</p>
        <a href='/residents/${resident.id}' id='resident-${resident.id}' class="ms-auto btn btn-dark d-inline-flex align-items-center rounded-pill">
          <p class="m-0 fs-sm">Visualizar</p> <i class="bi bi-search ms-1"></i>
        </a>
      </div>
      <hr class="m-0">
      `
        return html
    }
}