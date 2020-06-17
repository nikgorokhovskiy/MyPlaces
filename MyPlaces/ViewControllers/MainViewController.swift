//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Admin on 21.01.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let searchController = UISearchController(searchResultsController: nil)
    private var places: Results<Place>!
    private var filteredPlaces: Results<Place>!
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private  var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortingButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        places = realm.objects(Place.self)
        
        //Setup the search controller
        searchController.searchResultsUpdater = self //возврат результатов поиска в этот же класс
        searchController.obscuresBackgroundDuringPresentation = false //позволяет пользователю взаимодействовать с отсортированной информацией
        searchController.searchBar.placeholder = "Search" //надпись в поле поиска до взаимодействия
        navigationItem.searchController = searchController //интеграция поисковой строки в область навигации
        definesPresentationContext = true //позволяет отпустить строку поиска при переходе на другой экран
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredPlaces.count
        }
        return places.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

//        var place = Place()
        
        let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]

        cell.nameLabel?.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        cell.cosmosView.rating = place.rating

        


        return cell
    }

   //MARK: Teble view delegate
    //отмена выделения ячейки при нажатии на нее
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //удаление данных свайпом
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = places[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success)    in
            
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
   
    
     //MARK: - Navigation

   //передача, а точнее изъятие данных текущей строки для передачи в форму NewPlaces для последующего редактирования текущих данных
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
//            let place: Place
//            if isFiltering {
//                place = filteredPlaces[indexPath.row]
//            } else {
//                place = places[indexPath.row]
//            }
            //тоже что и выше только в виде тернарного оператора
            let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
       sorting()
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
       
        ascendingSorting.toggle()

       if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
       } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }

        sorting()
    }

    private func sorting() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}

//MARK: Extension for search

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentSearchText(_ searchText: String) {
        
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        
        tableView.reloadData()
    }
}

