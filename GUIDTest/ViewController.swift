//
//  ViewController.swift
//  GUIDTest
//
//  Created by Runar Svendsen on 12/06/2017.
//  Copyright © 2017 Geodata AS. All rights reserved.
//

import UIKit
import ArcGIS

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: AGSMapView!
    var map: AGSMap!
    var featureTables = [AGSServiceFeatureTable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupFeatureLayers()
        setupTouchDelegate()
    }

}

extension ViewController {
    fileprivate func setupMap() {
        self.map = AGSMap(basemap: .topographic())
        self.mapView.map = self.map
    }
    
    fileprivate func setupFeatureLayers() {
        featureServices.forEach { featureService in
            let featureTable = AGSServiceFeatureTable(url: featureService.featureTableURL)
            featureTables.append(featureTable)
            let featureLayer = AGSFeatureLayer(featureTable: featureTable)
            self.map.operationalLayers.add(featureLayer)
        }
    }
    
    fileprivate func setupTouchDelegate() {
        self.mapView.touchDelegate = self
    }
}

extension ViewController: AGSGeoViewTouchDelegate {

    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        mapTapped(mapPoint)
    }
    
    private func mapTapped(_ mapPoint: AGSPoint) {
        promptUser("Please select service to create a new feature at this point", ["AGOL (PostgreSQL) - Working", "SQLServer - FAILING"], "Cancel (do not create feature)") { [weak self] index in
            self?.createFeature(index, mapPoint)
        }
    }
        
    private func createFeature(_ index: Int, _ mapPoint: AGSPoint) {
        let featureService = featureServices[index]
        let featureTable = featureTables[index]
        //let guidValue = "{8B4D4B7B-0853-4FB4-8DB1-DB490E5E4808}" // plain String, with brackets
        //let guidValue = "8B4D4B7B-0853-4FB4-8DB1-DB490E5E4808" // plain String, no brackets
        //let guidValue = UUID(uuidString: "{8B4D4B7B-0853-4FB4-8DB1-DB490E5E4808}")! // UUID, brackets
        let guidValue = UUID(uuidString: "8B4D4B7B-0853-4FB4-8DB1-DB490E5E4808")! // UUID, no brackets
        let attributes = [featureService.guidFieldName: guidValue]
        let createdFeature = featureTable.createFeature(attributes: attributes, geometry: mapPoint)
        featureTable.add(createdFeature) { error in
            if let error = error {
                return print("Error adding feature: \(error)")
            }
            featureTable.applyEdits() { results, error in
                if let error = error {
                    print("Error applying edits to feature table with url \(featureTable.url!): \(error)")
                }
            }
        }
    }
}

let sqlServerFeatureService = FeatureService(guidFieldName: "RunarGuid", featureTableURL:
    URL(string: "https://mildir-utvikling.geodata.no/support/rest/services/GuidTest/FeatureServer/0")!)

let agolServerFeatureService = FeatureService(guidFieldName: "GUID", featureTableURL:
    URL(string: "http://services.arcgis.com/2JyTvMWQSnM2Vi8q/ArcGIS/rest/services/GUID/FeatureServer/0")!)

let featureServices = [agolServerFeatureService, sqlServerFeatureService]

struct FeatureService {
    let guidFieldName: String
    let featureTableURL: URL
}
