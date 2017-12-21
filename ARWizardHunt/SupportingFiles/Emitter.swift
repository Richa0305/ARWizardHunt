//
//  Emitter.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 10/13/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import UIKit

class Emitter{
    
    static func get(with image:UIImage) ->  CAEmitterLayer{
        let emitter = CAEmitterLayer()
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterCells = generateEmitterCells(with: image)
        
        return emitter
    }
    static func getSnow(with image:UIImage) ->  CAEmitterLayer{
        let emitter = CAEmitterLayer()
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterCells = generateSnowEmitterCells(with: image)
        
        return emitter
    }
    
    static func generateEmitterCells(with image:UIImage) -> [CAEmitterCell]{
        var cells = [CAEmitterCell]()
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        cell.birthRate = 50
        cell.lifetime = 6
        cell.velocity = CGFloat(30)
        cell.emissionLongitude = (180 * (.pi/180))
        cell.emissionRange = (2 * (.pi/180))
        cell.scale = 0.2
        cell.scaleRange = 0.3
        cells.append(cell)
        
        return cells
    }
    static func generateSnowEmitterCells(with image:UIImage) -> [CAEmitterCell]{
        var cells = [CAEmitterCell]()
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        cell.birthRate = 20
        cell.lifetime = 50
        cell.velocity = CGFloat(70)
        cell.emissionLongitude = (180 * (.pi/180))
        cell.emissionRange = (45 * (.pi/180))
        cell.scale = 0.2
        cell.scaleRange = 0.4
        cells.append(cell)
        
        return cells
    }
    
  
    

}

