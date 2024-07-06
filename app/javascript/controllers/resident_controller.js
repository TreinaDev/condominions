import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'condo', 'tower', 'floor', 'unit' ]

  searchTowers(condoId){
    fetch(`${window.origin}/residents/find_towers?id=${condoId}`)
    .then((response)=>{
      return response.json()
    })
    .then((towers)=>{
      this.towerTarget.innerHTML = ""
      towers.forEach(tower => {
        this.towerTarget.options.add(new Option(tower.name, tower.id))
      });
      this.towers = towers
      this.changeTower()
    })
    .catch(()=>{console.log('Towers not found')})
  }

  connect(){
    this.changeCondo()
  }

  changeCondo(){
    const condoId = this.condoTarget.value
    
    this.searchTowers(condoId)
  }

  changeTower(){
    let tower = this.towers[this.towerTarget.selectedIndex]
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