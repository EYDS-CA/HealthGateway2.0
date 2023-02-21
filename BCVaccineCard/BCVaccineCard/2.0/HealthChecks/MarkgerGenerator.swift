//
//  Marker.swift
//  find-clinics
//
//  Created by Amir Shayegh on 2023-02-18.
//

import UIKit
import MapKit

class MarkgerGenerator {
    // MARK: Constants
    private let markerImageSize: CGFloat = 34
    private let markerSize: CGFloat = 44
    
    private let maxVanvouverLon = -123.319307
    private let minVanvouverLon = -122.500825
    private let maxVancouverLat = 49.375320
    private let minVancouverLat = 49.004648
    
    private let maxVictoriaLon = -123.574450
    private let minVictoriaLon = -123.244173
    private let maxVictoriaLat = 48.700083
    private let minVictoriaLat = 48.401914
    
    func generateRandomVancouverLocation() -> CLLocation {
        let ramdonLat = Double.random(in: minVancouverLat...maxVancouverLat)
        let randomLon = Double.random(in: maxVanvouverLon...minVanvouverLon)
        return CLLocation(latitude: ramdonLat, longitude: randomLon)
    }
    
    func generateRandomVictoriaLocation() -> CLLocation {
        let ramdonLat = Double.random(in: minVictoriaLat...maxVictoriaLat)
        let randomLon = Double.random(in: minVictoriaLon...maxVictoriaLon)
        return CLLocation(latitude: ramdonLat, longitude: randomLon)
    }
    
