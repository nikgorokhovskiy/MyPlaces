//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Admin on 22.01.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import Cosmos

class NewPlaceViewController: UITableViewController {

    var currentPlace: Place!
    var imageIsChanged = false
    var currentRating = 0.0
    
    @IBOutlet var placeImage: UIImageView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var placeName: UITextField!
    @IBOutlet var placeLocation: UITextField!
    @IBOutlet var placeType: UITextField!
//    @IBOutlet var ratingControl: RatingControl!
    @IBOutlet var cosmosView: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        //устанавливает параметры таблицы(убираем нижнюю черту в последней ячейке
 
        saveButton.isEnabled = false
        
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged) //отслеживание редактирования текстового поля
        
        setupEditScreen() //вызов метода присваивания данных текущей строки в поля формы newPlaces
        
        cosmosView.didTouchCosmos = { rating in
            self.currentRating = rating
        }
    }
    
    //MARK: Table view delegate
    // добавление кнопок всплывающих при тапе на 1 строку таблицы (там где расположено изображение)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")   //добавление константы содержащей иконку
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            
            camera.setValue(cameraIcon, forKey: "image")    //добавление в меню иконки
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")    //смещение текста заголовка кнопки в левый край
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
                
            }
            
            
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .default)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            let identifier = segue.identifier,
            let mapVC = segue.destination as? MapViewController
        else { return }
        
        mapVC.incomeSegueIdentifier = identifier
        mapVC.mapViewControllerDelegate = self
        
        if identifier == "showPlace" {
            mapVC.place.name = placeName.text!
            mapVC.place.location = placeLocation.text!
            mapVC.place.type = placeType.text!
            mapVC.place.imageData = placeImage.image?.pngData()
        }
    }
    
    func savePlace() {
        
        let image = imageIsChanged ? placeImage.image : #imageLiteral(resourceName: "imagePlaceholder")
                
        let imageData = image?.pngData() //конвертация из UIImage типа в тип Data
        
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData,
                             rating: currentRating)
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
                
    }
    
    private func setupEditScreen() {
        if currentPlace != nil {
            
            setupNavigationBar()
            imageIsChanged = true
            
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill //масштабирует изображение по содержимому ImageView
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            cosmosView.rating = currentPlace.rating
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil  //скрываем кнопку "Cancel"
        title = currentPlace?.name              //присваиваем заголовку имя выбраноой строки
        saveButton.isEnabled = true             //активируем кнопку "Save" внезависимости от редактирования поля "name"
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
    // MARK: Text field delegate
    
    extension NewPlaceViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру по нажатию Done
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
        @objc private func textFieldChanged() {
            
            if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
            } else {
                saveButton.isEnabled = false
            }
        
        }
    }

//MARK: Work with image
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true    //Предоставление пользователю прав для редактирования изображения
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage     //выбор отредакрированного изображения
        placeImage.contentMode = .scaleAspectFill     //позволяет редактировать масштаб изображения
        placeImage.clipsToBounds = true               //позволяет обрезать изображение по рамкам
        
        imageIsChanged = true
        
        dismiss(animated: true)                         //закрывает imagePickerController
    }
}

extension NewPlaceViewController: MapViewControllerDelegate {
   
    func getAddress(_ address: String?) {
        placeLocation.text = address
    }
        
}
