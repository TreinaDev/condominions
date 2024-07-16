import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="units"
export default class extends Controller {
  static targets = [ 'tower', 'unit' ]

  searchUnits(towerId){
    fetch(`${window.origin}/units/find_units?id=${towerId}`)
    .then((response)=>{
      return response.json()
    })
    .then((units)=>{
      this.unitTarget.innerHTML = ""
      units.forEach(unit => {
        this.unitTarget.options.add(new Option(unit.short_identifier, unit.id))
      });

    })
    .catch(()=>{this.unitTarget.options.add(new Option('', ''))})
    
  }
  

  connect() {
    this.changeTower()
  }

  changeTower() {
    const towerId = this.towerTarget.value

    this.searchUnits(towerId)
  }

}