    func generateMaker(image: URL?, bgColour: UIColor, markerTitle: String? = nil) -> UIView {
        let arrowSize = markerImageSize/2.5
        let outerContainerSize = markerSize + (markerSize/2)
        let outerContainer = UIView(frame: CGRect(x: 0, y: 0, width: outerContainerSize, height: outerContainerSize))
        let container = UIView(frame: CGRect(x: 0, y: 0, width: markerSize, height: markerSize))
        let arrowView = UIView(frame: CGRect(x: 0, y: 0, width: arrowSize, height: arrowSize))
        let contentFrame = CGRect(x: 0, y: 0, width: markerImageSize, height: markerImageSize)
        let bgColor = bgColour
        
        outerContainer.translatesAutoresizingMaskIntoConstraints = false
        outerContainer.heightAnchor.constraint(equalToConstant: outerContainerSize).isActive = true
        outerContainer.widthAnchor.constraint(equalToConstant: outerContainerSize).isActive = true
        
        outerContainer.addSubview(container)
        container.layer.cornerRadius = markerSize / 3
        container.backgroundColor = bgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: markerSize).isActive = true
        container.widthAnchor.constraint(equalToConstant: markerSize).isActive = true
        container.centerXAnchor.constraint(equalTo: outerContainer.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: outerContainer.centerYAnchor).isActive = true
        
        
        if let image = image {
            let imageView = UIImageView(frame: contentFrame)
            container.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: markerImageSize).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: markerImageSize).isActive = true
            imageView.layer.cornerRadius = markerImageSize / 2
            imageView.layer.masksToBounds = false
            imageView.clipsToBounds = true
            imageView.backgroundColor = .white
            imageView.contentMode = .scaleAspectFill
            imageView.tintColor = .black
            URLSession.shared.dataTask(with: image, completionHandler: { data, response, error in
                guard let data = data, error == nil else { return }
                // always update the UI from the main thread
                DispatchQueue.main.async() {
                    imageView.image = UIImage(data: data)
                }
            }).resume()
        }
        
        if let markerTitle = markerTitle {
            let label = UILabel(frame: contentFrame)
            container.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: markerImageSize).isActive = true
            label.widthAnchor.constraint(equalToConstant: markerImageSize).isActive = true
            label.layer.cornerRadius = markerImageSize / 2
            label.layer.masksToBounds = false
            label.clipsToBounds = true
            label.backgroundColor = .white
            label.text = markerTitle
            label.textColor = bgColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        }
        
        
        arrowView.backgroundColor = .clear
        container.insertSubview(arrowView, at: 0)
        arrowView.clipsToBounds = false
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.heightAnchor.constraint(equalToConstant: arrowSize).isActive = true
        arrowView.widthAnchor.constraint(equalToConstant: arrowSize).isActive = true
        arrowView.centerXAnchor.constraint(equalTo: outerContainer.centerXAnchor).isActive = true
        arrowView.bottomAnchor.constraint(equalTo: outerContainer.bottomAnchor, constant: ((arrowSize / 5))).isActive = true
        setDownTriangle(triangleView: arrowView, bgColor: bgColor)
        
        return outerContainer
    }
    
    
    func generateMaker(image: UIImage?, bgColour: UIColor, markerTitle: String? = nil) -> UIView {
        let arrowSize = markerImageSize/2.5
        let outerContainerSize = markerSize + (markerSize/2)
        let outerContainer = UIView(frame: CGRect(x: 0, y: 0, width: outerContainerSize, height: outerContainerSize))
        let container = UIView(frame: CGRect(x: 0, y: 0, width: markerSize, height: markerSize))
        let arrowView = UIView(frame: CGRect(x: 0, y: 0, width: arrowSize, height: arrowSize))
        let contentFrame = CGRect(x: 0, y: 0, width: markerImageSize, height: markerImageSize)
        let bgColor = bgColour
        
        outerContainer.translatesAutoresizingMaskIntoConstraints = false
        outerContainer.heightAnchor.constraint(equalToConstant: outerContainerSize).isActive = true
        outerContainer.widthAnchor.constraint(equalToConstant: outerContainerSize).isActive = true
        
        outerContainer.addSubview(container)
        container.layer.cornerRadius = markerSize / 3
        container.backgroundColor = bgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: markerSize).isActive = true
        container.widthAnchor.constraint(equalToConstant: markerSize).isActive = true
        container.centerXAnchor.constraint(equalTo: outerContainer.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: outerContainer.centerYAnchor).isActive = true
        
        
        if let image = image {
            let imageView = UIImageView(frame: contentFrame)
            container.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: markerImageSize).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: markerImageSize).isActive = true
            imageView.layer.cornerRadius = markerImageSize / 2
            imageView.layer.masksToBounds = false
            imageView.clipsToBounds = true
            imageView.backgroundColor = bgColour
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
//            imageView.sdSetMagicPinImage(with: imageURL) { [weak self] image in
//                guard let `self` = self, let img = image else {return}
//                let scaledImage = img.scalePreservingAspectRatio(targetSize: CGSize(width: self.markerImageSize, height: self.markerImageSize))
//                imageView.image = scaledImage
//                imageView.contentMode = .scaleAspectFill
//            }
        }
        
        if let markerTitle = markerTitle {
            let label = UILabel(frame: contentFrame)
            container.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: markerImageSize).isActive = true
            label.widthAnchor.constraint(equalToConstant: markerImageSize).isActive = true
            label.layer.cornerRadius = markerImageSize / 2
            label.layer.masksToBounds = false
            label.clipsToBounds = true
            label.backgroundColor = .white
            label.text = markerTitle
            label.textColor = bgColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        }
        
        
        arrowView.backgroundColor = .clear
        container.insertSubview(arrowView, at: 0)
        arrowView.clipsToBounds = false
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.heightAnchor.constraint(equalToConstant: arrowSize).isActive = true
        arrowView.widthAnchor.constraint(equalToConstant: arrowSize).isActive = true
        arrowView.centerXAnchor.constraint(equalTo: outerContainer.centerXAnchor).isActive = true
        arrowView.bottomAnchor.constraint(equalTo: outerContainer.bottomAnchor, constant: ((arrowSize / 5))).isActive = true
        setDownTriangle(triangleView: arrowView, bgColor: bgColor)
        
        return outerContainer
    }
    
    private func setDownTriangle(triangleView: UIView, bgColor: UIColor) {
        let heightWidth = triangleView.frame.size.width
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x:heightWidth/2, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth, y:0))
        path.addLine(to: CGPoint(x:0, y:0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = bgColor.cgColor
        
        triangleView.layer.insertSublayer(shape, at: 0)
    }
}
