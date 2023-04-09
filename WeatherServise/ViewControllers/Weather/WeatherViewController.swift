//
//  WeatherViewController.swift
//  WeatherServise
//
//  Created by Константин Шмондрик on 17.03.2022.
//

import UIKit
import RealmSwift

final class WeatherViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var weekDayPicker: WeekDayPicker!
    @IBOutlet var collectionView: UICollectionView!
    
    var cityName = ""
    
    private let weatherService = WeatherService()
    private var weathers: List<RLMWeather>!
    private var token: NotificationToken?
    
    private var selectedDay: Day?
    
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH.mm"
        return dateFormatter
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        pairTableAndRealm()
        weatherService.loadWeatherData(city: cityName)
    }
    
    // MARK: - Private
    
    private func pairTableAndRealm() {
        guard let realm = try? Realm()
            , let city = realm.object(ofType: RLMCity.self, forPrimaryKey: cityName)
            else { return }
        
        weathers = city.weathers
        
        token = weathers.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    // MARK: - Actions

    @IBAction func didSelectDay(_ sender: WeekDayPicker) {
        self.selectedDay = sender.selectedDay
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weathers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        cell.configure(with: weathers[indexPath.row])
        return cell
    }
}
