//
//  RatingControl.swift
//  MyPlaces
//
//  Created by Admin on 24.01.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    //MARK: Properties
    
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    private var ratingButtons = [UIButton]()
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {   //добавление параметра в storyboard для кнопок в раздел atribute inspector
        didSet {
            setupButtons()
        }
    } //Наблюдатель за свойством starSize, необходим что бы данные передавались из storyboard
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    
    
    //MARK: Initilization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }

    //MARK: Button action
    
    @objc func ratingButtonTapped(button: UIButton) {
       
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        
        //Calculating the rating of the selected buttion
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        
    }
    
    //MARK: Private methods
    
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        //Load button image
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        
        for _ in 0 ..< starCount {
            
            //Create the button
            let button = UIButton()
            
            //Set the buttom image
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constrains
            button.translatesAutoresizingMaskIntoConstraints = false                    //отключает автоматически сгенерированные констрейнты
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true       //задает размер высоты
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true        //задает размер ширины
            
            // Setup the button action
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new buttons in the rating button array
            ratingButtons.append(button)
        }
         updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }

}
