import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'condo', 'tower', 'floor', 'unit' ]
  connect(){
    this.condosJson = JSON.parse(this.element.getAttribute("data-condo-json"))
    this.changeCondo()
  }

  changeCondo(){
    const condoSelected = this.condoTarget.selectedIndex
    const condo = this.condosJson[condoSelected]
    this.towerTarget.innerHTML = ""
    condo.towers.forEach(tower => {
      this.towerTarget.options.add(new Option(tower.name, tower.id))
    });
    this.changeTower()
  }

  changeTower(){
    const condoSelected = this.condoTarget.selectedIndex
    const condo = this.condosJson[condoSelected]
    console.log(condo)
    const towerSelected  = this.towerTarget.selectedIndex
    const tower = condo.towers[towerSelected]
    
    console.log(tower)

    this.unitTarget.innerHTML = ""
    this.floorTarget.innerHTML = ""
    for (let floor = 1; floor <= tower.floor_quantity; floor++) {
      this.floorTarget.options.add(new Option(`${floor}`, `${floor}`))
    }

    for (let unit = 1; unit <= tower.units_per_floor; unit++) {
      this.unitTarget.options.add(new Option(`${unit}`, `${unit}`))
    }
  }
}